import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../../kitchen_discovery/widgets/kitchen_photo.dart';
import '../controllers/kitchen_favourites_providers.dart';
import '../widgets/favourite_failure_note.dart';
import '../widgets/favourite_heart.dart';
import 'kitchen_favourites_text.dart';

/// NC-18 Favourite kitchens (C-24 extension). Signed-in customers only: a
/// guest sees the sign-in panel and no favourite is read (requirement 5.4).
class FavouriteKitchensSectionScreen extends ConsumerWidget {
  const FavouriteKitchensSectionScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final title = s.tx(KitchenFavouritesText.title);
    final eyebrow = s.tx(KitchenFavouritesText.eyebrow);
    if (ref.watch(actorProvider).isGuest) {
      return StScreen(
        title: title,
        eyebrow: eyebrow,
        child: const StSignInRequired(),
      );
    }
    final value = ref.watch(favouriteKitchensProvider);
    final paged = ref.read(favouriteKitchensProvider.notifier);
    return StScreen(
      title: title,
      eyebrow: eyebrow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(KitchenFavouritesText.intro))),
          const SizedBox(height: StSpace.sm),
          const FavouriteFailureNote(),
          StAsyncView<StPagedList<KitchenSummary>>(
            value: value,
            supported: states,
            isEmpty: (list) => list.isEmpty,
            emptyMessage: KitchenFavouritesText.empty,
            emptyAction: (
              label: KitchenFavouritesText.browse,
              onTap: () => stOpen(ref, 'NC-01'),
            ),
            onRetry: paged.reload,
            builder: (context, list) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final k in list.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: StSpace.xs),
                    child: StCard(
                      key: ValueKey('favourite-row-${k.id}'),
                      onTap: () => stOpen(ref, 'NC-02', {'kitchen': k.id}),
                      child: Row(
                        children: [
                          KitchenPhoto(img: k.img, size: StSize.btnLg),
                          const SizedBox(width: StSpace.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.t(k.nameEn, k.nameBn),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  s.tx(KitchenFavouritesText.rating, [
                                    '${k.rating}',
                                    '${k.ratingCount}',
                                  ]),
                                  style: TextStyle(
                                    fontSize: StFont.label,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FavouriteHeart(
                            kitchenId: k.id,
                            kitchenName: s.t(k.nameEn, k.nameBn),
                            intent: const NavEntry('NC-18'),
                          ),
                        ],
                      ),
                    ),
                  ),
                StLoadMore<KitchenSummary>(list: list, onMore: paged.loadMore),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
