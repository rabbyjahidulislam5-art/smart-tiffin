import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_controller.dart';
import '../state/shell_config.dart';
import '../ui/st_sheet_scope.dart';

/// Opens [id]: an id that lives in another app shows that app's hand-off
/// sheet, a sheet-form id opens as a sheet over the current screen, and any
/// other id is a normal navigation decided by the access guard.
void stOpen(WidgetRef ref, String id, [Map<String, String>? params]) {
  final config = ref.read(shellConfigProvider);
  final ctrl = ref.read(appProvider.notifier);
  if (!config.knows(id)) {
    final sheet = config.handoffFor?.call(id);
    if (sheet != null) {
      ctrl.showSheet(sheet);
      return;
    }
  }
  if (config.sheetIds.contains(id)) {
    stOpenSheet(ref, id, params);
    return;
  }
  ctrl.go(id, params);
}

/// Opens the screen registered for [id] as a sheet. A refused id is handed to
/// `go`, which records the refusal and shows the denied screen.
void stOpenSheet(WidgetRef ref, String id, [Map<String, String>? params]) {
  final config = ref.read(shellConfigProvider);
  final ctrl = ref.read(appProvider.notifier);
  if (!ctrl.canOpen(id)) {
    ctrl.go(id, params);
    return;
  }
  ctrl.showSheet(StSheetScope(params: params ?? const {}, child: config.buildScreen(id)));
}

/// True when [id] can be opened from the current state (registered, allowed).
bool stCanOpen(WidgetRef ref, String id) => ref.read(appProvider.notifier).canOpen(id);
