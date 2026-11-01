import 'package:st_domain/st_domain.dart';

import '../repo_check.dart';

const adminActor = Actor(StRole.admin, id: 'demo-admin');
const adminAccountingActor = Actor(StRole.accounting, id: 'demo-accounting');

MockBehavior _instant() => MockBehavior.instant();

final opsOverviewChecks = <RepoCheck>[
  (
    name:
        'ops overview: KPIs and incidents read the mock data; the filter works',
    run: () async {
      final repo = MockOpsOverviewRepository(behavior: _instant());
      final k = (await repo.kpis(adminActor)).valueOrNull;
      final open =
          (await repo.incidents(adminActor, status: IncidentStatus.open))
              .valueOrNull;
      return k?.ongoingOrders == 128 &&
          open != null &&
          open.every((i) => i.status == IncidentStatus.open);
    },
  ),
  (
    name: 'ops overview: accounting is refused',
    run: () async =>
        (await MockOpsOverviewRepository(behavior: _instant())
                .kpis(adminAccountingActor))
            .errorOrNull
            ?.kind ==
        RepoErrorKind.permissionDenied,
  ),
];

final policyChecks = <RepoCheck>[
  (
    name: 'policy: a published version is read back and supersedes the old one',
    run: () async {
      final repo = MockPolicyRepository(behavior: _instant());
      await repo.publishPolicyVersion(adminActor, RequestId.next('t'),
          key: 'policy.discount.rules',
          value: 'none',
          effectiveFrom: '2026-12-01');
      await repo.publishPolicyVersion(adminActor, RequestId.next('t'),
          key: 'policy.discount.rules',
          value: '5% weekly',
          effectiveFrom: '2026-12-15');
      final list = (await repo.versions(adminActor)).valueOrNull ?? const [];
      final mine = list.where((v) => v.key == 'policy.discount.rules').toList();
      return mine.first.status == PolicyStatus.published &&
          mine.first.value == '5% weekly' &&
          mine.any((v) => v.status == PolicyStatus.superseded);
    },
  ),
  (
    name: 'policy: an unknown key, a short value and a past date are invalid',
    run: () async {
      final repo = MockPolicyRepository(behavior: _instant());
      final a = await repo.publishPolicyVersion(adminActor, RequestId.next('t'),
          key: 'policy.x', value: 'abc', effectiveFrom: '2026-12-01');
      final b = await repo.publishPolicyVersion(adminActor, RequestId.next('t'),
          key: 'policy.discount.rules',
          value: 'a',
          effectiveFrom: '2026-12-01');
      final c = await repo.publishPolicyVersion(adminActor, RequestId.next('t'),
          key: 'policy.discount.rules',
          value: 'abc',
          effectiveFrom: '2026-01-01');
      return a.errorOrNull?.field == 'key' &&
          b.errorOrNull?.field == 'value' &&
          c.errorOrNull?.field == 'effectiveFrom' &&
          repo.revision == 0;
    },
  ),
];

final applicationReviewChecks = <RepoCheck>[
  (
    name: 'applications: approve is refused until every check is ticked',
    run: () async {
      final repo = MockApplicationReviewRepository(behavior: _instant());
      final list = (await repo.queue(adminActor)).valueOrNull ?? const [];
      final incomplete = list.firstWhere((c) => !c.allChecked);
      final r = await repo.decideApplication(adminActor, RequestId.next('t'),
          id: incomplete.id,
          decision: ApplicationDecision.approve,
          checklist: const {});
      return r.errorOrNull ==
              const RepoError(RepoErrorKind.businessRuleRejected,
                  field: 'checklist') &&
          repo.revision == 0;
    },
  ),
  (
    name: 'applications: an approval with every check is read back',
    run: () async {
      final repo = MockApplicationReviewRepository(behavior: _instant());
      final first =
          ((await repo.queue(adminActor)).valueOrNull ?? const []).first;
      final r = await repo.decideApplication(adminActor, RequestId.next('t'),
          id: first.id,
          decision: ApplicationDecision.approve,
          checklist: const {
            'identity': true,
            'premises': true,
            'compliance': true
          });
      final back = (await repo.application(adminActor, first.id)).valueOrNull;
      return r.isOk && back?.status == ApplicationStatus.approved;
    },
  ),
  (
    name: 'applications: reject needs a reason of 10 characters',
    run: () async {
      final repo = MockApplicationReviewRepository(behavior: _instant());
      final first =
          ((await repo.queue(adminActor)).valueOrNull ?? const []).first;
      final r = await repo.decideApplication(adminActor, RequestId.next('t'),
          id: first.id,
          decision: ApplicationDecision.reject,
          checklist: const {},
          reason: 'short');
      return r.errorOrNull?.field == 'reason';
    },
  ),
  (
    name: 'applications: an unknown id is not available',
    run: () async =>
        (await MockApplicationReviewRepository(behavior: _instant())
                .application(adminActor, 'nobody'))
            .errorOrNull
            ?.kind ==
        RepoErrorKind.notAvailable,
  ),
];

final dispatchChecks = <RepoCheck>[
  (
    name: 'dispatch: a reassignment is read back and cannot be repeated',
    run: () async {
      final repo = MockDispatchRepository(behavior: _instant());
      final r = await repo.reassignDelivery(adminActor, RequestId.next('t'),
          deliveryId: 'DL-913', riderId: 'rider-sabbir');
      final again = await repo.reassignDelivery(adminActor, RequestId.next('t'),
          deliveryId: 'DL-913', riderId: 'rider-mitu');
      final d = (await repo.delayedDeliveries(adminActor))
          .valueOrNull
          ?.firstWhere((x) => x.id == 'DL-913');
      return r.isOk &&
          d?.status == DispatchStatus.reassigned &&
          d?.backupRider == 'Sabbir Hasan' &&
          again.errorOrNull?.kind == RepoErrorKind.businessRuleRejected;
    },
  ),
  (
    name: 'dispatch: backup riders of an unknown delivery are not available',
    run: () async =>
        (await MockDispatchRepository(behavior: _instant())
                .backupRiders(adminActor, 'DL-0'))
            .errorOrNull
            ?.kind ==
        RepoErrorKind.notAvailable,
  ),
];

final financeKpiChecks = <RepoCheck>[
  (
    name: 'finance KPIs: admin reads the limited view only',
    run: () async {
      final repo = MockFinanceKpiRepository(behavior: _instant());
      final limited = await repo.limited(adminActor);
      final full = await repo.full(adminActor);
      return limited.isOk &&
          full.errorOrNull?.kind == RepoErrorKind.permissionDenied;
    },
  ),
  (
    name: 'finance KPIs: accounting reads the full view',
    run: () async =>
        (await MockFinanceKpiRepository(behavior: _instant())
                .full(adminAccountingActor))
            .valueOrNull
            ?.period ==
        '2026-11',
  ),
];

final reportChecks = <RepoCheck>[
  (
    name: 'reports: each scope is readable only by its role',
    run: () async {
      final repo = MockReportRepository(behavior: _instant());
      final ops = await repo.definitions(adminActor, ReportScope.operational);
      final fin = await repo.definitions(adminActor, ReportScope.financial);
      final finAcc =
          await repo.definitions(adminAccountingActor, ReportScope.financial);
      return (ops.valueOrNull
                  ?.every((d) => d.scope == ReportScope.operational) ??
              false) &&
          fin.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          (finAcc.valueOrNull?.isNotEmpty ?? false);
    },
  ),
  (
    name:
        'reports: an export is read back in the log; a future range is invalid',
    run: () async {
      final repo = MockReportRepository(behavior: _instant());
      final r = await repo.exportReport(adminActor, RequestId.next('t'),
          definitionId: 'OPS-LATE', range: '2026-10-01..2026-10-31');
      final bad = await repo.exportReport(adminActor, RequestId.next('t'),
          definitionId: 'OPS-LATE', range: '2026-10-01..2027-01-01');
      final log = (await repo.exportLog(adminActor, ReportScope.operational))
              .valueOrNull ??
          const [];
      return r.isOk &&
          log.any((x) => x.id == r.valueOrNull?.id) &&
          bad.errorOrNull?.field == 'range';
    },
  ),
];
