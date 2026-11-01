import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/supplier_earnings_providers.dart';
import 'supplier_earnings_text.dart';

/// NS-01 Supplier earnings detail: the five balance classes shown separately
/// and every earning entry with its source and itemised commission.
class SupplierEarningsOverviewScreen extends ConsumerWidget {
  const SupplierEarningsOverviewScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static const _statusText = <EarningStatus, StText>{
    EarningStatus.expected: SupplierEarningsText.expected,
    EarningStatus.earned: SupplierEarningsText.earned,
    EarningStatus.held: SupplierEarningsText.held,
    EarningStatus.eligible: SupplierEarningsText.eligible,
    EarningStatus.settled: SupplierEarningsText.settled,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final filter = ref.watch(supplierEarningFilterProvider);
    return StScreen(
      title: s.tx(SupplierEarningsText.title),
      eyebrow: s.tx(SupplierEarningsText.eyebrow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StAsyncView<EarningBalances>(
            value: ref.watch(supplierBalancesProvider),
            supported: states,
            onRetry: () => ref.invalidate(supplierBalancesProvider),
            builder: (context, b) => StKpiGrid(
              children: [
                StMoneyStat(
                  label: s.tx(SupplierEarningsText.expected),
                  minor: b.expectedMinor,
                  icon: Icons.schedule_rounded,
                  caption: s.tx(SupplierEarningsText.expectedNote),
                  tone: StColors.info,
                ),
                StMoneyStat(
                  label: s.tx(SupplierEarningsText.earned),
                  minor: b.earnedMinor,
                  icon: Icons.task_alt_rounded,
                ),
                StMoneyStat(
                  label: s.tx(SupplierEarningsText.held),
                  minor: b.heldMinor,
                  icon: Icons.pause_circle_outline_rounded,
                  tone: StColors.warning,
                ),
                StMoneyStat(
                  label: s.tx(SupplierEarningsText.eligible),
                  minor: b.eligibleMinor,
                  icon: Icons.account_balance_wallet_outlined,
                  tone: StColors.success,
                ),
                StMoneyStat(
                  label: s.tx(SupplierEarningsText.settled),
                  minor: b.settledMinor,
                  icon: Icons.verified_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: StSpace.sm),
          StNote(child: Text(s.tx(SupplierEarningsText.separateNote))),
          const SizedBox(height: StSpace.md),
          Row(
            children: [
              Expanded(
                child: StBtn(
                  label: s.tx(SupplierEarningsText.requestPayout),
                  icon: Icons.payments_outlined,
                  onTap: () => stOpen(ref, 'NS-02'),
                ),
              ),
              const SizedBox(width: StSpace.xs),
              Expanded(
                child: StBtn(
                  label: s.tx(SupplierEarningsText.payoutHistory),
                  icon: Icons.history_rounded,
                  variant: StBtnVariant.outline,
                  onTap: () => stOpen(ref, 'NS-03'),
                ),
              ),
            ],
          ),
          const SizedBox(height: StSpace.md),
          StSection(
            title: s.tx(SupplierEarningsText.statement),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StChipRow(
                  options: [
                    (v: 'all', l: s.tx(SupplierEarningsText.filterAll)),
                    for (final e in _statusText.entries)
                      (v: e.key.name, l: s.tx(e.value)),
                  ],
                  value: filter?.name ?? 'all',
                  onChanged: (v) =>
                      ref.read(supplierEarningFilterProvider.notifier).state =
                          v == 'all' ? null : EarningStatus.values.byName(v),
                ),
                const SizedBox(height: StSpace.sm),
                StAsyncView<List<SupplierEarning>>(
                  value: ref.watch(supplierEarningsProvider),
                  supported: states,
                  isEmpty: (rows) => rows.isEmpty,
                  emptyMessage: SupplierEarningsText.empty,
                  onRetry: () => ref.invalidate(supplierEarningsProvider),
                  builder: (context, rows) => StFinTable<SupplierEarning>(
                    rows: rows,
                    idLabel: SupplierEarningsText.colEntry,
                    idOf: (e) => e.orderRef,
                    subtitleOf: (e) => e.source,
                    amountLabel: SupplierEarningsText.colNet,
                    amountMinorOf: (e) => e.netMinor,
                    statusOf: (e) => _statusChip(s, e.status),
                    columns: [
                      StFinColumn(
                        label: SupplierEarningsText.colRecognised,
                        cell: (e) => e.recognisedOn.isEmpty
                            ? s.tx(SupplierEarningsText.notYet)
                            : e.recognisedOn,
                      ),
                      StFinColumn(
                        label: SupplierEarningsText.colGross,
                        cell: (e) => s.moneyMinor(e.grossMinor),
                        numeric: true,
                      ),
                      StFinColumn(
                        label: SupplierEarningsText.colCommission,
                        cell: (e) => s.moneyMinor(e.commissionMinor),
                        numeric: true,
                      ),
                    ],
                    onTap: (e) => _openEntry(ref, e),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _statusChip(AppState s, EarningStatus status) {
    final (tone, icon) = switch (status) {
      EarningStatus.expected => (StTone.muted, Icons.schedule_rounded),
      EarningStatus.earned => (StTone.role, Icons.task_alt_rounded),
      EarningStatus.held => (
        StTone.warning,
        Icons.pause_circle_outline_rounded,
      ),
      EarningStatus.eligible => (
        StTone.success,
        Icons.account_balance_wallet_outlined,
      ),
      EarningStatus.settled => (StTone.success, Icons.verified_rounded),
    };
    return StStatusChip(
      label: s.tx(_statusText[status]!),
      tone: tone,
      icon: icon,
    );
  }

  /// Entry detail: source, recognition event and the itemised deduction.
  static void _openEntry(WidgetRef ref, SupplierEarning e) {
    ref
        .read(appProvider.notifier)
        .showSheet(
          Consumer(
            builder: (context, ref, _) {
              final s = ref.watch(appProvider);
              final ctrl = ref.read(appProvider.notifier);
              Widget money(int minor) =>
                  StMoneyText.minor(minor, align: Alignment.centerRight);
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    s.tx(SupplierEarningsText.detailTitle),
                    style: const TextStyle(
                      fontSize: StFont.heading,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: StSpace.sm),
                  StInfoRow(
                    label: s.tx(SupplierEarningsText.source),
                    value: e.source,
                  ),
                  StInfoRow(
                    label: s.tx(SupplierEarningsText.reference),
                    value: s.digits(e.orderRef),
                  ),
                  StInfoRow(
                    label: s.tx(SupplierEarningsText.recognitionEvent),
                    value: e.recognisedOn.isEmpty
                        ? s.tx(SupplierEarningsText.notYet)
                        : s.digits(e.recognisedOn),
                  ),
                  StInfoRow(
                    label: s.tx(SupplierEarningsText.colGross),
                    trailing: money(e.grossMinor),
                  ),
                  StInfoRow(
                    label: s.tx(SupplierEarningsText.colCommission),
                    trailing: money(e.commissionMinor),
                  ),
                  StInfoRow(
                    label: s.tx(SupplierEarningsText.colNet),
                    trailing: money(e.netMinor),
                  ),
                  _statusChip(s, e.status),
                  if (e.holdReason != null) ...[
                    const SizedBox(height: StSpace.xs),
                    StNote(
                      tone: StNoteTone.warning,
                      child: Text(
                        '${s.tx(SupplierEarningsText.holdReason)}: ${e.holdReason}',
                      ),
                    ),
                  ],
                  const SizedBox(height: StSpace.xs),
                  Row(
                    children: [
                      const StSampleChip(),
                      const SizedBox(width: StSpace.xs),
                      Expanded(
                        child: Text(s.tx(SupplierEarningsText.commissionNote)),
                      ),
                    ],
                  ),
                  const SizedBox(height: StSpace.sm),
                  StBtn(
                    label: s.tx(SupplierEarningsText.close),
                    variant: StBtnVariant.outline,
                    onTap: ctrl.closeSheet,
                  ),
                ],
              );
            },
          ),
        );
  }
}
