import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:st_admin_accounting_app/features/general_ledger/screens/general_ledger_text.dart';
import 'package:st_admin_accounting_app/features/payout_operations/screens/payout_operations_text.dart';
import 'package:st_admin_accounting_app/navigation/admin_accounting_app_config.dart';
import 'package:st_admin_accounting_app/navigation/admin_accounting_manifest.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';
import 'package:st_test_kit/st_test_kit.dart';

// Widget, flow and matrix tests of NF-01..NF-17 (tasks 14.x..18.x).
// Written in this session; not run (Flutter is not run here).
void main() {
  for (final spec in adminAccountingManifest.where(
    (s) => s.id.startsWith('NF-'),
  )) {
    group(spec.id, () {
      stStandardScreenTests(
        config: adminAccountingAppConfig,
        spec: spec,
        sessions: [StRole.accounting],
        deniedSessions: [StRole.admin],
      );
    });
  }

  testWidgets(
    'NF-12 Close period stays disabled while the checklist is incomplete',
    (tester) async {
      final c = await pumpStApp(
        tester,
        config: adminAccountingAppConfig,
        start: 'NF-12',
      );
      c.read(appProvider.notifier);
      await tester.tap(
        find.text('2026-11 · ${stTx(c, GeneralLedgerText.open)}'),
      );
      await stPumpFrames(tester);
      final btn = tester.widget<StBtn>(
        find
            .widgetWithText(StBtn, stTx(c, GeneralLedgerText.closePeriod))
            .first,
      );
      expect(btn.disabled, isTrue);
    },
  );

  testWidgets('NF-08 releases a batch prepared by another operator once', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: adminAccountingAppConfig,
      start: 'NF-08',
    );
    await tester.tap(
      find.widgetWithText(StBtn, stTx(c, PayoutOperationsText.release)).first,
    );
    await stPumpFrames(tester);
    final repo = c.read(
      payoutOperationsRepositoryProvider,
    ) as MockPayoutOperationsRepository;
    expect(repo.calls.where((x) => x == 'releasePayoutBatch').length, 1);
  });

  testWidgets('an accounting session cannot open an admin screen', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: adminAccountingAppConfig,
      sessions: [StRole.accounting],
    );
    for (final id in ['A-01', 'NA-01', 'NA-05']) {
      c.read(appProvider.notifier).go(id);
      await stPumpFrames(tester, frames: 2);
      expect(find.byType(StDeniedScreen), findsOneWidget);
      c.read(appProvider.notifier).clearDenied();
      await stPumpFrames(tester, frames: 2);
    }
  });

  testWidgets('flow AU-13 accounting sign-in > NF-01 > NF-07 > NF-08', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: adminAccountingAppConfig,
      sessions: const [],
    );
    await tester.enterText(
      find.byType(TextField).first,
      'accounts@smarttiffin.bd',
    );
    final flow = StFlowRunner(tester, c);
    c.read(appProvider.notifier)
      ..setRole(StRole.accounting)
      ..reset('NF-01');
    await stPumpFrames(tester);
    flow.expectAt('NF-01');
    await flow.open('NF-07');
    flow.expectAt('NF-07');
    await flow.tapText(stTx(c, PayoutOperationsText.batchTitle));
    flow.expectAt('NF-08');
  });

  stMatrixTest(
    'NF',
    config: adminAccountingAppConfig,
    id: 'NF-01',
    sessions: [StRole.accounting],
  );
}
