import '../../access/actor.dart';
import '../../models/finance/adjustment.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Financial adjustments with maker-checker (NF-16), accounting only.
abstract interface class AdjustmentRepository {
  Future<RepoResult<List<Adjustment>>> adjustments(Actor actor);

  Future<RepoResult<Adjustment>> requestAdjustment(
    Actor actor,
    RequestId requestId, {
    required String description,
    required int amountMinor,
    required String evidenceRef,
  });

  /// Refused with `businessRuleRejected` when the actor is the maker.
  Future<RepoResult<Adjustment>> approveAdjustment(Actor actor, RequestId requestId, {required String adjustmentId, required bool approve});
}
