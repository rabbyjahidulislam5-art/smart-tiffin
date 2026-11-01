/// COD cash in custody for one rider and service date (NF-03).
class CodCustodyRow {
  const CodCustodyRow({
    required this.riderId,
    required this.riderName,
    required this.date,
    required this.heldMinor,
    required this.remittedMinor,
    required this.overdue,
  });

  final String riderId;
  final String riderName;
  final String date;
  final int heldMinor;
  final int remittedMinor;
  final bool overdue;

  int get outstandingMinor => heldMinor - remittedMinor;
}
