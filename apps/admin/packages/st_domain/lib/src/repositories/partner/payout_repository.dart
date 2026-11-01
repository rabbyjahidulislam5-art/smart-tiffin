import '../../access/actor.dart';
import '../../models/partner/eligible_balance.dart';
import '../../models/partner/payout_record.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../result/st_page.dart';

/// Payout requests of a supplier (NS-02, NS-03) or rider (NR-02).
abstract interface class PayoutRepository {
  Future<RepoResult<EligibleBalance>> eligibleBalance(Actor actor);

  Future<RepoResult<StPage<PayoutRecord>>> history(Actor actor, {String? cursor});

  /// Command. Amount from 0.01 to 999,999.99 and not above the eligible balance.
  Future<RepoResult<PayoutRecord>> requestPayout(Actor actor, RequestId requestId, {required int amountMinor});
}
