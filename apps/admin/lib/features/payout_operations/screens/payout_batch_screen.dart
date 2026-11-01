import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/payout_operations_providers.dart';
import 'payout_operations_text.dart';

/// NF-08 Payout batch execution (`createPayoutBatch`, `releasePayoutBatch`,
/// `recordPayoutResult`): maker-checker release; settled only on a recorded
/// external transfer result.
class PayoutBatchScreen extends ConsumerWidget {
  const PayoutBatchScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static StText batchStatus(BatchStatus st) => switch (st) {
    BatchStatus.prepared => PayoutOperationsText.prepared,
    BatchStatus.processing => PayoutOperationsText.processing,
    BatchStatus.settled => PayoutOperationsText.settled,
    BatchStatus.failed => PayoutOperationsText.failed,
  };

  static void _recordResult(WidgetRef ref, PayoutBatch b) {
    final repo = ref.read(payoutOperationsRepositoryProvider);
    final actor = ref.read(actorProvider);
    final ctrl = ref.read(appProvider.notifier);
    final reference = TextEditingController();
    var settled = true;
    ctrl.showSheet(
      StatefulBuilder(
        builder: (context, setLocal) => Consumer(
          builder: (context, ref, _) {
            final s = ref.watch(appProvider);
            return StCommandScope(
              onConfirmationEnd: ctrl.closeSheet,
              builder: (context, cmd) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${s.tx(PayoutOperationsText.recordResult)} · ${s.digits(b.id)}',
                    style: const TextStyle(
                      fontSize: StFont.heading,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: StSpace.sm),
                  StToggle(
                    value: settled,
                    label: s.tx(PayoutOperationsText.transferSettled),
                    onChanged: (v) => setLocal(() => settled = v),
                  ),
                  StField(
                    label: s.tx(PayoutOperationsText.transferRef),
                    controller: reference,
                  ),
                  const SizedBox(height: StSpace.sm),
                  StCommandButton(
                    label: s.tx(PayoutOperationsText.recordResult),
                    busy: cmd.busy,
                    onTap: () => cmd.run(
                      () => repo.recordPayoutResult(
                        actor,
                        RequestId.next('result'),
                        batchId: b.id,
                        settled: settled,
                        reference: reference.text,
                      ),
                      name: PayoutOperationsText.resultName,
                      success: PayoutOperationsText.resultDone,
                      onSuccess: () => ref.invalidate(payoutBatchesProvider),
                    ),
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
    final selection = ref.watch(batchSelectionProvider);
    final repo = ref.read(payoutOperationsRepositoryProvider);
    final actor = ref.read(actorProvider);
    return StScreen(
      title: s.tx(PayoutOperationsText.batchTitle),
      eyebrow: s.tx(PayoutOperationsText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(PayoutOperationsText.batchIntro))),
          const SizedBox(height: StSpace.xs),
          StNote(
            tone: StNoteTone.policy,
            child: Text(s.tx(PayoutOperationsText.dualApproval)),
          ),
          const SizedBox(height: StSpace.sm),
          StSection(
            title: s.tx(PayoutOperationsText.approvedRequests),
            child: StAsyncView<List<PayoutRequestCase>>(
              value: ref.watch(payoutCasesProvider),
              supported: states,
              onRetry: () => ref.invalidate(payoutCasesProvider),
              builder: (context, cases) {
                final approved = [
                  for (final c in cases)
                    if (c.status == PayoutCaseStatus.approved) c,
                ];
                final total = approved
                    .where((c) => selection.contains(c.id))
                    .fold<int>(0, (a, c) => a + c.amountMinor);
                return StCommandScope(
                  builder: (context, cmd) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final c in approved)
                        Padding(
                          padding: const EdgeInsets.only(bottom: StSpace.xs),
                          child: StCard(
                            key: ValueKey('batch-pick-${c.id}'),
                            onTap: () {
                              final n = ref.read(
                                batchSelectionProvider.notifier,
                              );
                              n.state = n.state.contains(c.id)
                                  ? ({...n.state}..remove(c.id))
                                  : {...n.state, c.id};
                            },
                            child: Row(
                              children: [
                                Icon(
                                  selection.contains(c.id)
                                      ? Icons.check_box_rounded
                                      : Icons.check_box_outline_blank_rounded,
                                  color: context.roleColor,
                                ),
                                const SizedBox(width: StSpace.xs),
                                Expanded(
                                  child: Text(
                                    '${c.partyName} · ${s.digits(c.id)}',
                                  ),
                                ),
                                StMoneyText.minor(
                                  c.amountMinor,
                                  align: Alignment.centerRight,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      StCommandButton(
                        label: s.tx(PayoutOperationsText.createBatch),
                        icon: Icons.playlist_add_rounded,
                        busy: cmd.busy,
                        disabledReason: selection.isEmpty
                            ? s.tx(PayoutOperationsText.selectFirst)
                            : null,
                        onTap: () => ref
                            .read(appProvider.notifier)
                            .showConfirm(
                              ConfirmOpts(
                                title: s.tx(
                                  PayoutOperationsText.createConfirmTitle,
                                  ['${selection.length}'],
                                ),
                                body: s.tx(
                                  PayoutOperationsText.createConfirmBody,
                                  [s.moneyMinor(total)],
                                ),
                                ok: s.tx(PayoutOperationsText.createBatch),
                                onOk: () => cmd.run(
                                  () => repo.createPayoutBatch(
                                    actor,
                                    RequestId.next('batch'),
                                    caseIds: selection.toList(),
                                  ),
                                  name: PayoutOperationsText.createName,
                                  success: PayoutOperationsText.createDone,
                                  onSuccess: () {
                                    ref
                                            .read(
                                              batchSelectionProvider.notifier,
                                            )
                                            .state =
                                        const {};
                                    ref.invalidate(payoutCasesProvider);
                                    ref.invalidate(payoutBatchesProvider);
                                  },
                                ),
                              ),
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: StSpace.md),
          StSection(
            title: s.tx(PayoutOperationsText.batches),
            child: StAsyncView<List<PayoutBatch>>(
              value: ref.watch(payoutBatchesProvider),
              supported: states,
              isEmpty: (l) => l.isEmpty,
              emptyMessage: PayoutOperationsText.noBatches,
              onRetry: () => ref.invalidate(payoutBatchesProvider),
              builder: (context, batches) => StCommandScope(
                builder: (context, cmd) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final b in batches)
                      Padding(
                        padding: const EdgeInsets.only(bottom: StSpace.xs),
                        child: StCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      s.digits(b.id),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  StMoneyText.minor(
                                    b.totalMinor,
                                    align: Alignment.centerRight,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: StSpace.xs),
                                  StStatusChip(
                                    label: s.tx(batchStatus(b.status)),
                                    tone: switch (b.status) {
                                      BatchStatus.prepared => StTone.warning,
                                      BatchStatus.processing => StTone.info,
                                      BatchStatus.settled => StTone.success,
                                      BatchStatus.failed => StTone.danger,
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                s.tx(PayoutOperationsText.requestsCount, [
                                  '${b.requestIds.length}',
                                ]),
                                style: const TextStyle(fontSize: StFont.label),
                              ),
                              Text(
                                s.tx(PayoutOperationsText.preparedBy, [
                                  b.preparedBy,
                                ]),
                                style: const TextStyle(fontSize: StFont.label),
                              ),
                              if (b.approvedBy != null)
                                Text(
                                  s.tx(PayoutOperationsText.approvedBy, [
                                    b.approvedBy!,
                                  ]),
                                  style: const TextStyle(
                                    fontSize: StFont.label,
                                  ),
                                ),
                              if (b.status == BatchStatus.prepared) ...[
                                const SizedBox(height: StSpace.xs),
                                StCommandButton(
                                  label: s.tx(PayoutOperationsText.release),
                                  icon: Icons.send_rounded,
                                  busy: cmd.busy,
                                  disabledReason: b.preparedBy == actor.id
                                      ? s.tx(PayoutOperationsText.releaseSelf)
                                      : null,
                                  onTap: () => cmd.run(
                                    () => repo.releasePayoutBatch(
                                      actor,
                                      RequestId.next('release'),
                                      batchId: b.id,
                                    ),
                                    name: PayoutOperationsText.releaseName,
                                    success: PayoutOperationsText.releaseDone,
                                    onSuccess: () =>
                                        ref.invalidate(payoutBatchesProvider),
                                  ),
                                ),
                              ],
                              if (b.status == BatchStatus.processing) ...[
                                const SizedBox(height: StSpace.xs),
                                StBtn(
                                  label: s.tx(
                                    PayoutOperationsText.recordResult,
                                  ),
                                  variant: StBtnVariant.soft,
                                  icon: Icons.fact_check_outlined,
                                  onTap: () => _recordResult(ref, b),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
