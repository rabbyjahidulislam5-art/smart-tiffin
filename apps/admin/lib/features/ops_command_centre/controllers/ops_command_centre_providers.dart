import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// NA-01 KPI tiles.
final opsKpisProvider = FutureProvider.autoDispose<OpsKpi>(
  (ref) => stUnwrap(
    ref.watch(opsOverviewRepositoryProvider).kpis(ref.watch(actorProvider)),
  ),
);

/// NA-01 incident filter (null = all).
final incidentFilterProvider = StateProvider.autoDispose<IncidentStatus?>(
  (ref) => null,
);

/// NA-01 incident queue for the filter.
final incidentsProvider = FutureProvider.autoDispose<List<IncidentSummary>>((
  ref,
) {
  final status = ref.watch(incidentFilterProvider);
  return stUnwrap(
    ref
        .watch(opsOverviewRepositoryProvider)
        .incidents(ref.watch(actorProvider), status: status),
  );
});
