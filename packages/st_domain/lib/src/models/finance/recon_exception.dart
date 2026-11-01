import 'exception_status.dart';
import 'recon_exception_type.dart';

/// An unmatched, duplicate or invalid reconciliation item (NF-13).
class ReconException {
  const ReconException({
    required this.id,
    required this.type,
    required this.ref,
    required this.amountMinor,
    required this.status,
    this.assignedTo,
  });

  final String id;
  final ReconExceptionType type;
  final String ref;
  final int amountMinor;
  final ExceptionStatus status;
  final String? assignedTo;
}
