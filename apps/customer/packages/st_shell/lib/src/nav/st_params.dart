import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_controller.dart';
import '../ui/st_sheet_scope.dart';

/// Parameters of the screen being built: the sheet's when shown as a sheet,
/// otherwise the current route's.
Map<String, String> stParamsOf(BuildContext context, WidgetRef ref) =>
    StSheetScope.maybeOf(context)?.params ?? ref.watch(appProvider.select((s) => s.current.params));
