import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/supplier_earnings_providers.dart';
import 'supplier_earnings_text.dart';

/// NS-03 Supplier payout history: settled, failed and processing transfers;
/// "requested" is never shown as paid (S-09 rule).
class SupplierPayoutHistoryScreen extends ConsumerWidget {
  const SupplierPayoutHistoryScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final history = ref.read(supplierPayoutHistoryProvider.notifier);
    return StScreen(
      title: s.tx(SupplierEarningsText.historyTitle),
      eyebrow: s.tx(SupplierEarningsText.eyebrow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(SupplierEarningsText.historyNote))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<StPagedList<PayoutRecord>>(
            value: ref.watch(supplierPayoutHistoryProvider),
            supported: states,
            isEmpty: (list) => list.isEmpty,
            emptyMessage: SupplierEarningsText.historyEmpty,
            emptyAction: (
              label: SupplierEarningsText.requestPayout,
              onTap: () => stOpen(ref, 'NS-02'),
            ),
            onRetry: history.reload,
            builder: (context, list) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StFinTable<PayoutRecord>(
                  rows: list.items,
                  idLabel: SupplierEarningsText.reference,
                  idOf: (r) => r.id,
                  subtitleOf: (r) => s.digits(r.requestedOn),
                  amountMinorOf: (r) => r.amountMinor,
                  statusOf: (r) => StPayoutStatusChip(status: r.status),
                  columns: [
                    StFinColumn(
                      label: SupplierEarningsText.colRequested,
                      cell: (r) => r.requestedOn,
                    ),
                    StFinColumn(
                      label: SupplierEarningsText.colDestination,
                      cell: (r) => r.destination,
                    ),
                    StFinColumn(
                      label: SupplierEarningsText.colReference,
                      cell: (r) => r.reference ?? '-',
                    ),
                  ],
                ),
                StLoadMore<PayoutRecord>(list: list, onMore: history.loadMore),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
