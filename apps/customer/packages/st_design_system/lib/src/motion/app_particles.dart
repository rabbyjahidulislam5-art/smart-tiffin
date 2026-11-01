import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/st_colors.dart';
import '../theme/st_role_theme.dart';
import 'app_motion.dart';

/// One-shot confetti burst drawn behind a success result.
///
/// Rebuilt: the exported `lib/motion/app_particles.dart` was an empty stub.
/// The only use is `const AppConfetti()` inside `IgnorePointer` on the
/// payment result screen (C-09). Colours are the role accent plus the
/// success and warning tokens; under reduced motion nothing is drawn.
class AppConfetti extends StatefulWidget {
  const AppConfetti({super.key, this.count = 36});

  final int count;

  @override
  State<AppConfetti> createState() => _AppConfettiState();
}

class _AppConfettiState extends State<AppConfetti> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);
  late final List<_Bit> _bits = _makeBits(widget.count);
  bool _started = false;
  bool _reduced = false;

  static List<_Bit> _makeBits(int n) {
    final r = math.Random(7);
    return List.generate(n, (i) {
      final angle = -math.pi / 2 + (r.nextDouble() - 0.5) * math.pi * 0.9;
      return _Bit(
        angle: angle,
        speed: 0.45 + r.nextDouble() * 0.55,
        spin: (r.nextDouble() - 0.5) * 8,
        size: 4 + r.nextDouble() * 5,
        tone: i % 3,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _reduced = AppMotion.reduced(context);
    if (_reduced) return;
    _c.duration = AppMotion.xl * 2;
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reduced) return const SizedBox.shrink();
    final colors = [context.roleColor, StColors.success, StColors.warning];
    return CustomPaint(
      painter: _ConfettiPainter(progress: _c, bits: _bits, colors: colors),
      size: Size.infinite,
    );
  }
}

class _Bit {
  const _Bit({required this.angle, required this.speed, required this.spin, required this.size, required this.tone});

  final double angle;
  final double speed;
  final double spin;
  final double size;
  final int tone;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress, required this.bits, required this.colors})
      : super(repaint: progress);

  final Animation<double> progress;
  final List<_Bit> bits;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t <= 0 || t >= 1) return;
    final origin = Offset(size.width / 2, size.height * 0.32);
    final reach = math.min(size.width, size.height) * 0.6;
    final fade = 1 - Curves.easeIn.transform(t);
    for (final b in bits) {
      final d = reach * b.speed * Curves.easeOutCubic.transform(t);
      final gravity = reach * 0.5 * t * t;
      final p = origin + Offset(math.cos(b.angle) * d, math.sin(b.angle) * d + gravity);
      final paint = Paint()..color = colors[b.tone].withValues(alpha: fade);
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(b.spin * t);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: b.size, height: b.size * 0.6), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress || old.colors != colors;
}
