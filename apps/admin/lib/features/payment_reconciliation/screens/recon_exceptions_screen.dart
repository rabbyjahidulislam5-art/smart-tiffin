import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/payment_reconciliation_providers.dart';
import 'payment_reconciliation_text.dart';

/// NF-13 Reconciliation exceptions: unmatched, duplicate and invalid items
/// with bulk assignment after an explicit confirmation (`assignException`).
class ReconExceptionsScreen extends ConsumerWidget {
  const ReconExceptionsScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };
  static const assignees = ['Rahim', 'Sadia', 'You'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final selected = ref.watch(selectedExceptionsProvider);
    final assignee = ref.watch(exceptionAssigneeProvider);
    final repo = ref.read(paymentReconciliationRepositoryProvider);
    final actor = ref.read(actorProvider);
    return StScreen(
      title: s.tx(PaymentReconciliationText.exTitle),
      eyebrow: s.tx(PaymentReconciliationText.eyebrow),
      dense: true,
      child: StAsyncView<List<ReconException>>(
        value: ref.watch(reconExceptionsProvider),
        supported: states,
        isEmpty: (l) => l.isEmpty,
        emptyMessage: PaymentReconciliationText.noExceptions,
        onRetry: () => ref.invalidate(reconExceptionsProvider),
        builder: (context, list) => StCommandScope(
          builder: (context, cmd) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final e in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: StSpace.xs),
                  child: StCard(
                    key: ValueKey('exception-${e.id}'),
                    onTap: e.status == ExceptionStatus.resolved
                        ? null
                        : () {
                            final n = ref.read(
                              selectedExceptionsProvider.notifier,
                            );
                            n.state = n.state.contains(e.id)
                                ? ({...n.state}..remove(e.id))
                                : {...n.state, e.id};
                          },
                    child: Row(
                      children: [
                        Icon(
                          selected.contains(e.id)
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          color: context.roleColor,
                        ),
                        const SizedBox(width: StSpace.xs),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${s.digits(e.id)} · ${s.digits(e.ref)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                s.tx(switch (e.type) {
                                  ReconExceptionType.unmatched =>
                                    PaymentReconciliationText.unmatched,
                                  ReconExceptionType.duplicate =>
                                    PaymentReconciliationText.duplicate,
                                  ReconExceptionType.invalid =>
                                    PaymentReconciliationText.invalid,
                                }),
                                style: const TextStyle(fontSize: StFont.label),
                              ),
                            ],
                          ),
                        ),
                        StMoneyText.minor(
                          e.amountMinor,
                          align: Alignment.centerRight,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: StSpace.xs),
                        switch (e.status) {
                          ExceptionStatus.open => StStatusChip(
                            label: s.tx(PaymentReconciliationText.open),
                            tone: StTone.danger,
                          ),
                          ExceptionStatus.assigned => StStatusChip(
                            label: s.tx(PaymentReconciliationText.assigned, [
                              e.assignedTo ?? '-',
                            ]),
                            tone: StTone.info,
                          ),
                          ExceptionStatus.resolved => StStatusChip(
                            label: s.tx(PaymentReconciliationText.resolved),
                            tone: StTone.success,
                          ),
                        },
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: StSpace.sm),
              Text(
                s.tx(PaymentReconciliationText.assignTo),
                style: const TextStyle(
                  fontSize: StFont.label,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: StSpace.gap6),
              StChipRow(
                options: [for (final a in assignees) (v: a, l: a)],
                value: assignee,
                onChanged: (a) =>
                    ref.read(exceptionAssigneeProvider.notifier).state = a,
              ),
              const SizedBox(height: StSpace.sm),
              StCommandButton(
                label: s.tx(PaymentReconciliationText.assign),
                icon: Icons.assignment_ind_outlined,
                busy: cmd.busy,
                disabledReason: selected.isEmpty
                    ? s.tx(PaymentReconciliationText.selectFirst)
                    : null,
                onTap: () => ref
                    .read(appProvider.notifier)
                    .showConfirm(
                      ConfirmOpts(
                        title: s.tx(
                          PaymentReconciliationText.assignConfirmTitle,
                          ['${selected.length}'],
                        ),
                        body: s.tx(
                          PaymentReconciliationText.assignConfirmBody,
                          ['${selected.length}', assignee],
                        ),
                        ok: s.tx(PaymentReconciliationText.assign),
                        onOk: () => cmd.run(
                          () => repo.assignException(
                            actor,
                            RequestId.next('assign'),
                            exceptionIds: selected.toList(),
                            assignee: assignee,
                          ),
                          name: PaymentReconciliationText.assignName,
                          success: PaymentReconciliationText.assignDone,
                          onSuccess: () {
                            ref
                                    .read(selectedExceptionsProvider.notifier)
                                    .state =
                                const {};
                            ref.invalidate(reconExceptionsProvider);
                          },
                        ),
                      ),
                    ),
              ),
              const SizedBox(height: StSpace.xs),
              StBtn(
                label: s.tx(PaymentReconciliationText.title),
                variant: StBtnVariant.ghost,
                icon: Icons.compare_arrows_rounded,
                onTap: () => stOpen(ref, 'NF-02'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
