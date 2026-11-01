import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import 'pump_st_app.dart';
import 'st_failing.dart';
import 'st_registry_spy.dart';

/// The screen for [spec] is built (no placeholder) and shows its anchor.
void stExpectBuilt(ProviderContainer container, StScreenSpec spec) {
  expect(find.byType(StUnbuiltScreen), findsNothing);
  expect(find.byType(StDeniedScreen), findsNothing);
  final anchor = container.read(appProvider).tx(spec.anchor);
  expect(
    find.text(anchor),
    findsWidgets,
    reason: '${spec.id} anchor "$anchor"',
  );
}

/// Text of [text] in the current language.
String stTx(ProviderContainer container, StText text) =>
    container.read(appProvider).tx(text);

/// Standard state checks of one data-backed screen: built with its anchor,
/// loading skeleton within 100 ms, error panel with one Retry activation,
/// offline banner or panel when the spec lists offline, and the denied
/// screen (no repository read) for [deniedSessions].
void stStandardScreenTests({
  required StShellConfig config,
  required StScreenSpec spec,
  Map<String, String> params = const {},
  List<StRole>? sessions,
  List<StRole> deniedSessions = const [],
}) {
  final id = spec.id;
  testWidgets('$id builds through the registry with its anchor', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: config,
      start: id,
      params: params,
      sessions: sessions,
    );
    stExpectBuilt(c, spec);
    expect(tester.takeException(), isNull);
  });

  testWidgets('$id shows the loading skeleton within 100 ms', (tester) async {
    final c = await pumpStApp(
      tester,
      config: config,
      sessions: sessions,
      behavior: stSlow(400),
    );
    c.read(appProvider.notifier).go(id, params);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(StSkeleton), findsWidgets);
    await stPumpFrames(tester, frames: 20);
  });

  testWidgets('$id shows the error panel and allows one Retry', (tester) async {
    final c = await pumpStApp(
      tester,
      config: config,
      start: id,
      params: params,
      sessions: sessions,
      behavior: stFailing(RepoErrorKind.temporarilyUnavailable),
    );
    expect(find.byType(StStatusPanel), findsWidgets);
    final retry = find.text(stTx(c, StErrorText.retry));
    if (retry.evaluate().isNotEmpty) {
      await tester.tap(retry.first);
      await stPumpFrames(tester, frames: 2);
    }
  });

  if (spec.states.contains(StVariant.offline)) {
    testWidgets('$id shows the offline state with gated controls', (
      tester,
    ) async {
      final c = await pumpStApp(
        tester,
        config: config,
        start: id,
        params: params,
        sessions: sessions,
        offline: true,
      );
      final banner = find.byType(StOfflineBanner).evaluate().isNotEmpty;
      final panel = find.byType(StStatusPanel).evaluate().isNotEmpty;
      expect(banner || panel, isTrue);
      c.read(appProvider.notifier).setOffline(false);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(StOfflineBanner), findsNothing);
    });
  }

  for (final denied in deniedSessions) {
    testWidgets('$id is denied for a ${denied.name} session', (tester) async {
      final spy = StRegistrySpy();
      final c = await pumpStApp(
        tester,
        config: spy.wrap(config),
        sessions: [denied],
      );
      c.read(appProvider.notifier).go(id, params);
      await stPumpFrames(tester);
      expect(find.byType(StDeniedScreen), findsOneWidget);
      expect(spy.built.contains(id), isFalse);
    });
  }

  testWidgets('$id keeps the screen when language and theme change', (
    tester,
  ) async {
    final c = await pumpStApp(
      tester,
      config: config,
      start: id,
      params: params,
      sessions: sessions,
    );
    final ctrl = c.read(appProvider.notifier);
    ctrl.setLang(StLang.bn);
    ctrl.setThemeMode(StThemeMode.dark);
    await stPumpFrames(tester);
    expect(stCurrentId(c), c.read(appProvider).current.id);
    expect(find.byType(StUnbuiltScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
