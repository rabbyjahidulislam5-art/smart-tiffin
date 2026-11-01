import '../../access/actor.dart';
import '../../models/customer/refund_case.dart';
import '../../result/repo_result.dart';
import '../../result/st_page.dart';

/// Refunds and disputes of the signed-in customer (NC-17).
abstract interface class RefundRepository {
  Future<RepoResult<StPage<RefundCase>>> refunds(Actor actor, {String? cursor});

  Future<RepoResult<RefundCase>> refund(Actor actor, String id);
}
