import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/general_ledger_providers.dart';
import 'general_ledger_text.dart';

/// NF-12 Period close workspace (`closePeriod`, `reopenPeriod`): close is
/// disabled until the checklist is complete; reopening needs a reason.
class PeriodCloseScreen extends ConsumerWidget {
  const PeriodCloseScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static StText statusText(PeriodStatus st) => switch (st) {
    PeriodStatus.open => GeneralLedgerText.open,
    PeriodStatus.closing => GeneralLedgerText.closing,
    PeriodStatus.closed => GeneralLedgerText.closed,
    PeriodStatus.reopened => GeneralLedgerText.reopened,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final selected = ref.watch(selectedPeriodProvider);
    final repo = ref.read(ledgerRepositoryProvider);
    final actor = ref.read(actorProvider);
    return StScreen(
      title: s.tx(GeneralLedgerText.periodTitle),
      eyebrow: s.tx(GeneralLedgerText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(GeneralLedgerText.periodIntro))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<Period>>(
            value: ref.watch(periodsProvider),
            supported: states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: GeneralLedgerText.noPeriods,
            onRetry: () => ref.invalidate(periodsProvider),
            builder: (context, periods) {
              final current =
                  periods.where((p) => p.id == selected).firstOrNull ??
                  periods
                      .where((p) => p.status == PeriodStatus.closing)
                      .firstOrNull ??
                  periods.first;
              return StCommandScope(
                builder: (context, cmd) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StChipRow(
                      options: [
                        for (final p in periods)
                          (
                            v: p.id,
                            l: '${s.digits(p.id)} · ${s.tx(statusText(p.status))}',
                          ),
                      ],
                      value: current.id,
                      onChanged: (id) =>
                          ref.read(selectedPeriodProvider.notifier).state = id,
                    ),
                    const SizedBox(height: StSpace.sm),
                    StSection(
                      title: s.tx(GeneralLedgerText.checklist),
                      child: current.checklist.isEmpty
                          ? StNote(
                              child: Text(s.tx(GeneralLedgerText.noChecklist)),
                            )
                          : StList(
                              children: [
                                for (final c in current.checklist)
                                  StRowTile(
                                    icon: c.done
                                        ? Icons.check_circle_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    label: s.tx(c.label),
                                  ),
                              ],
                            ),
                    ),
                    if (current.note != null)
                      Text(s.tx(GeneralLedgerText.note, [current.note!])),
                    const SizedBox(height: StSpace.sm),
                    if (current.status != PeriodStatus.closed)
                      StCommandButton(
                        label: s.tx(GeneralLedgerText.closePeriod),
                        icon: Icons.lock_outline_rounded,
                        busy: cmd.busy,
                        disabledReason: current.ready
                            ? null
                            : s.tx(GeneralLedgerText.closeBlocked),
                        onTap: () => cmd.run(
                          () => repo.closePeriod(
                            actor,
                            RequestId.next('close'),
                            periodId: current.id,
                          ),
                          name: GeneralLedgerText.closeName,
                          success: GeneralLedgerText.closeDone,
                          onSuccess: () => ref.invalidate(periodsProvider),
                        ),
                      )
                    else
                      StBtn(
                        label: s.tx(GeneralLedgerText.reopen),
                        variant: StBtnVariant.outline,
                        icon: Icons.lock_open_rounded,
                        onTap: () => ref
                            .read(appProvider.notifier)
                            .showSheet(
                              StReasonSheet(
                                title: GeneralLedgerText.reopenTitle,
                                body: GeneralLedgerText.reopenBody,
                                commandName: GeneralLedgerText.reopenName,
                                success: GeneralLedgerText.reopenDone,
                                confirmLabel: GeneralLedgerText.reopen,
                                minLength: 10,
                                onSubmit: (reason) => repo.reopenPeriod(
                                  actor,
                                  RequestId.next('reopen'),
                                  periodId: current.id,
                                  reason: reason,
                                ),
                                onDone: () => ref.invalidate(periodsProvider),
                              ),
                            ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
