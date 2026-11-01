import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/cod_verification_providers.dart';
import 'cod_verification_text.dart';

/// NF-03 COD collection dashboard: rider by date custody, overdue first.
class CodCustodyScreen extends ConsumerWidget {
  const CodCustodyScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    return StScreen(
      title: s.tx(CodVerificationText.custodyTitle),
      eyebrow: s.tx(CodVerificationText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(CodVerificationText.custodyIntro))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<CodCustodyRow>>(
            value: ref.watch(codCustodyProvider),
            supported: states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: CodVerificationText.empty,
            onRetry: () => ref.invalidate(codCustodyProvider),
            builder: (context, rows) => StFinTable<CodCustodyRow>(
              rows: rows,
              idLabel: CodVerificationText.colRider,
              idOf: (r) => r.riderName,
              subtitleOf: (r) => s.digits(r.date),
              amountLabel: CodVerificationText.outstanding,
              amountMinorOf: (r) => r.outstandingMinor,
              statusOf: (r) => r.overdue
                  ? StStatusChip(
                      label: s.tx(CodVerificationText.overdue),
                      tone: StTone.danger,
                      icon: Icons.warning_amber_rounded,
                    )
                  : r.outstandingMinor == 0
                  ? StStatusChip(
                      label: s.tx(CodVerificationText.settled),
                      tone: StTone.success,
                      icon: Icons.check_circle_outline,
                    )
                  : StStatusChip(
                      label: s.tx(CodVerificationText.onTime),
                      tone: StTone.info,
                    ),
              columns: [
                StFinColumn(
                  label: CodVerificationText.colDate,
                  cell: (r) => r.date,
                ),
                StFinColumn(
                  label: CodVerificationText.colHeld,
                  cell: (r) => s.moneyMinor(r.heldMinor),
                  numeric: true,
                ),
                StFinColumn(
                  label: CodVerificationText.colRemitted,
                  cell: (r) => s.moneyMinor(r.remittedMinor),
                  numeric: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: StSpace.sm),
          StBtn(
            label: s.tx(CodVerificationText.verifyDeposits),
            icon: Icons.fact_check_outlined,
            onTap: () => stOpen(ref, 'NF-04'),
          ),
        ],
      ),
    );
  }
}
