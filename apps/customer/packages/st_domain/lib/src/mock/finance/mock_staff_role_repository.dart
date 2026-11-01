import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/finance/finance_sub_role.dart';
import '../../models/finance/grant_status.dart';
import '../../models/finance/staff_grant.dart';
import '../../repositories/finance/staff_role_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';
import 'finance_staff.dart';

class MockStaffRoleRepository extends MockRepositoryBase implements StaffRoleRepository {
  MockStaffRoleRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.accounting};

  final List<StaffGrant> _staff = [
    const StaffGrant(staffId: FinanceStaff.me, name: 'You', email: 'accounts@smarttiffin.bd', subRole: FinanceSubRole.accountsManager, status: GrantStatus.active),
    const StaffGrant(staffId: FinanceStaff.operator, name: 'Rahim', email: 'rahim@smarttiffin.bd', subRole: FinanceSubRole.accountsOperator, status: GrantStatus.active),
    const StaffGrant(staffId: FinanceStaff.approver, name: 'Sadia', email: 'sadia@smarttiffin.bd', subRole: FinanceSubRole.payoutApprover, status: GrantStatus.active),
    const StaffGrant(staffId: 'farid.finv', name: 'Farid', email: 'farid@smarttiffin.bd', subRole: FinanceSubRole.financeViewer, status: GrantStatus.revoked),
  ];
  int _seq = 0;

  @override
  Future<RepoResult<List<StaffGrant>>> staff(Actor actor) => guardRead(actor, roles, 'staff', () => Ok(List.unmodifiable(_staff)));

  @override
  Future<RepoResult<StaffGrant>> grantStaffRole(Actor actor, RequestId requestId, {required String email, required FinanceSubRole subRole}) =>
      guardCommand(actor, roles, 'grantStaffRole', requestId, () {
        final address = email.trim().toLowerCase();
        if (!RegExp(r'^[a-z0-9._-]+@smarttiffin\.bd$').hasMatch(address)) return MockRepositoryBase.invalid('email');
        final mine = _staff.where((s) => s.staffId == actor.id).map((s) => s.email).toSet();
        if (mine.contains(address)) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'email'));
        if (_staff.any((s) => s.email == address && s.subRole == subRole && s.status == GrantStatus.active)) {
          return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        }
        final g = StaffGrant(staffId: 'staff-${++_seq}', name: address.split('@').first, email: address, subRole: subRole, status: GrantStatus.active);
        _staff.add(g);
        return Ok(g);
      });

  @override
  Future<RepoResult<StaffGrant>> revokeStaffRole(Actor actor, RequestId requestId, {required String staffId, required String reason}) =>
      guardCommand(actor, roles, 'revokeStaffRole', requestId, () {
        final i = _staff.indexWhere((s) => s.staffId == staffId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (staffId == actor.id) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'staff'));
        if (_staff[i].status != GrantStatus.active) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (reason.trim().length < 5) return MockRepositoryBase.invalid('reason');
        final next = _staff[i].withStatus(GrantStatus.revoked);
        _staff[i] = next;
        return Ok(next);
      });
}
