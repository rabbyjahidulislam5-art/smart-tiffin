import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/handoff_providers.dart';
import 'handoff_text.dart';

/// NS-07 Kitchen pickup handoff (sheet; `recordHandoff`, DEC-014). Built
/// outside a sheet (deep link, test) it renders as a full screen.
class HandoffSheetScreen extends ConsumerStatefulWidget {
  const HandoffSheetScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  ConsumerState<HandoffSheetScreen> createState() => _HandoffSheetScreenState();
}

class _HandoffSheetScreenState extends ConsumerState<HandoffSheetScreen> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final ok = await ref.read(handoffFormProvider.notifier).submit();
    if (!ok || !mounted) return;
    _code.clear();
    ref.read(handoffFormProvider.notifier).set((
      handoffId: '',
      code: '',
      counted: false,
      sealed: false,
    ));
    ref.invalidate(pendingHandoffsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final form = ref.watch(handoffFormProvider);
    final formCtrl = ref.read(handoffFormProvider.notifier);
    final preselect = stParamsOf(context, ref)['id'];
    String? err(String f) =>
        form.errorFor(f) == null ? null : s.tx(form.errorFor(f)!);
    return StSheetOrScreen(
      title: s.tx(HandoffText.title),
      eyebrow: s.tx(HandoffText.eyebrow),
      child: StAsyncView<List<Handoff>>(
        value: ref.watch(pendingHandoffsProvider),
        supported: HandoffSheetScreen.states,
        isEmpty: (list) => list.isEmpty,
        emptyMessage: HandoffText.empty,
        onRetry: () => ref.invalidate(pendingHandoffsProvider),
        builder: (context, list) {
          final selected = form.values.handoffId.isNotEmpty
              ? form.values.handoffId
              : (preselect ?? '');
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StNote(child: Text(s.tx(HandoffText.intro))),
              const SizedBox(height: StSpace.sm),
              for (final h in list)
                _handoffTile(s, h, selected == h.id, formCtrl),
              if (err('handoff') != null)
                Text(
                  err('handoff')!,
                  style: const TextStyle(
                    color: StColors.danger,
                    fontSize: StFont.label,
                  ),
                ),
              const SizedBox(height: StSpace.sm),
              if (form.confirmed) ...[
                StConfirmation(
                  message: s.tx(HandoffText.success),
                  dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
                  onDismissed: formCtrl.dismissConfirmation,
                ),
                const SizedBox(height: StSpace.xs),
              ],
              if (form.failed && form.errorKind != null) ...[
                StCommandError(
                  name: HandoffText.commandName,
                  kind: form.errorKind!,
                ),
                const SizedBox(height: StSpace.xs),
              ],
              StField(
                label: s.tx(HandoffText.code),
                controller: _code,
                keyboardType: TextInputType.number,
                error: err('code'),
                onChanged: (t) => formCtrl.update(
                  (v) => (
                    handoffId: v.handoffId.isEmpty ? selected : v.handoffId,
                    code: t,
                    counted: v.counted,
                    sealed: v.sealed,
                  ),
                ),
              ),
              StToggle(
                value: form.values.counted,
                label: s.tx(HandoffText.counted),
                onChanged: (on) => formCtrl.update(
                  (v) => (
                    handoffId: v.handoffId.isEmpty ? selected : v.handoffId,
                    code: v.code,
                    counted: on,
                    sealed: v.sealed,
                  ),
                ),
              ),
              StToggle(
                value: form.values.sealed,
                label: s.tx(HandoffText.sealed),
                onChanged: (on) => formCtrl.update(
                  (v) => (
                    handoffId: v.handoffId.isEmpty ? selected : v.handoffId,
                    code: v.code,
                    counted: v.counted,
                    sealed: on,
                  ),
                ),
              ),
              if (err('checks') != null)
                Text(
                  err('checks')!,
                  style: const TextStyle(
                    color: StColors.danger,
                    fontSize: StFont.label,
                  ),
                ),
              const SizedBox(height: StSpace.sm),
              StCommandButton(
                label: s.tx(HandoffText.confirm),
                icon: Icons.handshake_outlined,
                busy: form.submitting,
                onTap: _confirm,
              ),
              const SizedBox(height: StSpace.xs),
              StBtn(
                label: s.tx(HandoffText.report),
                variant: StBtnVariant.outline,
                icon: Icons.report_outlined,
                disabled: true,
                reason: s.tx(HandoffText.reportGap),
              ),
              const SizedBox(height: StSpace.sm),
              StNote(
                tone: StNoteTone.policy,
                child: Text(s.tx(HandoffText.noEffect)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _handoffTile(
    AppState s,
    Handoff h,
    bool selected,
    StFormController<HandoffValues> formCtrl,
  ) {
    final ready = h.status == HandoffStatus.ready;
    final (tone, label) = switch (h.status) {
      HandoffStatus.ready => (StTone.info, HandoffText.ready),
      HandoffStatus.handedOff => (StTone.success, HandoffText.handedOff),
      HandoffStatus.exception => (StTone.danger, HandoffText.exception),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: StSpace.xs),
      child: StCard(
        key: ValueKey('handoff-${h.id}'),
        color: selected ? context.roleColor.withValues(alpha: 0.08) : null,
        onTap: ready
            ? () => formCtrl.update(
                (v) => (
                  handoffId: h.id,
                  code: v.code,
                  counted: v.counted,
                  sealed: v.sealed,
                ),
              )
            : null,
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: ready
                  ? context.roleColor
                  : Theme.of(context).disabledColor,
            ),
            const SizedBox(width: StSpace.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.digits(h.orderRef),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    s.tx(HandoffText.rider, [h.riderName, h.vehicle]),
                    style: const TextStyle(fontSize: StFont.label),
                  ),
                  Text(
                    s.tx(HandoffText.items, ['${h.items}']),
                    style: const TextStyle(fontSize: StFont.label),
                  ),
                ],
              ),
            ),
            StStatusChip(label: s.tx(label), tone: tone),
          ],
        ),
      ),
    );
  }
}
