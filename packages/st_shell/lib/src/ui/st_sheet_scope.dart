import 'package:flutter/widgets.dart';

/// Marks content shown in the shell's bottom sheet and carries the parameters
/// of a sheet-form screen (NS-07, NR-03, NC-07, NC-09, NC-16). A sheet-form
/// screen built outside this scope (deep link, test) renders as a full screen.
class StSheetScope extends InheritedWidget {
  const StSheetScope({super.key, required this.params, required super.child});

  final Map<String, String> params;

  static StSheetScope? maybeOf(BuildContext context) => context.dependOnInheritedWidgetOfExactType<StSheetScope>();

  static bool isSheet(BuildContext context) => maybeOf(context) != null;

  @override
  bool updateShouldNotify(StSheetScope oldWidget) => oldWidget.params != params;
}
