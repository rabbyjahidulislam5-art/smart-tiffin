import '../../access/actor.dart';
import '../../models/finance/payable_row.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Supplier and rider payable ledgers (NF-05, NF-06), accounting only.
abstract interface class SettlementLedgerRepository {
  Future<RepoResult<List<PayableRow>>> supplierPayables(Actor actor);

  Future<RepoResult<List<PayableRow>>> riderPayables(Actor actor);

  Future<RepoResult<PayableRow>> placeHold(Actor actor, RequestId requestId, {required String partyId, required String reason});

  Future<RepoResult<PayableRow>> releaseHold(Actor actor, RequestId requestId, {required String partyId, required String reason});
}
