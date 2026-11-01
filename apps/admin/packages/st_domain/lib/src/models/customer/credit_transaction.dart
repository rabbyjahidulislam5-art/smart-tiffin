import 'credit_class.dart';
import 'credit_tx_kind.dart';

/// One credit movement with its source order or obligation.
class CreditTransaction {
  const CreditTransaction({
    required this.id,
    required this.creditClass,
    required this.kind,
    required this.amountMinor,
    required this.sourceRef,
    required this.at,
  });

  final String id;
  final CreditClass creditClass;
  final CreditTxKind kind;
  final int amountMinor;
  final String sourceRef;
  final String at;
}
