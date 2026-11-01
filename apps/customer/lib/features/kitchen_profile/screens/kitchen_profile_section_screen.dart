import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../../kitchen_discovery/controllers/kitchen_discovery_providers.dart';
import '../../kitchen_discovery/widgets/kitchen_labels.dart';
import '../controllers/kitchen_profile_providers.dart';
import '../widgets/kitchen_header.dart';
import '../widgets/review_tile.dart';
import 'kitchen_profile_text.dart';

/// NC-02 Kitchen profile (C-06 extension, guest-readable): header, segments,
/// served areas, hours, slots, policy summary and a review preview, with
/// View menu and Subscribe as sticky actions. An absent and a non-viewable
/// kitchen show the same neutral panel with Back (requirement 5.8).
class KitchenProfileSectionScreen extends ConsumerWidget {
  const KitchenProfileSectionScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final title = s.tx(KitchenProfileText.aboutTitle);
    final key = kitchenKeyOf(stParamsOf(context, ref));
    if (key == null) {
      return StScreen(title: title, child: const StUnavailablePanel());
    }
    final profile = ref.watch(kitchenProfileProvider(key));
    final p = profile.valueOrNull;
    final guest = ref.watch(actorProvider).isGuest;
    return StScreen(
      title: title,
      eyebrow: s.tx(KitchenProfileText.eyebrow),
      actions: [
        if (p != null)
          StIconBtn(
            icon: Icons.flag_outlined,
            label: s.tx(KitchenProfileText.report),
            onTap: () => _report(ref, p.summary.id, guest),
          ),
      ],
      footer: p == null ? null : _footer(s, ref, p.summary, guest),
      child: StAsyncView<KitchenProfile>(
        value: profile,
        supported: states,
        onRetry: () => ref.invalidate(kitchenProfileProvider(key)),
        builder: (context, p) => _body(context, s, ref, p, guest),
      ),
    );
  }

  void _report(WidgetRef ref, String kitchenId, bool guest) {
    if (guest) {
      showSignInPrompt(
        ref,
        intent: NavEntry('NC-02', {'kitchen': kitchenId}),
        body: KitchenProfileText.reportPrompt,
      );
      return;
    }
    stOpen(ref, 'SH-06', {'ref': 'kitchen:$kitchenId'});
  }

  Widget _footer(AppState s, WidgetRef ref, KitchenSummary k, bool guest) {
    final String? blocked = !k.accepting
        ? s.tx(KitchenProfileText.subscribeBlocked)
        : (s.offline ? s.tx(KitchenProfileText.offlineAction) : null);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: StBtn(
            key: const ValueKey('view-menu'),
            label: s.tx(KitchenProfileText.viewMenu),
            icon: Icons.restaurant_menu_rounded,
            variant: StBtnVariant.outline,
            onTap: () => stOpen(ref, 'NC-03', {'kitchen': k.id}),
          ),
        ),
        const SizedBox(width: StSpace.xs),
        Expanded(
          child: StBtn(
            key: const ValueKey('subscribe'),
            label: s.tx(KitchenProfileText.subscribe),
            icon: Icons.event_rounded,
            disabled: blocked != null,
            reason: blocked,
            onTap: () {
              if (guest) {
                // The kitchen id survives the sign-in (fixes the C-11 gap).
                showSignInPrompt(
                  ref,
                  intent: NavEntry('NC-02', {'kitchen': k.id}),
                  body: KitchenProfileText.subscribePrompt,
                );
                return;
              }
              stOpen(ref, 'NC-04', {'kitchen': k.id});
            },
          ),
        ),
      ],
    );
  }

  Widget _body(
    BuildContext context,
    AppState s,
    WidgetRef ref,
    KitchenProfile p,
    bool guest,
  ) {
    final k = p.summary;
    final zone = ref.watch(kitchenQueryProvider).zone;
    final description = s.t(p.descriptionEn, p.descriptionBn).trim();
    final hint = Theme.of(context).hintColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KitchenHeader(summary: k, intent: NavEntry('NC-02', {'kitchen': k.id})),
        const SizedBox(height: StSpace.sm),
        StSegmented(
          options: [
            (v: 'about', l: s.tx(KitchenProfileText.segAbout)),
            (v: 'menu', l: s.tx(KitchenProfileText.segMenu)),
            (v: 'reviews', l: s.tx(KitchenProfileText.segReviews)),
          ],
          value: 'about',
          onChanged: (v) {
            if (v == 'menu') stOpen(ref, 'NC-03', {'kitchen': k.id});
            if (v == 'reviews') {
              stOpen(ref, 'NC-03', {'kitchen': k.id, 'tab': 'reviews'});
            }
          },
        ),
        const SizedBox(height: StSpace.md),
        // A missing description is omitted, never shown blank (NC-02.8).
        if (description.isNotEmpty)
          StSection(
            title: s.tx(KitchenProfileText.description),
            child: Text(description),
          ),
        StSection(
          title: s.tx(KitchenProfileText.servedAreas),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: StSpace.xxs,
                runSpacing: StSpace.xxs,
                children: [
                  for (final z in k.zones)
                    StStatusChip(
                      label: s.tx(zoneText(z)),
                      icon: Icons.place_outlined,
                    ),
                ],
              ),
              if (zone != null) ...[
                const SizedBox(height: StSpace.xs),
                Row(
                  children: [
                    Icon(
                      k.serves(zone)
                          ? Icons.check_circle_outline
                          : Icons.location_off_outlined,
                      size: StSize.iconSm,
                      color: k.serves(zone)
                          ? StColors.success
                          : StColors.danger,
                    ),
                    const SizedBox(width: StSpace.xxs),
                    Expanded(
                      child: Text(
                        s.tx(
                          k.serves(zone)
                              ? KitchenProfileText.servesYou
                              : KitchenProfileText.notServesYou,
                          [s.tx(zoneText(zone))],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (!guest) ...[
                const SizedBox(height: StSpace.xs),
                StBtn(
                  key: const ValueKey('profile-change-address'),
                  label: s.tx(KitchenProfileText.changeAddress),
                  icon: Icons.home_outlined,
                  variant: StBtnVariant.soft,
                  size: StBtnSize.sm,
                  onTap: () => stOpen(ref, 'C-02'),
                ),
              ],
            ],
          ),
        ),
        StSection(
          title: s.tx(KitchenProfileText.hours),
          child: Text(s.digits(p.hours)),
        ),
        StSection(
          title: s.tx(KitchenProfileText.slots),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final slot in Slot.values)
                if (p.slotWindows[slot] != null)
                  StInfoRow(
                    label: StCatalogueText.slot(s, slot),
                    value: s.digits(p.slotWindows[slot]!),
                  ),
            ],
          ),
        ),
        StSection(
          title: s.tx(KitchenProfileText.policyTitle),
          child: StNote(
            tone: StNoteTone.policy,
            child: Text(s.tx(KitchenProfileText.policy)),
          ),
        ),
        StSection(
          title: s.tx(KitchenProfileText.recentReviews),
          action: s.tx(KitchenProfileText.seeAll),
          onAction: () =>
              stOpen(ref, 'NC-03', {'kitchen': k.id, 'tab': 'reviews'}),
          child: p.reviews.isEmpty
              ? Text(
                  s.tx(KitchenProfileText.noReviews),
                  style: TextStyle(color: hint),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [for (final r in p.reviews) ReviewTile(review: r)],
                ),
        ),
      ],
    );
  }
}
