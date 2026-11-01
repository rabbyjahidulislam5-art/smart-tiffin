import 'remittance_status.dart';

/// A deposit of collected COD cash with its unique reference.
class CodRemittance {
  const CodRemittance({
    required this.id,
    required this.amountMinor,
    required this.reference,
    required this.method,
    required this.submittedOn,
    required this.status,
  });

  final String id;
  final int amountMinor;
  final String reference;
  final String method;
  final String submittedOn;
  final RemittanceStatus status;
}
