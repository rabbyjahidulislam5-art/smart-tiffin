import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_partner_app/features/supplier_earnings/screens/supplier_earnings_text.dart';
import 'package:st_partner_app/navigation/partner_app_config.dart';
import 'package:st_partner_app/navigation/partner_manifest.dart';
import 'package:st_shell/st_shell.dart';
import 'package:st_test_kit/st_test_kit.dart';

// Widget, flow and matrix tests of NS-01..NS-03 (tasks 6.10, 6.11, 6.12).
// Written in this session; not run (Flutter is not run here).
void main() {
  for (final id in ['NS-01', 'NS-02', 'NS-03']) {
    final spec = partnerManifest.firstWhere((s) => s.id == id);
    group(id, () {
      stStandardScreenTests(
        config: partnerAppConfig,
        spec: spec,
        sessions: [StRole.supplier],
        deniedSessions: [StRole.rider],
      );
    });
  }

  Future<void> fillPayout(WidgetTester tester, String amount) async {
    await tester.enterText(find.byType(TextField).first, amount);
    await tester.tap(find.byType(StToggle));
    await stPumpFrames(tester, frames: 2);
    await tester.tap(find.byType(StCommandButton));
    await stPumpFrames(tester);
  }

  group('NS-02 amount validation makes no requestPayout call', () {
    for (final bad in ['0', '0.001', '1000000', '18450.01']) {
      testWidgets('rejects $bad', (tester) async {
        final c = await pumpStApp(
          tester,
          config: partnerAppConfig,
          start: 'NS-02',
        );
        await fillPayout(tester, bad);
        expect(
          c.read(mockPayoutRepositoryProvider).calls.contains('requestPayout'),
          isFalse,
        );
        final messages = [
          StAmountText.format,
          StAmountText.range,
          StAmountText.aboveBalance,
        ].map((t) => stTx(c, t));
        expect(messages.any((m) => find.text(m).evaluate().isNotEmpty), isTrue);
      });
    }
  });

  testWidgets(
    'NS-02 failure names the command, keeps the value and the balance',
    (tester) async {
      final behavior = MockBehavior.instant();
      final c = await pumpStApp(
        tester,
        config: partnerAppConfig,
        start: 'NS-02',
        behavior: behavior,
      );
      behavior.failNext(RepoErrorKind.temporarilyUnavailable);
      await fillPayout(tester, '100');
      expect(find.byType(StCommandError), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(
        c.read(mockPayoutRepositoryProvider).eligibleOf(StRole.supplier),
        1845000,
      );
    },
  );

  testWidgets(
    'NS-02 shows Bangla digits under bn and keeps the amount across a theme switch',
    (tester) async {
      final c = await pumpStApp(
        tester,
        config: partnerAppConfig,
        start: 'NS-02',
        lang: StLang.bn,
      );
      await tester.enterText(find.byType(TextField).first, '250');
      c.read(appProvider.notifier).setThemeMode(StThemeMode.dark);
      await stPumpFrames(tester);
      expect(find.text('250'), findsOneWidget);
      expect(find.textContaining('৳১৮,৪৫০'), findsWidgets);
    },
  );

  testWidgets('flow S-08 > NS-01 > NS-02 > NS-03 shows the new request', (
    tester,
  ) async {
    final c = await pumpStApp(tester, config: partnerAppConfig, start: 'S-08');
    final flow = StFlowRunner(tester, c)..expectAt('S-08');
    await flow.tapKey(const ValueKey('host-entry-NS-01'));
    flow.expectAt('NS-01');
    await flow.tapText(stTx(c, SupplierEarningsText.requestPayout));
    flow.expectAt('NS-02');
    await fillPayout(tester, '100');
    expect(find.text(stTx(c, SupplierEarningsText.success)), findsOneWidget);
    await flow.tapText(stTx(c, SupplierEarningsText.payoutHistory));
    flow.expectAt('NS-03');
    expect(find.text('PO-401'), findsWidgets);
  });

  stMatrixTest(
    'NS money',
    config: partnerAppConfig,
    id: 'NS-01',
    sessions: [StRole.supplier],
  );
}
