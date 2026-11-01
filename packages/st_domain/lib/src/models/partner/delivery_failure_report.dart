import 'delivery_failure_kind.dart';

/// A rider report of a delivery that could not be completed (SC-21).
class DeliveryFailureReport {
  const DeliveryFailureReport({
    required this.id,
    required this.deliveryRef,
    required this.kind,
    required this.note,
    required this.reportedOn,
    this.underReview = true,
  });

  final String id;
  final String deliveryRef;
  final DeliveryFailureKind kind;
  final String note;
  final String reportedOn;
  final bool underReview;
}
