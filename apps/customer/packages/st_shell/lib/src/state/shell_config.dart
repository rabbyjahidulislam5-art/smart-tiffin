import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

import 'tab_def.dart';

/// Builds the screen registered for a screen id (the app's registry).
typedef StScreenBuilder = Widget Function(String id);

/// Per-app shell configuration. Replaces the legacy global `homeOf`,
/// `tabsOf` and `buildStScreen` of the single-app prototype.
class StShellConfig {
  const StShellConfig({
    required this.appTitle,
    required this.roles,
    required this.initialRole,
    required this.initialRoute,
    required this.homeOf,
    required this.tabsOf,
    required this.buildScreen,
    String? signInRoute,
    this.knownIds = const {},
    this.railTabsOf = const {},
    this.sheetIds = const {},
    this.handoffFor,
  }) : signInRoute = signInRoute ?? initialRoute;

  final String appTitle;

  /// Roles this app serves (`appRoles` of the access policy).
  final Set<StRole> roles;

  /// Role whose accent the app shows before anyone signs in.
  final StRole initialRole;
  final String initialRoute;
  final Map<StRole, String> homeOf;
  final Map<StRole, List<TabDef>> tabsOf;
  final StScreenBuilder buildScreen;

  /// LC-3: target of `signOut()`; defaults to [initialRoute].
  final String signInRoute;

  /// LC-3: documented ids of the app; empty means not enforced.
  final Set<String> knownIds;

  /// LC-3: side-navigation entries per role; empty means use [tabsOf].
  final Map<StRole, List<TabDef>> railTabsOf;

  /// Ids whose specified form is a sheet (opened over the current screen).
  final Set<String> sheetIds;

  /// Sheet for an id that lives in another app (for example the Partner app
  /// hand-off for AU-09 in the Customer app), or null.
  final Widget? Function(String id)? handoffFor;

  List<TabDef> tabsFor(StRole role) => tabsOf[role] ?? const [];

  List<TabDef> railTabsFor(StRole role) {
    final rail = railTabsOf[role];
    return (rail == null || rail.isEmpty) ? tabsFor(role) : rail;
  }

  String homeFor(StRole role) => homeOf[role] ?? initialRoute;

  /// True when [id] is registered in this app (always true when not enforced).
  bool knows(String id) => knownIds.isEmpty || knownIds.contains(id);
}

/// The app's configuration; every app overrides it in its `ProviderScope`.
final shellConfigProvider = Provider<StShellConfig>(
  (ref) => throw UnimplementedError('Override shellConfigProvider with the app configuration.'),
);
