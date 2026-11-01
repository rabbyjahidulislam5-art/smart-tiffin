import '../../access/st_role.dart';
import '../../repositories/auth/staff_auth_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';

/// Sample staff accounts.
///
/// Keeps the AU-13 admin behaviour identical (any invited `@smarttiffin.bd`
/// address with a password of at least 8 characters, prefilled
/// `nadia@smarttiffin.bd`) and adds the accounting sample account
/// `accounts@smarttiffin.bd` (Decision D-03, option A).
class MockStaffAuthRepository extends MockRepositoryBase implements StaffAuthRepository {
  MockStaffAuthRepository({MockBehavior? behavior}) : super(behavior);

  static const adminEmail = 'nadia@smarttiffin.bd';
  static const accountingEmail = 'accounts@smarttiffin.bd';
  static const staffDomain = '@smarttiffin.bd';

  @override
  Future<RepoResult<StRole>> verifyCredentials(String email, String password) async {
    final e = await open('verifyCredentials');
    if (e != null) return Err<StRole>(e);
    final address = email.trim().toLowerCase();
    if (!address.endsWith(staffDomain) || password.length < 8) {
      return const Err<StRole>(RepoError(RepoErrorKind.unauthenticated));
    }
    if (address == accountingEmail) return const Ok<StRole>(StRole.accounting);
    return const Ok<StRole>(StRole.admin);
  }
}
