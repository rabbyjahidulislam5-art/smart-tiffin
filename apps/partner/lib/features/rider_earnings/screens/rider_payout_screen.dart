import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../../cod_collection/controllers/cod_providers.dart';
import '../controllers/rider_earnings_providers.dart';
import 'rider_earnings_text.dart';

/// NR-02 Rider payout request: eligible balance only, COD liability shown
/// separately and never netted (BR-026).
class RiderPayoutScreen extends ConsumerStatefulWidget {
  const RiderPayoutScreen({super.key});

  static const states = {StVariant.loading, StVariant.error, StVariant.offline};

  @override
  ConsumerState<RiderPayoutScreen> createState() => _RiderPayoutScreenState();
}

class _RiderPayoutScreenState extends ConsumerState<RiderPayoutScreen> {
  final _amount = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref.read(riderPayoutFormProvider.notifier).submit();
    if (!ok || !mounted) return;
    _amount.clear();
    ref
        .read(riderPayoutFormProvider.notifier)
        .update((v) => (amount: '', confirmed: v.confirmed));
    ref.invalidate(riderEligibleBalanceProvider);
    ref.read(riderPayoutHistoryProvider.notifier).reload();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final form = ref.watch(riderPayoutFormProvider);
    final formCtrl = ref.read(riderPayoutFormProvider.notifier);
    final amountError = form.errorFor('amount');
    final confirmError = form.errorFor('confirmed');
    final cod = ref.watch(codLiabilityProvider).valueOrNull;
    return StScreen(
      title: s.tx(RiderEarningsText.payoutTitle),
      eyebrow: s.tx(RiderEarningsText.eyebrow),
      child: StAsyncView<EligibleBalance>(
        value: ref.watch(riderEligibleBalanceProvider),
        supported: RiderPayoutScreen.states,
        onRetry: () => ref.invalidate(riderEligibleBalanceProvider),
        builder: (context, b) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StKpiGrid(
              children: [
                StMoneyStat(
                  label: s.tx(RiderEarningsText.eligible),
                  minor: b.eligibleMinor,
                  icon: Icons.account_balance_wallet_outlined,
                  tone: StColors.success,
                ),
                StMoneyStat(
                  label: s.tx(RiderEarningsText.pending),
                  minor: b.pendingMinor,
                  icon: Icons.schedule_rounded,
                ),
                if (cod != null)
                  StMoneyStat(
                    label: s.tx(RiderEarningsText.codTitle),
                    minor: cod,
                    icon: Icons.local_atm_rounded,
                    tone: StColors.warning,
                    caption: s.tx(RiderEarningsText.codNote),
                  ),
              ],
            ),
            const SizedBox(height: StSpace.sm),
            StNote(
              tone: StNoteTone.policy,
              child: Text(s.tx(RiderEarningsText.payoutNote)),
            ),
            const SizedBox(height: StSpace.md),
            if (form.confirmed) ...[
              StConfirmation(
                message: s.tx(RiderEarningsText.success),
                dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
                onDismissed: formCtrl.dismissConfirmation,
              ),
              const SizedBox(height: StSpace.sm),
            ],
            if (form.failed && form.errorKind != null) ...[
              StCommandError(
                name: RiderEarningsText.commandName,
                kind: form.errorKind!,
              ),
              const SizedBox(height: StSpace.sm),
            ],
            StField(
              label: s.tx(RiderEarningsText.amountLabel),
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              error: amountError == null ? null : s.tx(amountError),
              onChanged: (t) =>
                  formCtrl.update((v) => (amount: t, confirmed: v.confirmed)),
            ),
            const SizedBox(height: StSpace.sm),
            StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StInfoRow(
                    label: s.tx(RiderEarningsText.destination),
                    value: s.digits(b.destination),
                  ),
                  StToggle(
                    value: form.values.confirmed,
                    label: s.tx(RiderEarningsText.confirmDestination),
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
              label: s.tx(RiderEarningsText.submit),
              icon: Icons.send_rounded,
              busy: form.submitting,
              onTap: _submit,
            ),
            const SizedBox(height: StSpace.md),
            StSection(
              title: s.tx(RiderEarningsText.recent),
              child: StAsyncView<StPagedList<PayoutRecord>>(
                value: ref.watch(riderPayoutHistoryProvider),
                supported: const {
                  StVariant.loading,
                  StVariant.error,
                  StVariant.empty,
                },
                isEmpty: (l) => l.isEmpty,
                emptyMessage: RiderEarningsText.noRequests,
                onRetry: ref.read(riderPayoutHistoryProvider.notifier).reload,
                builder: (context, list) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StFinTable<PayoutRecord>(
                      rows: list.items,
                      idLabel: RiderEarningsText.colRequest,
                      idOf: (r) => r.id,
                      subtitleOf: (r) => s.digits(r.requestedOn),
                      amountMinorOf: (r) => r.amountMinor,
                      statusOf: (r) => StPayoutStatusChip(status: r.status),
                    ),
                    StLoadMore<PayoutRecord>(
                      list: list,
                      onMore: ref
                          .read(riderPayoutHistoryProvider.notifier)
                          .loadMore,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
