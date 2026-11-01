import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/finance_overview_providers.dart';
import 'finance_overview_text.dart';

/// NF-01 Finance executive overview: every figure with its period and its
/// qualifier (cash movement or recognised), each drilling into its records.
class FinanceOverviewDashboard extends ConsumerWidget {
  const FinanceOverviewDashboard({super.key});

  static const states = {StVariant.loading, StVariant.error, StVariant.offline};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    Widget tile(
      StText label,
      int minor,
      IconData icon,
      String target, {
      bool cash = true,
      StText? note,
      Color? tone,
    }) => StMoneyStat(
      key: ValueKey('kpi-$target-${label.en}'),
      label: s.tx(label),
      minor: minor,
      icon: icon,
      tone: tone,
      caption: note == null
          ? s.tx(
              cash ? FinanceOverviewText.cash : FinanceOverviewText.recognised,
            )
          : '${s.tx(cash ? FinanceOverviewText.cash : FinanceOverviewText.recognised)} · ${s.tx(note)}',
      onTap: () => stOpen(ref, target),
    );
    return StScreen(
      title: s.tx(FinanceOverviewText.title),
      eyebrow: s.tx(FinanceOverviewText.eyebrow),
      back: false,
      dense: true,
      child: StAsyncView<FullFinanceKpis>(
        value: ref.watch(fullFinanceKpisProvider),
        supported: states,
        onRetry: () => ref.invalidate(fullFinanceKpisProvider),
        builder: (context, k) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    s.tx(FinanceOverviewText.period, [k.period, k.generatedAt]),
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ),
                const StSampleChip(),
              ],
            ),
            const SizedBox(height: StSpace.sm),
            StKpiGrid(
              children: [
                tile(
                  FinanceOverviewText.verifiedCollections,
                  k.verifiedCollectionsMinor,
                  Icons.verified_outlined,
                  'NF-02',
                ),
                tile(
                  FinanceOverviewText.receivables,
                  k.receivablesMinor,
                  Icons.call_received_rounded,
                  'NF-11',
                  cash: false,
                ),
                tile(
                  FinanceOverviewText.supplierPayables,
                  k.supplierPayablesMinor,
                  Icons.storefront_outlined,
                  'NF-05',
                  cash: false,
                ),
                tile(
                  FinanceOverviewText.riderPayables,
                  k.riderPayablesMinor,
                  Icons.two_wheeler_rounded,
                  'NF-06',
                  cash: false,
                ),
                tile(
                  FinanceOverviewText.creditLiability,
                  k.creditLiabilityMinor,
                  Icons.card_giftcard_rounded,
                  'NF-09',
                  cash: false,
                ),
                tile(
                  FinanceOverviewText.codAwaiting,
                  k.codAwaitingMinor,
                  Icons.local_atm_rounded,
                  'NF-03',
                  tone: StColors.warning,
                ),
                tile(
                  FinanceOverviewText.availableFunds,
                  k.availableFundsMinor,
                  Icons.account_balance_rounded,
                  'NF-11',
                  note: FinanceOverviewText.availableNote,
                  tone: StColors.success,
                ),
                tile(
                  FinanceOverviewText.pendingSettlements,
                  k.pendingSettlementsMinor,
                  Icons.schedule_rounded,
                  'NF-08',
                ),
                tile(
                  FinanceOverviewText.completedSettlements,
                  k.completedSettlementsMinor,
                  Icons.task_alt_rounded,
                  'NF-08',
                ),
                tile(
                  FinanceOverviewText.refundObligations,
                  k.refundObligationsMinor,
                  Icons.undo_rounded,
                  'NF-10',
                  cash: false,
                ),
                tile(
                  FinanceOverviewText.revenue,
                  k.revenueMinor,
                  Icons.trending_up_rounded,
                  'NF-11',
                  cash: false,
                ),
                StStat(
                  label: s.tx(FinanceOverviewText.exceptions),
                  value: s.digits('${k.exceptionCount}'),
                  icon: Icons.report_problem_outlined,
                  onTap: () => stOpen(ref, 'NF-13'),
                ),
              ],
            ),
            const SizedBox(height: StSpace.sm),
            StNote(child: Text(s.tx(FinanceOverviewText.drill))),
            const SizedBox(height: StSpace.xs),
            StNote(
              tone: StNoteTone.policy,
              child: Text(s.tx(FinanceOverviewText.sample)),
            ),
          ],
        ),
      ),
    );
  }
}
