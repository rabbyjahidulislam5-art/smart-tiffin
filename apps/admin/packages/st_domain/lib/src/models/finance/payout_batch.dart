import 'batch_status.dart';

/// A batch of approved payouts; released only by someone other than its
/// preparer (maker-checker, ADR-010).
class PayoutBatch {
  const PayoutBatch({
    required this.id,
    required this.requestIds,
    required this.totalMinor,
    required this.status,
    required this.preparedBy,
    this.approvedBy,
    this.resultRef,
  });

  final String id;
  final List<String> requestIds;
  final int totalMinor;
  final BatchStatus status;
  final String preparedBy;
  final String? approvedBy;
  final String? resultRef;

  PayoutBatch copyWith({BatchStatus? status, String? approvedBy, String? resultRef}) => PayoutBatch(
        id: id,
        requestIds: requestIds,
        totalMinor: totalMinor,
        status: status ?? this.status,
        preparedBy: preparedBy,
        approvedBy: approvedBy ?? this.approvedBy,
        resultRef: resultRef ?? this.resultRef,
      );
}
