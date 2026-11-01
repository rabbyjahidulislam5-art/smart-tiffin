import '../../access/st_role.dart';
import '../../result/repo_result.dart';

/// Staff sign-in for AU-13. Runs before a session exists, so it is the only
/// repository without a role gate.
abstract interface class StaffAuthRepository {
  /// The role granted to the staff account, or `unauthenticated`.
  Future<RepoResult<StRole>> verifyCredentials(String email, String password);
}
