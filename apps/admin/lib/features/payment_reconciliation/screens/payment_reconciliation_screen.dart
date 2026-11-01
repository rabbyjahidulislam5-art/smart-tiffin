import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/payment_reconciliation_providers.dart';
import 'payment_reconciliation_text.dart';

/// NF-02 Online payment reconciliation: gateway records against ledger
/// postings; statements are reconciled with evidence (`reconcileGatewayStatement`).
class PaymentReconciliationScreen extends ConsumerWidget {
  const PaymentReconciliationScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static Widget stateChip(AppState s, ReconState st) => switch (st) {
    ReconState.matched => StStatusChip(
      label: s.tx(PaymentReconciliationText.matched),
      tone: StTone.success,
      icon: Icons.check_circle_outline,
    ),
    ReconState.exception => StStatusChip(
      label: s.tx(PaymentReconciliationText.exception),
      tone: StTone.danger,
      icon: Icons.error_outline,
    ),
    ReconState.resolving => StStatusChip(
      label: s.tx(PaymentReconciliationText.resolving),
      tone: StTone.warning,
      icon: Icons.sync_rounded,
    ),
  };

  /// Opens the evidence sheet that reconciles [statement] (shared with NF-17).
  static void reconcileSheet(WidgetRef ref, GatewayStatement statement) {
    final repo = ref.read(paymentReconciliationRepositoryProvider);
    final actor = ref.read(actorProvider);
    ref
        .read(appProvider.notifier)
        .showSheet(
          StReasonSheet(
            title: PaymentReconciliationText.reconcile,
            body: PaymentReconciliationText.reconcileBody,
            fieldLabel: PaymentReconciliationText.evidence,
            commandName: PaymentReconciliationText.reconcileName,
            success: PaymentReconciliationText.reconcileDone,
            confirmLabel: PaymentReconciliationText.reconcile,
            minLength: 4,
            onSubmit: (evidence) => repo.reconcileGatewayStatement(
              actor,
              RequestId.next('recon'),
              statementId: statement.id,
              evidenceRef: evidence,
            ),
            onDone: () => ref.invalidate(gatewayStatementsProvider),
          ),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    return StScreen(
      title: s.tx(PaymentReconciliationText.title),
      eyebrow: s.tx(PaymentReconciliationText.eyebrow),
      back: false,
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(PaymentReconciliationText.intro))),
          const SizedBox(height: StSpace.sm),
          Row(
            children: [
              Expanded(
                child: StBtn(
                  label: s.tx(PaymentReconciliationText.openExceptions),
                  variant: StBtnVariant.soft,
                  icon: Icons.report_problem_outlined,
                  onTap: () => stOpen(ref, 'NF-13'),
                ),
              ),
              const SizedBox(width: StSpace.xs),
              Expanded(
                child: StBtn(
                  label: s.tx(PaymentReconciliationText.openStatements),
                  variant: StBtnVariant.soft,
                  icon: Icons.receipt_long_outlined,
                  onTap: () => stOpen(ref, 'NF-17'),
                ),
              ),
            ],
          ),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<ReconItem>>(
            value: ref.watch(reconMatchesProvider),
            supported: states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: PaymentReconciliationText.empty,
            onRetry: () => ref.invalidate(reconMatchesProvider),
            builder: (context, rows) => StFinTable<ReconItem>(
              rows: rows,
              idLabel: PaymentReconciliationText.colPayment,
              idOf: (r) => r.paymentRef,
              amountLabel: PaymentReconciliationText.colDifference,
              amountMinorOf: (r) => r.differenceMinor,
              statusOf: (r) => stateChip(s, r.state),
              columns: [
                StFinColumn(
                  label: PaymentReconciliationText.colGateway,
                  cell: (r) => s.moneyMinor(r.gatewayMinor),
                  numeric: true,
                ),
                StFinColumn(
                  label: PaymentReconciliationText.colLedger,
                  cell: (r) => s.moneyMinor(r.ledgerMinor),
                  numeric: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: StSpace.md),
          StSection(
            title: s.tx(PaymentReconciliationText.openStatements),
            child: StAsyncView<List<GatewayStatement>>(
              value: ref.watch(gatewayStatementsProvider),
              supported: states,
              isEmpty: (l) => l.isEmpty,
              emptyMessage: PaymentReconciliationText.noStatements,
              onRetry: () => ref.invalidate(gatewayStatementsProvider),
              builder: (context, list) => StList(
                children: [
                  for (final st in list)
                    StRowTile(
                      icon: Icons.receipt_long_outlined,
                      label: '${st.provider} · ${s.digits(st.period)}',
                      sub:
                          '${s.tx(PaymentReconciliationText.deviation)} ${s.moneyMinor(st.deviationMinor)}',
                      right: st.status == StatementStatus.reconciled
                          ? StStatusChip(
                              label: s.tx(PaymentReconciliationText.reconciled),
                              tone: StTone.success,
                            )
                          : StBtn(
                              label: s.tx(PaymentReconciliationText.reconcile),
                              size: StBtnSize.sm,
                              onTap: () => reconcileSheet(ref, st),
                            ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
