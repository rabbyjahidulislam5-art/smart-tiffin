import '../../access/actor.dart';
import '../../models/finance/gateway_statement.dart';
import '../../models/finance/recon_exception.dart';
import '../../models/finance/recon_item.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Payment reconciliation (NF-02, NF-13, NF-17), accounting only.
abstract interface class PaymentReconciliationRepository {
  Future<RepoResult<List<ReconItem>>> matches(Actor actor);

  Future<RepoResult<List<ReconException>>> exceptions(Actor actor);

  Future<RepoResult<List<GatewayStatement>>> statements(Actor actor);

  /// Records that a statement's deviations are explained by [evidenceRef].
  Future<RepoResult<GatewayStatement>> reconcileGatewayStatement(Actor actor, RequestId requestId, {required String statementId, required String evidenceRef});

  Future<RepoResult<List<ReconException>>> assignException(Actor actor, RequestId requestId, {required List<String> exceptionIds, required String assignee});
}
