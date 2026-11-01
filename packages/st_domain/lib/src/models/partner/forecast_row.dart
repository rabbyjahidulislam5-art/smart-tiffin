import '../../result/slot.dart';

/// Future portions committed for one date, slot and meal (obligations only).
class ForecastRow {
  const ForecastRow({
    required this.date,
    required this.slot,
    required this.mealId,
    required this.portions,
    required this.capacity,
  });

  final String date;
  final Slot slot;
  final String mealId;
  final int portions;
  final int capacity;

  bool get overCapacity => portions > capacity;
}
