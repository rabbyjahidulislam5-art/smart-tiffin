import 'customer_refund_kind.dart';
import 'customer_refund_status.dart';

/// A refund or dispute of the signed-in customer (NC-17).
class RefundCase {
  const RefundCase({
    required this.id,
    required this.kind,
    required this.status,
    required this.amountMinor,
    required this.orderRef,
    required this.createdOn,
    this.providerRef,
  });

  final String id;
  final CustomerRefundKind kind;
  final CustomerRefundStatus status;
  final int amountMinor;
  final String orderRef;
  final String createdOn;

  /// Gateway confirmation reference, present once executed.
  final String? providerRef;
}
