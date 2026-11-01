import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/capacity_providers.dart';
import 'capacity_text.dart';

/// NS-05 Kitchen capacity scheduler (S-04 extension): daily limit and
/// availability per slot (`saveCapacity`, `setSlotAvailability`, BR-022).
class CapacitySectionScreen extends ConsumerStatefulWidget {
  const CapacitySectionScreen({super.key});

  static const states = {StVariant.loading, StVariant.error, StVariant.offline};

  @override
  ConsumerState<CapacitySectionScreen> createState() =>
      _CapacitySectionScreenState();
}

class _CapacitySectionScreenState extends ConsumerState<CapacitySectionScreen> {
  final Map<Slot, TextEditingController> _fields = {};

  TextEditingController _field(Slot slot) =>
      _fields.putIfAbsent(slot, TextEditingController.new);

  @override
  void dispose() {
    for (final c in _fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save(Slot slot) async {
    final ok = await ref.read(capacityFormProvider(slot).notifier).submit();
    if (!ok || !mounted) return;
    _field(slot).clear();
    ref.invalidate(capacityProvider);
  }

  Future<void> _setOpen(Slot slot, bool open) async {
    final form = ref.read(slotAvailabilityFormProvider(slot).notifier)
      ..set(open);
    final ok = await form.submit();
    if (ok && mounted) ref.invalidate(capacityProvider);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    return StScreen(
      title: s.tx(CapacityText.title),
      eyebrow: s.tx(CapacityText.eyebrow),
      child: StAsyncView<List<CapacityRule>>(
        value: ref.watch(capacityProvider),
        supported: CapacitySectionScreen.states,
        onRetry: () => ref.invalidate(capacityProvider),
        builder: (context, rules) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StNote(child: Text(s.tx(CapacityText.intro))),
            const SizedBox(height: StSpace.sm),
            for (final rule in rules) ...[
              _slotCard(context, s, rule),
              const SizedBox(height: StSpace.sm),
            ],
            StNote(
              tone: StNoteTone.policy,
              child: Text(s.tx(CapacityText.cutoffNote)),
            ),
            const SizedBox(height: StSpace.xs),
            StNote(child: Text(s.tx(CapacityText.informed))),
            const SizedBox(height: StSpace.sm),
            StBtn(
              label: s.tx(CapacityText.addClosure),
              variant: StBtnVariant.outline,
              icon: Icons.event_busy_rounded,
              disabled: true,
              reason: s.tx(CapacityText.closuresGap),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slotCard(BuildContext context, AppState s, CapacityRule rule) {
    final form = ref.watch(capacityFormProvider(rule.slot));
    final formCtrl = ref.read(capacityFormProvider(rule.slot).notifier);
    final open = ref.watch(slotAvailabilityFormProvider(rule.slot));
    final error = form.errorFor('max');
    final (tone, label) = !rule.open
        ? (StTone.muted, CapacityText.closed)
        : rule.full
        ? (StTone.danger, CapacityText.full)
        : (StTone.success, CapacityText.open);
    return StCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  StCatalogueText.slot(s, rule.slot),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: StFont.bodyLg,
                  ),
                ),
              ),
              StStatusChip(
                label: s.tx(label),
                tone: tone,
                icon: rule.open ? Icons.check_circle_outline : Icons.block,
              ),
            ],
          ),
          const SizedBox(height: StSpace.xxs),
          Text(s.tx(CapacityText.committed, ['${rule.committed}'])),
          Text(
            s.tx(CapacityText.currentMax, ['${rule.maxPortions}']),
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: StFont.label,
            ),
          ),
          const SizedBox(height: StSpace.sm),
          if (form.confirmed) ...[
            StConfirmation(
              message: s.tx(CapacityText.saved),
              dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
              onDismissed: formCtrl.dismissConfirmation,
            ),
            const SizedBox(height: StSpace.xs),
          ],
          if (form.failed && form.errorKind != null) ...[
            StCommandError(name: CapacityText.saveName, kind: form.errorKind!),
            const SizedBox(height: StSpace.xs),
          ],
          StField(
            label: s.tx(CapacityText.newMax),
            controller: _field(rule.slot),
            placeholder: s.digits('${rule.maxPortions}'),
            keyboardType: TextInputType.number,
            error: error == null ? null : s.tx(error, ['${rule.committed}']),
            onChanged: formCtrl.set,
          ),
          const SizedBox(height: StSpace.xs),
          StCommandButton(
            label: s.tx(CapacityText.save),
            icon: Icons.save_outlined,
            busy: form.submitting,
            onTap: () => _save(rule.slot),
          ),
          const SizedBox(height: StSpace.xs),
          if (open.failed && open.errorKind != null) ...[
            StCommandError(
              name: CapacityText.availabilityName,
              kind: open.errorKind!,
            ),
            const SizedBox(height: StSpace.xs),
          ],
          StNeedsConnection(
            builder: (context, enabled, reason) => StToggle(
              value: rule.open,
              label: s.tx(CapacityText.open),
              onChanged: (v) {
                if (enabled && !open.submitting) _setOpen(rule.slot, v);
              },
            ),
          ),
        ],
      ),
    );
  }
}
