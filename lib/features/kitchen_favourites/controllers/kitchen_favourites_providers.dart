import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import 'favourites_controller.dart';

/// Favourite kitchen ids (not auto-disposed: NC-01, NC-02 and NC-18 share
/// them).
final favouritesProvider =
    AsyncNotifierProvider<FavouritesController, Set<String>>(
      FavouritesController.new,
    );

/// Kind of the last failed favourite change; cleared by the next success.
final favouriteFailureProvider = StateProvider<RepoErrorKind?>((ref) => null);

/// NC-18 favourite kitchens, cursor paged. Rebuilt when the favourites
/// change, so a removed kitchen leaves the list.
final favouriteKitchensProvider =
    StateNotifierProvider.autoDispose<
      StPagedController<KitchenSummary>,
      AsyncValue<StPagedList<KitchenSummary>>
    >((ref) {
      final repo = ref.watch(kitchenRepositoryProvider);
      final actor = ref.watch(actorProvider);
      final ids = ref.watch(favouritesProvider.future);
      return StPagedController<KitchenSummary>((cursor) async {
        try {
          final favourites = await ids;
          return await repo.search(
            actor,
            const KitchenQuery(favouritesOnly: true),
            cursor: cursor,
            favourites: favourites,
          );
        } on RepoError catch (e) {
          return Err(e);
        }
      });
    });
