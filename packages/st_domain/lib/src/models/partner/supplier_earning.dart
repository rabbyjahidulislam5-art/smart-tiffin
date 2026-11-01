import 'earning_status.dart';

/// One recognised (or expected) supplier earning, traceable to its source.
class SupplierEarning {
  const SupplierEarning({
    required this.id,
    required this.orderRef,
    required this.source,
    required this.recognisedOn,
    required this.grossMinor,
    required this.commissionMinor,
    required this.status,
    this.holdReason,
  });

  final String id;
  final String orderRef;
  final String source;

  /// Service date of the recognition event (empty for expected earnings).
  final String recognisedOn;
  final int grossMinor;

  /// Platform deduction (BR-009, sample until approved).
  final int commissionMinor;
  final EarningStatus status;
  final String? holdReason;

  int get netMinor => grossMinor - commissionMinor;
}
