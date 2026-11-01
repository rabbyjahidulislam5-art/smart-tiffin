import 'statement_line.dart';
import 'statement_status.dart';

/// A periodic provider settlement statement (NF-17).
class GatewayStatement {
  const GatewayStatement({
    required this.id,
    required this.provider,
    required this.period,
    required this.lines,
    required this.status,
    this.evidenceRef,
  });

  final String id;
  final String provider;
  final String period;
  final List<StatementLine> lines;
  final StatementStatus status;
  final String? evidenceRef;

  int get deviationMinor => lines.fold(0, (a, l) => a + l.deviationMinor);
  int get statementTotalMinor => lines.fold(0, (a, l) => a + l.statementMinor);
}
