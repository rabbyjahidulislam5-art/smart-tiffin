import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/forecast_providers.dart';
import 'forecast_text.dart';

/// NS-04 Kitchen subscription forecast (S-07 extension): future portions by
/// date, slot and meal with a capacity overlay.
class ForecastSectionScreen extends ConsumerWidget {
  const ForecastSectionScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final slot = ref.watch(forecastSlotFilterProvider);
    return StScreen(
      title: s.tx(ForecastText.title),
      eyebrow: s.tx(ForecastText.eyebrow),
      child: StAsyncView<List<ForecastRow>>(
        value: ref.watch(forecastProvider),
        supported: states,
        isEmpty: (rows) => rows.isEmpty,
        emptyMessage: ForecastText.empty,
        onRetry: () => ref.invalidate(forecastProvider),
        builder: (context, rows) {
          final slots = {for (final r in rows) r.slot}.toList()
            ..sort((a, b) => a.index.compareTo(b.index));
          final shown = [
            for (final r in rows)
              if (slot == null || r.slot == slot) r,
          ];
          final dates = {for (final r in shown) r.date}.toList()..sort();
          final over = shown.where((r) => r.overCapacity).length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StNote(child: Text(s.tx(ForecastText.advisory))),
              const SizedBox(height: StSpace.sm),
              StChipRow(
                options: [
                  (v: 'all', l: s.tx(ForecastText.allSlots)),
                  for (final sl in slots)
                    (v: sl.name, l: StCatalogueText.slot(s, sl)),
                ],
                value: slot?.name ?? 'all',
                onChanged: (v) =>
                    ref.read(forecastSlotFilterProvider.notifier).state =
                        v == 'all' ? null : Slot.values.byName(v),
              ),
              if (over > 0) ...[
                const SizedBox(height: StSpace.sm),
                StNote(
                  tone: StNoteTone.warning,
                  child: Text(s.tx(ForecastText.overCount, ['$over'])),
                ),
                const SizedBox(height: StSpace.xs),
                StBtn(
                  label: s.tx(ForecastText.openCapacity),
                  variant: StBtnVariant.soft,
                  icon: Icons.tune_rounded,
                  onTap: () => stOpen(ref, 'NS-05'),
                ),
              ],
              for (final d in dates) ...[
                const SizedBox(height: StSpace.md),
                StSection(
                  title: s.tx(ForecastText.dayTotal, [
                    d,
                    '${shown.where((r) => r.date == d).fold<int>(0, (a, r) => a + r.portions)}',
                  ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final r in shown.where((r) => r.date == d))
                        _row(context, s, r),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  static Widget _row(BuildContext context, AppState s, ForecastRow r) {
    final ratio = r.capacity <= 0
        ? 1.0
        : (r.portions / r.capacity).clamp(0.0, 1.0);
    final role = context.roleColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: StSpace.xs),
      child: StCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StCatalogueText.meal(s, r.mealId),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: StFont.body,
                        ),
                      ),
                      Text(
                        StCatalogueText.slot(s, r.slot),
                        style: TextStyle(
                          fontSize: StFont.label,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      s.tx(ForecastText.portionsOf, [
                        '${r.portions}',
                        '${r.capacity}',
                      ]),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: StFont.bodyLg,
                      ),
                    ),
                    if (r.overCapacity)
                      StStatusChip(
                        label: s.tx(ForecastText.overCapacity),
                        tone: StTone.danger,
                        icon: Icons.warning_amber_rounded,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: StSpace.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(StRadius.pill),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: StSize.dot,
                color: r.overCapacity ? StColors.danger : role,
                backgroundColor: Theme.of(context).dividerColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
