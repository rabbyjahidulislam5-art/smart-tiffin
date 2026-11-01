import 'statement_line_kind.dart';

/// One line of a gateway settlement statement against the platform record.
class StatementLine {
  const StatementLine({required this.ref, required this.kind, required this.statementMinor, required this.recordMinor});

  final String ref;
  final StatementLineKind kind;
  final int statementMinor;
  final int recordMinor;

  int get deviationMinor => statementMinor - recordMinor;
}
