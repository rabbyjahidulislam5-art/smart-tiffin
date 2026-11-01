import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/cod_providers.dart';
import 'cod_text.dart';

/// NR-04 COD remittance submission (`submitCodRemittance`, INV-12): deposit
/// evidence with a unique reference; partial deposits reduce the liability.
class CodRemittanceScreen extends ConsumerStatefulWidget {
  const CodRemittanceScreen({super.key});

  static const states = {StVariant.loading, StVariant.error, StVariant.offline};

  static StText remittanceStatus(RemittanceStatus st) => switch (st) {
    RemittanceStatus.submitted => CodText.statusSubmitted,
    RemittanceStatus.partial => CodText.statusPartial,
    RemittanceStatus.verified => CodText.statusVerified,
    RemittanceStatus.rejected => CodText.statusRejected,
  };

  @override
  ConsumerState<CodRemittanceScreen> createState() =>
      _CodRemittanceScreenState();
}

class _CodRemittanceScreenState extends ConsumerState<CodRemittanceScreen> {
  final _amount = TextEditingController();
  final _reference = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref.read(codRemittanceFormProvider.notifier).submit();
    if (!ok || !mounted) return;
    _amount.clear();
    _reference.clear();
    ref
        .read(codRemittanceFormProvider.notifier)
        .update((v) => (amount: '', method: v.method, reference: ''));
    ref.invalidate(codLiabilityProvider);
    ref.invalidate(codRemittancesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final form = ref.watch(codRemittanceFormProvider);
    final formCtrl = ref.read(codRemittanceFormProvider.notifier);
    String? err(String f) =>
        form.errorFor(f) == null ? null : s.tx(form.errorFor(f)!);
    return StScreen(
      title: s.tx(CodText.remitTitle),
      eyebrow: s.tx(CodText.eyebrow),
      child: StAsyncView<int>(
        value: ref.watch(codLiabilityProvider),
        supported: CodRemittanceScreen.states,
        onRetry: () => ref.invalidate(codLiabilityProvider),
        builder: (context, liability) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StMoneyStat(
              label: s.tx(CodText.liability),
              minor: liability,
              icon: Icons.local_atm_rounded,
              tone: StColors.warning,
            ),
            const SizedBox(height: StSpace.xs),
            StNote(child: Text(s.tx(CodText.liabilityNote))),
            const SizedBox(height: StSpace.md),
            StSection(
              title: s.tx(CodText.collected),
              child: StAsyncView<List<CodCollection>>(
                value: ref.watch(codCollectionsProvider),
                supported: const {StVariant.loading, StVariant.error},
                onRetry: () => ref.invalidate(codCollectionsProvider),
                builder: (context, list) => StFinTable<CodCollection>(
                  rows: [
                    for (final c in list)
                      if (c.status == CodStatus.collected) c,
                  ],
                  idLabel: CodText.collected,
                  idOf: (c) => c.orderRef,
                  subtitleOf: (c) => c.customerRef,
                  amountMinorOf: (c) => c.collectedMinor ?? 0,
                  statusOf: (c) => StStatusChip(
                    label: s.tx(CodText.liability),
                    tone: StTone.warning,
                    icon: Icons.schedule_rounded,
                  ),
                ),
              ),
            ),
            const SizedBox(height: StSpace.md),
            StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (form.confirmed) ...[
                    StConfirmation(
                      message: s.tx(CodText.submitted),
                      dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
                      onDismissed: formCtrl.dismissConfirmation,
                    ),
                    const SizedBox(height: StSpace.xs),
                  ],
                  if (form.failed && form.errorKind != null) ...[
                    StCommandError(
                      name: CodText.submitName,
                      kind: form.errorKind!,
                    ),
                    const SizedBox(height: StSpace.xs),
                  ],
                  StField(
                    label: s.tx(CodText.amountLabel),
                    controller: _amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    error: err('amount'),
                    onChanged: (t) => formCtrl.update(
                      (v) =>
                          (amount: t, method: v.method, reference: v.reference),
                    ),
                  ),
                  const SizedBox(height: StSpace.sm),
                  Text(
                    s.tx(CodText.method),
                    style: const TextStyle(
                      fontSize: StFont.label,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: StSpace.gap6),
                  StSegmented(
                    options: [
                      (v: 'Bank deposit', l: s.tx(CodText.bank)),
                      (v: 'bKash transfer', l: s.tx(CodText.bkash)),
                    ],
                    value: form.values.method,
                    onChanged: (m) => formCtrl.update(
                      (v) =>
                          (amount: v.amount, method: m, reference: v.reference),
                    ),
                  ),
                  const SizedBox(height: StSpace.sm),
                  StField(
                    label: s.tx(CodText.reference),
                    controller: _reference,
                    error: err('reference'),
                    onChanged: (t) => formCtrl.update(
                      (v) => (amount: v.amount, method: v.method, reference: t),
                    ),
                  ),
                  const SizedBox(height: StSpace.sm),
                  StCommandButton(
                    label: s.tx(CodText.submit),
                    icon: Icons.upload_rounded,
                    busy: form.submitting,
                    onTap: _submit,
                  ),
                ],
              ),
            ),
            const SizedBox(height: StSpace.md),
            StSection(
              title: s.tx(CodText.deposits),
              child: StAsyncView<List<CodRemittance>>(
                value: ref.watch(codRemittancesProvider),
                supported: const {
                  StVariant.loading,
                  StVariant.error,
                  StVariant.empty,
                },
                isEmpty: (l) => l.isEmpty,
                emptyMessage: CodText.noDeposits,
                onRetry: () => ref.invalidate(codRemittancesProvider),
                builder: (context, list) => StFinTable<CodRemittance>(
                  rows: list,
                  idLabel: CodText.reference,
                  idOf: (r) => r.reference,
                  subtitleOf: (r) => '${s.digits(r.submittedOn)} · ${r.method}',
                  amountMinorOf: (r) => r.amountMinor,
                  statusOf: (r) => StStatusChip(
                    label: s.tx(CodRemittanceScreen.remittanceStatus(r.status)),
                    tone: switch (r.status) {
                      RemittanceStatus.verified => StTone.success,
                      RemittanceStatus.rejected => StTone.danger,
                      RemittanceStatus.partial => StTone.warning,
                      RemittanceStatus.submitted => StTone.info,
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: StSpace.sm),
            StBtn(
              label: s.tx(CodText.discrepancies),
              variant: StBtnVariant.ghost,
              icon: Icons.rule_rounded,
              onTap: () => stOpen(ref, 'NR-05'),
            ),
          ],
        ),
      ),
    );
  }
}
