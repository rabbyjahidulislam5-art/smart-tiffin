import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_controller.dart';

/// Gates a control that needs connectivity (requirement 11.6): while offline
/// [builder] gets `enabled == false` and a localized reason; other controls
/// are not affected. Re-enables in the same frame when offline ends.
class StNeedsConnection extends ConsumerWidget {
  const StNeedsConnection({super.key, required this.builder});

  final Widget Function(BuildContext context, bool enabled, String? reason) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline = ref.watch(appProvider.select((s) => s.offline));
    final t = ref.watch(appProvider).t;
    return builder(context, !offline, offline ? t('Needs a connection', 'সংযোগ প্রয়োজন') : null);
  }
}
