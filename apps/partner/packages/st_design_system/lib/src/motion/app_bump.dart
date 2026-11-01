import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_motion.dart';

/// Scales [child] in a quick bump whenever [trigger] changes — the bag badge
/// when an item lands, a counter when it ticks, a tab icon on new content.
class AppBump extends StatefulWidget {
  const AppBump({super.key, required this.trigger, required this.child, this.amount = 0.28});

  final Object? trigger;
  final Widget child;
  final double amount;

  @override
  State<AppBump> createState() => _AppBumpState();
}

class _AppBumpState extends State<AppBump> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: AppMotion.md);

  @override
  void didUpdateWidget(AppBump old) {
    super.didUpdateWidget(old);
    if (old.trigger != widget.trigger && !AppMotion.reduced(context)) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) => Transform.scale(
        scale: 1 + widget.amount * math.sin(_c.value * math.pi),
        child: child,
      ),
      child: widget.child,
    );
  }
}
