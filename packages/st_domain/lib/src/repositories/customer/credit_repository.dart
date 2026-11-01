import '../../access/actor.dart';
import '../../models/customer/credit_account.dart';
import '../../models/customer/credit_class.dart';
import '../../models/customer/credit_transaction.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../result/st_page.dart';

/// Service credits of the signed-in customer (NC-11, NC-16).
abstract interface class CreditRepository {
  Future<RepoResult<CreditAccount>> account(Actor actor);

  Future<RepoResult<StPage<CreditTransaction>>> transactions(Actor actor, {CreditClass? creditClass, String? cursor});

  /// Credit reserved for a checkout quote.
  Future<RepoResult<int>> reservedFor(Actor actor, String quoteId);

  Future<RepoResult<CreditAccount>> reserveCredit(Actor actor, RequestId requestId, {required String quoteId, required int amountMinor});

  Future<RepoResult<CreditAccount>> consumeCredit(Actor actor, RequestId requestId, {required String quoteId});

  Future<RepoResult<CreditAccount>> releaseCredit(Actor actor, RequestId requestId, {required String quoteId});
}
