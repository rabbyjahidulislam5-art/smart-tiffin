import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/admin/limited_finance_kpis.dart';
import '../../models/finance/full_finance_kpis.dart';
import '../../models/finance/period_status.dart';
import '../../repositories/admin/finance_kpi_repository.dart';
import '../../result/repo_result.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';

/// Sample finance KPIs (HYPOTHETICAL figures).
class MockFinanceKpiRepository extends MockRepositoryBase implements FinanceKpiRepository {
  MockFinanceKpiRepository({MockBehavior? behavior}) : super(behavior);

  static const limitedRoles = {StRole.admin, StRole.accounting};
  static const fullRoles = {StRole.accounting};

  @override
  Future<RepoResult<LimitedFinanceKpis>> limited(Actor actor) => guardRead(
        actor,
        limitedRoles,
        'limited',
        () => const Ok(LimitedFinanceKpis(
          orderVolumeChangePercent: 12,
          collectionRatePercent: 96,
          openExceptionCount: 3,
          pendingPayoutRequestCount: 5,
          periodStatus: PeriodStatus.open,
        )),
      );

  @override
  Future<RepoResult<FullFinanceKpis>> full(Actor actor) => guardRead(
        actor,
        fullRoles,
        'full',
        () => const Ok(FullFinanceKpis(
          period: '2026-11',
          verifiedCollectionsMinor: 128450000,
          receivablesMinor: 36200000,
          supplierPayablesMinor: 41280000,
          riderPayablesMinor: 6940000,
          creditLiabilityMinor: 1225000,
          codAwaitingMinor: 1134000,
          availableFundsMinor: 72600000,
          pendingSettlementsMinor: 4980000,
          completedSettlementsMinor: 63410000,
          refundObligationsMinor: 342000,
          revenueMinor: 19268000,
          exceptionCount: 3,
          generatedAt: '2026-11-02 12:40',
        )),
      );
}
