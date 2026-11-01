import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'st_colors.dart';
import 'st_role_theme.dart';

/// Light and dark [ThemeData] for a role accent.
///
/// Rebuilt from its uses in `main.dart` (`StTheme.light(role:)`,
/// `StTheme.dark(role:)`, `StTheme.overlayFor(brightness, background)`) and in
/// the widgets, which read `cardColor`, `dividerColor`, `hintColor`,
/// `scaffoldBackgroundColor` and `colorScheme.onSurface/surface/onPrimary`.
abstract final class StTheme {
  static ThemeData light({required Color role}) => _build(Brightness.light, role);

  static ThemeData dark({required Color role}) => _build(Brightness.dark, role);

  /// System bar style: transparent bars, icons that contrast with [background].
  static SystemUiOverlayStyle overlayFor(Brightness brightness, Color background) {
    final dark = brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      statusBarBrightness: dark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: background,
      systemNavigationBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    );
  }

  static ThemeData _build(Brightness brightness, Color role) {
    final dark = brightness == Brightness.dark;
    final background = dark ? StColors.darkBackground : StColors.background;
    final foreground = dark ? StColors.darkForeground : StColors.foreground;
    final card = dark ? StColors.darkCard : StColors.card;
    final border = dark ? StColors.darkBorder : StColors.border;
    final hint = dark ? StColors.darkMutedForeground : StColors.mutedForeground;
    final scheme = ColorScheme.fromSeed(seedColor: role, brightness: brightness).copyWith(
      primary: role,
      onPrimary: StColors.card,
      secondary: role,
      onSecondary: StColors.card,
      error: StColors.danger,
      onError: StColors.card,
      surface: card,
      onSurface: foreground,
      outline: border,
      outlineVariant: border,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      cardColor: card,
      dividerColor: border,
      hintColor: hint,
      splashFactory: InkRipple.splashFactory,
      extensions: [StRoleTheme(role: role)],
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: foreground, displayColor: foreground),
      iconTheme: IconThemeData(color: foreground),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: foreground,
        contentTextStyle: TextStyle(color: background, fontWeight: FontWeight.w600),
      ),
      textSelectionTheme: TextSelectionThemeData(cursorColor: role),
    );
  }
}
