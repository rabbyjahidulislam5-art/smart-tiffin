import 'package:flutter_test/flutter_test.dart';
import 'package:st_shell/st_shell.dart';

import 'pump_st_app.dart';

/// One id of every role (task 4.15 table).
const stRoleDenialIds = [
  'C-01',
  'S-01',
  'R-01',
  'A-01',
  'NC-01',
  'NS-01',
  'NR-01',
  'NA-01',
  'NF-01',
];

/// For each role of [config], requests every table id owned by another role
/// and expects the denied screen with the role, session and screen unchanged.
void stRoleDenialTests(StShellConfig config) {
  for (final role in config.roles) {
    for (final id in stRoleDenialIds.where((i) => roleForScreenId(i) != role)) {
      testWidgets('${role.name} session: $id is denied', (tester) async {
        final c = await pumpStApp(tester, config: config, sessions: [role]);
        final ctrl = c.read(appProvider.notifier);
        ctrl.reset(config.homeFor(role));
        await stPumpFrames(tester);
        final before = c.read(appProvider);
        ctrl.go(id);
        await stPumpFrames(tester);
        final after = c.read(appProvider);
        expect(find.byType(StDeniedScreen), findsOneWidget);
        expect(after.current.id, before.current.id);
        expect(after.role, role);
        expect(after.sessions, before.sessions);
      });
    }
  }
}
