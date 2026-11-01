import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/ops_command_centre_providers.dart';
import 'ops_command_centre_text.dart';

/// NA-01 Desktop operations command centre: KPI tiles that drill into the
/// authorised detail, the incident queue and the work queues (reads only).
class OpsCommandCentreDashboard extends ConsumerWidget {
  const OpsCommandCentreDashboard({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static StText statusText(IncidentStatus st) => switch (st) {
    IncidentStatus.open => OpsCommandCentreText.statusOpen,
    IncidentStatus.assigned => OpsCommandCentreText.statusAssigned,
    IncidentStatus.resolved => OpsCommandCentreText.statusResolved,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final filter = ref.watch(incidentFilterProvider);
    return StScreen(
      title: s.tx(OpsCommandCentreText.title),
      eyebrow: s.tx(OpsCommandCentreText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StAsyncView<OpsKpi>(
            value: ref.watch(opsKpisProvider),
            supported: states,
            onRetry: () => ref.invalidate(opsKpisProvider),
            builder: (context, k) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StKpiGrid(
                  children: [
                    StStat(
                      label: s.tx(OpsCommandCentreText.ongoing),
                      value: s.digits('${k.ongoingOrders}'),
                      icon: Icons.receipt_long_rounded,
                      onTap: () => stOpen(ref, 'A-10'),
                    ),
                    StStat(
                      label: s.tx(OpsCommandCentreText.late),
                      value: s.digits('${k.lateOrders}'),
                      icon: Icons.timer_off_outlined,
                      onTap: () => stOpen(ref, 'A-10'),
                    ),
                    StStat(
                      label: s.tx(OpsCommandCentreText.nearCapacity),
                      value: s.digits('${k.kitchensNearCapacity}'),
                      icon: Icons.storefront_outlined,
                      onTap: () => stOpen(ref, 'A-08'),
                    ),
                    StStat(
                      label: s.tx(OpsCommandCentreText.dispatchRisk),
                      value: s.digits('${k.dispatchRisk}'),
                      icon: Icons.two_wheeler_rounded,
                      onTap: () => stOpen(ref, 'NA-04'),
                    ),
                    StStat(
                      label: s.tx(OpsCommandCentreText.openIncidents),
                      value: s.digits('${k.openIncidents}'),
                      icon: Icons.warning_amber_rounded,
                      onTap: () => stOpen(ref, 'A-03'),
                    ),
                    StStat(
                      label: s.tx(OpsCommandCentreText.pendingApplications),
                      value: s.digits('${k.pendingApplications}'),
                      icon: Icons.how_to_reg_outlined,
                      onTap: () => stOpen(ref, 'NA-03'),
                    ),
                  ],
                ),
                const SizedBox(height: StSpace.xxs),
                Text(
                  s.tx(OpsCommandCentreText.generated, [k.generatedAt]),
                  style: TextStyle(
                    fontSize: StFont.caption,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: StSpace.md),
          StResponsive(
            compact: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _incidents(context, ref, s, filter),
                const SizedBox(height: StSpace.md),
                _queues(ref, s),
              ],
            ),
            expanded: (context) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _incidents(context, ref, s, filter)),
                const SizedBox(width: StSpace.md),
                Expanded(flex: 2, child: _queues(ref, s)),
              ],
            ),
          ),
          const SizedBox(height: StSpace.sm),
          StNote(
            tone: StNoteTone.policy,
            child: Text(s.tx(OpsCommandCentreText.financeNote)),
          ),
        ],
      ),
    );
  }

  static Widget _incidents(
    BuildContext context,
    WidgetRef ref,
    AppState s,
    IncidentStatus? filter,
  ) => StSection(
    title: s.tx(OpsCommandCentreText.incidents),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StChipRow(
          options: [
            (v: 'all', l: s.tx(OpsCommandCentreText.filterAll)),
            for (final st in IncidentStatus.values)
              (v: st.name, l: s.tx(statusText(st))),
          ],
          value: filter?.name ?? 'all',
          onChanged: (v) => ref.read(incidentFilterProvider.notifier).state =
              v == 'all' ? null : IncidentStatus.values.byName(v),
        ),
        const SizedBox(height: StSpace.xs),
        StAsyncView<List<IncidentSummary>>(
          value: ref.watch(incidentsProvider),
          supported: states,
          isEmpty: (l) => l.isEmpty,
          emptyMessage: OpsCommandCentreText.noIncidents,
          onRetry: () => ref.invalidate(incidentsProvider),
          builder: (context, list) => StList(
            children: [
              for (final i in list)
                StRowTile(
                  key: ValueKey('incident-${i.id}'),
                  icon: Icons.report_outlined,
                  label: s.tx(i.title),
                  sub:
                      '${s.digits(i.id)} · ${s.tx(OpsCommandCentreText.age, ['${i.ageMinutes}'])} · ${s.tx(statusText(i.status))}',
                  right: StStatusChip(
                    label: s.tx(switch (i.severity) {
                      IncidentSeverity.high => OpsCommandCentreText.high,
                      IncidentSeverity.medium => OpsCommandCentreText.medium,
                      IncidentSeverity.low => OpsCommandCentreText.low,
                    }),
                    tone: switch (i.severity) {
                      IncidentSeverity.high => StTone.danger,
                      IncidentSeverity.medium => StTone.warning,
                      IncidentSeverity.low => StTone.muted,
                    },
                  ),
                  onTap: () => stOpen(ref, 'A-02', {'id': i.id}),
                ),
            ],
          ),
        ),
      ],
    ),
  );

  static Widget _queues(WidgetRef ref, AppState s) => StSection(
    title: s.tx(OpsCommandCentreText.workQueues),
    child: StList(
      children: [
        StRowTile(
          icon: Icons.policy_outlined,
          label: s.tx(OpsCommandCentreText.policy),
          onTap: () => stOpen(ref, 'NA-02'),
        ),
        StRowTile(
          icon: Icons.how_to_reg_outlined,
          label: s.tx(OpsCommandCentreText.verification),
          onTap: () => stOpen(ref, 'NA-03'),
        ),
        StRowTile(
          icon: Icons.alt_route_rounded,
          label: s.tx(OpsCommandCentreText.dispatcher),
          onTap: () => stOpen(ref, 'NA-04'),
        ),
        StRowTile(
          icon: Icons.insights_outlined,
          label: s.tx(OpsCommandCentreText.oversight),
          onTap: () => stOpen(ref, 'NA-05'),
        ),
        StRowTile(
          icon: Icons.insert_chart_outlined,
          label: s.tx(OpsCommandCentreText.reports),
          onTap: () => stOpen(ref, 'NA-06'),
        ),
      ],
    ),
  );
}
