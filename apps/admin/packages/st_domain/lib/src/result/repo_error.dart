/// Error categories (CUSTOMER_NEW_SCREENS.md section 3.4). The UI maps each
/// kind to a localized message; no free text travels with an error.
enum RepoErrorKind {
  unauthenticated,
  permissionDenied,
  invalidInput,
  policyNotConfigured,
  businessRuleRejected,
  conflict,
  notAvailable,
  rateLimited,
  temporarilyUnavailable,
  outcomeUnknown,
  internalError,
}

/// A repository failure: a [kind] and, for `invalidInput`, the [field] name.
/// It carries no message text and no stack trace.
class RepoError {
  const RepoError(this.kind, {this.field});

  final RepoErrorKind kind;
  final String? field;

  @override
  bool operator ==(Object other) => other is RepoError && other.kind == kind && other.field == field;

  @override
  int get hashCode => Object.hash(kind, field);

  @override
  String toString() => field == null ? 'RepoError(${kind.name})' : 'RepoError(${kind.name}, $field)';
}
