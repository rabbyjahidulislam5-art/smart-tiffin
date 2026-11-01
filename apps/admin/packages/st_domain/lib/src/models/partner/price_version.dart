import 'price_version_status.dart';

/// One effective-dated price of a meal variant (ADR-009).
class PriceVersion {
  const PriceVersion({
    required this.id,
    required this.mealId,
    required this.variant,
    required this.amountMinor,
    required this.effectiveFrom,
    required this.status,
    required this.author,
    required this.reason,
    this.boundCommitments = 0,
  });

  final String id;
  final String mealId;
  final String variant;
  final int amountMinor;
  final String effectiveFrom;
  final PriceVersionStatus status;
  final String author;
  final String reason;

  /// Active commitments and open quotes still bound to this version.
  final int boundCommitments;
}
