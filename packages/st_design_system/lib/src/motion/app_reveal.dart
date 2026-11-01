import 'package:flutter/widgets.dart';

import 'app_motion.dart';

/// Staggered entrance: [child] fades in and rises slightly, [index] steps
/// after the first item.
///
/// Rebuilt from its 414 uses (`AppReveal(index: n, child: ...)`). The delay
/// is part of the animation (an [Interval]), so no timer is left pending when
/// the widget is disposed. Under reduced motion the child shows at once.
class AppReveal extends StatefulWidget {
  const AppReveal({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<AppReveal> createState() => _AppRevealState();
}

class _AppRevealState extends State<AppReveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);
  Animation<double> _t = const AlwaysStoppedAnimation<double>(1);
  bool _started = false;

  static const Offset _rise = Offset(0, 0.04);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.reduced(context)) {
      _c.value = 1;
      return;
    }
    final steps = widget.index.clamp(0, AppMotion.revealMaxSteps);
    final delay = AppMotion.revealStep * steps;
    final total = delay + AppMotion.md;
    final startAt = total.inMicroseconds == 0 ? 0.0 : delay.inMicroseconds / total.inMicroseconds;
    _c.duration = total;
    _t = CurvedAnimation(parent: _c, curve: Interval(startAt, 1, curve: AppMotion.enter));
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _t,
      child: SlideTransition(
        position: Tween<Offset>(begin: _rise, end: Offset.zero).animate(_t),
        child: widget.child,
      ),
    );
  }
}
