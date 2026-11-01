import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../../kitchen_favourites/screens/kitchen_favourites_text.dart';
import '../../kitchen_favourites/widgets/favourite_failure_note.dart';
import '../../partner_handoff/widgets/partner_handoff_sheet.dart';
import '../controllers/kitchen_discovery_providers.dart';
import '../widgets/kitchen_card.dart';
import '../widgets/kitchen_filter_panel.dart';
import '../widgets/kitchen_filters_sheet.dart';
import '../widgets/kitchen_labels.dart';
import 'kitchen_discovery_text.dart';

/// NC-01 Kitchen discovery search (guest-readable). Text, filters and sort
/// live in a non-auto-disposed controller and the scroll offset in
/// `StScrollMemory`, so a return from a kitchen or a sign-in restores them.
/// Supplier and rider entries open the Partner hand-off sheet, never a route.
class KitchenDiscoveryScreen extends ConsumerStatefulWidget {
  const KitchenDiscoveryScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  ConsumerState<KitchenDiscoveryScreen> createState() =>
      _KitchenDiscoveryScreenState();
}

class _KitchenDiscoveryScreenState
    extends ConsumerState<KitchenDiscoveryScreen> {
  final _search = TextEditingController();
  late final StScrollMemory _memory = StScrollMemory(ref, 'NC-01');
  late final ScrollController _scroll = _memory.create();
  Timer? _debounce;
  bool _tooLong = false;

  @override
  void initState() {
    super.initState();
    _search.text = ref.read(kitchenQueryProvider).q;
    final params = ref.read(appProvider).current.params;
    if (params.isNotEmpty) {
      // A deep link or a restored intent; providers change after this frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(kitchenQueryProvider.notifier).applyParams(params);
        final q = ref.read(kitchenQueryProvider).q;
        if (_search.text != q) _search.text = q;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _onText(String text) {
    _debounce?.cancel();
    final tooLong = text.length > KitchenQuery.maxQueryLength;
    setState(() => _tooLong = tooLong);
    // NC-01.8: a query that is too long gets the inline helper, no request.
    if (tooLong) return;
    _debounce = Timer(StTiming.searchDebounce, () {
      if (mounted) {
        ref.read(kitchenQueryProvider.notifier).setText(text.trim());
      }
    });
  }

  void _clear() {
    _debounce?.cancel();
    _search.clear();
    setState(() => _tooLong = false);
    ref.read(kitchenQueryProvider.notifier).setText('');
  }

  void _toggleFavouritesOnly() {
    final q = ref.read(kitchenQueryProvider);
    if (ref.read(actorProvider).isGuest) {
      showSignInPrompt(
        ref,
        intent: NavEntry('NC-01', q.toParams()),
        body: KitchenFavouritesText.prompt,
      );
      return;
    }
    ref
        .read(kitchenQueryProvider.notifier)
        .set(q.copyWith(favouritesOnly: !q.favouritesOnly));
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final query = ref.watch(kitchenQueryProvider);
    final guest = ref.watch(actorProvider).isGuest;
    final band = bandOf(MediaQuery.sizeOf(context).width);
    final wide = isWide(band);
    final columns = switch (band) {
      StBand.compact => 1,
      StBand.medium => 2,
      StBand.expanded => 3,
      StBand.large => 4,
    };
    final results = StAsyncView<StPagedList<KitchenSummary>>(
      value: ref.watch(kitchenResultsProvider),
      supported: KitchenDiscoveryScreen.states,
      onRetry: ref.read(kitchenResultsProvider.notifier).reload,
      builder: (context, page) => _results(s, query, page, columns, guest),
    );
    return _memory.track(
      child: StScreen(
        title: s.tx(KitchenDiscoveryText.title),
        eyebrow: s.tx(KitchenDiscoveryText.eyebrow),
        dense: true,
        scrollController: _scroll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ..._controls(s, query, guest, wide),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StCard(
                      child: KitchenFilterPanel(
                        query: query,
                        onChanged: ref.read(kitchenQueryProvider.notifier).set,
                        onFavourites: _toggleFavouritesOnly,
                        enabled: !s.offline,
                      ),
                    ),
                  ),
                  const SizedBox(width: StSpace.md),
                  Expanded(flex: 3, child: results),
                ],
              )
            else
              results,
            const SizedBox(height: StSpace.lg),
            StList(
              children: [
                if (!guest)
                  StRowTile(
                    key: const ValueKey('open-favourites'),
                    icon: Icons.favorite_border_rounded,
                    label: s.tx(KitchenFavouritesText.title),
                    onTap: () => stOpen(ref, 'NC-18'),
                  ),
                StRowTile(
                  key: const ValueKey('handoff-supplier'),
                  icon: Icons.storefront_rounded,
                  label: s.tx(KitchenDiscoveryText.cook),
                  sub: s.tx(KitchenDiscoveryText.cookSub),
                  onTap: () => showPartnerHandoff(ref, supplier: true),
                ),
                StRowTile(
                  key: const ValueKey('handoff-rider'),
                  icon: Icons.two_wheeler_rounded,
                  label: s.tx(KitchenDiscoveryText.ride),
                  sub: s.tx(KitchenDiscoveryText.rideSub),
                  onTap: () => showPartnerHandoff(ref, supplier: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _controls(
    AppState s,
    KitchenQuery query,
    bool guest,
    bool wide,
  ) {
    final queryCtrl = ref.read(kitchenQueryProvider.notifier);
    final offline = s.offline;
    const labelStyle = TextStyle(
      fontSize: StFont.label,
      fontWeight: FontWeight.w700,
    );
    return [
      StField(
        label: s.tx(KitchenDiscoveryText.search),
        controller: _search,
        placeholder: s.tx(KitchenDiscoveryText.searchHint),
        enabled: !offline,
        error: _tooLong ? s.tx(KitchenDiscoveryText.queryTooLong) : null,
        onChanged: _onText,
      ),
      if (_search.text.isNotEmpty)
        Align(
          alignment: Alignment.centerRight,
          child: StBtn(
            key: const ValueKey('search-clear'),
            label: s.tx(KitchenDiscoveryText.clear),
            icon: Icons.close_rounded,
            variant: StBtnVariant.ghost,
            size: StBtnSize.sm,
            disabled: offline,
            onTap: _clear,
          ),
        ),
      const SizedBox(height: StSpace.sm),
      Text(s.tx(KitchenDiscoveryText.area), style: labelStyle),
      const SizedBox(height: StSpace.gap6),
      IgnorePointer(
        ignoring: offline,
        child: StChipRow(
          options: [
            (v: '', l: s.tx(KitchenDiscoveryText.anyArea)),
            for (final z in kitchenZones) (v: z, l: s.tx(zoneText(z))),
          ],
          value: query.zone ?? '',
          onChanged: (v) => queryCtrl.setZone(v.isEmpty ? null : v),
        ),
      ),
      if (!guest) ...[
        const SizedBox(height: StSpace.xs),
        Align(
          alignment: Alignment.centerLeft,
          child: StBtn(
            key: const ValueKey('change-address'),
            label: s.tx(KitchenDiscoveryText.changeAddress),
            icon: Icons.home_outlined,
            variant: StBtnVariant.soft,
            size: StBtnSize.sm,
            onTap: () => stOpen(ref, 'C-02'),
          ),
        ),
      ],
      const SizedBox(height: StSpace.sm),
      if (!wide) ...[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              StBtn(
                key: const ValueKey('open-filters'),
                label: s.tx(KitchenDiscoveryText.filters),
                icon: Icons.tune_rounded,
                variant: StBtnVariant.outline,
                size: StBtnSize.sm,
                disabled: offline,
                onTap: () => ref
                    .read(appProvider.notifier)
                    .showSheet(const KitchenFiltersSheet()),
              ),
              const SizedBox(width: StSpace.xs),
              FilterChip(
                key: const ValueKey('quick-verified'),
                label: Text(s.tx(KitchenDiscoveryText.verifiedOnly)),
                selected: query.verifiedOnly,
                onSelected: offline
                    ? null
                    : (_) => queryCtrl.set(
                        query.copyWith(verifiedOnly: !query.verifiedOnly),
                      ),
              ),
              const SizedBox(width: StSpace.xs),
              FilterChip(
                key: const ValueKey('quick-favourites'),
                label: Text(s.tx(KitchenDiscoveryText.favourites)),
                selected: query.favouritesOnly,
                onSelected: offline ? null : (_) => _toggleFavouritesOnly(),
              ),
              for (final slot in Slot.values) ...[
                const SizedBox(width: StSpace.xs),
                FilterChip(
                  key: ValueKey('quick-slot-${slot.name}'),
                  label: Text(StCatalogueText.slot(s, slot)),
                  selected: query.slots.contains(slot),
                  onSelected: offline
                      ? null
                      : (_) => queryCtrl.toggleSlot(slot),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: StSpace.sm),
      ],
      Text(s.tx(KitchenDiscoveryText.sort), style: labelStyle),
      const SizedBox(height: StSpace.gap6),
      IgnorePointer(
        ignoring: offline,
        child: StChipRow(
          options: [
            (
              v: KitchenSort.relevance.name,
              l: s.tx(KitchenDiscoveryText.sortRelevance),
            ),
            (
              v: KitchenSort.rating.name,
              l: s.tx(KitchenDiscoveryText.sortRating),
            ),
            (v: KitchenSort.name.name, l: s.tx(KitchenDiscoveryText.sortName)),
          ],
          value: query.sort.name,
          onChanged: (v) => queryCtrl.setSort(KitchenSort.values.byName(v)),
        ),
      ),
      if (offline) ...[
        const SizedBox(height: StSpace.xs),
        StNote(
          tone: StNoteTone.warning,
          child: Text(s.tx(KitchenDiscoveryText.offlineControls)),
        ),
      ],
      const SizedBox(height: StSpace.sm),
      const FavouriteFailureNote(),
    ];
  }

  Widget _results(
    AppState s,
    KitchenQuery query,
    StPagedList<KitchenSummary> page,
    int columns,
    bool guest,
  ) {
    final queryCtrl = ref.read(kitchenQueryProvider.notifier);
    if (page.isEmpty) {
      // NC-01.8: "area not served" is distinct from "no match".
      final areaOnly =
          query.zone != null && !query.hasFilters && query.q.isEmpty;
      if (areaOnly) {
        return StStatusPanel(
          icon: Icons.location_off_outlined,
          title: KitchenDiscoveryText.noArea,
          action: guest
              ? (
                  label: KitchenDiscoveryText.anyArea,
                  onTap: () => queryCtrl.setZone(null),
                )
              : (
                  label: KitchenDiscoveryText.changeAddress,
                  onTap: () => stOpen(ref, 'C-02'),
                ),
        );
      }
      return StStatusPanel(
        icon: Icons.search_off,
        title: KitchenDiscoveryText.noMatch,
        action: (
          label: KitchenDiscoveryText.clearFilters,
          onTap: () {
            _search.clear();
            setState(() => _tooLong = false);
            queryCtrl.clearAll();
          },
        ),
      );
    }
    final base = query.toParams();
    final cards = [
      for (final k in page.items)
        KitchenCard(
          kitchen: k,
          zone: query.zone,
          intent: NavEntry('NC-01', {...base, 'kitchen': k.id}),
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            s.tx(
              page.atEnd
                  ? KitchenDiscoveryText.count
                  : KitchenDiscoveryText.countMore,
              ['${page.items.length}'],
            ),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: StSpace.xs),
        LayoutBuilder(
          builder: (context, constraints) {
            if (columns == 1) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final c in cards)
                    Padding(
                      padding: const EdgeInsets.only(bottom: StSpace.sm),
                      child: c,
                    ),
                ],
              );
            }
            final width =
                (constraints.maxWidth - StSpace.sm * (columns - 1)) / columns;
            return Wrap(
              spacing: StSpace.sm,
              runSpacing: StSpace.sm,
              children: [
                for (final c in cards) SizedBox(width: width, child: c),
              ],
            );
          },
        ),
        StLoadMore<KitchenSummary>(
          list: page,
          onMore: ref.read(kitchenResultsProvider.notifier).loadMore,
        ),
      ],
    );
  }
}
