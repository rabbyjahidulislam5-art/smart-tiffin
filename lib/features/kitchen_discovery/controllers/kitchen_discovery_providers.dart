import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../../kitchen_favourites/controllers/kitchen_favourites_providers.dart';
import 'kitchen_query_controller.dart';

/// NC-01 search state (not auto-disposed; requirement 5.7).
final kitchenQueryProvider =
    NotifierProvider<KitchenQueryController, KitchenQuery>(
      KitchenQueryController.new,
    );

/// NC-01 results of the current query, cursor paged. A new query replaces
/// the controller, so an obsolete in-flight page is dropped and only the
/// latest result renders (NC-01.5). Kept alive with the query so a return
/// from a kitchen shows the same rows at the same scroll offset.
final kitchenResultsProvider =
    StateNotifierProvider<
      StPagedController<KitchenSummary>,
      AsyncValue<StPagedList<KitchenSummary>>
    >((ref) {
      final repo = ref.watch(kitchenRepositoryProvider);
      final actor = ref.watch(actorProvider);
      final query = ref.watch(kitchenQueryProvider);
      final favourites = query.favouritesOnly && !actor.isGuest
          ? ref.watch(favouritesProvider).valueOrNull ?? const <String>{}
          : const <String>{};
      return StPagedController<KitchenSummary>(
        (cursor) =>
            repo.search(actor, query, cursor: cursor, favourites: favourites),
      );
    });
