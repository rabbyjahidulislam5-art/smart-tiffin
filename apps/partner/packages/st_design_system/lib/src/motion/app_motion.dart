import 'package:flutter/widgets.dart';

/// Overall motion character. Scales every [AppMotion] duration.
enum MotionPersonality { calm, balanced, lively }

/// Motion tokens: durations, curves and the reduced-motion switch.
///
/// Rebuilt: the exported `lib/motion/app_motion.dart` was an empty stub.
/// The members are the ones the legacy code uses (`personality`, `reduced`,
/// `sm`, `md`, `lg`, `xl`, `enter`, `exitCurve`, `standard`). Timing follows
/// `FINAL_REFINED_DOCS/design/DESIGN_SYSTEM.md`: 120-180 ms state feedback
/// (`sm`), 200-260 ms page and sheet transitions (`md`), plus a
/// reduced-motion alternative.
abstract final class AppMotion {
  /// Set once in `main()`; `balanced` keeps the base durations.
  static MotionPersonality personality = MotionPersonality.balanced;

  static const Duration _sm = Duration(milliseconds: 150);
  static const Duration _md = Duration(milliseconds: 240);
  static const Duration _lg = Duration(milliseconds: 420);
  static const Duration _xl = Duration(milliseconds: 700);

  /// Stagger step between two [AppReveal] items, and the largest step count.
  static const Duration _revealStep = Duration(milliseconds: 45);
  static const int revealMaxSteps = 8;

  static double get _scale => switch (personality) {
        MotionPersonality.calm => 1.25,
        MotionPersonality.balanced => 1.0,
        MotionPersonality.lively => 0.8,
      };

  static Duration _scaled(Duration d) =>
      Duration(microseconds: (d.inMicroseconds * _scale).round());

  /// State feedback (toggles, segmented controls).
  static Duration get sm => _scaled(_sm);

  /// Page and sheet transitions, bumps.
  static Duration get md => _scaled(_md);

  /// Drawn success marks, progress rings.
  static Duration get lg => _scaled(_lg);

  /// Long gestures such as fly-to.
  static Duration get xl => _scaled(_xl);

  static Duration get revealStep => _scaled(_revealStep);

  /// Entering elements decelerate.
  static const Curve enter = Curves.easeOutCubic;

  /// Leaving elements accelerate.
  static const Curve exitCurve = Curves.easeInCubic;

  /// Symmetric moves.
  static const Curve standard = Curves.easeInOutCubic;

  /// True when the platform asks for reduced motion.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;
}
