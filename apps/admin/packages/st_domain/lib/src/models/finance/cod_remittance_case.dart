import 'verification_status.dart';

/// A rider remittance waiting for Accounts verification (NF-04).
class CodRemittanceCase {
  const CodRemittanceCase({
    required this.id,
    required this.riderName,
    required this.reference,
    required this.method,
    required this.declaredMinor,
    required this.expectedMinor,
    required this.status,
    this.verifiedBy,
  });

  final String id;
  final String riderName;
  final String reference;
  final String method;
  final int declaredMinor;
  final int expectedMinor;
  final VerificationStatus status;
  final String? verifiedBy;
}
