import 'package:st_shell/st_shell.dart';

/// Records every id the shell asks the registry to build.
class StRegistrySpy {
  final List<String> built = [];

  /// A copy of [config] whose registry records the ids it builds.
  StShellConfig wrap(StShellConfig config) => StShellConfig(
    appTitle: config.appTitle,
    roles: config.roles,
    initialRole: config.initialRole,
    initialRoute: config.initialRoute,
    homeOf: config.homeOf,
    tabsOf: config.tabsOf,
    buildScreen: (id) {
      built.add(id);
      return config.buildScreen(id);
    },
    signInRoute: config.signInRoute,
    knownIds: config.knownIds,
    railTabsOf: config.railTabsOf,
    sheetIds: config.sheetIds,
    handoffFor: config.handoffFor,
  );
}
