/// Why a quote carries its delivery fee (NC-07). When the fee policy is not
/// configured, [feeMinor] is null and the sheet says so.
class PriceExplanation {
  const PriceExplanation({
    required this.quoteId,
    required this.zone,
    required this.distanceBand,
    required this.groupedDelivery,
    required this.policyVersion,
    this.feeMinor,
  });

  final String quoteId;
  final String zone;
  final String distanceBand;

  /// Subscription deliveries are grouped; one-time orders are per order.
  final bool groupedDelivery;
  final String policyVersion;
  final int? feeMinor;

  bool get feeConfigured => feeMinor != null;
}
