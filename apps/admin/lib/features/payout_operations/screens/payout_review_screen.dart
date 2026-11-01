import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/payout_operations_providers.dart';
import 'payout_operations_text.dart';

/// NF-07 Payout request review (`reviewPayout`, `rejectPayout`; INV-14).
class PayoutReviewScreen extends ConsumerWidget {
  const PayoutReviewScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static Widget statusChip(AppState s, PayoutCaseStatus st) => switch (st) {
    PayoutCaseStatus.requested => StStatusChip(
      label: s.tx(PayoutOperationsText.requested),
      tone: StTone.warning,
    ),
    PayoutCaseStatus.approved => StStatusChip(
      label: s.tx(PayoutOperationsText.approved),
      tone: StTone.success,
    ),
    PayoutCaseStatus.batched => StStatusChip(
      label: s.tx(PayoutOperationsText.batched),
      tone: StTone.info,
    ),
    PayoutCaseStatus.rejected => StStatusChip(
      label: s.tx(PayoutOperationsText.rejected),
      tone: StTone.danger,
    ),
  };

  static void _open(WidgetRef ref, PayoutRequestCase c) {
    final repo = ref.read(payoutOperationsRepositoryProvider);
    final actor = ref.read(actorProvider);
    final ctrl = ref.read(appProvider.notifier);
    final withinBalance = c.amountMinor <= c.eligibleMinor;
    final eligible = withinBalance && c.beneficiaryVerified;
    ctrl.showSheet(
      Consumer(
        builder: (context, ref, _) {
          final s = ref.watch(appProvider);
          return StCommandScope(
            onConfirmationEnd: ctrl.closeSheet,
            builder: (context, cmd) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${c.partyName} · ${s.digits(c.id)}',
                  style: const TextStyle(
                    fontSize: StFont.heading,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: StSpace.xs),
                StInfoRow(
                  label: s.tx(PayoutOperationsText.eligible),
                  trailing: StMoneyText.minor(
                    c.eligibleMinor,
                    align: Alignment.centerRight,
                  ),
                ),
                StInfoRow(
                  label: s.tx(PayoutOperationsText.requested),
                  trailing: StMoneyText.minor(
                    c.amountMinor,
                    align: Alignment.centerRight,
                  ),
                ),
                StStatusChip(
                  label: s.tx(
                    withinBalance
                        ? PayoutOperationsText.withinBalance
                        : PayoutOperationsText.aboveBalance,
                  ),
                  tone: withinBalance ? StTone.success : StTone.danger,
                  icon: withinBalance
                      ? Icons.check_circle_outline
                      : Icons.error_outline,
                ),
                const SizedBox(height: StSpace.xxs),
                StStatusChip(
                  label: s.tx(
                    c.beneficiaryVerified
                        ? PayoutOperationsText.verifiedBeneficiary
                        : PayoutOperationsText.unverifiedBeneficiary,
                  ),
                  tone: c.beneficiaryVerified ? StTone.success : StTone.danger,
                  icon: c.beneficiaryVerified
                      ? Icons.verified_user_outlined
                      : Icons.gpp_maybe_outlined,
                ),
                const SizedBox(height: StSpace.sm),
                StCommandButton(
                  label: s.tx(PayoutOperationsText.approve),
                  icon: Icons.task_alt_rounded,
                  variant: StBtnVariant.success,
                  busy: cmd.busy,
                  disabledReason: eligible
                      ? null
                      : s.tx(PayoutOperationsText.approveBlocked),
                  onTap: () => cmd.run(
                    () => repo.reviewPayout(
                      actor,
                      RequestId.next('review'),
                      caseId: c.id,
                    ),
                    name: PayoutOperationsText.reviewName,
                    success: PayoutOperationsText.approvedDone,
                    onSuccess: () => ref.invalidate(payoutCasesProvider),
                  ),
                ),
                const SizedBox(height: StSpace.xs),
                StBtn(
                  label: s.tx(PayoutOperationsText.reject),
                  icon: Icons.block_rounded,
                  variant: StBtnVariant.danger,
                  onTap: () => ctrl.showSheet(
                    StReasonSheet(
                      title: PayoutOperationsText.rejectTitle,
                      body: PayoutOperationsText.reasonBody,
                      commandName: PayoutOperationsText.reviewName,
                      success: PayoutOperationsText.rejectedDone,
                      confirmLabel: PayoutOperationsText.reject,
                      danger: true,
                      onSubmit: (reason) => repo.rejectPayout(
                        actor,
                        RequestId.next('reject'),
                        caseId: c.id,
                        reason: reason,
                      ),
                      onDone: () => ref.invalidate(payoutCasesProvider),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    return StScreen(
      title: s.tx(PayoutOperationsText.reviewTitle),
      eyebrow: s.tx(PayoutOperationsText.eyebrow),
      back: false,
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(PayoutOperationsText.reviewIntro))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<PayoutRequestCase>>(
            value: ref.watch(payoutCasesProvider),
            supported: states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: PayoutOperationsText.empty,
            onRetry: () => ref.invalidate(payoutCasesProvider),
            builder: (context, list) => StFinTable<PayoutRequestCase>(
              rows: list,
              idLabel: PayoutOperationsText.colParty,
              idOf: (c) => c.partyName,
              subtitleOf: (c) =>
                  '${s.digits(c.id)} · ${s.tx(c.partyKind == 'rider' ? PayoutOperationsText.rider : PayoutOperationsText.supplier)}',
              amountMinorOf: (c) => c.amountMinor,
              statusOf: (c) => statusChip(s, c.status),
              columns: [
                StFinColumn(
                  label: PayoutOperationsText.eligible,
                  cell: (c) => s.moneyMinor(c.eligibleMinor),
                  numeric: true,
                ),
                StFinColumn(
                  label: PayoutOperationsText.verifiedBeneficiary,
                  cell: (c) => s.tx(
                    c.beneficiaryVerified
                        ? PayoutOperationsText.verifiedBeneficiary
                        : PayoutOperationsText.unverifiedBeneficiary,
                  ),
                  width: StSize.contentNarrow / 3,
                ),
              ],
              onTap: (c) {
                if (c.status == PayoutCaseStatus.requested) _open(ref, c);
              },
            ),
          ),
          const SizedBox(height: StSpace.sm),
          StBtn(
            label: s.tx(PayoutOperationsText.batchTitle),
            variant: StBtnVariant.soft,
            icon: Icons.playlist_add_check_rounded,
            onTap: () => stOpen(ref, 'NF-08'),
          ),
        ],
      ),
    );
  }
}
