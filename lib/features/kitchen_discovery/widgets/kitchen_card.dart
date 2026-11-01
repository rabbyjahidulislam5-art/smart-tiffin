import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../../kitchen_favourites/widgets/favourite_heart.dart';
import '../screens/kitchen_discovery_text.dart';
import 'kitchen_labels.dart';
import 'kitchen_photo.dart';

/// One NC-01 result: photo, both names, the verified badge (only from an
/// approved state), rating, offered slots, the area line and the favourite
/// heart. Opening it shows NC-02; the search state stays in its controller.
class KitchenCard extends ConsumerWidget {
  const KitchenCard({
    super.key,
    required this.kitchen,
    required this.zone,
    required this.intent,
  });

  final KitchenSummary kitchen;

  /// The selected area, or null for any area.
  final String? zone;

  /// Restored after a guest signs in from the heart (requirement 5.4).
  final NavEntry intent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final k = kitchen;
    final hint = Theme.of(context).hintColor;
    final name = s.t(k.nameEn, k.nameBn);
    final other = s.lang == StLang.bn ? k.nameEn : k.nameBn;
    final z = zone;
    final served = z == null || k.serves(z);
    final areaLine = z == null
        ? s.tx(KitchenDiscoveryText.serves, [
            [for (final x in k.zones) s.tx(zoneText(x))].join(', '),
          ])
        : (served
              ? s.tx(KitchenDiscoveryText.serves, [s.tx(zoneText(z))])
              : s.tx(KitchenDiscoveryText.notServes));
    return StCard(
      key: ValueKey('kitchen-${k.id}'),
      onTap: () => stOpen(ref, 'NC-02', {'kitchen': k.id}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
                        fontWeight: FontWeight.w800,
                        fontSize: StFont.bodyLg,
                      ),
                    ),
                    Text(
                      other,
                      style: TextStyle(color: hint, fontSize: StFont.label),
                    ),
                    const SizedBox(height: StSpace.xxs),
                    Wrap(
                      spacing: StSpace.xxs,
                      runSpacing: StSpace.xxs,
                      children: [
                        if (k.verified)
                          StStatusChip(
                            label: s.tx(KitchenDiscoveryText.verified),
                            tone: StTone.success,
                            icon: Icons.verified_rounded,
                          ),
                        if (!k.accepting)
                          StStatusChip(
                            label: s.tx(KitchenDiscoveryText.notAccepting),
                            tone: StTone.warning,
                            icon: Icons.pause_circle_outline,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              FavouriteHeart(
                kitchenId: k.id,
                kitchenName: name,
                intent: intent,
              ),
            ],
          ),
          const SizedBox(height: StSpace.xs),
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
                  s.tx(KitchenDiscoveryText.rating, [
                    '${k.rating}',
                    '${k.ratingCount}',
                  ]),
                  style: const TextStyle(fontSize: StFont.label),
                ),
              ),
            ],
          ),
          const SizedBox(height: StSpace.xxs),
          Wrap(
            spacing: StSpace.xxs,
            runSpacing: StSpace.xxs,
            children: [
              for (final slot in Slot.values)
                if (k.slots.contains(slot))
                  StStatusChip(
                    label: StCatalogueText.slot(s, slot),
                    icon: Icons.schedule_rounded,
                  ),
            ],
          ),
          const SizedBox(height: StSpace.xxs),
          Row(
            children: [
              Icon(
                served ? Icons.place_outlined : Icons.location_off_outlined,
                size: StSize.iconSm,
                color: served ? hint : StColors.danger,
              ),
              const SizedBox(width: StSpace.xxs),
              Expanded(
                child: Text(
                  areaLine,
                  style: TextStyle(
                    fontSize: StFont.label,
                    color: served ? hint : StColors.danger,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
