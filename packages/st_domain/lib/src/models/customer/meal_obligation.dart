import '../../result/slot.dart';
import 'obligation_status.dart';

/// One purchased meal on one date and slot (NC-06).
class MealObligation {
  const MealObligation({
    required this.id,
    required this.date,
    required this.slot,
    required this.menuItemId,
    required this.mealId,
    required this.priceMinor,
    required this.status,
    required this.cutoffPassed,
  });

  final String id;
  final String date;
  final Slot slot;
  final String menuItemId;
  final String mealId;
  final int priceMinor;
  final ObligationStatus status;
  final bool cutoffPassed;

  /// A skip or replacement is still possible.
  bool get changeable => status == ObligationStatus.scheduled && !cutoffPassed;

  MealObligation copyWith({ObligationStatus? status, String? menuItemId, String? mealId, int? priceMinor}) => MealObligation(
        id: id,
        date: date,
        slot: slot,
        menuItemId: menuItemId ?? this.menuItemId,
        mealId: mealId ?? this.mealId,
        priceMinor: priceMinor ?? this.priceMinor,
        status: status ?? this.status,
        cutoffPassed: cutoffPassed,
      );
}
