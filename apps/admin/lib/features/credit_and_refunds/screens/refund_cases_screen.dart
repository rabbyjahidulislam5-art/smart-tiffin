import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/credit_and_refunds_providers.dart';
import 'credit_and_refunds_text.dart';

/// NF-10 Refund and chargeback management (`initiateRefund`,
/// `recordRefundResult`; INV-17 blocks a refund when a credit was issued).
class RefundCasesScreen extends ConsumerWidget {
  const RefundCasesScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static StText statusText(RefundOpsStatus st) => switch (st) {
    RefundOpsStatus.pending => CreditAndRefundsText.pending,
    RefundOpsStatus.approved => CreditAndRefundsText.approved,
    RefundOpsStatus.executed => CreditAndRefundsText.executed,
    RefundOpsStatus.disputed => CreditAndRefundsText.disputed,
  };

  static void _open(WidgetRef ref, RefundOpsCase c) {
    final repo = ref.read(creditAndRefundRepositoryProvider);
    final actor = ref.read(actorProvider);
    final ctrl = ref.read(appProvider.notifier);
    final providerRef = TextEditingController();
    var executed = true;
    ctrl.showSheet(
      StatefulBuilder(
        builder: (context, setLocal) => Consumer(
          builder: (context, ref, _) {
            final s = ref.watch(appProvider);
            final isRefund = c.kind == RefundOpsKind.refund;
            return StCommandScope(
              onConfirmationEnd: ctrl.closeSheet,
              builder: (context, cmd) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${s.digits(c.id)} · ${s.digits(c.orderRef)}',
                    style: const TextStyle(
                      fontSize: StFont.heading,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  StInfoRow(
                    label: s.tx(
                      isRefund
                          ? CreditAndRefundsText.refund
                          : CreditAndRefundsText.chargeback,
                    ),
                    trailing: StMoneyText.minor(
                      c.amountMinor,
                      align: Alignment.centerRight,
                    ),
                  ),
                  const SizedBox(height: StSpace.xs),
                  if (!isRefund)
                    StBtn(
                      label: s.tx(CreditAndRefundsText.evidenceReview),
                      variant: StBtnVariant.outline,
                      disabled: true,
                      reason: s.tx(CreditAndRefundsText.evidenceGap),
                    )
                  else if (c.status == RefundOpsStatus.pending)
                    StCommandButton(
                      label: s.tx(CreditAndRefundsText.initiate),
                      icon: Icons.undo_rounded,
                      busy: cmd.busy,
                      disabledReason: c.creditIssued
                          ? s.tx(CreditAndRefundsText.creditBlocks)
                          : null,
                      onTap: () => cmd.run(
                        () => repo.initiateRefund(
                          actor,
                          RequestId.next('refund'),
                          caseId: c.id,
                        ),
                        name: CreditAndRefundsText.initiateName,
                        success: CreditAndRefundsText.initiateDone,
                        onSuccess: () => ref.invalidate(refundOpsCasesProvider),
                      ),
                    )
                  else if (c.status == RefundOpsStatus.approved) ...[
                    StToggle(
                      value: executed,
                      label: s.tx(CreditAndRefundsText.refundExecuted),
                      onChanged: (v) => setLocal(() => executed = v),
                    ),
                    StField(
                      label: s.tx(CreditAndRefundsText.providerRef),
                      controller: providerRef,
                    ),
                    const SizedBox(height: StSpace.xs),
                    StCommandButton(
                      label: s.tx(CreditAndRefundsText.recordResult),
                      busy: cmd.busy,
                      onTap: () => cmd.run(
                        () => repo.recordRefundResult(
                          actor,
                          RequestId.next('refund-result'),
                          caseId: c.id,
                          executed: executed,
                          providerRef: providerRef.text,
                        ),
                        name: CreditAndRefundsText.resultName,
                        success: CreditAndRefundsText.resultDone,
                        onSuccess: () => ref.invalidate(refundOpsCasesProvider),
                      ),
                    ),
                  ],
                  const SizedBox(height: StSpace.xs),
                  StBtn(
                    label: s.tx(CreditAndRefundsText.openCredits),
                    variant: StBtnVariant.ghost,
                    onTap: () => stOpen(ref, 'NF-09'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    return StScreen(
      title: s.tx(CreditAndRefundsText.refundTitle),
      eyebrow: s.tx(CreditAndRefundsText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(CreditAndRefundsText.refundIntro))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<RefundOpsCase>>(
            value: ref.watch(refundOpsCasesProvider),
            supported: states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: CreditAndRefundsText.noCases,
            onRetry: () => ref.invalidate(refundOpsCasesProvider),
            builder: (context, list) => StFinTable<RefundOpsCase>(
              rows: list,
              idLabel: CreditAndRefundsText.refund,
              idOf: (c) => c.id,
              subtitleOf: (c) =>
                  '${s.digits(c.orderRef)} · ${s.tx(c.kind == RefundOpsKind.refund ? CreditAndRefundsText.refund : CreditAndRefundsText.chargeback)}',
              amountMinorOf: (c) => c.amountMinor,
              statusOf: (c) => StStatusChip(
                label: s.tx(statusText(c.status)),
                tone: switch (c.status) {
                  RefundOpsStatus.pending => StTone.warning,
                  RefundOpsStatus.approved => StTone.info,
                  RefundOpsStatus.executed => StTone.success,
                  RefundOpsStatus.disputed => StTone.danger,
                },
              ),
              columns: [
                StFinColumn(
                  label: CreditAndRefundsText.providerRef,
                  cell: (c) => c.providerRef ?? '-',
                ),
              ],
              onTap: (c) => _open(ref, c),
            ),
          ),
        ],
      ),
    );
  }
}
