import 'payout_status.dart';

/// One payout request and its outcome.
class PayoutRecord {
  const PayoutRecord({
    required this.id,
    required this.amountMinor,
    required this.requestedOn,
    required this.status,
    required this.destination,
    this.reference,
  });

  final String id;
  final int amountMinor;
  final String requestedOn;
  final PayoutStatus status;
  final String destination;

  /// Transfer reference, present once settled.
  final String? reference;
}
