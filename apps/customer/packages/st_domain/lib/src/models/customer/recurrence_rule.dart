import '../../result/slot.dart';

/// Weekly pattern of NC-05: the same menu item on the chosen weekdays.
class RecurrenceRule {
  const RecurrenceRule({required this.weekdays, required this.slot, required this.menuItemId, required this.qty, required this.weeks});

  /// 1 = Monday ... 7 = Sunday.
  final Set<int> weekdays;
  final Slot slot;
  final String menuItemId;
  final int qty;
  final int weeks;
}
