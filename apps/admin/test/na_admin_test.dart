import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:st_admin_accounting_app/features/verification_queue/screens/verification_queue_text.dart';
import 'package:st_admin_accounting_app/navigation/admin_accounting_app_config.dart';
import 'package:st_admin_accounting_app/navigation/admin_accounting_manifest.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';
import 'package:st_test_kit/st_test_kit.dart';

// Widget, flow and matrix tests of NA-01..NA-06 (tasks 11.x, 12.x).
// Written in this session; not run (Flutter is not run here).
void main() {
  for (final spec in adminAccountingManifest.where(
    (s) => s.id.startsWith('NA-'),
  )) {
    group(spec.id, () {
      stStandardScreenTests(
        config: adminAccountingAppConfig,
        spec: spec,
        sessions: [StRole.admin],
        deniedSessions: [StRole.accounting],
      );
    });
  }

  testWidgets('NA-03 Approve stays disabled until every check is ticked', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: adminAccountingAppConfig,
      start: 'NA-03',
    );
    await tester.tap(find.byKey(const ValueKey('application-ctg')));
    await stPumpFrames(tester);
    final approve = tester.widget<StBtn>(
      find.widgetWithText(StBtn, stTx(c, VerificationQueueText.approve)).first,
    );
    expect(approve.disabled, isTrue);
    expect(
      (c.read(
        applicationReviewRepositoryProvider,
      ) as MockApplicationReviewRepository).calls.contains('decideApplication'),
      isFalse,
    );
  });

  testWidgets('an admin session cannot reach a payout or ledger screen', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: adminAccountingAppConfig,
      sessions: [StRole.admin],
    );
    for (final id in ['NF-07', 'NF-08', 'NF-11']) {
      c.read(appProvider.notifier).go(id);
      await stPumpFrames(tester, frames: 2);
      expect(find.byType(StDeniedScreen), findsOneWidget);
      c.read(appProvider.notifier).clearDenied();
      await stPumpFrames(tester, frames: 2);
    }
  });

  testWidgets('flow A-01 > NA-01 > NA-03', (tester) async {
    final c = await pumpStApp(
      tester,
      config: adminAccountingAppConfig,
      start: 'A-01',
    );
    final flow = StFlowRunner(tester, c)..expectAt('A-01');
    await flow.tapText('Command centre');
    flow.expectAt('NA-01');
    await flow.open('NA-03');
    flow.expectAt('NA-03');
  });

  stMatrixTest(
    'NA',
    config: adminAccountingAppConfig,
    id: 'NA-01',
    sessions: [StRole.admin],
  );
}
