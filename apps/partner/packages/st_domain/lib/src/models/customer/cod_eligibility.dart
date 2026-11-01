/// Result of the server COD check (BR-012); sample while the policy is pending.
class CodEligibility {
  const CodEligibility({required this.eligible, this.reasonKey, this.sample = true});

  final bool eligible;

  /// Why COD is refused (`amount`, `policy`), or null.
  final String? reasonKey;
  final bool sample;
}
