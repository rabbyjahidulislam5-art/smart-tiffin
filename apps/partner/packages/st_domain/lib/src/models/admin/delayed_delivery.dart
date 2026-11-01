import 'dispatch_status.dart';

/// A delivery that is late or lost its rider (NA-04).
class DelayedDelivery {
  const DelayedDelivery({
    required this.id,
    required this.orderRef,
    required this.kitchen,
    required this.delayMinutes,
    required this.riderName,
    required this.status,
    this.backupRider,
  });

  final String id;
  final String orderRef;
  final String kitchen;
  final int delayMinutes;
  final String riderName;
  final DispatchStatus status;
  final String? backupRider;
}
