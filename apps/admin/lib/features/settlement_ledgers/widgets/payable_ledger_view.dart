import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/settlement_ledgers_text.dart';

/// Payable table of NF-05 (suppliers) and NF-06 (riders, with the COD cash
/// column beside, never netted). A row opens the eligibility explanation
/// and the hold commands (`placeHold`, `releaseHold`).
class PayableLedgerView extends ConsumerWidget {
  const PayableLedgerView({
    super.key,
    required this.provider,
    required this.riders,
  });

  final AutoDisposeFutureProvider<List<PayableRow>> provider;
  final bool riders;

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  void _open(WidgetRef ref, PayableRow row, VoidCallback refresh) {
    final repo = ref.read(settlementLedgerRepositoryProvider);
    final actor = ref.read(actorProvider);
    final ctrl = ref.read(appProvider.notifier);
    ctrl.showSheet(
      Consumer(
        builder: (context, ref, _) {
          final s = ref.watch(appProvider);
          Widget money(int minor) =>
              StMoneyText.minor(minor, align: Alignment.centerRight);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                row.partyName,
                style: const TextStyle(
                  fontSize: StFont.heading,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: StSpace.xs),
              Text(
                s.tx(SettlementLedgersText.explain),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              StInfoRow(
                label: s.tx(SettlementLedgersText.recognised),
                trailing: money(row.recognisedMinor),
              ),
              StInfoRow(
                label: s.tx(SettlementLedgersText.deductions),
                trailing: money(-row.deductionsMinor),
              ),
              StInfoRow(
                label: s.tx(SettlementLedgersText.held),
                trailing: money(-row.heldMinor),
              ),
              StInfoRow(
                label: s.tx(SettlementLedgersText.disputed),
                trailing: money(-row.disputedMinor),
              ),
              StInfoRow(
                label: s.tx(SettlementLedgersText.eligible),
                trailing: money(row.eligibleMinor),
              ),
              Text(
                s.tx(SettlementLedgersText.formula),
                style: TextStyle(
                  fontSize: StFont.caption,
                  color: Theme.of(context).hintColor,
                ),
              ),
              if (riders && row.codLiabilityMinor != null) ...[
                const SizedBox(height: StSpace.xs),
                StInfoRow(
                  label: s.tx(SettlementLedgersText.codLiability),
                  trailing: money(row.codLiabilityMinor!),
                ),
              ],
              if (row.holdReason != null) ...[
                const SizedBox(height: StSpace.xs),
                StNote(
                  tone: StNoteTone.warning,
                  child: Text(
                    s.tx(SettlementLedgersText.holdReason, [row.holdReason!]),
                  ),
                ),
              ],
              const SizedBox(height: StSpace.sm),
              StBtn(
                label: s.tx(
                  row.onHold
                      ? SettlementLedgersText.releaseHold
                      : SettlementLedgersText.placeHold,
                ),
                variant: row.onHold ? StBtnVariant.soft : StBtnVariant.danger,
                icon: row.onHold
                    ? Icons.lock_open_rounded
                    : Icons.lock_outline_rounded,
                onTap: () => ctrl.showSheet(
                  StReasonSheet(
                    title: row.onHold
                        ? SettlementLedgersText.releaseHold
                        : SettlementLedgersText.placeHold,
                    body: SettlementLedgersText.holdBody,
                    commandName: SettlementLedgersText.holdName,
                    success: row.onHold
                        ? SettlementLedgersText.holdReleased
                        : SettlementLedgersText.holdPlaced,
                    confirmLabel: row.onHold
                        ? SettlementLedgersText.releaseHold
                        : SettlementLedgersText.placeHold,
                    danger: !row.onHold,
                    onSubmit: (reason) => row.onHold
                        ? repo.releaseHold(
                            actor,
                            RequestId.next('hold'),
                            partyId: row.partyId,
                            reason: reason,
                          )
                        : repo.placeHold(
                            actor,
                            RequestId.next('hold'),
                            partyId: row.partyId,
                            reason: reason,
                          ),
                    onDone: refresh,
                  ),
                ),
              ),
              const SizedBox(height: StSpace.xs),
              StBtn(
                label: s.tx(SettlementLedgersText.close),
                variant: StBtnVariant.outline,
                onTap: ctrl.closeSheet,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    return StAsyncView<List<PayableRow>>(
      value: ref.watch(provider),
      supported: states,
      isEmpty: (l) => l.isEmpty,
      emptyMessage: SettlementLedgersText.empty,
      onRetry: () => ref.invalidate(provider),
      builder: (context, rows) => StFinTable<PayableRow>(
        rows: rows,
        idLabel: SettlementLedgersText.colParty,
        idOf: (r) => r.partyName,
        amountLabel: SettlementLedgersText.eligible,
        amountMinorOf: (r) => r.eligibleMinor,
        statusOf: (r) => r.onHold
            ? StStatusChip(
                label: s.tx(SettlementLedgersText.onHold),
                tone: StTone.danger,
                icon: Icons.lock_outline_rounded,
              )
            : r.disputedMinor > 0
            ? StStatusChip(
                label: s.tx(SettlementLedgersText.disputed),
                tone: StTone.warning,
              )
            : StStatusChip(
                label: s.tx(SettlementLedgersText.clear),
                tone: StTone.success,
              ),
        columns: [
          StFinColumn(
            label: SettlementLedgersText.recognised,
            cell: (r) => s.moneyMinor(r.recognisedMinor),
            numeric: true,
          ),
          StFinColumn(
            label: SettlementLedgersText.deductions,
            cell: (r) => s.moneyMinor(r.deductionsMinor),
            numeric: true,
          ),
          StFinColumn(
            label: SettlementLedgersText.held,
            cell: (r) => s.moneyMinor(r.heldMinor),
            numeric: true,
          ),
          StFinColumn(
            label: SettlementLedgersText.disputed,
            cell: (r) => s.moneyMinor(r.disputedMinor),
            numeric: true,
          ),
          if (riders)
            StFinColumn(
              label: SettlementLedgersText.codLiability,
              cell: (r) => s.moneyMinor(r.codLiabilityMinor ?? 0),
              numeric: true,
            ),
        ],
        onTap: (r) => _open(ref, r, () => ref.invalidate(provider)),
      ),
    );
  }
}
