import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

import 'support/shell_test_support.dart';

// Task 3.10. Written in this session; not run (Flutter is not run here).
void main() {
  test('a denied go keeps the stack, role and sessions and builds nothing', () {
    final c = stTestContainer();
    addTearDown(c.dispose);
    final ctrl = c.read(appProvider.notifier)..setRole(StRole.admin);
    final before = c.read(appProvider);
    ctrl.go('NF-01');
    final after = c.read(appProvider);
    expect(after.denied?.reason, DeniedReason.roleMismatch);
    expect(after.stack.map((e) => e.id), before.stack.map((e) => e.id));
    expect(after.role, StRole.admin);
    expect(after.sessions, {StRole.admin});
    expect(stBuiltIds, isEmpty);
  });

  test('an unknown id is denied', () {
    final c = stTestContainer();
    addTearDown(c.dispose);
    c.read(appProvider.notifier).go('X-99');
    expect(c.read(appProvider).denied?.reason, DeniedReason.unknownId);
  });

  test('sign-out ends only the active session and opens the sign-in route', () {
    final c = stTestContainer();
    addTearDown(c.dispose);
    final ctrl = c.read(appProvider.notifier)
      ..setRole(StRole.admin)
      ..setRole(StRole.accounting)
      ..reset('NF-01')
      ..setAfterLogin(const NavEntry('NF-01'));
    ctrl.signOut();
    final s = c.read(appProvider);
    expect(s.sessions, {StRole.admin});
    expect(s.afterLogin, isNull);
    expect(s.denied, isNull);
    expect(s.current.id, 'AU-13');
  });

  test('back from AU-03 drops a stale intent', () {
    final c = stTestContainer();
    addTearDown(c.dispose);
    final ctrl = c.read(appProvider.notifier)
      ..go('AU-03')
      ..setAfterLogin(const NavEntry('A-02'));
    ctrl.back();
    expect(c.read(appProvider).afterLogin, isNull);
    expect(c.read(appProvider).current.id, 'AU-13');
  });

  test('AppState.t falls back to English on an empty Bangla string', () {
    const s = AppState(lang: StLang.bn);
    expect(s.t('Hello', ''), 'Hello');
    expect(s.t('Hello', '   '), 'Hello');
    expect(s.t('Hello', 'হ্যালো'), 'হ্যালো');
  });

  testWidgets('StDeniedScreen Back clears the refusal', (tester) async {
    final c = stTestContainer();
    addTearDown(c.dispose);
    c.read(appProvider.notifier).setRole(StRole.admin);
    await tester.pumpWidget(
        UncontrolledProviderScope(container: c, child: const SmartTiffinApp()));
    c.read(appProvider.notifier).go('NF-01');
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(StDeniedScreen), findsOneWidget);
    await tester.tap(find
        .descendant(
            of: find.byType(StDeniedScreen), matching: find.byType(StBtn))
        .first);
    await tester.pump(const Duration(milliseconds: 300));
    expect(c.read(appProvider).denied, isNull);
    expect(stBuiltIds.contains('NF-01'), isFalse);
  });
}
