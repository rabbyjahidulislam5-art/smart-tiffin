import '../../access/actor.dart';
import '../../models/admin/limited_finance_kpis.dart';
import '../../models/finance/full_finance_kpis.dart';
import '../../result/repo_result.dart';

/// Finance KPIs: `limited` for admin and accounting (NA-05), `full` for
/// accounting only (NF-01).
abstract interface class FinanceKpiRepository {
  Future<RepoResult<LimitedFinanceKpis>> limited(Actor actor);

  Future<RepoResult<FullFinanceKpis>> full(Actor actor);
}
