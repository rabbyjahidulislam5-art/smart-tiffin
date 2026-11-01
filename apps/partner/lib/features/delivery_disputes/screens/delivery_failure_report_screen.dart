import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/delivery_dispute_providers.dart';
import 'delivery_dispute_text.dart';

/// NR-06 Rider delivery dispute (SC-21): report a no-show, accident or failed
/// delivery (`reportDeliveryFailure`); it never becomes Delivered.
class DeliveryFailureReportScreen extends ConsumerStatefulWidget {
  const DeliveryFailureReportScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static const kinds = <DeliveryFailureKind, StText>{
    DeliveryFailureKind.noShow: DeliveryDisputeText.noShow,
    DeliveryFailureKind.accident: DeliveryDisputeText.accident,
    DeliveryFailureKind.failed: DeliveryDisputeText.failed,
  };

  @override
  ConsumerState<DeliveryFailureReportScreen> createState() =>
      _DeliveryFailureReportScreenState();
}

class _DeliveryFailureReportScreenState
    extends ConsumerState<DeliveryFailureReportScreen> {
  final _delivery = TextEditingController();
  final _note = TextEditingController();
  bool _seeded = false;

  @override
  void dispose() {
    _delivery.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref.read(deliveryFailureFormProvider.notifier).submit();
    if (!ok || !mounted) return;
    _note.clear();
    ref
        .read(deliveryFailureFormProvider.notifier)
        .update((v) => (delivery: v.delivery, kind: v.kind, note: ''));
    ref.invalidate(deliveryReportsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final form = ref.watch(deliveryFailureFormProvider);
    final formCtrl = ref.read(deliveryFailureFormProvider.notifier);
    final seed = stParamsOf(context, ref)['delivery'];
    if (!_seeded && seed != null) {
      _seeded = true;
      _delivery.text = seed;
      Future.microtask(
        () => formCtrl.update(
          (v) => (delivery: seed, kind: v.kind, note: v.note),
        ),
      );
    }
    String? err(String f) =>
        form.errorFor(f) == null ? null : s.tx(form.errorFor(f)!);
    return StScreen(
      title: s.tx(DeliveryDisputeText.title),
      eyebrow: s.tx(DeliveryDisputeText.eyebrow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(
            tone: StNoteTone.policy,
            child: Text(s.tx(DeliveryDisputeText.policy)),
          ),
          const SizedBox(height: StSpace.sm),
          StCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (form.confirmed) ...[
                  StConfirmation(
                    message: s.tx(DeliveryDisputeText.success),
                    dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
                    onDismissed: formCtrl.dismissConfirmation,
                  ),
                  const SizedBox(height: StSpace.xs),
                ],
                if (form.failed && form.errorKind != null) ...[
                  StCommandError(
                    name: DeliveryDisputeText.commandName,
                    kind: form.errorKind!,
                  ),
                  const SizedBox(height: StSpace.xs),
                ],
                StField(
                  label: s.tx(DeliveryDisputeText.delivery),
                  controller: _delivery,
                  placeholder: 'DL-913',
                  error: err('delivery'),
                  onChanged: (t) => formCtrl.update(
                    (v) => (delivery: t, kind: v.kind, note: v.note),
                  ),
                ),
                const SizedBox(height: StSpace.sm),
                Text(
                  s.tx(DeliveryDisputeText.kind),
                  style: const TextStyle(
                    fontSize: StFont.label,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: StSpace.gap6),
                StChipRow(
                  options: [
                    for (final e in DeliveryFailureReportScreen.kinds.entries)
                      (v: e.key.name, l: s.tx(e.value)),
                  ],
                  value: form.values.kind?.name ?? '',
                  onChanged: (k) => formCtrl.update(
                    (v) => (
                      delivery: v.delivery,
                      kind: DeliveryFailureKind.values.byName(k),
                      note: v.note,
                    ),
                  ),
                ),
                if (err('kind') != null)
                  Text(
                    err('kind')!,
                    style: const TextStyle(
                      color: StColors.danger,
                      fontSize: StFont.label,
                    ),
                  ),
                const SizedBox(height: StSpace.sm),
                StField(
                  label: s.tx(DeliveryDisputeText.note),
                  controller: _note,
                  maxLines: 3,
                  error: err('note'),
                  onChanged: (t) => formCtrl.update(
                    (v) => (delivery: v.delivery, kind: v.kind, note: t),
                  ),
                ),
                const SizedBox(height: StSpace.sm),
                StCommandButton(
                  label: s.tx(DeliveryDisputeText.submit),
                  icon: Icons.flag_rounded,
                  busy: form.submitting,
                  onTap: _submit,
                ),
                const SizedBox(height: StSpace.xs),
                StBtn(
                  label: s.tx(DeliveryDisputeText.sos),
                  variant: StBtnVariant.danger,
                  icon: Icons.emergency_outlined,
                  onTap: () => stOpen(ref, 'R-05'),
                ),
              ],
            ),
          ),
          const SizedBox(height: StSpace.md),
          StSection(
            title: s.tx(DeliveryDisputeText.history),
            child: StAsyncView<List<DeliveryFailureReport>>(
              value: ref.watch(deliveryReportsProvider),
              supported: DeliveryFailureReportScreen.states,
              isEmpty: (l) => l.isEmpty,
              emptyMessage: DeliveryDisputeText.noReports,
              onRetry: () => ref.invalidate(deliveryReportsProvider),
              builder: (context, list) => StList(
                children: [
                  for (final r in list)
                    StRowTile(
                      icon: Icons.flag_outlined,
                      label:
                          '${s.digits(r.deliveryRef)} · ${s.tx(DeliveryFailureReportScreen.kinds[r.kind]!)}',
                      sub: '${s.digits(r.reportedOn)} · ${r.note}',
                      right: StStatusChip(
                        label: s.tx(
                          r.underReview
                              ? DeliveryDisputeText.underReview
                              : DeliveryDisputeText.reviewed,
                        ),
                        tone: r.underReview ? StTone.info : StTone.success,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
