import '../../access/actor.dart';
import '../../models/finance/payout_batch.dart';
import '../../models/finance/payout_request_case.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Payout review and batch execution (NF-07, NF-08), accounting only.
abstract interface class PayoutOperationsRepository {
  Future<RepoResult<List<PayoutRequestCase>>> requests(Actor actor);

  Future<RepoResult<PayoutRequestCase>> reviewPayout(Actor actor, RequestId requestId, {required String caseId});

  Future<RepoResult<PayoutRequestCase>> rejectPayout(Actor actor, RequestId requestId, {required String caseId, required String reason});

  Future<RepoResult<List<PayoutBatch>>> batches(Actor actor);

  Future<RepoResult<PayoutBatch>> createPayoutBatch(Actor actor, RequestId requestId, {required List<String> caseIds});

  /// Refused with `businessRuleRejected` when the actor prepared the batch.
  Future<RepoResult<PayoutBatch>> releasePayoutBatch(Actor actor, RequestId requestId, {required String batchId});

  Future<RepoResult<PayoutBatch>> recordPayoutResult(Actor actor, RequestId requestId, {required String batchId, required bool settled, required String reference});
}
