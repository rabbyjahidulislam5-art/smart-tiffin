import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/settlement_ledgers_providers.dart';
import '../widgets/payable_ledger_view.dart';
import 'settlement_ledgers_text.dart';

/// NF-06 Rider payable ledger (compensation beside, never netted with, COD).
class RiderPayablesScreen extends ConsumerWidget {
  const RiderPayablesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    return StScreen(
      title: s.tx(SettlementLedgersText.riderTitle),
      eyebrow: s.tx(SettlementLedgersText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(SettlementLedgersText.riderIntro))),
          const SizedBox(height: StSpace.sm),
          PayableLedgerView(provider: riderPayablesProvider, riders: true),
        ],
      ),
    );
  }
}
