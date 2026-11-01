import '../../access/actor.dart';
import '../../models/customer/kitchen_profile.dart';
import '../../models/customer/kitchen_query.dart';
import '../../models/customer/kitchen_review.dart';
import '../../models/customer/kitchen_summary.dart';
import '../../models/customer/slot_menu.dart';
import '../../result/repo_result.dart';
import '../../result/slot.dart';
import '../../result/st_page.dart';

/// Public kitchen catalogue (NC-01..NC-03). Guests may read. An absent and a
/// non-viewable kitchen both return `notAvailable` (requirement 5.8).
abstract interface class KitchenRepository {
  Future<RepoResult<StPage<KitchenSummary>>> search(Actor actor, KitchenQuery query, {String? cursor, Set<String> favourites = const {}});

  /// [idOrName] accepts the kitchen id or its English name (legacy params).
  Future<RepoResult<KitchenProfile>> kitchen(Actor actor, String idOrName);

  /// Service dates the kitchen has published.
  Future<RepoResult<List<String>>> menuDates(Actor actor, String kitchenId);

  Future<RepoResult<SlotMenu>> menu(Actor actor, String kitchenId, {required Slot slot, required String date});

  Future<RepoResult<StPage<KitchenReview>>> reviews(Actor actor, String kitchenId, {String? cursor});
}
