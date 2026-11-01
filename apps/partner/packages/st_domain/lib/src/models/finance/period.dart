import 'period_check.dart';
import 'period_status.dart';

/// An accounting period (NF-12).
class Period {
  const Period({required this.id, required this.status, required this.checklist, this.note});

  /// `YYYY-MM`.
  final String id;
  final PeriodStatus status;
  final List<PeriodCheck> checklist;
  final String? note;

  bool get ready => checklist.every((c) => c.done);

  Period withStatus(PeriodStatus s, {String? note}) => Period(id: id, status: s, checklist: checklist, note: note ?? this.note);
}
