import 'quote_line.dart';
import 'quote_status.dart';

/// An immutable server quote (pattern 3.3). The total is always the sum of
/// the lines (INV-18); no widget computes it.
class Quote {
  const Quote({
    required this.id,
    required this.sourceId,
    required this.lines,
    required this.status,
    required this.expiresAt,
    required this.policyVersions,
  });

  final String id;

  /// Draft id, `cart` or the renewal offer id.
  final String sourceId;
  final List<QuoteLine> lines;
  final QuoteStatus status;
  final String expiresAt;
  final List<String> policyVersions;

  int get totalMinor => lines.fold(0, (a, l) => a + l.amountMinor);

  Quote copyWith({List<QuoteLine>? lines, QuoteStatus? status}) => Quote(
        id: id,
        sourceId: sourceId,
        lines: lines ?? this.lines,
        status: status ?? this.status,
        expiresAt: expiresAt,
        policyVersions: policyVersions,
      );
}
