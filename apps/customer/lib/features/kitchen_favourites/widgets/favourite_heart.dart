import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/kitchen_favourites_providers.dart';
import '../screens/kitchen_favourites_text.dart';

/// The favourite heart of a kitchen (NC-01, NC-02, NC-18). Its label names
/// the kitchen. A guest gets the sign-in prompt with [intent] and nothing is
/// written; offline the heart is disabled (NC-01.8).
class FavouriteHeart extends ConsumerWidget {
  const FavouriteHeart({
    super.key,
    required this.kitchenId,
    required this.kitchenName,
    required this.intent,
  });

  final String kitchenId;
  final String kitchenName;
  final NavEntry intent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final guest = ref.watch(actorProvider).isGuest;
    final on =
        !guest &&
        (ref.watch(favouritesProvider).valueOrNull?.contains(kitchenId) ??
            false);
    final label = s.tx(
      on ? KitchenFavouritesText.removeLabel : KitchenFavouritesText.addLabel,
      [kitchenName],
    );
    return IconButton(
      key: ValueKey('favourite-$kitchenId'),
      tooltip: s.offline ? s.tx(KitchenFavouritesText.offline) : label,
      isSelected: on,
      icon: const Icon(Icons.favorite_border_rounded),
      selectedIcon: const Icon(Icons.favorite_rounded, color: StColors.danger),
      onPressed: s.offline
          ? null
          : () {
              if (guest) {
                showSignInPrompt(
                  ref,
                  intent: intent,
                  body: KitchenFavouritesText.prompt,
                );
                return;
              }
              ref.read(favouritesProvider.notifier).toggle(kitchenId);
            },
    );
  }
}
