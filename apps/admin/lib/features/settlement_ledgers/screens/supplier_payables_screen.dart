import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/settlement_ledgers_providers.dart';
import '../widgets/payable_ledger_view.dart';
import 'settlement_ledgers_text.dart';

/// NF-05 Supplier payable ledger.
class SupplierPayablesScreen extends ConsumerWidget {
  const SupplierPayablesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    return StScreen(
      title: s.tx(SettlementLedgersText.supplierTitle),
      eyebrow: s.tx(SettlementLedgersText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(SettlementLedgersText.supplierIntro))),
          const SizedBox(height: StSpace.sm),
          PayableLedgerView(provider: supplierPayablesProvider, riders: false),
        ],
      ),
    );
  }
}
