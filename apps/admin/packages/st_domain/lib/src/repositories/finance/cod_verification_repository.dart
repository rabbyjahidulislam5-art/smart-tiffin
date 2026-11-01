import '../../access/actor.dart';
import '../../models/finance/cod_custody_row.dart';
import '../../models/finance/cod_remittance_case.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// COD custody and remittance verification (NF-03, NF-04), accounting only.
abstract interface class CodVerificationRepository {
  Future<RepoResult<List<CodCustodyRow>>> custody(Actor actor);

  Future<RepoResult<List<CodRemittanceCase>>> remittances(Actor actor);

  Future<RepoResult<CodRemittanceCase>> remittance(Actor actor, String id);

  /// Confirms (or rejects) a remittance against its deposit reference.
  Future<RepoResult<CodRemittanceCase>> verifyCodRemittance(
    Actor actor,
    RequestId requestId, {
    required String remittanceId,
    required String depositReference,
    required bool accept,
  });
}
