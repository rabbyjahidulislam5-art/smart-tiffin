import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/customer/kitchen_profile.dart';
import '../../models/customer/kitchen_query.dart';
import '../../models/customer/kitchen_review.dart';
import '../../models/customer/kitchen_sort.dart';
import '../../models/customer/kitchen_summary.dart';
import '../../models/customer/slot_menu.dart';
import '../../repositories/customer/kitchen_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/slot.dart';
import '../../result/st_page.dart';
import '../mock_behavior.dart';
import '../mock_clock.dart';
import '../mock_repository_base.dart';
import 'customer_fixtures.dart';

/// Public kitchen catalogue; guests read the same projection.
class MockKitchenRepository extends MockRepositoryBase implements KitchenRepository {
  MockKitchenRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.customer};
  static const pageSize = 4;

  KitchenSummary? _find(String idOrName) {
    for (final k in publishedKitchens) {
      if (k.id == idOrName || k.nameEn == idOrName) return k;
    }
    return null;
  }

  @override
  Future<RepoResult<StPage<KitchenSummary>>> search(Actor actor, KitchenQuery query, {String? cursor, Set<String> favourites = const {}}) =>
      guardRead(actor, roles, 'search', signedIn: false, () {
        if (query.q.length > KitchenQuery.maxQueryLength) return MockRepositoryBase.invalid('q');
        final q = query.q.trim().toLowerCase();
        final list = [
          for (final k in publishedKitchens)
            if ((q.isEmpty || k.nameEn.toLowerCase().contains(q) || k.nameBn.contains(query.q.trim())) &&
                (query.cuisine == null || k.cuisine == query.cuisine) &&
                (query.dietary == null || k.dietary.contains(query.dietary)) &&
                query.slots.every(k.slots.contains) &&
                (!query.verifiedOnly || k.verified) &&
                (!query.favouritesOnly || favourites.contains(k.id)) &&
                k.serves(query.zone))
              k,
        ];
        switch (query.sort) {
          case KitchenSort.rating:
            list.sort((a, b) => b.rating.compareTo(a.rating));
          case KitchenSort.name:
            list.sort((a, b) => a.nameEn.compareTo(b.nameEn));
          case KitchenSort.relevance:
            break;
        }
        return Ok(StPage.slice(list, cursor: cursor, size: pageSize));
      });

  @override
  Future<RepoResult<KitchenProfile>> kitchen(Actor actor, String idOrName) => guardRead(actor, roles, 'kitchen', signedIn: false, () {
        final k = _find(idOrName);
        if (k == null) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        return Ok(KitchenProfile(
          summary: k,
          descriptionEn: 'Home-cooked ${k.cuisine == 'diet' ? 'diet meals' : 'Bengali meals'} prepared fresh every service day.',
          descriptionBn: 'প্রতিটি সার্ভিস দিনে তাজা রান্না করা ঘরোয়া খাবার।',
          hours: 'Sat–Thu · 10:00–21:00',
          slotWindows: {
            for (final s in k.slots)
              s: switch (s) {
                Slot.breakfast => '07:30–09:00',
                Slot.lunch => '12:30–14:00',
                Slot.snack => '16:30–17:30',
                Slot.dinner => '19:30–21:00',
              },
          },
          reviews: reviewFixtures.take(3).toList(),
        ));
      });

  @override
  Future<RepoResult<List<String>>> menuDates(Actor actor, String kitchenId) => guardRead(actor, roles, 'menuDates', signedIn: false, () {
        if (_find(kitchenId) == null) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        return const Ok(publishedDates);
      });

  @override
  Future<RepoResult<SlotMenu>> menu(Actor actor, String kitchenId, {required Slot slot, required String date}) =>
      guardRead(actor, roles, 'menu', signedIn: false, () {
        final k = _find(kitchenId);
        if (k == null) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (!publishedDates.contains(date)) return MockRepositoryBase.invalid('date');
        final items = [for (final m in menuItems) if (m.kitchenId == k.id && m.slot == slot) m];
        return Ok(SlotMenu(kitchenId: k.id, slot: slot, date: date, items: items, cutoffPassed: date.compareTo(mockToday) <= 0));
      });

  @override
  Future<RepoResult<StPage<KitchenReview>>> reviews(Actor actor, String kitchenId, {String? cursor}) =>
      guardRead(actor, roles, 'reviews', signedIn: false, () {
        if (_find(kitchenId) == null) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        return Ok(StPage.slice(reviewFixtures, cursor: cursor, size: 3));
      });
}
