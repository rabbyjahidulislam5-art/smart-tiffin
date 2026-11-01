import 'package:flutter/material.dart';

/// Smart Tiffin colour tokens.
///
/// Rebuilt: the exported `lib/theme/st_colors.dart` was 1 byte. Sources:
/// - Role accents and canvas: legacy prototype tokens (HSL) in
///   `FINAL_REFINED_DOCS/analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md` section 6,
///   which `FINAL_REFINED_DOCS/design/DESIGN_SYSTEM.md` names the primary
///   visual reference. Converted from HSL to sRGB.
/// - Accounting accent `#2B5A6B`: DESIGN_SYSTEM.md 2026-10-30 extension.
/// - Success, warning, danger and secondary text: DESIGN_SYSTEM.md token table.
/// - Info, muted, border and dark-mode neutrals: no documented value; derived
///   from the warm canvas hue (30) and recorded in IMPLEMENTATION_PROGRESS.md
///   for owner review.
abstract final class StColors {
  // Role accents
  /// Customer orange, hsl(24 95% 53%).
  static const customer = Color(0xFFF97015);

  /// Supplier green, hsl(158 64% 36%).
  static const supplier = Color(0xFF21976B);

  /// Rider blue, hsl(221 83% 53%).
  static const rider = Color(0xFF2463EB);

  /// Admin indigo, hsl(243 75% 59%).
  static const admin = Color(0xFF5048E5);

  /// Accounting slate-teal.
  static const accounting = Color(0xFF2B5A6B);

  /// Text and icons on role-coloured fills. Added in B2 (DD-6).
  static const onAccent = Color(0xFFFFFFFF);

  // Status
  static const success = Color(0xFF08744F);
  static const warning = Color(0xFF854A0E);
  static const danger = Color(0xFFB42318);
  static const info = Color(0xFF0369A1);

  // Light neutrals
  /// Warm cream canvas, hsl(30 33% 97.5%).
  static const background = Color(0xFFFBF9F7);

  /// Primary text, hsl(222 30% 13%).
  static const foreground = Color(0xFF171D2B);
  static const card = Color(0xFFFFFFFF);
  static const border = Color(0xFFE5E0DC);
  static const muted = Color(0xFFF1EDEA);
  static const mutedForeground = Color(0xFF52616D);

  // Dark neutrals
  /// Dark canvas, hsl(24 12% 8%).
  static const darkBackground = Color(0xFF171412);
  static const darkForeground = Color(0xFFF3F0ED);
  static const darkCard = Color(0xFF1F1C19);
  static const darkBorder = Color(0xFF3D3734);
  static const darkMuted = Color(0xFF2D2825);
  static const darkMutedForeground = Color(0xFFADA69F);

  /// Accent for a role name (`StRole.name`). Unknown names get the customer accent.
  static Color roleOf(String name) => switch (name) {
        'supplier' => supplier,
        'rider' => rider,
        'admin' => admin,
        'accounting' => accounting,
        _ => customer,
      };
}
