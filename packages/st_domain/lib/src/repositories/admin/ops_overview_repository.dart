import '../../access/actor.dart';
import '../../models/admin/incident_status.dart';
import '../../models/admin/incident_summary.dart';
import '../../models/admin/ops_kpi.dart';
import '../../result/repo_result.dart';

/// Read-only operations overview (NA-01), admin only.
abstract interface class OpsOverviewRepository {
  Future<RepoResult<OpsKpi>> kpis(Actor actor);

  Future<RepoResult<List<IncidentSummary>>> incidents(Actor actor, {IncidentStatus? status});
}
