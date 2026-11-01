import 'finance_sub_role.dart';
import 'grant_status.dart';

/// A staff member's finance sub-role grant (NF-15).
class StaffGrant {
  const StaffGrant({
    required this.staffId,
    required this.name,
    required this.email,
    required this.subRole,
    required this.status,
  });

  final String staffId;
  final String name;
  final String email;
  final FinanceSubRole subRole;
  final GrantStatus status;

  StaffGrant withStatus(GrantStatus s) => StaffGrant(staffId: staffId, name: name, email: email, subRole: subRole, status: s);
}
