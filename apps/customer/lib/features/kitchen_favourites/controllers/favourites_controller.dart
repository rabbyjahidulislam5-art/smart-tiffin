import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import 'kitchen_favourites_providers.dart';

/// Favourite kitchen ids of the signed-in customer, shared by NC-01, NC-02
/// and NC-18. A guest has none and never calls the repository. A change is
/// optimistic and reverts when the command fails (NC-01.5).
class FavouritesController extends AsyncNotifier<Set<String>> {
  final Set<String> _pending = {};

  @override
  Future<Set<String>> build() async {
    final actor = ref.watch(actorProvider);
    if (actor.isGuest) return const <String>{};
    return stUnwrap(ref.watch(favouriteRepositoryProvider).favourites(actor));
  }

  /// Adds or removes [kitchenId] with one `setFavourite` call; a second tap
  /// on the same kitchen while the call runs is ignored.
  Future<void> toggle(String kitchenId) async {
    final before = state.valueOrNull;
    final actor = ref.read(actorProvider);
    if (before == null || actor.isGuest || !_pending.add(kitchenId)) return;
    final favourite = !before.contains(kitchenId);
    state = AsyncData({
      for (final id in before)
        if (id != kitchenId) id,
      if (favourite) kitchenId,
    });
    final r = await ref
        .read(favouriteRepositoryProvider)
        .setFavourite(
          actor,
          RequestId.next('fav'),
          kitchenId: kitchenId,
          favourite: favourite,
        );
    _pending.remove(kitchenId);
    switch (r) {
      case Ok(:final value):
        state = AsyncData(value);
        ref.read(favouriteFailureProvider.notifier).state = null;
      case Err(:final error):
        state = AsyncData(before);
        ref.read(favouriteFailureProvider.notifier).state = error.kind;
    }
  }
}
