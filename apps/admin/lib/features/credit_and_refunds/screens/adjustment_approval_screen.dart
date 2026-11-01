import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/credit_and_refunds_providers.dart';
import 'credit_and_refunds_text.dart';

/// NF-16 Financial adjustment approval (`requestAdjustment`,
/// `approveAdjustment`; maker is never checker, INV-02).
class AdjustmentApprovalScreen extends ConsumerStatefulWidget {
  const AdjustmentApprovalScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  ConsumerState<AdjustmentApprovalScreen> createState() =>
      _AdjustmentApprovalScreenState();
}

class _AdjustmentApprovalScreenState
    extends ConsumerState<AdjustmentApprovalScreen> {
  final _description = TextEditingController();
  final _amount = TextEditingController();
  final _evidence = TextEditingController();

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    _evidence.dispose();
    super.dispose();
  }

  Future<void> _request() async {
    final ok = await ref.read(adjustmentFormProvider.notifier).submit();
    if (!ok || !mounted) return;
    _description.clear();
    _amount.clear();
    _evidence.clear();
    ref.read(adjustmentFormProvider.notifier).set((
      description: '',
      amount: '',
      reduces: false,
      evidence: '',
    ));
    ref.invalidate(adjustmentsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final form = ref.watch(adjustmentFormProvider);
    final formCtrl = ref.read(adjustmentFormProvider.notifier);
    final repo = ref.read(adjustmentRepositoryProvider);
    final actor = ref.read(actorProvider);
    String? err(String f) =>
        form.errorFor(f) == null ? null : s.tx(form.errorFor(f)!);
    return StScreen(
      title: s.tx(CreditAndRefundsText.adjTitle),
      eyebrow: s.tx(CreditAndRefundsText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(CreditAndRefundsText.adjIntro))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<Adjustment>>(
            value: ref.watch(adjustmentsProvider),
            supported: AdjustmentApprovalScreen.states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: CreditAndRefundsText.noAdjustments,
            onRetry: () => ref.invalidate(adjustmentsProvider),
            builder: (context, list) => StCommandScope(
              builder: (context, cmd) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final a in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: StSpace.xs),
                      child: StCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${s.digits(a.id)} · ${a.description}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                StMoneyText.minor(
                                  a.amountMinor,
                                  align: Alignment.centerRight,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              s.tx(CreditAndRefundsText.adjMaker, [a.maker]),
                              style: const TextStyle(fontSize: StFont.label),
                            ),
                            if (a.checker != null)
                              Text(
                                s.tx(CreditAndRefundsText.adjChecker, [
                                  a.checker!,
                                ]),
                                style: const TextStyle(fontSize: StFont.label),
                              ),
                            const SizedBox(height: StSpace.xxs),
                            switch (a.status) {
                              AdjustmentStatus.requested => StStatusChip(
                                label: s.tx(CreditAndRefundsText.adjRequested),
                                tone: StTone.warning,
                              ),
                              AdjustmentStatus.approved => StStatusChip(
                                label: s.tx(CreditAndRefundsText.adjApproved),
                                tone: StTone.success,
                              ),
                              AdjustmentStatus.rejected => StStatusChip(
                                label: s.tx(CreditAndRefundsText.adjRejected),
                                tone: StTone.danger,
                              ),
                            },
                            if (a.status == AdjustmentStatus.requested) ...[
                              const SizedBox(height: StSpace.xs),
                              Row(
                                children: [
                                  Expanded(
                                    child: StCommandButton(
                                      label: s.tx(
                                        CreditAndRefundsText.adjApprove,
                                      ),
                                      variant: StBtnVariant.success,
                                      busy: cmd.busy,
                                      disabledReason: a.maker == actor.id
                                          ? s.tx(CreditAndRefundsText.adjSelf)
                                          : null,
                                      onTap: () => cmd.run(
                                        () => repo.approveAdjustment(
                                          actor,
                                          RequestId.next('adj'),
                                          adjustmentId: a.id,
                                          approve: true,
                                        ),
                                        name:
                                            CreditAndRefundsText.adjDecideName,
                                        success: CreditAndRefundsText
                                            .adjApprovedDone,
                                        onSuccess: () =>
                                            ref.invalidate(adjustmentsProvider),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: StSpace.xs),
                                  Expanded(
                                    child: StCommandButton(
                                      label: s.tx(
                                        CreditAndRefundsText.adjReject,
                                      ),
                                      variant: StBtnVariant.danger,
                                      busy: cmd.busy,
                                      disabledReason: a.maker == actor.id
                                          ? s.tx(CreditAndRefundsText.adjSelf)
                                          : null,
                                      onTap: () => cmd.run(
                                        () => repo.approveAdjustment(
                                          actor,
                                          RequestId.next('adj'),
                                          adjustmentId: a.id,
                                          approve: false,
                                        ),
                                        name:
                                            CreditAndRefundsText.adjDecideName,
                                        success: CreditAndRefundsText
                                            .adjRejectedDone,
                                        onSuccess: () =>
                                            ref.invalidate(adjustmentsProvider),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: StSpace.md),
          StSection(
            title: s.tx(CreditAndRefundsText.adjSubmit),
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (form.confirmed) ...[
                    StConfirmation(
                      message: s.tx(CreditAndRefundsText.adjDone),
                      dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
                      onDismissed: formCtrl.dismissConfirmation,
                    ),
                    const SizedBox(height: StSpace.xs),
                  ],
                  if (form.failed && form.errorKind != null) ...[
                    StCommandError(
                      name: CreditAndRefundsText.adjName,
                      kind: form.errorKind!,
                    ),
                    const SizedBox(height: StSpace.xs),
                  ],
                  StField(
                    label: s.tx(CreditAndRefundsText.adjDescription),
                    controller: _description,
                    maxLines: 2,
                    error: err('description'),
                    onChanged: (t) => formCtrl.update(
                      (v) => (
                        description: t,
                        amount: v.amount,
                        reduces: v.reduces,
                        evidence: v.evidence,
                      ),
                    ),
                  ),
                  const SizedBox(height: StSpace.sm),
                  StField(
                    label: s.tx(CreditAndRefundsText.adjAmount),
                    controller: _amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    error: err('amount'),
                    onChanged: (t) => formCtrl.update(
                      (v) => (
                        description: v.description,
                        amount: t,
                        reduces: v.reduces,
                        evidence: v.evidence,
                      ),
                    ),
                  ),
                  StToggle(
                    value: form.values.reduces,
                    label: s.tx(CreditAndRefundsText.adjReduces),
                    onChanged: (on) => formCtrl.update(
                      (v) => (
                        description: v.description,
                        amount: v.amount,
                        reduces: on,
                        evidence: v.evidence,
                      ),
                    ),
                  ),
                  StField(
                    label: s.tx(CreditAndRefundsText.adjEvidence),
                    controller: _evidence,
                    error: err('evidence'),
                    onChanged: (t) => formCtrl.update(
                      (v) => (
                        description: v.description,
                        amount: v.amount,
                        reduces: v.reduces,
                        evidence: t,
                      ),
                    ),
                  ),
                  const SizedBox(height: StSpace.sm),
                  StCommandButton(
                    label: s.tx(CreditAndRefundsText.adjSubmit),
                    icon: Icons.post_add_rounded,
                    busy: form.submitting,
                    onTap: _request,
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
