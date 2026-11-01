import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../state/app_controller.dart';
import '../state/app_state.dart';
import '../state/shell_config.dart';
import 'st_band.dart';
import 'st_icon_btn.dart';
import 'st_host_entries.dart';
import 'st_host_entry_list.dart';
import 'st_state_view.dart';

// LC-4: role screens include the new families (NC, NS, NR, NA, NF) so they
// get the side navigation in the expanded and large bands.
bool _isRoleScreen(String id) => RegExp(r'^(?:N?[CSRA]|NF)-').hasMatch(id);

class StScreen extends ConsumerWidget {
  const StScreen({
    super.key,
    required this.title,
    required this.child,
    this.eyebrow,
    this.actions,
    this.back = true,
    this.states = true,
    this.footer,
    this.scrollController,
    this.dense = false,
  });

  final String title;
  final String? eyebrow;
  final Widget child;
  final List<Widget>? actions;
  final bool back;
  final bool states;
  final Widget? footer;

  /// LC-4: lets a screen restore its scroll position (`StScrollMemory`).
  final ScrollController? scrollController;

  /// LC-4: dense desktop layout (NA and NF): the wide content caps (1024 and
  /// 1152) apply in the expanded and large bands, not only on tab screens.
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final w = MediaQuery.sizeOf(context).width;
    final band = bandOf(w);
    final wide = isWide(band);
    final tabs = ref.watch(shellConfigProvider).tabsFor(s.role);
    final isTab = tabs.any((x) => x.id == s.current.id);
    final hasTabs = isTab && !wide;
    final rail = wide && _isRoleScreen(s.current.id);
    final role = context.roleColor;

    // LC-11: entry controls added by the registry (StHostEntries) render
    // below the host's own content; a host without entries is unchanged.
    final entries = StHostEntries.of(context);
    Widget body = states && s.variant != StVariant.normal
        ? StStateView(variant: s.variant)
        : (entries.isEmpty
            ? child
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  child,
                  const SizedBox(height: StSpace.md),
                  StHostEntryList(entries: entries)
                ],
              ));

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withValues(alpha: 0.72),
            border: Border(
                bottom: BorderSide(
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.6))),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                if (back && s.stack.length > 1) ...[
                  StIconBtn(
                      icon: Icons.arrow_back_rounded,
                      label: t('Back', 'ফিরে যান'),
                      onTap: ctrl.back),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (eyebrow ?? 'Smart Tiffin').toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: role,
                        ),
                      ),
                      Text(title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.fromLTRB(
                    16, 16, 16, hasTabs ? 112 : (footer != null ? 16 : 32)),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: band == StBand.compact
                          ? double.infinity
                          : ((isTab || dense) && wide
                              ? (band == StBand.large ? 1152 : 1024)
                              : 672),
                    ),
                    child: body,
                  ),
                ),
              );
            },
          ),
        ),
        if (footer != null)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withValues(alpha: 0.72),
              border: Border(
                  top: BorderSide(
                      color: Theme.of(context)
                          .dividerColor
                          .withValues(alpha: 0.6))),
            ),
            child: SafeArea(top: false, child: footer!),
          ),
      ],
    );

    return Stack(
      children: [
        Row(
          children: [
            if (rail) _NavRail(band: band),
            Expanded(child: content),
          ],
        ),
        if (hasTabs)
          Positioned(
            left: band == StBand.medium ? null : 12,
            right: band == StBand.medium ? null : 12,
            bottom: 12,
            child: band == StBand.medium
                ? Center(
                    child: SizedBox(
                        width: (w - 24).clamp(0, 560),
                        child: const _BottomNav()))
                : const _BottomNav(),
          ),
        if (band == StBand.medium && hasTabs)
          const Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Center(child: SizedBox(width: 560, child: _BottomNav()))),
      ],
    );
  }
}

class _NavRail extends ConsumerWidget {
  const _NavRail({required this.band});
  final StBand band;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final full = band == StBand.large;
    final role = context.roleColor;
    return Container(
      width: full ? 224 : 80,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.6),
        border: Border(
            right: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.6))),
      ),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: full ? 12 : 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                full ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(colors: [role, StColors.warning]),
                ),
                child: const Text('ST',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12)),
              ),
              if (full) ...[
                const SizedBox(width: 8),
                const Text('Smart Tiffin',
                    style: TextStyle(fontWeight: FontWeight.w800)),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (final tab
                    in ref.watch(shellConfigProvider).railTabsFor(s.role))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Material(
                      color: tab.id == s.current.id
                          ? role.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () => ctrl.reset(tab.id),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: full ? 12 : 4,
                            vertical: full ? 12 : 8,
                          ),
                          child: full
                              ? Row(
                                  children: [
                                    Icon(
                                      tab.icon,
                                      size: 20,
                                      color: tab.id == s.current.id
                                          ? role
                                          : Theme.of(context).hintColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        s.t(tab.en, tab.bn),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: tab.id == s.current.id
                                              ? role
                                              : Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Icon(
                                      tab.icon,
                                      size: 20,
                                      color: tab.id == s.current.id
                                          ? role
                                          : Theme.of(context).hintColor,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      s.t(tab.en, tab.bn),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: tab.id == s.current.id
                                            ? role
                                            : Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends ConsumerWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final role = context.roleColor;
    final tabs = ref.watch(shellConfigProvider).tabsFor(s.role);
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(24),
      color: Theme.of(context).cardColor.withValues(alpha: 0.92),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            for (final tab in tabs)
              Expanded(
                child: InkWell(
                  onTap: () => ctrl.reset(tab.id),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: tab.id == s.current.id
                          ? role.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(tab.icon,
                            size: 20,
                            color: tab.id == s.current.id
                                ? role
                                : Theme.of(context).hintColor),
                        const SizedBox(height: 2),
                        Text(
                          s.t(tab.en, tab.bn),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: tab.id == s.current.id
                                ? role
                                : Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
