import '../../access/actor.dart';
import '../../models/finance/credit_liability_row.dart';
import '../../models/finance/refund_ops_case.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Credit liability and refund operations (NF-09, NF-10), accounting only.
abstract interface class CreditAndRefundRepository {
  Future<RepoResult<List<CreditLiabilityRow>>> liability(Actor actor);

  Future<RepoResult<CreditLiabilityRow>> voidCredit(Actor actor, RequestId requestId, {required String rowId, required String reason});

  Future<RepoResult<List<RefundOpsCase>>> cases(Actor actor);

  Future<RepoResult<RefundOpsCase>> initiateRefund(Actor actor, RequestId requestId, {required String caseId});

  Future<RepoResult<RefundOpsCase>> recordRefundResult(Actor actor, RequestId requestId, {required String caseId, required bool executed, required String providerRef});
}
