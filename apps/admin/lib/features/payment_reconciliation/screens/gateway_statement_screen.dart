import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/payment_reconciliation_providers.dart';
import 'payment_reconciliation_screen.dart';
import 'payment_reconciliation_text.dart';

/// NF-17 Gateway settlement statement: line-by-line comparison with fees,
/// refund deductions and withholding as separate lines.
class GatewayStatementScreen extends ConsumerWidget {
  const GatewayStatementScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static StText kindText(StatementLineKind k) => switch (k) {
    StatementLineKind.payment => PaymentReconciliationText.lineKindPayment,
    StatementLineKind.fee => PaymentReconciliationText.lineKindFee,
    StatementLineKind.refund => PaymentReconciliationText.lineKindRefund,
    StatementLineKind.withholding =>
      PaymentReconciliationText.lineKindWithholding,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final selected = ref.watch(selectedStatementProvider);
    return StScreen(
      title: s.tx(PaymentReconciliationText.stTitle),
      eyebrow: s.tx(PaymentReconciliationText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(PaymentReconciliationText.stIntro))),
          const SizedBox(height: StSpace.sm),
          StBtn(
            label: s.tx(PaymentReconciliationText.importStatement),
            variant: StBtnVariant.outline,
            icon: Icons.upload_file_rounded,
            disabled: true,
            reason: s.tx(PaymentReconciliationText.importGap),
          ),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<GatewayStatement>>(
            value: ref.watch(gatewayStatementsProvider),
            supported: states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: PaymentReconciliationText.noStatements,
            onRetry: () => ref.invalidate(gatewayStatementsProvider),
            builder: (context, list) {
              final current =
                  list
                      .where((x) => x.id == (selected ?? list.first.id))
                      .firstOrNull ??
                  list.first;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StChipRow(
                    options: [
                      for (final st in list) (v: st.id, l: s.digits(st.period)),
                    ],
                    value: current.id,
                    onChanged: (id) =>
                        ref.read(selectedStatementProvider.notifier).state = id,
                  ),
                  const SizedBox(height: StSpace.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${current.provider} · ${s.digits(current.id)}',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      switch (current.status) {
                        StatementStatus.reconciled => StStatusChip(
                          label: s.tx(PaymentReconciliationText.reconciled),
                          tone: StTone.success,
                        ),
                        StatementStatus.deviation => StStatusChip(
                          label: s.tx(PaymentReconciliationText.deviation),
                          tone: StTone.danger,
                        ),
                        StatementStatus.imported => StStatusChip(
                          label: s.tx(PaymentReconciliationText.imported),
                          tone: StTone.info,
                        ),
                      },
                    ],
                  ),
                  if (current.evidenceRef != null)
                    Text(
                      s.tx(PaymentReconciliationText.evidenceOn, [
                        current.evidenceRef!,
                      ]),
                    ),
                  const SizedBox(height: StSpace.xs),
                  StFinTable<StatementLine>(
                    rows: current.lines,
                    idLabel: PaymentReconciliationText.colPayment,
                    idOf: (l) => l.ref,
                    subtitleOf: (l) => s.tx(kindText(l.kind)),
                    amountLabel: PaymentReconciliationText.deviation,
                    amountMinorOf: (l) => l.deviationMinor,
                    statusOf: (l) => StStatusChip(
                      label: s.tx(kindText(l.kind)),
                      tone: l.deviationMinor == 0
                          ? StTone.muted
                          : StTone.warning,
                    ),
                    columns: [
                      StFinColumn(
                        label: PaymentReconciliationText.colStatement,
                        cell: (l) => s.moneyMinor(l.statementMinor),
                        numeric: true,
                      ),
                      StFinColumn(
                        label: PaymentReconciliationText.colRecord,
                        cell: (l) => s.moneyMinor(l.recordMinor),
                        numeric: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: StSpace.xs),
                  StInfoRow(
                    label: s.tx(PaymentReconciliationText.deviation),
                    trailing: StMoneyText.minor(
                      current.deviationMinor,
                      align: Alignment.centerRight,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: StSpace.sm),
                  if (current.status != StatementStatus.reconciled)
                    StCommandButton(
                      label: s.tx(PaymentReconciliationText.reconcile),
                      icon: Icons.fact_check_outlined,
                      onTap: () => PaymentReconciliationScreen.reconcileSheet(
                        ref,
                        current,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
