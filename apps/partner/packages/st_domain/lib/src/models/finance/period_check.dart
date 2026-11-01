import '../../text/st_text.dart';

/// One item of the period-close checklist (FINANCIAL_LEDGER.md).
class PeriodCheck {
  const PeriodCheck({required this.key, required this.label, required this.done});

  final String key;
  final StText label;
  final bool done;
}
