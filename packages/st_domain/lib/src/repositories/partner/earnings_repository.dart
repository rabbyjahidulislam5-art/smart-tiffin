import '../../access/actor.dart';
import '../../models/partner/earning_balances.dart';
import '../../models/partner/earning_status.dart';
import '../../models/partner/rider_earning.dart';
import '../../models/partner/rider_earning_status.dart';
import '../../models/partner/supplier_earning.dart';
import '../../result/repo_result.dart';

/// Earnings of the signed-in supplier (NS-01) or rider (NR-01), own data only.
abstract interface class EarningsRepository {
  Future<RepoResult<List<SupplierEarning>>> supplierEarnings(Actor actor, {EarningStatus? status});

  Future<RepoResult<EarningBalances>> supplierBalances(Actor actor);

  Future<RepoResult<List<RiderEarning>>> riderEarnings(Actor actor, {RiderEarningStatus? status});

  Future<RepoResult<EarningBalances>> riderBalances(Actor actor);
}
