import 'handoff_status.dart';

/// A ready order waiting for custody transfer to its assigned rider.
class Handoff {
  const Handoff({
    required this.id,
    required this.orderRef,
    required this.riderName,
    required this.vehicle,
    required this.items,
    required this.status,
    required this.pickupCode,
  });

  final String id;
  final String orderRef;
  final String riderName;
  final String vehicle;
  final int items;
  final HandoffStatus status;

  /// Short-lived code the assigned rider shows (sample).
  final String pickupCode;

  Handoff withStatus(HandoffStatus s) => Handoff(
        id: id,
        orderRef: orderRef,
        riderName: riderName,
        vehicle: vehicle,
        items: items,
        status: s,
        pickupCode: pickupCode,
      );
}
