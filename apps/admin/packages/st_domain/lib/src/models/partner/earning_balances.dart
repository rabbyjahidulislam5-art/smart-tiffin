/// The separate balance classes of an earnings account, in minor units.
class EarningBalances {
  const EarningBalances({
    required this.expectedMinor,
    required this.earnedMinor,
    required this.heldMinor,
    required this.eligibleMinor,
    required this.settledMinor,
  });

  final int expectedMinor;

  /// Supplier: earned; rider: confirmed.
  final int earnedMinor;
  final int heldMinor;
  final int eligibleMinor;
  final int settledMinor;
}
