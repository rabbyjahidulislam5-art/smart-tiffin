/// What a supplier or rider may request as a payout right now.
class EligibleBalance {
  const EligibleBalance({
    required this.eligibleMinor,
    required this.heldMinor,
    required this.pendingMinor,
    required this.destination,
  });

  final int eligibleMinor;
  final int heldMinor;

  /// Requested but not yet settled.
  final int pendingMinor;

  /// Approved payout destination, masked.
  final String destination;
}
