import 'package:flutter/widgets.dart';

import 'st_host_entry.dart';

/// Wraps a Built host screen in the registry and supplies its added entries.
class StHostEntries extends InheritedWidget {
  const StHostEntries({super.key, required this.entries, required super.child});

  final List<StHostEntry> entries;

  static List<StHostEntry> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StHostEntries>()?.entries ?? const [];

  @override
  bool updateShouldNotify(StHostEntries oldWidget) => oldWidget.entries != entries;
}
