import 'package:flutter_test/flutter_test.dart';
import 'package:st_admin_accounting_app/navigation/admin_accounting_app_config.dart';
import 'package:st_shell/st_shell.dart';
import 'package:st_test_kit/st_test_kit.dart';

void main() {
  testWidgets('the app starts at the staff sign-in (AU-13)', (tester) async {
    final c = await pumpStApp(tester, config: adminAccountingAppConfig);
    expect(stCurrentId(c), 'AU-13');
    expect(find.byType(StUnbuiltScreen), findsNothing);
  });

  testWidgets('A-12 and A-13 are not registered (requirement 8.4)', (
    tester,
  ) async {
    expect(adminAccountingAppConfig.knows('A-12'), isFalse);
    expect(adminAccountingAppConfig.knows('A-13'), isFalse);
  });

  testWidgets('an admin session cannot open a customer id (10.6)', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: adminAccountingAppConfig,
      sessions: [StRole.admin],
    );
    c.read(appProvider.notifier).go('C-01');
    await stPumpFrames(tester);
    expect(find.byType(StDeniedScreen), findsOneWidget);
  });
}
