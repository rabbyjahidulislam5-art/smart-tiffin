/// Payable balance of one supplier or rider (NF-05, NF-06).
class PayableRow {
  const PayableRow({
    required this.partyId,
    required this.partyName,
    required this.recognisedMinor,
    required this.deductionsMinor,
    required this.heldMinor,
    required this.disputedMinor,
    this.codLiabilityMinor,
    this.holdReason,
  });

  final String partyId;
  final String partyName;
  final int recognisedMinor;
  final int deductionsMinor;
  final int heldMinor;
  final int disputedMinor;

  /// Rider only: COD cash owed, shown alongside and never netted (BR-026).
  final int? codLiabilityMinor;
  final String? holdReason;

  int get eligibleMinor {
    final v = recognisedMinor - deductionsMinor - heldMinor - disputedMinor;
    return v < 0 ? 0 : v;
  }

  bool get onHold => holdReason != null;

  PayableRow withHold({required int heldMinor, String? holdReason}) => PayableRow(
        partyId: partyId,
        partyName: partyName,
        recognisedMinor: recognisedMinor,
        deductionsMinor: deductionsMinor,
        heldMinor: heldMinor,
        disputedMinor: disputedMinor,
        codLiabilityMinor: codLiabilityMinor,
        holdReason: holdReason,
      );
}
