import 'package:flutter_test/flutter_test.dart';
import 'package:st_customer_app/navigation/customer_app_config.dart';
import 'package:st_shell/st_shell.dart';
import 'package:st_test_kit/st_test_kit.dart';

void main() {
  testWidgets('the Customer app starts at the guest home (P-01)', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      sessions: const [],
    );
    expect(stCurrentId(c), 'P-01');
    expect(find.byType(StUnbuiltScreen), findsNothing);
  });

  testWidgets('a supplier id is denied in the Customer app (10.6)', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      sessions: [StRole.customer],
    );
    c.read(appProvider.notifier).go('S-01');
    await stPumpFrames(tester);
    expect(find.byType(StDeniedScreen), findsOneWidget);
  });

  testWidgets('AU-09 opens the Partner app hand-off instead of a route (5.6)', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: customerAppConfig,
      sessions: const [],
    );
    expect(customerAppConfig.knows('AU-09'), isFalse);
    c
        .read(appProvider.notifier)
        .showSheet(customerAppConfig.handoffFor!('AU-09')!);
    await stPumpFrames(tester);
    expect(find.byType(StHandoffSheet), findsOneWidget);
    expect(stCurrentId(c), 'P-01');
  });
}
