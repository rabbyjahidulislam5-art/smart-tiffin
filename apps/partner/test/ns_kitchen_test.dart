import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_partner_app/features/kitchen_capacity/screens/capacity_text.dart';
import 'package:st_partner_app/features/pickup_handoff/screens/handoff_text.dart';
import 'package:st_partner_app/navigation/partner_app_config.dart';
import 'package:st_partner_app/navigation/partner_manifest.dart';
import 'package:st_shell/st_shell.dart';
import 'package:st_test_kit/st_test_kit.dart';

// Widget and flow tests of NS-04..NS-07 (tasks 7.10, 7.11). Written; not run.
void main() {
  for (final id in ['NS-04', 'NS-05', 'NS-06', 'NS-07']) {
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

  MockKitchenOperationsRepository kitchen(ProviderContainerLike c) =>
      c.read(kitchenOperationsRepositoryProvider)
          as MockKitchenOperationsRepository;

  testWidgets(
    'NS-05 a limit below the committed portions makes no saveCapacity call',
    (tester) async {
      final c = await pumpStApp(
        tester,
        config: partnerAppConfig,
        start: 'NS-05',
      );
      await tester.enterText(find.byType(TextField).first, '10');
      await tester.tap(
        find.widgetWithText(StCommandButton, stTx(c, CapacityText.save)).first,
      );
      await stPumpFrames(tester);
      expect(kitchen(c).calls.contains('saveCapacity'), isFalse);
    },
  );

  testWidgets('NS-05 saves one limit with one call and shows the new value', (
    tester,
  ) async {
    final c = await pumpStApp(tester, config: partnerAppConfig, start: 'NS-05');
    await tester.enterText(find.byType(TextField).first, '70');
    await tester.tap(
      find.widgetWithText(StCommandButton, stTx(c, CapacityText.save)).first,
    );
    await stPumpFrames(tester);
    expect(kitchen(c).calls.where((x) => x == 'saveCapacity').length, 1);
    expect(find.text(stTx(c, CapacityText.saved)), findsOneWidget);
  });

  testWidgets('NS-05 a failed save names the command and keeps the value', (
    tester,
  ) async {
    final b = MockBehavior.instant();
    final c = await pumpStApp(
      tester,
      config: partnerAppConfig,
      start: 'NS-05',
      behavior: b,
    );
    await tester.enterText(find.byType(TextField).first, '70');
    b.failNext(RepoErrorKind.temporarilyUnavailable);
    await tester.tap(
      find.widgetWithText(StCommandButton, stTx(c, CapacityText.save)).first,
    );
    await stPumpFrames(tester);
    expect(find.byType(StCommandError), findsOneWidget);
    expect(find.text('70'), findsOneWidget);
  });

  testWidgets('NS-07 records a handoff once with the right code', (
    tester,
  ) async {
    final c = await pumpStApp(tester, config: partnerAppConfig, start: 'NS-07');
    await tester.tap(find.byKey(const ValueKey('handoff-HO-81')));
    await stPumpFrames(tester, frames: 2);
    await tester.enterText(find.byType(TextField).first, '4821');
    for (final t in find.byType(StToggle).evaluate().toList()) {
      await tester.tap(find.byWidget(t.widget));
    }
    await stPumpFrames(tester, frames: 2);
    await tester.tap(find.byType(StCommandButton));
    await stPumpFrames(tester);
    expect(kitchen(c).calls.where((x) => x == 'recordHandoff').length, 1);
    expect(find.text(stTx(c, HandoffText.success)), findsOneWidget);
  });

  testWidgets('flow S-03 > NS-07 opens the handoff as a sheet over S-03', (
    tester,
  ) async {
    final c = await pumpStApp(tester, config: partnerAppConfig, start: 'S-03');
    final flow = StFlowRunner(tester, c)..expectAt('S-03');
    await flow.tapKey(const ValueKey('host-entry-NS-07'));
    expect(flow.sheetOpen, isTrue);
    flow.expectAt('S-03');
  });

  testWidgets('flow S-07 > NS-04 > NS-05', (tester) async {
    final c = await pumpStApp(tester, config: partnerAppConfig, start: 'S-07');
    final flow = StFlowRunner(tester, c)..expectAt('S-07');
    await flow.tapKey(const ValueKey('host-entry-NS-04'));
    flow.expectAt('NS-04');
    await flow.open('NS-05');
    flow.expectAt('NS-05');
  });
}
