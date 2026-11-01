import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stored scroll offsets per screen key (not auto-disposed, so a screen that
/// is rebuilt after navigation restores its position; requirement 5.7).
final stScrollOffsetsProvider =
    StateProvider<Map<String, double>>((ref) => const {});

/// Creates a [ScrollController] at the stored offset for [key] and writes the
/// offset back when scrolling ends. Pass the controller to
/// `StScreen(scrollController:)` and wrap the body with [track].
class StScrollMemory {
  StScrollMemory(this.ref, this.key);

  final WidgetRef ref;
  final String key;

  double get stored => ref.read(stScrollOffsetsProvider)[key] ?? 0;

  ScrollController create() => ScrollController(initialScrollOffset: stored);

  Widget track({required Widget child}) =>
      NotificationListener<ScrollEndNotification>(
        onNotification: (n) {
          // Only the screen's own vertical scroll view counts; chip rows and
          // nested lists report their own notifications.
          if (n.depth == 0 && n.metrics.axis == Axis.vertical)
            save(n.metrics.pixels);
          return false;
        },
        child: child,
      );

  void save(double offset) {
    ref.read(stScrollOffsetsProvider.notifier).state = {
      ...ref.read(stScrollOffsetsProvider),
      key: offset
    };
  }
}
