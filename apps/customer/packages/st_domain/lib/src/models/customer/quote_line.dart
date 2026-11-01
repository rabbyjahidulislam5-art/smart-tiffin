import '../../text/st_text.dart';
import 'quote_line_kind.dart';

/// One itemised line of a server quote. An unconfigured policy line carries
/// no amount and says so; the UI never guesses a value.
class QuoteLine {
  const QuoteLine({required this.kind, required this.label, required this.amountMinor, this.configured = true});

  final QuoteLineKind kind;
  final StText label;
  final int amountMinor;
  final bool configured;
}
