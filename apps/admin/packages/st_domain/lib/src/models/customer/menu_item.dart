import '../../result/slot.dart';

/// A meal a kitchen offers in one slot, at the current price version.
class MenuItem {
  const MenuItem({
    required this.id,
    required this.kitchenId,
    required this.mealId,
    required this.slot,
    required this.priceMinor,
    required this.available,
  });

  final String id;
  final String kitchenId;

  /// Catalogue meal (name, photo, description).
  final String mealId;
  final Slot slot;
  final int priceMinor;
  final bool available;
}
