import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../../kitchen_discovery/widgets/kitchen_labels.dart';
import '../controllers/kitchen_profile_providers.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/menu_item_sheet.dart';
import '../widgets/review_tile.dart';
import 'kitchen_profile_text.dart';

/// NC-03 Kitchen menu by meal slot, with the paged reviews (C-06 extension,
/// guest-readable). Slot tabs list only the slots the kitchen offers; dates
/// past cutoff are shown disabled with the reason. Adding to the order is a
/// signed-in action. An absent and a non-viewable kitchen show the same
/// neutral panel (requirement 5.8).
class KitchenMenuSectionScreen extends ConsumerStatefulWidget {
  const KitchenMenuSectionScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  ConsumerState<KitchenMenuSectionScreen> createState() =>
      _KitchenMenuSectionScreenState();
}

class _KitchenMenuSectionScreenState
    extends ConsumerState<KitchenMenuSectionScreen> {
  Slot? _slot;
  String? _date;
  String? _tab;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final title = s.tx(KitchenProfileText.menuTitle);
    final params = stParamsOf(context, ref);
    final key = kitchenKeyOf(params);
    if (key == null) {
      return StScreen(title: title, child: const StUnavailablePanel());
    }
    final tab = _tab ?? (params['tab'] == 'reviews' ? 'reviews' : 'menu');
    final profile = ref.watch(kitchenProfileProvider(key));
    return StScreen(
      title: title,
      eyebrow: s.tx(KitchenProfileText.eyebrow),
      child: StAsyncView<KitchenProfile>(
        value: profile,
        supported: KitchenMenuSectionScreen.states,
        onRetry: () => ref.invalidate(kitchenProfileProvider(key)),
        builder: (context, p) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              s.t(p.summary.nameEn, p.summary.nameBn),
              style: const TextStyle(
                fontSize: StFont.bodyLg,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: StSpace.xs),
            StSegmented(
              options: [
                (v: 'menu', l: s.tx(KitchenProfileText.segMenu)),
                (v: 'reviews', l: s.tx(KitchenProfileText.segReviews)),
              ],
              value: tab,
              onChanged: (v) => setState(() => _tab = v),
            ),
            const SizedBox(height: StSpace.sm),
            if (tab == 'reviews')
              _reviews(s, p.summary.id)
            else
              _menu(context, s, p.summary, params),
          ],
        ),
      ),
    );
  }

  Widget _menu(
    BuildContext context,
    AppState s,
    KitchenSummary k,
    Map<String, String> params,
  ) {
    final offered = [
      for (final x in Slot.values)
        if (k.slots.contains(x)) x,
    ];
    if (offered.isEmpty) {
      return const StStatusPanel(
        icon: Icons.restaurant_rounded,
        title: KitchenProfileText.noSlot,
      );
    }
    Slot? fromParams;
    for (final x in offered) {
      if (x.name == params['slot']) fromParams = x;
    }
    final slot = _slot ?? fromParams ?? offered.first;
    final today = ref.watch(todayProvider);
    final hint = Theme.of(context).hintColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Slot tabs render at once; the slot identity is data, not a label.
        StChipRow(
          options: [
            for (final x in offered) (v: x.name, l: StCatalogueText.slot(s, x)),
          ],
          value: slot.name,
          onChanged: (v) => setState(() => _slot = Slot.values.byName(v)),
        ),
        const SizedBox(height: StSpace.sm),
        StAsyncView<List<String>>(
          value: ref.watch(kitchenMenuDatesProvider(k.id)),
          supported: const {
            StVariant.loading,
            StVariant.error,
            StVariant.offline,
          },
          onRetry: () => ref.invalidate(kitchenMenuDatesProvider(k.id)),
          builder: (context, dates) {
            final open = [
              for (final d in dates)
                if (d.compareTo(today) > 0) d,
            ];
            final asked = params['date'];
            final date = _date ??
                (asked != null && open.contains(asked)
                    ? asked
                    : (open.isNotEmpty ? open.first : null));
            if (date == null) {
              return const StStatusPanel(
                icon: Icons.event_busy_outlined,
                title: KitchenProfileText.noDates,
              );
            }
            final i = open.indexOf(date);
            final next = i >= 0 && i + 1 < open.length ? open[i + 1] : null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  s.tx(KitchenProfileText.date),
                  style: const TextStyle(
                    fontSize: StFont.label,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: StSpace.gap6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final d in dates)
                        Padding(
                          padding: const EdgeInsets.only(right: StSpace.xs),
                          child: ChoiceChip(
                            key: ValueKey('date-$d'),
                            label: Text(
                              s.digits(
                                '${d.substring(8)}/${d.substring(5, 7)}',
                              ),
                            ),
                            selected: d == date,
                            tooltip: d.compareTo(today) <= 0
                                ? s.tx(KitchenProfileText.cutoffReason)
                                : null,
                            onSelected: d.compareTo(today) <= 0
                                ? null
                                : (_) => setState(() => _date = d),
                          ),
                        ),
                    ],
                  ),
                ),
                if (dates.any((d) => d.compareTo(today) <= 0))
                  Text(
                    s.tx(KitchenProfileText.cutoffReason),
                    style: TextStyle(fontSize: StFont.caption, color: hint),
                  ),
                const SizedBox(height: StSpace.sm),
                _meals(s, k, slot, date, next),
              ],
            );
          },
        ),
        const SizedBox(height: StSpace.sm),
        StNote(child: Text(s.tx(KitchenProfileText.confirmNote))),
        const SizedBox(height: StSpace.xs),
        StNote(
          tone: StNoteTone.policy,
          child: Text(s.tx(KitchenProfileText.sellerClaim)),
        ),
        if (k.dietary.isNotEmpty) ...[
          const SizedBox(height: StSpace.xs),
          Wrap(
            spacing: StSpace.xxs,
            runSpacing: StSpace.xxs,
            children: [
              for (final d in k.dietary)
                StStatusChip(
                  label: s.tx(dietaryText(d)),
                  icon: Icons.eco_outlined,
                ),
            ],
          ),
        ],
        _cartBar(s),
      ],
    );
  }

  Widget _meals(
    AppState s,
    KitchenSummary k,
    Slot slot,
    String date,
    String? next,
  ) {
    final key = (kitchen: k.id, slot: slot, date: date);
    return StAsyncView<SlotMenu>(
      value: ref.watch(kitchenMenuProvider(key)),
      supported: KitchenMenuSectionScreen.states,
      isEmpty: (m) => m.items.isEmpty,
      emptyMessage: KitchenProfileText.noMeals,
      emptyAction: next == null
          ? null
          : (
              label: KitchenProfileText.nextDate,
              onTap: () => setState(() => _date = next),
            ),
      onRetry: () => ref.invalidate(kitchenMenuProvider(key)),
      builder: (context, menu) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in menu.items)
            Padding(
              padding: const EdgeInsets.only(bottom: StSpace.xs),
              child: MenuItemCard(
                item: item,
                cutoffPassed: menu.cutoffPassed,
                accepting: k.accepting,
                onSelect: () => _select(item, k, slot, date),
              ),
            ),
        ],
      ),
    );
  }

  void _select(MenuItem item, KitchenSummary k, Slot slot, String date) {
    ref.read(appProvider.notifier).showSheet(
          MenuItemSheet(
            item: item,
            kitchen: k,
            intent: NavEntry('NC-03', {
              'kitchen': k.id,
              'slot': slot.name,
              'date': date,
            }),
          ),
        );
  }

  Widget _reviews(AppState s, String kitchenId) {
    final value = ref.watch(kitchenReviewsProvider(kitchenId));
    final paged = ref.read(kitchenReviewsProvider(kitchenId).notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StNote(child: Text(s.tx(KitchenProfileText.reviewsNote))),
        const SizedBox(height: StSpace.sm),
        StAsyncView<StPagedList<KitchenReview>>(
          value: value,
          supported: KitchenMenuSectionScreen.states,
          isEmpty: (list) => list.isEmpty,
          emptyMessage: KitchenProfileText.noReviews,
          onRetry: paged.reload,
          builder: (context, list) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final r in list.items) ReviewTile(review: r),
              StLoadMore<KitchenReview>(list: list, onMore: paged.loadMore),
            ],
          ),
        ),
      ],
    );
  }

  /// Selection summary (signed-in customers): the legacy one-kitchen cart.
  Widget _cartBar(AppState s) {
    final count = s.store.cart;
    if (ref.watch(actorProvider).isGuest || count <= 0) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: StSpace.sm),
      child: StCard(
        child: Row(
          children: [
            const Icon(Icons.shopping_bag_outlined),
            const SizedBox(width: StSpace.xs),
            Expanded(
              child: Semantics(
                liveRegion: true,
                child: Text(s.tx(KitchenProfileText.inCart, ['$count'])),
              ),
            ),
            StBtn(
              key: const ValueKey('open-cart'),
              label: s.tx(KitchenProfileText.openCart),
              size: StBtnSize.sm,
              onTap: () => stOpen(ref, 'C-07'),
            ),
          ],
        ),
      ),
    );
  }
}
