import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../../kitchen_discovery/widgets/kitchen_photo.dart';
import '../screens/kitchen_profile_text.dart';

/// One NC-03 meal: photo, name, short description, the current price version
/// and an availability line with icon and text. Select is disabled with the
/// visible reason when the meal cannot be ordered.
class MenuItemCard extends ConsumerWidget {
  const MenuItemCard({
    super.key,
    required this.item,
    required this.cutoffPassed,
    required this.accepting,
    required this.onSelect,
  });

  final MenuItem item;
  final bool cutoffPassed;
  final bool accepting;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    Meal? meal;
    for (final m in meals) {
      if (m.id == item.mealId) meal = m;
    }
    final (StText status, StTone tone, IconData icon) = !item.available
        ? (KitchenProfileText.soldOut, StTone.danger, Icons.block_rounded)
        : cutoffPassed
            ? (
                KitchenProfileText.cutoffPassed,
                StTone.warning,
                Icons.schedule_rounded,
              )
            : !accepting
                ? (
                    KitchenProfileText.notOrderable,
                    StTone.warning,
                    Icons.pause_circle_outline,
                  )
                : (
                    KitchenProfileText.available,
                    StTone.success,
                    Icons.check_circle_outline,
                  );
    final orderable = item.available && !cutoffPassed && accepting;
    return StCard(
      key: ValueKey('menu-item-${item.id}'),
      onTap: () => stOpen(ref, 'C-05', {'id': item.mealId}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KitchenPhoto(
                img: meal?.img ?? '',
                icon: Icons.restaurant_rounded,
              ),
              const SizedBox(width: StSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StCatalogueText.meal(s, item.mealId),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (meal != null)
                      Text(
                        s.t(meal.desc, meal.descBn),
                        style: TextStyle(
                          fontSize: StFont.label,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    const SizedBox(height: StSpace.xxs),
                    StMoneyText.minor(
                      item.priceMinor,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: StSpace.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: StStatusChip(
                    label: s.tx(status),
                    tone: tone,
                    icon: icon,
                  ),
                ),
              ),
              const SizedBox(width: StSpace.xs),
              Expanded(
                child: StBtn(
                  key: ValueKey('select-${item.id}'),
                  label: s.tx(KitchenProfileText.select),
                  size: StBtnSize.sm,
                  variant:
                      orderable ? StBtnVariant.primary : StBtnVariant.outline,
                  disabled: !orderable,
                  reason: orderable ? null : s.tx(status),
                  onTap: onSelect,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
