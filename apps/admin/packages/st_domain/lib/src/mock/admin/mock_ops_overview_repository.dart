import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/admin/incident_severity.dart';
import '../../models/admin/incident_status.dart';
import '../../models/admin/incident_summary.dart';
import '../../models/admin/ops_kpi.dart';
import '../../repositories/admin/ops_overview_repository.dart';
import '../../result/repo_result.dart';
import '../../text/st_text.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';

class MockOpsOverviewRepository extends MockRepositoryBase implements OpsOverviewRepository {
  MockOpsOverviewRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.admin};

  static const incidentFixtures = <IncidentSummary>[
    IncidentSummary(id: 'INC-14', title: StText('Rider delayed on Banani route', 'বনানী রুটে রাইডার দেরি করছে'), severity: IncidentSeverity.high, status: IncidentStatus.open, ageMinutes: 12),
    IncidentSummary(id: 'INC-13', title: StText('Kitchen reports gas outage', 'কিচেনে গ্যাস সংযোগ বন্ধ'), severity: IncidentSeverity.medium, status: IncidentStatus.assigned, ageMinutes: 48),
    IncidentSummary(id: 'INC-11', title: StText('Customer reports missing item', 'গ্রাহক আইটেম না পাওয়ার কথা জানিয়েছেন'), severity: IncidentSeverity.low, status: IncidentStatus.resolved, ageMinutes: 190),
  ];

  @override
  Future<RepoResult<OpsKpi>> kpis(Actor actor) => guardRead(
        actor,
        roles,
        'kpis',
        () => const Ok(OpsKpi(
          ongoingOrders: 128,
          lateOrders: 4,
          kitchensNearCapacity: 2,
          dispatchRisk: 3,
          openIncidents: 2,
          pendingApplications: 4,
          generatedAt: '2026-11-02 12:40',
        )),
      );

  @override
  Future<RepoResult<List<IncidentSummary>>> incidents(Actor actor, {IncidentStatus? status}) =>
      guardRead(actor, roles, 'incidents', () => Ok([for (final i in incidentFixtures) if (status == null || i.status == status) i]));
}
