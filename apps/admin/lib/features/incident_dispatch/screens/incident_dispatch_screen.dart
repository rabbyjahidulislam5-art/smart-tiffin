import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/incident_dispatch_providers.dart';
import 'incident_dispatch_text.dart';

/// NA-04 Desktop incident dispatcher (`reassignDelivery`, WF-J).
class IncidentDispatchScreen extends ConsumerWidget {
  const IncidentDispatchScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final selected = ref.watch(selectedDeliveryProvider);
    return StScreen(
      title: s.tx(IncidentDispatchText.title),
      eyebrow: s.tx(IncidentDispatchText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(IncidentDispatchText.intro))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<DelayedDelivery>>(
            value: ref.watch(delayedDeliveriesProvider),
            supported: states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: IncidentDispatchText.empty,
            onRetry: () => ref.invalidate(delayedDeliveriesProvider),
            builder: (context, list) {
              DelayedDelivery? current;
              for (final d in list) {
                if (d.id == selected) current = d;
              }
              final listView = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final d in list)
                    _deliveryTile(context, ref, s, d, d.id == selected),
                ],
              );
              final detail = current == null
                  ? StNote(child: Text(s.tx(IncidentDispatchText.pick)))
                  : _backups(ref, s, current);
              return StResponsive(
                compact: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    listView,
                    const SizedBox(height: StSpace.sm),
                    detail,
                  ],
                ),
                expanded: (context) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: listView),
                    const SizedBox(width: StSpace.md),
                    Expanded(child: detail),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _deliveryTile(
    BuildContext context,
    WidgetRef ref,
    AppState s,
    DelayedDelivery d,
    bool selected,
  ) {
    final reassigned = d.status == DispatchStatus.reassigned;
    return Padding(
      padding: const EdgeInsets.only(bottom: StSpace.xs),
      child: StCard(
        key: ValueKey('delivery-${d.id}'),
        color: selected ? context.roleColor.withValues(alpha: 0.08) : null,
        onTap: () => ref.read(selectedDeliveryProvider.notifier).state = d.id,
        child: Row(
          children: [
            Icon(
              reassigned
                  ? Icons.check_circle_outline
                  : Icons.timer_off_outlined,
              color: reassigned ? StColors.success : StColors.warning,
            ),
            const SizedBox(width: StSpace.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${s.digits(d.orderRef)} · ${d.kitchen}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    s.tx(IncidentDispatchText.delayed, ['${d.delayMinutes}']),
                    style: const TextStyle(fontSize: StFont.label),
                  ),
                  Text(
                    reassigned
                        ? s.tx(IncidentDispatchText.reassignedTo, [
                            d.backupRider ?? '-',
                          ])
                        : s.tx(IncidentDispatchText.riderNow, [d.riderName]),
                    style: const TextStyle(fontSize: StFont.label),
                  ),
                ],
              ),
            ),
            StStatusChip(
              label: s.tx(
                reassigned
                    ? IncidentDispatchText.statusReassigned
                    : IncidentDispatchText.statusDelayed,
              ),
              tone: reassigned ? StTone.success : StTone.warning,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _backups(WidgetRef ref, AppState s, DelayedDelivery d) {
    final repo = ref.read(dispatchRepositoryProvider);
    final actor = ref.read(actorProvider);
    return StSection(
      title: s.tx(IncidentDispatchText.backups),
      child: StAsyncView<List<BackupRider>>(
        value: ref.watch(backupRidersProvider(d.id)),
        supported: states,
        onRetry: () => ref.invalidate(backupRidersProvider(d.id)),
        builder: (context, riders) => StCommandScope(
          builder: (context, cmd) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (d.status == DispatchStatus.reassigned)
                StNote(child: Text(s.tx(IncidentDispatchText.alreadyDone))),
              for (final r in riders)
                Padding(
                  padding: const EdgeInsets.only(bottom: StSpace.xs),
                  child: StCard(
                    child: Row(
                      children: [
                        StAvatar(name: r.name),
                        const SizedBox(width: StSpace.sm),
                        Expanded(
                          child: Text(
                            s.tx(IncidentDispatchText.riderLine, [
                              r.name,
                              '${r.distance} · ${r.vehicle}',
                            ]),
                          ),
                        ),
                        StCommandButton(
                          label: s.tx(IncidentDispatchText.reassign),
                          full: false,
                          size: StBtnSize.sm,
                          busy: cmd.busy,
                          disabledReason: d.status == DispatchStatus.reassigned
                              ? s.tx(IncidentDispatchText.alreadyDone)
                              : null,
                          onTap: () => cmd.run(
                            () => repo.reassignDelivery(
                              actor,
                              RequestId.next('reassign'),
                              deliveryId: d.id,
                              riderId: r.id,
                            ),
                            name: IncidentDispatchText.commandName,
                            success: IncidentDispatchText.success,
                            onSuccess: () =>
                                ref.invalidate(delayedDeliveriesProvider),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
