import 'payout_case_status.dart';

/// A supplier or rider payout request under Accounts review (NF-07).
class PayoutRequestCase {
  const PayoutRequestCase({
    required this.id,
    required this.partyName,
    required this.partyKind,
    required this.amountMinor,
    required this.eligibleMinor,
    required this.beneficiaryVerified,
    required this.status,
    this.reason,
  });

  final String id;
  final String partyName;

  /// `supplier` or `rider`.
  final String partyKind;
  final int amountMinor;
  final int eligibleMinor;
  final bool beneficiaryVerified;
  final PayoutCaseStatus status;
  final String? reason;

  PayoutRequestCase withStatus(PayoutCaseStatus s, {String? reason}) => PayoutRequestCase(
        id: id,
        partyName: partyName,
        partyKind: partyKind,
        amountMinor: amountMinor,
        eligibleMinor: eligibleMinor,
        beneficiaryVerified: beneficiaryVerified,
        status: s,
        reason: reason ?? this.reason,
      );
}
