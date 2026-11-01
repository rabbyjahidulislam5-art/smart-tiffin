import 'credit_movement.dart';

/// One movement of customer credit liability (NF-09). A credit is never cash.
class CreditLiabilityRow {
  const CreditLiabilityRow({
    required this.id,
    required this.customerRef,
    required this.movement,
    required this.amountMinor,
    required this.date,
    required this.sourceRef,
  });

  final String id;
  final String customerRef;
  final CreditMovement movement;
  final int amountMinor;
  final String date;
  final String sourceRef;
}
