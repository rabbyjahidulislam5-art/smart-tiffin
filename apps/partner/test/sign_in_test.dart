import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_partner_app/navigation/partner_app_config.dart';
import 'package:st_shell/st_shell.dart';
import 'package:st_test_kit/st_test_kit.dart';

// Task 4.16 (requirements 10.1, 10.2, 10.5). Written; not run in this session.
void main() {
  Future<void> signIn(WidgetTester tester, String id) async {
    await tester.enterText(find.byType(TextField).first, id);
    await tester.tap(find.widgetWithText(StBtn, 'Sign in').first);
    await stPumpFrames(tester);
  }

  testWidgets('a supplier account signs in to S-01', (tester) async {
    final c = await pumpStApp(tester, config: partnerAppConfig);
    await signIn(tester, 'rina@kitchen.bd');
    expect(stCurrentId(c), 'S-01');
    expect(c.read(appProvider).activeRole, StRole.supplier);
  });

  testWidgets('a rider account signs in to R-01', (tester) async {
    final c = await pumpStApp(tester, config: partnerAppConfig);
    await signIn(tester, 'rokon@rider.bd');
    expect(stCurrentId(c), 'R-01');
    expect(c.read(appProvider).activeRole, StRole.rider);
  });

  testWidgets(
    'a customer account stays on AU-03 with the message and no role',
    (tester) async {
      final c = await pumpStApp(tester, config: partnerAppConfig);
      await signIn(tester, '+880 1712-892401');
      expect(stCurrentId(c), 'AU-03');
      expect(find.text('This account cannot use this app.'), findsOneWidget);
      expect(c.read(appProvider).sessions, isEmpty);
    },
  );

  testWidgets('sign-out opens AU-03 within one second', (tester) async {
    final c = await pumpStApp(tester, config: partnerAppConfig, start: 'S-10');
    c.read(appProvider.notifier).signOut();
    await tester.pump(const Duration(milliseconds: 1000));
    expect(stCurrentId(c), 'AU-03');
    expect(c.read(appProvider).sessions, isEmpty);
  });
}
