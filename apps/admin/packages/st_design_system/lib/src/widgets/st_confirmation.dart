import 'package:flutter/material.dart';

import '../motion/app_draw_check.dart';
import '../theme/st_colors.dart';
import '../theme/st_font.dart';
import '../theme/st_radius.dart';
import '../theme/st_size.dart';
import '../theme/st_space.dart';
import '../theme/st_timing.dart';

/// Success banner that stays visible for [StTiming.confirmationHold] or until
/// the user dismisses it (requirement 14.5). The hold is an animation, not a
/// timer, so nothing is left pending when the widget is disposed.
class StConfirmation extends StatefulWidget {
  const StConfirmation({
    super.key,
    required this.message,
    required this.onDismissed,
    this.dismissLabel = 'Dismiss',
    this.hold = StTiming.confirmationHold,
  });

  final String message;
  final String dismissLabel;
  final VoidCallback onDismissed;
  final Duration hold;

  @override
  State<StConfirmation> createState() => _StConfirmationState();
}

class _StConfirmationState extends State<StConfirmation> with SingleTickerProviderStateMixin {
  late final AnimationController _hold = AnimationController(vsync: this, duration: widget.hold)
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) widget.onDismissed();
    })
    ..forward();

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: StSpace.md, vertical: StSpace.sm),
        decoration: BoxDecoration(
          color: StColors.success.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(StRadius.field),
          border: Border.all(color: StColors.success.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Container(
              width: StSize.statBox,
              height: StSize.statBox,
              decoration: const BoxDecoration(color: StColors.success, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const AppDrawCheck(size: StSize.icon, color: StColors.onAccent),
            ),
            const SizedBox(width: StSpace.sm),
            Expanded(
              child: Text(
                widget.message,
                style: const TextStyle(fontSize: StFont.body, fontWeight: FontWeight.w700, color: StColors.success),
              ),
            ),
            IconButton(
              tooltip: widget.dismissLabel,
              onPressed: widget.onDismissed,
              icon: const Icon(Icons.close_rounded, size: StSize.iconMd, color: StColors.success),
            ),
          ],
        ),
      ),
    );
  }
}
