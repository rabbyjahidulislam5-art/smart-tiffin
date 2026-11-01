import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_shell/st_shell.dart';

/// Ids the shell asked the test registry to build, in order.
final List<String> stBuiltIds = [];

Widget _stTestBuild(String id) {
  stBuiltIds.add(id);
  return Text('screen $id');
}

/// A two-role test app (admin and accounting) with an enforced id set.
const stTestConfig = StShellConfig(
  appTitle: 'Shell test',
  roles: {StRole.admin, StRole.accounting},
  initialRole: StRole.admin,
  initialRoute: 'AU-13',
  signInRoute: 'AU-13',
  homeOf: {StRole.admin: 'A-01', StRole.accounting: 'NF-01'},
  tabsOf: {},
  buildScreen: _stTestBuild,
  knownIds: {'AU-03', 'AU-13', 'A-01', 'A-02', 'NF-01', 'SH-01'},
);

/// A container for [stTestConfig]; disposed after the test.
ProviderContainer stTestContainer() {
  stBuiltIds.clear();
  final c = ProviderContainer(
      overrides: [shellConfigProvider.overrideWithValue(stTestConfig)]);
  return c;
}
