import 'refund_ops_kind.dart';
import 'refund_ops_status.dart';

/// A gateway refund or an external chargeback case (NF-10).
class RefundOpsCase {
  const RefundOpsCase({
    required this.id,
    required this.kind,
    required this.orderRef,
    required this.amountMinor,
    required this.status,
    this.providerRef,
    this.creditIssued = false,
  });

  final String id;
  final RefundOpsKind kind;
  final String orderRef;
  final int amountMinor;
  final RefundOpsStatus status;
  final String? providerRef;

  /// INV-17: a credit already covers the obligation, so a refund is blocked.
  final bool creditIssued;

  RefundOpsCase withStatus(RefundOpsStatus s, {String? providerRef}) => RefundOpsCase(
        id: id,
        kind: kind,
        orderRef: orderRef,
        amountMinor: amountMinor,
        status: s,
        providerRef: providerRef ?? this.providerRef,
        creditIssued: creditIssued,
      );
}
