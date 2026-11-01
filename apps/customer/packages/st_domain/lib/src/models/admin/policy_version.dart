import 'policy_status.dart';

/// A versioned, effective-dated business policy value (NA-02).
class PolicyVersion {
  const PolicyVersion({
    required this.id,
    required this.key,
    required this.rule,
    required this.value,
    required this.effectiveFrom,
    required this.status,
    required this.author,
  });

  final String id;

  /// Configuration key, for example `policy.cutoff.change`.
  final String key;

  /// Business rule reference (BR-xxx).
  final String rule;

  /// Empty while the policy is not configured.
  final String value;
  final String effectiveFrom;
  final PolicyStatus status;
  final String author;
}
