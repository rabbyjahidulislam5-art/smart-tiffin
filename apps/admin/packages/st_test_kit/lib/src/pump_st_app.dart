import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// Pumps [SmartTiffinApp] for [config] with instant mocks.
///
/// [sessions] are signed in in order, so the last one is the active role;
/// by default the role of [start] is signed in (none for AU-, SH- and P- ids).
/// An empty list keeps a guest. [start] opens through `reset`, so a refused
/// id leaves the initial route with the denied screen over it.
Future<ProviderContainer> pumpStApp(
  WidgetTester tester, {
  required StShellConfig config,
  String? start,
  Map<String, String> params = const {},
  List<StRole>? sessions,
  StLang lang = StLang.en,
  StThemeMode theme = StThemeMode.light,
  double width = 360,
  double height = 800,
  MockBehavior? behavior,
  List<Override> overrides = const [],
  bool offline = false,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final container = ProviderContainer(
    overrides: [
      shellConfigProvider.overrideWithValue(config),
      mockBehaviorProvider.overrideWithValue(
        behavior ?? MockBehavior.instant(),
      ),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);
  final ctrl = container.read(appProvider.notifier);
  final startRole = start == null ? null : roleForScreenId(start);
  for (final r in sessions ?? [if (startRole != null) startRole]) {
    ctrl.setRole(r);
  }
  ctrl.setLang(lang);
  ctrl.setThemeMode(theme);
  if (offline) ctrl.setOffline(true);
  if (start != null) ctrl.reset(start, params);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const SmartTiffinApp(),
    ),
  );
  await stPumpFrames(tester);
  return container;
}

/// Pumps a bounded number of frames (never waits for endless animations).
Future<void> stPumpFrames(WidgetTester tester, {int frames = 12}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// Id of the screen on top of the stack.
String stCurrentId(ProviderContainer container) =>
    container.read(appProvider).current.id;
