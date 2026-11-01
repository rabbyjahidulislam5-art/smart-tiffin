import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/kitchen_discovery_text.dart';
import 'kitchen_labels.dart';

/// The NC-01 filters: cuisine, dietary, slots offered, verified kitchens,
/// favourites and "open on a date" (disabled with its reason: the search
/// read has no date availability yet). Shown as the wide-band rail and
/// inside the Filters sheet. Chips announce their selected state.
class KitchenFilterPanel extends ConsumerWidget {
  const KitchenFilterPanel({
    super.key,
    required this.query,
    required this.onChanged,
    required this.onFavourites,
    this.enabled = true,
  });

  final KitchenQuery query;
  final ValueChanged<KitchenQuery> onChanged;

  /// The favourites filter; a guest gets the sign-in prompt instead.
  final VoidCallback onFavourites;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final q = query;
    Widget label(StText t) => Padding(
      padding: const EdgeInsets.only(top: StSpace.sm, bottom: StSpace.xxs),
      child: Text(
        s.tx(t),
        style: const TextStyle(
          fontSize: StFont.label,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    Widget chip(Key key, String text, bool selected, VoidCallback onTap) =>
        FilterChip(
          key: key,
          label: Text(text),
          selected: selected,
          onSelected: enabled ? (_) => onTap() : null,
        );
    Widget wrap(List<Widget> children) =>
        Wrap(spacing: StSpace.xxs, runSpacing: StSpace.xxs, children: children);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        label(KitchenDiscoveryText.cuisine),
        wrap([
          for (final c in kitchenCuisines)
            chip(
              ValueKey('filter-cuisine-$c'),
              s.tx(cuisineText(c)),
              q.cuisine == c,
              () => onChanged(
                q.cuisine == c
                    ? q.copyWith(clearCuisine: true)
                    : q.copyWith(cuisine: c),
              ),
            ),
        ]),
        label(KitchenDiscoveryText.dietary),
        wrap([
          for (final d in kitchenDietary)
            chip(
              ValueKey('filter-dietary-$d'),
              s.tx(dietaryText(d)),
              q.dietary == d,
              () => onChanged(
                q.dietary == d
                    ? q.copyWith(clearDietary: true)
                    : q.copyWith(dietary: d),
              ),
            ),
        ]),
        label(KitchenDiscoveryText.slots),
        wrap([
          for (final slot in Slot.values)
            chip(
              ValueKey('filter-slot-${slot.name}'),
              StCatalogueText.slot(s, slot),
              q.slots.contains(slot),
              () {
                final next = {...q.slots};
                if (!next.remove(slot)) next.add(slot);
                onChanged(q.copyWith(slots: next));
              },
            ),
        ]),
        label(KitchenDiscoveryText.more),
        wrap([
          chip(
            const ValueKey('filter-verified'),
            s.tx(KitchenDiscoveryText.verifiedOnly),
            q.verifiedOnly,
            () => onChanged(q.copyWith(verifiedOnly: !q.verifiedOnly)),
          ),
          chip(
            const ValueKey('filter-favourites'),
            s.tx(KitchenDiscoveryText.favourites),
            q.favouritesOnly,
            onFavourites,
          ),
          FilterChip(
            key: const ValueKey('filter-open-on'),
            label: Text(s.tx(KitchenDiscoveryText.openOn)),
            selected: false,
            onSelected: null,
            tooltip: s.tx(KitchenDiscoveryText.openOnGap),
          ),
        ]),
        const SizedBox(height: StSpace.xxs),
        Text(
          s.tx(KitchenDiscoveryText.openOnGap),
          style: TextStyle(
            fontSize: StFont.caption,
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }
}
