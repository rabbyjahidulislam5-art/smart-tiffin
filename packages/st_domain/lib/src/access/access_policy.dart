import 'access_decision.dart';
import 'denied_reason.dart';
import 'st_role.dart';

/// The single access rule for every navigation (design: decision table).
///
/// Evaluated top to bottom:
/// 1. id not in [knownIds] -> Denied(unknownId)
/// 2. id has no owning role (AU-, SH-, P-, X-) -> Allowed
/// 3. owning role not in [appRoles] -> Denied(roleNotInApp)
/// 4. owning role differs from [activeRole] -> Denied(roleMismatch)
/// 5. owning role is not customer and [sessions] lacks it -> Denied(noSession)
/// 6. otherwise -> Allowed
AccessDecision decideAccess({
  required String screenId,
  required StRole activeRole,
  required Set<StRole> sessions,
  required Set<StRole> appRoles,
  required Set<String> knownIds,
}) {
  if (!knownIds.contains(screenId)) return const Denied(DeniedReason.unknownId);
  final owner = roleForScreenId(screenId);
  if (owner == null) return const Allowed();
  if (!appRoles.contains(owner)) return const Denied(DeniedReason.roleNotInApp);
  if (owner != activeRole) return const Denied(DeniedReason.roleMismatch);
  if (owner != StRole.customer && !sessions.contains(owner)) {
    return const Denied(DeniedReason.noSession);
  }
  return const Allowed();
}
