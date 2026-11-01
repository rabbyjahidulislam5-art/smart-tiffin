import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_partner_app/features/cod_collection/screens/cod_text.dart';
import 'package:st_partner_app/navigation/partner_app_config.dart';
import 'package:st_partner_app/navigation/partner_manifest.dart';
import 'package:st_shell/st_shell.dart';
import 'package:st_test_kit/st_test_kit.dart';

// Widget, flow and matrix tests of NR-01..NR-06 (tasks 8.10, 8.11, 9.9, 9.10).
// Written in this session; not run (Flutter is not run here).
void main() {
  for (final id in ['NR-01', 'NR-02', 'NR-03', 'NR-04', 'NR-05', 'NR-06']) {
    final spec = partnerManifest.firstWhere((s) => s.id == id);
    group(id, () {
      stStandardScreenTests(
        config: partnerAppConfig,
        spec: spec,
        sessions: [StRole.rider],
        deniedSessions: [StRole.supplier],
      );
    });
  }

  group('NR-02 amount rejection makes no requestPayout call', () {
    for (final bad in ['0', '0.001', '1000000', '2600.01']) {
      testWidgets('rejects $bad', (tester) async {
        final c = await pumpStApp(
          tester,
          config: partnerAppConfig,
          start: 'NR-02',
        );
        await tester.enterText(find.byType(TextField).first, bad);
        await tester.tap(find.byType(StToggle));
        await tester.tap(find.byType(StCommandButton));
        await stPumpFrames(tester);
        expect(
          c.read(mockPayoutRepositoryProvider).calls.contains('requestPayout'),
          isFalse,
        );
      });
    }
  });

  testWidgets('NR-03 rejects 0 without a recordCodCollection call', (
    tester,
  ) async {
    final c = await pumpStApp(tester, config: partnerAppConfig, start: 'NR-03');
    await tester.enterText(find.byType(TextField).first, '0');
    await tester.tap(find.byType(StToggle));
    await tester.tap(find.byType(StCommandButton));
    await stPumpFrames(tester);
    expect(
      (c.read(codRepositoryProvider) as MockCodRepository).calls.contains(
            'recordCodCollection',
          ),
      isFalse,
    );
  });

  testWidgets('NR-04 failure keeps the reference and the COD records', (
    tester,
  ) async {
    final b = MockBehavior.instant();
    final c = await pumpStApp(
      tester,
      config: partnerAppConfig,
      start: 'NR-04',
      behavior: b,
    );
    await tester.enterText(find.byType(TextField).at(0), '100');
    await tester.enterText(find.byType(TextField).at(1), 'DEP-77001');
    b.failNext(RepoErrorKind.temporarilyUnavailable);
    await tester.tap(find.byType(StCommandButton));
    await stPumpFrames(tester);
    expect(find.byType(StCommandError), findsOneWidget);
    expect(find.text('DEP-77001'), findsOneWidget);
    expect((c.read(codRepositoryProvider) as MockCodRepository).revision, 0);
  });

  testWidgets('flow R-01 > NR-03 (sheet) > NR-04 > NR-05', (tester) async {
    final c = await pumpStApp(tester, config: partnerAppConfig, start: 'R-01');
    final flow = StFlowRunner(tester, c)..expectAt('R-01');
    await flow.tapKey(const ValueKey('host-entry-NR-03'));
    expect(flow.sheetOpen, isTrue);
    await tester.enterText(find.byType(TextField).first, '240');
    await tester.tap(find.byType(StToggle));
    await tester.tap(find.byType(StCommandButton));
    await stPumpFrames(tester);
    await flow.tapText(stTx(c, CodText.toRemit));
    flow.expectAt('NR-04');
    await flow.tapText(stTx(c, CodText.discrepancies));
    flow.expectAt('NR-05');
  });

  stMatrixTest(
    'NR',
    config: partnerAppConfig,
    id: 'NR-01',
    sessions: [StRole.rider],
  );
}
