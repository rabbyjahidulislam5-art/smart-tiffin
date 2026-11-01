import 'rider_earning_status.dart';

/// Per-delivery rider compensation; never includes COD cash.
class RiderEarning {
  const RiderEarning({
    required this.id,
    required this.deliveryRef,
    required this.date,
    required this.expectedMinor,
    required this.confirmedMinor,
    required this.status,
    this.reversedMinor = 0,
  });

  final String id;
  final String deliveryRef;
  final String date;
  final int expectedMinor;
  final int confirmedMinor;
  final RiderEarningStatus status;
  final int reversedMinor;
}
