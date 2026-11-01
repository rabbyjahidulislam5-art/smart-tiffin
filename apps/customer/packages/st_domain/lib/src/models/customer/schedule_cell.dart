import '../../result/slot.dart';

/// One scheduled meal of a draft: date, slot, menu item and quantity.
class ScheduleCell {
  const ScheduleCell({required this.date, required this.slot, required this.menuItemId, required this.qty});

  final String date;
  final Slot slot;
  final String menuItemId;
  final int qty;

  @override
  bool operator ==(Object other) =>
      other is ScheduleCell && other.date == date && other.slot == slot && other.menuItemId == menuItemId && other.qty == qty;

  @override
  int get hashCode => Object.hash(date, slot, menuItemId, qty);
}
