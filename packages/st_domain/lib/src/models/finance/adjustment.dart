import 'adjustment_status.dart';

/// A manual correction request; the approver is never the maker (NF-16).
class Adjustment {
  const Adjustment({
    required this.id,
    required this.description,
    required this.amountMinor,
    required this.maker,
    required this.status,
    required this.evidenceRef,
    this.checker,
  });

  final String id;
  final String description;

  /// Signed: positive credits the party, negative debits it.
  final int amountMinor;
  final String maker;
  final AdjustmentStatus status;
  final String evidenceRef;
  final String? checker;

  Adjustment decided(AdjustmentStatus s, String by) =>
      Adjustment(id: id, description: description, amountMinor: amountMinor, maker: maker, status: s, evidenceRef: evidenceRef, checker: by);
}
