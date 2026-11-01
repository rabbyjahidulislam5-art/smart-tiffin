/// Workspace roles. Moved from `st_shell` (LC-7, DD-2); `st_shell` re-exports it.
enum StRole { customer, supplier, rider, admin, accounting }

/// The role that owns a screen id, or null for role-less ids (AU-, SH-, P-, X-).
///
/// C-, NC- customer; S-, NS- supplier; R-, NR- rider; A-, NA- admin;
/// NF- accounting.
StRole? roleForScreenId(String id) {
  if (id.startsWith('NC-') || id.startsWith('C-')) return StRole.customer;
  if (id.startsWith('NS-') || id.startsWith('S-')) return StRole.supplier;
  if (id.startsWith('NR-') || id.startsWith('R-')) return StRole.rider;
  if (id.startsWith('NA-') || id.startsWith('A-')) return StRole.admin;
  if (id.startsWith('NF-')) return StRole.accounting;
  return null;
}
