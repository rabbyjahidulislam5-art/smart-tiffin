import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_motion.dart';

/// Circular progress ring that sweeps to [value] (0..1) with [child] centred.
///
/// Rebuilt: the exported `lib/motion/app_progress.dart` was an empty stub.
/// Signature taken from its uses:
/// `AppProgressRing(value: 0.72, size: 72, stroke: 7, color: role, child: ...)`.
class AppProgressRing extends StatelessWidget {
  const AppProgressRing({
    super.key,
    required this.value,
    this.size = 48,
    this.stroke = 5,
    this.color,
    this.child,
  });

  final double value;
  final double size;
  final double stroke;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    final target = value.clamp(0.0, 1.0);
    return SizedBox.square(
      dimension: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: target),
        duration: AppMotion.reduced(context) ? Duration.zero : AppMotion.lg,
        curve: AppMotion.enter,
        builder: (context, v, inner) => CustomPaint(
          painter: _RingPainter(value: v, stroke: stroke, color: c),
          child: Center(child: inner),
        ),
        child: child,
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.value, required this.stroke, required this.color});

  final double value;
  final double stroke;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final track = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, track);
    if (value > 0) canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * value, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.stroke != stroke || old.color != color;
}
