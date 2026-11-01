import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// The kitchen an NC-02 or NC-03 route names: `kitchen` (id or English name,
/// the C-06 parameter) or `meal` (a catalogue meal id, passed on from C-05).
String? kitchenKeyOf(Map<String, String> params) {
  final kitchen = params['kitchen'];
  if (kitchen != null && kitchen.isNotEmpty) return kitchen;
  final meal = params['meal'];
  if (meal == null) return null;
  for (final m in meals) {
    if (m.id == meal) return m.kitchen;
  }
  return null;
}

/// NC-02 and NC-03 kitchen profile (guest-readable public projection).
final kitchenProfileProvider = FutureProvider.autoDispose
    .family<KitchenProfile, String>(
      (ref, key) => stUnwrap(
        ref
            .watch(kitchenRepositoryProvider)
            .kitchen(ref.watch(actorProvider), key),
      ),
    );

/// NC-03 service dates the kitchen has published.
final kitchenMenuDatesProvider = FutureProvider.autoDispose
    .family<List<String>, String>(
      (ref, kitchenId) => stUnwrap(
        ref
            .watch(kitchenRepositoryProvider)
            .menuDates(ref.watch(actorProvider), kitchenId),
      ),
    );

/// Key of one NC-03 menu read.
typedef KitchenMenuKey = ({String kitchen, Slot slot, String date});

/// NC-03 meals of one slot and service date.
final kitchenMenuProvider = FutureProvider.autoDispose
    .family<SlotMenu, KitchenMenuKey>(
      (ref, k) => stUnwrap(
        ref
            .watch(kitchenRepositoryProvider)
            .menu(
              ref.watch(actorProvider),
              k.kitchen,
              slot: k.slot,
              date: k.date,
            ),
      ),
    );

/// NC-03 reviews, cursor paged; a failed page keeps the loaded rows and a
/// retry never duplicates them.
final kitchenReviewsProvider = StateNotifierProvider.autoDispose
    .family<
      StPagedController<KitchenReview>,
      AsyncValue<StPagedList<KitchenReview>>,
      String
    >((ref, kitchenId) {
      final repo = ref.watch(kitchenRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StPagedController<KitchenReview>(
        (cursor) => repo.reviews(actor, kitchenId, cursor: cursor),
      );
    });
