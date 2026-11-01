import 'schedule_change_kind.dart';

/// Server preview of a skip or replacement before confirmation (NC-09, NC-10).
class ScheduleChangePreview {
  const ScheduleChangePreview({
    required this.obligationId,
    required this.kind,
    required this.creditMinor,
    required this.chargeMinor,
    this.newMenuItemId,
    this.sample = true,
  });

  final String obligationId;
  final ScheduleChangeKind kind;
  final int creditMinor;
  final int chargeMinor;
  final String? newMenuItemId;

  /// True while the credit formula (BR-006) is pending: the figure is a sample.
  final bool sample;
}
