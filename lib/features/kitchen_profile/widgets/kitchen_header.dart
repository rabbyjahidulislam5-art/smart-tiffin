import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../../kitchen_discovery/widgets/kitchen_photo.dart';
import '../../kitchen_favourites/widgets/favourite_heart.dart';
import '../screens/kitchen_profile_text.dart';

/// NC-02 header band: photo, both names, the verified badge (approved state
/// only), the rating summary, the accepting-orders chip (no internal reason
/// is shown) and the favourite heart.
class KitchenHeader extends ConsumerWidget {
  const KitchenHeader({super.key, required this.summary, required this.intent});

  final KitchenSummary summary;
  final NavEntry intent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final k = summary;
    final name = s.t(k.nameEn, k.nameBn);
    final other = s.lang == StLang.bn ? k.nameEn : k.nameBn;
    return StCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KitchenPhoto(img: k.img),
          const SizedBox(width: StSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: StFont.title,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  other,
                  style: TextStyle(
                    fontSize: StFont.label,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: StSpace.xxs),
                Wrap(
                  spacing: StSpace.xxs,
                  runSpacing: StSpace.xxs,
                  children: [
                    if (k.verified)
                      StStatusChip(
                        label: s.tx(KitchenProfileText.verified),
                        tone: StTone.success,
                        icon: Icons.verified_rounded,
                      ),
                    StStatusChip(
                      label: s.tx(
                        k.accepting
                            ? KitchenProfileText.accepting
                            : KitchenProfileText.notAccepting,
                      ),
                      tone: k.accepting ? StTone.success : StTone.warning,
                      icon: k.accepting
                          ? Icons.check_circle_outline
                          : Icons.pause_circle_outline,
                    ),
                  ],
                ),
                const SizedBox(height: StSpace.xxs),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: StSize.iconSm,
                      color: StColors.warning,
                    ),
                    const SizedBox(width: StSpace.xxs),
                    Expanded(
                      child: Text(
                        s.tx(KitchenProfileText.ratingSummary, [
                          '${k.rating}',
                          '${k.ratingCount}',
                        ]),
                        style: const TextStyle(fontSize: StFont.label),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          FavouriteHeart(kitchenId: k.id, kitchenName: name, intent: intent),
        ],
      ),
    );
  }
}
