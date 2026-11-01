import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:st_shell/st_shell.dart';

import 'pump_st_app.dart';

/// Drives a multi-screen flow and records the screen ids it passes.
class StFlowRunner {
  StFlowRunner(this.tester, this.container);

  final WidgetTester tester;
  final ProviderContainer container;
  final List<String> visited = [];

  AppState get state => container.read(appProvider);

  String get currentId => state.current.id;

  bool get sheetOpen => state.sheet != null;

  /// Asserts the current screen and records it.
  void expectAt(String id) {
    expect(
      currentId,
      id,
      reason: 'flow expected $id after ${visited.join(' > ')}',
    );
    visited.add(id);
  }

  Future<void> tapText(String text) async {
    final f = find.text(text).first;
    await tester.ensureVisible(f);
    await tester.tap(f);
    await stPumpFrames(tester);
  }

  Future<void> tapKey(Key key) async {
    final f = find.byKey(key).first;
    await tester.ensureVisible(f);
    await tester.tap(f);
    await stPumpFrames(tester);
  }

  Future<void> enterText(Finder field, String text) async {
    await tester.ensureVisible(field);
    await tester.enterText(field, text);
    await stPumpFrames(tester, frames: 2);
  }

  /// Opens [id] the way an entry control does (`stOpen`).
  Future<void> open(String id, [Map<String, String>? params]) async {
    final ctrl = container.read(appProvider.notifier);
    final config = container.read(shellConfigProvider);
    if (config.sheetIds.contains(id)) {
      ctrl.showSheet(
        StSheetScope(params: params ?? const {}, child: config.buildScreen(id)),
      );
    } else {
      ctrl.go(id, params);
    }
    await stPumpFrames(tester);
  }
}
