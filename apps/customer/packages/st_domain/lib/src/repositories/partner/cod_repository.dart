import '../../access/actor.dart';
import '../../models/partner/cod_collection.dart';
import '../../models/partner/cod_discrepancy.dart';
import '../../models/partner/cod_remittance.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// COD custody of the signed-in rider (NR-03, NR-04, NR-05).
abstract interface class CodRepository {
  Future<RepoResult<List<CodCollection>>> collections(Actor actor);

  /// Cash collected and not yet remitted (the rider's COD liability).
  Future<RepoResult<int>> liability(Actor actor);

  Future<RepoResult<CodCollection>> recordCodCollection(Actor actor, RequestId requestId, {required String collectionId, required int amountMinor});

  Future<RepoResult<List<CodRemittance>>> remittances(Actor actor);

  Future<RepoResult<CodRemittance>> submitCodRemittance(
    Actor actor,
    RequestId requestId, {
    required int amountMinor,
    required String reference,
    required String method,
  });

  Future<RepoResult<List<CodDiscrepancy>>> discrepancies(Actor actor);

  /// The rider's response to a mismatch case (`flagCodDiscrepancy`).
  Future<RepoResult<CodDiscrepancy>> respondToDiscrepancy(Actor actor, RequestId requestId, {required String discrepancyId, required String response});
}
