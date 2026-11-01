import 'package:flutter_test/flutter_test.dart';
import 'package:st_partner_app/navigation/partner_app_config.dart';
import 'package:st_shell/st_shell.dart';
import 'package:st_test_kit/st_test_kit.dart';

void main() {
  testWidgets('the Partner app starts at sign-in (AU-03)', (tester) async {
    final c = await pumpStApp(tester, config: partnerAppConfig);
    expect(stCurrentId(c), 'AU-03');
    expect(find.byType(StUnbuiltScreen), findsNothing);
  });

  testWidgets('an admin id is denied in the Partner app (10.6)', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: partnerAppConfig,
      sessions: [StRole.supplier],
    );
    c.read(appProvider.notifier).go('A-01');
    await stPumpFrames(tester);
    expect(find.byType(StDeniedScreen), findsOneWidget);
    expect(stCurrentId(c), 'AU-03');
  });

  testWidgets('a rider session cannot open a supplier screen', (tester) async {
    final c = await pumpStApp(
      tester,
      config: partnerAppConfig,
      sessions: [StRole.rider],
    );
    c.read(appProvider.notifier).go('S-01');
    await stPumpFrames(tester);
    expect(find.byType(StDeniedScreen), findsOneWidget);
  });
}
