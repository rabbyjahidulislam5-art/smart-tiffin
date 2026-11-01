import '../../result/slot.dart';
import 'menu_item.dart';

/// Menu of one kitchen for one slot and service date (NC-03).
class SlotMenu {
  const SlotMenu({required this.kitchenId, required this.slot, required this.date, required this.items, required this.cutoffPassed});

  final String kitchenId;
  final Slot slot;
  final String date;
  final List<MenuItem> items;
  final bool cutoffPassed;
}
