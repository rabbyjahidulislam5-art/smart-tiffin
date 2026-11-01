import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/finance_roles_text.dart';

/// NF-15 staff grants.
final staffGrantsProvider = FutureProvider.autoDispose<List<StaffGrant>>(
  (ref) => stUnwrap(
    ref.watch(staffRoleRepositoryProvider).staff(ref.watch(actorProvider)),
  ),
);

/// NF-15 grant form values.
typedef GrantValues = ({String email, FinanceSubRole? subRole});

/// NF-15 grant form (`grantStaffRole`).
final grantFormProvider =
    StateNotifierProvider.autoDispose<
      StFormController<GrantValues>,
      StFormState<GrantValues>
    >((ref) {
      final repo = ref.watch(staffRoleRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<GrantValues>(
        initial: (email: '', subRole: null),
        validate: (v) => {
          if (!RegExp(r'^[a-z0-9._-]+@smarttiffin\.bd$')
              .hasMatch(v.email.trim().toLowerCase()))
            'email': FinanceRolesText.emailBad,
          if (v.subRole == null) 'subRole': FinanceRolesText.chooseRole,
        },
        command: (v, id) => repo.grantStaffRole(
          actor,
          id,
          email: v.email.trim().toLowerCase(),
          subRole: v.subRole ?? FinanceSubRole.financeViewer,
        ),
      );
    });
