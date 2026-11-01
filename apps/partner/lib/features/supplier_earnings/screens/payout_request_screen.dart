import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/supplier_earnings_providers.dart';
import 'supplier_earnings_text.dart';

/// NS-02 Supplier payout request (`requestPayout`, INV-14): an amount up to
/// the eligible balance, sent only to the approved destination.
class PayoutRequestScreen extends ConsumerStatefulWidget {
  const PayoutRequestScreen({super.key});

  static const states = {StVariant.loading, StVariant.error, StVariant.offline};

  @override
  ConsumerState<PayoutRequestScreen> createState() =>
      _PayoutRequestScreenState();
}

class _PayoutRequestScreenState extends ConsumerState<PayoutRequestScreen> {
  final _amount = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref.read(supplierPayoutFormProvider.notifier).submit();
    if (!ok || !mounted) return;
    _amount.clear();
    ref
        .read(supplierPayoutFormProvider.notifier)
        .update((v) => (amount: '', confirmed: v.confirmed));
    ref.invalidate(supplierEligibleBalanceProvider);
    ref.invalidate(supplierPayoutHistoryProvider);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final form = ref.watch(supplierPayoutFormProvider);
    final formCtrl = ref.read(supplierPayoutFormProvider.notifier);
    final amountError = form.errorFor('amount');
    final confirmError = form.errorFor('confirmed');
    return StScreen(
      title: s.tx(SupplierEarningsText.requestTitle),
      eyebrow: s.tx(SupplierEarningsText.eyebrow),
      child: StAsyncView<EligibleBalance>(
        value: ref.watch(supplierEligibleBalanceProvider),
        supported: PayoutRequestScreen.states,
        onRetry: () => ref.invalidate(supplierEligibleBalanceProvider),
        builder: (context, b) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StKpiGrid(
              children: [
                StMoneyStat(
                  label: s.tx(SupplierEarningsText.eligible),
                  minor: b.eligibleMinor,
                  icon: Icons.account_balance_wallet_outlined,
                  tone: StColors.success,
                ),
                StMoneyStat(
                  label: s.tx(SupplierEarningsText.held),
                  minor: b.heldMinor,
                  icon: Icons.pause_circle_outline_rounded,
                  tone: StColors.warning,
                ),
                StMoneyStat(
                  label: s.tx(SupplierEarningsText.pending),
                  minor: b.pendingMinor,
                  icon: Icons.schedule_rounded,
                ),
              ],
            ),
            const SizedBox(height: StSpace.sm),
            StNote(child: Text(s.tx(SupplierEarningsText.requestNote))),
            const SizedBox(height: StSpace.md),
            if (form.confirmed) ...[
              StConfirmation(
                message: s.tx(SupplierEarningsText.success),
                dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
                onDismissed: formCtrl.dismissConfirmation,
              ),
              const SizedBox(height: StSpace.sm),
            ],
            if (form.failed && form.errorKind != null) ...[
              StCommandError(
                name: SupplierEarningsText.commandName,
                kind: form.errorKind!,
              ),
              const SizedBox(height: StSpace.sm),
            ],
            StField(
              label: s.tx(SupplierEarningsText.amountLabel),
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              error: amountError == null ? null : s.tx(amountError),
              onChanged: (text) => formCtrl.update(
                (v) => (amount: text, confirmed: v.confirmed),
              ),
            ),
            const SizedBox(height: StSpace.sm),
            StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StInfoRow(
                    label: s.tx(SupplierEarningsText.destination),
                    value: s.digits(b.destination),
                  ),
                  StToggle(
                    value: form.values.confirmed,
                    label: s.tx(SupplierEarningsText.confirmDestination),
                    onChanged: (on) => formCtrl.update(
                      (v) => (amount: v.amount, confirmed: on),
                    ),
                  ),
                  if (confirmError != null)
                    Text(
                      s.tx(confirmError),
                      style: const TextStyle(
                        color: StColors.danger,
                        fontSize: StFont.label,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: StSpace.md),
            StCommandButton(
              label: s.tx(SupplierEarningsText.submit),
              icon: Icons.send_rounded,
              busy: form.submitting,
              onTap: _submit,
            ),
            const SizedBox(height: StSpace.sm),
            StNote(
              tone: StNoteTone.policy,
              child: Text(s.tx(SupplierEarningsText.notPaidNote)),
            ),
            const SizedBox(height: StSpace.xs),
            StBtn(
              label: s.tx(SupplierEarningsText.payoutHistory),
              variant: StBtnVariant.ghost,
              icon: Icons.history_rounded,
              onTap: () => stOpen(ref, 'NS-03'),
            ),
          ],
        ),
      ),
    );
  }
}
