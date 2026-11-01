import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../../kitchen_favourites/screens/kitchen_favourites_text.dart';
import '../controllers/kitchen_discovery_providers.dart';
import '../screens/kitchen_discovery_text.dart';
import 'kitchen_filter_panel.dart';

/// The NC-01 Filters sheet: changes stay local until Apply; Cancel keeps the
/// previous filters and Reset clears them (NC-01.5).
class KitchenFiltersSheet extends ConsumerStatefulWidget {
  const KitchenFiltersSheet({super.key});

  @override
  ConsumerState<KitchenFiltersSheet> createState() =>
      _KitchenFiltersSheetState();
}

class _KitchenFiltersSheetState extends ConsumerState<KitchenFiltersSheet> {
  late KitchenQuery _draft = ref.read(kitchenQueryProvider);

  void _favourites() {
    if (ref.read(actorProvider).isGuest) {
      showSignInPrompt(
        ref,
        intent: NavEntry('NC-01', ref.read(kitchenQueryProvider).toParams()),
        body: KitchenFavouritesText.prompt,
      );
      return;
    }
    setState(
      () => _draft = _draft.copyWith(favouritesOnly: !_draft.favouritesOnly),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          s.tx(KitchenDiscoveryText.filters),
          style: const TextStyle(
            fontSize: StFont.heading,
            fontWeight: FontWeight.w800,
          ),
        ),
        KitchenFilterPanel(
          query: _draft,
          onChanged: (q) => setState(() => _draft = q),
          onFavourites: _favourites,
        ),
        const SizedBox(height: StSpace.md),
        StBtn(
          key: const ValueKey('filters-apply'),
          label: s.tx(KitchenDiscoveryText.apply),
          full: true,
          onTap: () {
            ref.read(kitchenQueryProvider.notifier).set(_draft);
            ctrl.closeSheet();
          },
        ),
        const SizedBox(height: StSpace.xs),
        Row(
          children: [
            Expanded(
              child: StBtn(
                key: const ValueKey('filters-reset'),
                label: s.tx(KitchenDiscoveryText.reset),
                variant: StBtnVariant.outline,
                onTap: () => setState(() => _draft = _draft.cleared()),
              ),
            ),
            const SizedBox(width: StSpace.xs),
            Expanded(
              child: StBtn(
                key: const ValueKey('filters-cancel'),
                label: s.tx(KitchenDiscoveryText.cancel),
                variant: StBtnVariant.ghost,
                onTap: ctrl.closeSheet,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
