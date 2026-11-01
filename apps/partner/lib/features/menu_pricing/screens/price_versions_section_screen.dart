import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/menu_pricing_providers.dart';
import 'menu_pricing_text.dart';

/// NS-06 Menu price and version manager (S-05 extension): effective-dated
/// price versions and a schedule-change form (`schedulePriceChange`, ADR-009).
class PriceVersionsSectionScreen extends ConsumerStatefulWidget {
  const PriceVersionsSectionScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  ConsumerState<PriceVersionsSectionScreen> createState() =>
      _PriceVersionsSectionScreenState();
}

class _PriceVersionsSectionScreenState
    extends ConsumerState<PriceVersionsSectionScreen> {
  final _amount = TextEditingController();
  final _date = TextEditingController();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _date.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref.read(priceChangeFormProvider.notifier).submit();
    if (!ok || !mounted) return;
    _amount.clear();
    _date.clear();
    _reason.clear();
    ref
        .read(priceChangeFormProvider.notifier)
        .update(
          (v) => (mealId: v.mealId, amount: '', effectiveFrom: '', reason: ''),
        );
    ref.invalidate(priceVersionsProvider);
  }

  static StText _statusText(PriceVersionStatus st) => switch (st) {
    PriceVersionStatus.active => MenuPricingText.statusActive,
    PriceVersionStatus.scheduled => MenuPricingText.statusScheduled,
    PriceVersionStatus.superseded => MenuPricingText.statusSuperseded,
    PriceVersionStatus.cancelled => MenuPricingText.statusCancelled,
  };

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final form = ref.watch(priceChangeFormProvider);
    final formCtrl = ref.read(priceChangeFormProvider.notifier);
    String? err(String field) =>
        form.errorFor(field) == null ? null : s.tx(form.errorFor(field)!);
    return StScreen(
      title: s.tx(MenuPricingText.title),
      eyebrow: s.tx(MenuPricingText.eyebrow),
      child: StAsyncView<List<PriceVersion>>(
        value: ref.watch(priceVersionsProvider),
        supported: PriceVersionsSectionScreen.states,
        isEmpty: (v) => v.isEmpty,
        emptyMessage: MenuPricingText.empty,
        onRetry: () => ref.invalidate(priceVersionsProvider),
        builder: (context, versions) {
          final mealIds = <String>[];
          for (final v in versions) {
            if (!mealIds.contains(v.mealId)) mealIds.add(v.mealId);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StNote(child: Text(s.tx(MenuPricingText.snapshotNote))),
              const SizedBox(height: StSpace.md),
              for (final mealId in mealIds)
                StSection(
                  title: StCatalogueText.meal(s, mealId),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final v in versions.where((v) => v.mealId == mealId))
                        _versionCard(context, s, v),
                    ],
                  ),
                ),
              const SizedBox(height: StSpace.md),
              StSection(
                title: s.tx(MenuPricingText.schedule),
                child: StCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (form.confirmed) ...[
                        StConfirmation(
                          message: s.tx(MenuPricingText.success),
                          dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
                          onDismissed: formCtrl.dismissConfirmation,
                        ),
                        const SizedBox(height: StSpace.xs),
                      ],
                      if (form.failed && form.errorKind != null) ...[
                        StCommandError(
                          name: MenuPricingText.commandName,
                          kind: form.errorKind!,
                        ),
                        const SizedBox(height: StSpace.xs),
                      ],
                      Text(
                        s.tx(MenuPricingText.meal),
                        style: const TextStyle(
                          fontSize: StFont.label,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: StSpace.gap6),
                      StChipRow(
                        options: [
                          for (final id in mealIds)
                            (v: id, l: StCatalogueText.meal(s, id)),
                        ],
                        value: form.values.mealId,
                        onChanged: (id) => formCtrl.update(
                          (v) => (
                            mealId: id,
                            amount: v.amount,
                            effectiveFrom: v.effectiveFrom,
                            reason: v.reason,
                          ),
                        ),
                      ),
                      if (err('meal') != null)
                        Text(
                          err('meal')!,
                          style: const TextStyle(
                            color: StColors.danger,
                            fontSize: StFont.label,
                          ),
                        ),
                      const SizedBox(height: StSpace.sm),
                      StField(
                        label: s.tx(MenuPricingText.newPrice),
                        controller: _amount,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        error: err('amount'),
                        onChanged: (t) => formCtrl.update(
                          (v) => (
                            mealId: v.mealId,
                            amount: t,
                            effectiveFrom: v.effectiveFrom,
                            reason: v.reason,
                          ),
                        ),
                      ),
                      const SizedBox(height: StSpace.sm),
                      StField(
                        label: s.tx(MenuPricingText.date),
                        controller: _date,
                        keyboardType: TextInputType.datetime,
                        error: err('effectiveFrom'),
                        onChanged: (t) => formCtrl.update(
                          (v) => (
                            mealId: v.mealId,
                            amount: v.amount,
                            effectiveFrom: t,
                            reason: v.reason,
                          ),
                        ),
                      ),
                      const SizedBox(height: StSpace.sm),
                      StField(
                        label: s.tx(MenuPricingText.reason),
                        controller: _reason,
                        maxLines: 2,
                        error: err('reason'),
                        onChanged: (t) => formCtrl.update(
                          (v) => (
                            mealId: v.mealId,
                            amount: v.amount,
                            effectiveFrom: v.effectiveFrom,
                            reason: t,
                          ),
                        ),
                      ),
                      const SizedBox(height: StSpace.sm),
                      StNote(
                        tone: StNoteTone.policy,
                        child: Text(s.tx(MenuPricingText.noticePolicy)),
                      ),
                      const SizedBox(height: StSpace.sm),
                      StCommandButton(
                        label: s.tx(MenuPricingText.submit),
                        icon: Icons.event_rounded,
                        busy: form.submitting,
                        onTap: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _versionCard(BuildContext context, AppState s, PriceVersion v) {
    final (tone, icon) = switch (v.status) {
      PriceVersionStatus.active => (StTone.success, Icons.check_circle_outline),
      PriceVersionStatus.scheduled => (StTone.info, Icons.schedule_rounded),
      PriceVersionStatus.superseded => (StTone.muted, Icons.history_rounded),
      PriceVersionStatus.cancelled => (StTone.danger, Icons.cancel_outlined),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: StSpace.xs),
      child: StCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: StMoneyText.minor(
                    v.amountMinor,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: StFont.bodyLg,
                    ),
                  ),
                ),
                StStatusChip(
                  label: s.tx(_statusText(v.status)),
                  tone: tone,
                  icon: icon,
                ),
              ],
            ),
            Text(s.tx(MenuPricingText.effectiveFrom, [v.effectiveFrom])),
            Text(
              s.tx(MenuPricingText.byAuthor, [v.author, v.reason]),
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: StFont.label,
              ),
            ),
            if (v.boundCommitments > 0)
              Text(
                s.tx(MenuPricingText.bound, ['${v.boundCommitments}']),
                style: const TextStyle(fontSize: StFont.label),
              ),
            if (v.status == PriceVersionStatus.scheduled) ...[
              const SizedBox(height: StSpace.xs),
              StBtn(
                label: s.tx(MenuPricingText.cancel),
                variant: StBtnVariant.outline,
                size: StBtnSize.sm,
                disabled: true,
                reason: s.tx(MenuPricingText.cancelGap),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
