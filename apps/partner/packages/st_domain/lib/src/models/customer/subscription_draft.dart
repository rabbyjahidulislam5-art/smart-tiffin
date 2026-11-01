import 'billing_frequency.dart';
import 'draft_status.dart';
import 'schedule_cell.dart';

/// A server-side subscription draft; edits carry `expectedVersion` (NC-04, NC-05).
class SubscriptionDraft {
  const SubscriptionDraft({
    required this.id,
    required this.version,
    required this.kitchenId,
    required this.startDate,
    required this.weeks,
    required this.billing,
    required this.cells,
    required this.status,
    this.addressLabel,
    this.window,
  });

  final String id;
  final int version;
  final String kitchenId;
  final String startDate;
  final int weeks;
  final BillingFrequency billing;
  final List<ScheduleCell> cells;
  final DraftStatus status;
  final String? addressLabel;
  final String? window;

  SubscriptionDraft copyWith({
    int? version,
    String? startDate,
    int? weeks,
    BillingFrequency? billing,
    List<ScheduleCell>? cells,
    DraftStatus? status,
    String? addressLabel,
    String? window,
  }) =>
      SubscriptionDraft(
        id: id,
        version: version ?? this.version,
        kitchenId: kitchenId,
        startDate: startDate ?? this.startDate,
        weeks: weeks ?? this.weeks,
        billing: billing ?? this.billing,
        cells: cells ?? this.cells,
        status: status ?? this.status,
        addressLabel: addressLabel ?? this.addressLabel,
        window: window ?? this.window,
      );
}
