import 'journal_line.dart';
import 'journal_status.dart';

/// A posted journal entry (NF-11). Never edited; only reversed.
class Journal {
  const Journal({
    required this.id,
    required this.date,
    required this.source,
    required this.policyVersion,
    required this.status,
    required this.lines,
    this.reversalOf,
    this.reversedBy,
  });

  final String id;
  final String date;

  /// Source command, for example `confirmQuote`.
  final String source;
  final String policyVersion;
  final JournalStatus status;
  final List<JournalLine> lines;
  final String? reversalOf;
  final String? reversedBy;

  int get debitMinor => lines.fold(0, (a, l) => a + l.debitMinor);
  int get creditMinor => lines.fold(0, (a, l) => a + l.creditMinor);
  bool get balanced => debitMinor == creditMinor;

  Journal reversed(String by) => Journal(
        id: id,
        date: date,
        source: source,
        policyVersion: policyVersion,
        status: JournalStatus.reversed,
        lines: lines,
        reversalOf: reversalOf,
        reversedBy: by,
      );
}
