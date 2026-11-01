import 'discrepancy_status.dart';

/// A remittance mismatch case raised by Accounts (SC-09).
class CodDiscrepancy {
  const CodDiscrepancy({
    required this.id,
    required this.remittanceId,
    required this.expectedMinor,
    required this.declaredMinor,
    required this.status,
    this.riderResponse,
  });

  final String id;
  final String remittanceId;
  final int expectedMinor;
  final int declaredMinor;
  final DiscrepancyStatus status;
  final String? riderResponse;

  int get differenceMinor => expectedMinor - declaredMinor;
}
