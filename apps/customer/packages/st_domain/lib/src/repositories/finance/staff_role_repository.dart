import '../../access/actor.dart';
import '../../models/finance/finance_sub_role.dart';
import '../../models/finance/staff_grant.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Finance staff role grants (NF-15), accounting only.
abstract interface class StaffRoleRepository {
  Future<RepoResult<List<StaffGrant>>> staff(Actor actor);

  Future<RepoResult<StaffGrant>> grantStaffRole(Actor actor, RequestId requestId, {required String email, required FinanceSubRole subRole});

  Future<RepoResult<StaffGrant>> revokeStaffRole(Actor actor, RequestId requestId, {required String staffId, required String reason});
}
