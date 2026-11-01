import '../../access/actor.dart';
import '../../models/admin/policy_version.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Business policy versions (NA-02), admin only.
abstract interface class PolicyRepository {
  Future<RepoResult<List<PolicyVersion>>> versions(Actor actor);

  Future<RepoResult<PolicyVersion>> publishPolicyVersion(
    Actor actor,
    RequestId requestId, {
    required String key,
    required String value,
    required String effectiveFrom,
  });
}
