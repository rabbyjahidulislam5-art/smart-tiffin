import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../../cod_collection/controllers/cod_providers.dart';
import '../controllers/rider_earnings_providers.dart';
import 'rider_earnings_text.dart';

/// NR-01 Rider earning ledger: per-delivery expected, confirmed, held, paid
/// and reversed amounts, shown next to (never combined with) the COD cash.
class RiderEarningsOverviewScreen extends ConsumerWidget {
  const RiderEarningsOverviewScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static const _statusText = <RiderEarningStatus, StText>{
    RiderEarningStatus.expected: RiderEarningsText.expected,
    RiderEarningStatus.confirmed: RiderEarningsText.confirmed,
    RiderEarningStatus.held: RiderEarningsText.held,
    RiderEarningStatus.paid: RiderEarningsText.paid,
    RiderEarningStatus.reversed: RiderEarningsText.reversed,
  };

  static Widget statusChip(AppState s, RiderEarningStatus st) {
    final (tone, icon) = switch (st) {
      RiderEarningStatus.expected => (StTone.muted, Icons.schedule_rounded),
      RiderEarningStatus.confirmed => (StTone.role, Icons.task_alt_rounded),
      RiderEarningStatus.held => (
        StTone.warning,
        Icons.pause_circle_outline_rounded,
      ),
      RiderEarningStatus.paid => (StTone.success, Icons.check_circle_rounded),
      RiderEarningStatus.reversed => (StTone.danger, Icons.undo_rounded),
    };
    return StStatusChip(label: s.tx(_statusText[st]!), tone: tone, icon: icon);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final filter = ref.watch(riderEarningFilterProvider);
    return StScreen(
      title: s.tx(RiderEarningsText.title),
      eyebrow: s.tx(RiderEarningsText.eyebrow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StAsyncView<EarningBalances>(
            value: ref.watch(riderBalancesProvider),
            supported: states,
            onRetry: () => ref.invalidate(riderBalancesProvider),
            builder: (context, b) => StKpiGrid(
              children: [
                StMoneyStat(
                  label: s.tx(RiderEarningsText.expected),
                  minor: b.expectedMinor,
                  icon: Icons.schedule_rounded,
                  caption: s.tx(RiderEarningsText.expectedNote),
                  tone: StColors.info,
                ),
                StMoneyStat(
                  label: s.tx(RiderEarningsText.confirmed),
                  minor: b.earnedMinor,
                  icon: Icons.task_alt_rounded,
                ),
                StMoneyStat(
                  label: s.tx(RiderEarningsText.held),
                  minor: b.heldMinor,
                  icon: Icons.pause_circle_outline_rounded,
                  tone: StColors.warning,
                ),
                StMoneyStat(
                  label: s.tx(RiderEarningsText.eligible),
                  minor: b.eligibleMinor,
                  icon: Icons.account_balance_wallet_outlined,
                  tone: StColors.success,
                ),
                StMoneyStat(
                  label: s.tx(RiderEarningsText.settled),
                  minor: b.settledMinor,
                  icon: Icons.verified_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: StSpace.sm),
          StAsyncView<int>(
            value: ref.watch(codLiabilityProvider),
            supported: states,
            onRetry: () => ref.invalidate(codLiabilityProvider),
            builder: (context, cod) => StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.local_atm_rounded,
                        color: StColors.warning,
                      ),
                      const SizedBox(width: StSpace.xs),
                      Expanded(
                        child: Text(
                          s.tx(RiderEarningsText.codTitle),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      StMoneyText.minor(
                        cod,
                        align: Alignment.centerRight,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: StFont.bodyLg,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: StSpace.xxs),
                  Text(
                    s.tx(RiderEarningsText.codNote),
                    style: TextStyle(
                      fontSize: StFont.label,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: StSpace.xs),
                  StBtn(
                    label: s.tx(RiderEarningsText.remitCod),
                    variant: StBtnVariant.soft,
                    icon: Icons.upload_rounded,
                    onTap: () => stOpen(ref, 'NR-04'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: StSpace.sm),
          StBtn(
            label: s.tx(RiderEarningsText.requestPayout),
            icon: Icons.payments_outlined,
            onTap: () => stOpen(ref, 'NR-02'),
          ),
          const SizedBox(height: StSpace.md),
          StSection(
            title: s.tx(RiderEarningsText.deliveries),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StChipRow(
                  options: [
                    (v: 'all', l: s.tx(RiderEarningsText.filterAll)),
                    for (final e in _statusText.entries)
                      (v: e.key.name, l: s.tx(e.value)),
                  ],
                  value: filter?.name ?? 'all',
                  onChanged: (v) =>
                      ref
                          .read(riderEarningFilterProvider.notifier)
                          .state = v == 'all'
                      ? null
                      : RiderEarningStatus.values.byName(v),
                ),
                const SizedBox(height: StSpace.sm),
                StAsyncView<List<RiderEarning>>(
                  value: ref.watch(riderEarningsProvider),
                  supported: states,
                  isEmpty: (rows) => rows.isEmpty,
                  emptyMessage: RiderEarningsText.empty,
                  onRetry: () => ref.invalidate(riderEarningsProvider),
                  builder: (context, rows) => StFinTable<RiderEarning>(
                    rows: rows,
                    idLabel: RiderEarningsText.colDelivery,
                    idOf: (e) => e.deliveryRef,
                    subtitleOf: (e) => s.digits(e.date),
                    amountLabel: RiderEarningsText.colConfirmed,
                    amountMinorOf: (e) => e.confirmedMinor,
                    statusOf: (e) => statusChip(s, e.status),
                    columns: [
                      StFinColumn(
                        label: RiderEarningsText.colDate,
                        cell: (e) => e.date,
                      ),
                      StFinColumn(
                        label: RiderEarningsText.colExpected,
                        cell: (e) => s.moneyMinor(e.expectedMinor),
                        numeric: true,
                      ),
                      StFinColumn(
                        label: RiderEarningsText.colReversed,
                        cell: (e) => s.moneyMinor(e.reversedMinor),
                        numeric: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: StSpace.xs),
                StBtn(
                  label: s.tx(RiderEarningsText.reportError),
                  variant: StBtnVariant.ghost,
                  icon: Icons.report_problem_outlined,
                  onTap: () => stOpen(ref, 'SH-06'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
