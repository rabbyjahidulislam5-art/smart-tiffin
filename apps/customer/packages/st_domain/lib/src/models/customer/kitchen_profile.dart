import '../../result/slot.dart';
import 'kitchen_review.dart';
import 'kitchen_summary.dart';

/// Kitchen profile detail (NC-02).
class KitchenProfile {
  const KitchenProfile({
    required this.summary,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.hours,
    required this.slotWindows,
    required this.reviews,
  });

  final KitchenSummary summary;
  final String descriptionEn;
  final String descriptionBn;
  final String hours;
  final Map<Slot, String> slotWindows;

  /// Preview of the latest reviews.
  final List<KitchenReview> reviews;
}
