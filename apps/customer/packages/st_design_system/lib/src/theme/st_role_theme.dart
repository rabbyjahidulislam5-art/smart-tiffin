import 'package:flutter/material.dart';

import 'st_colors.dart';

/// Theme extension that carries the accent of the active role.
///
/// Rebuilt from its uses: `StRoleTheme(role: ...)` is set by `StAppShell` and by
/// screens that pin an accent (`const StRoleTheme(role: StColors.supplier)`),
/// and widgets read it through `context.roleColor`.
@immutable
class StRoleTheme extends ThemeExtension<StRoleTheme> {
  const StRoleTheme({required this.role});

  final Color role;

  @override
  StRoleTheme copyWith({Color? role}) => StRoleTheme(role: role ?? this.role);

  @override
  StRoleTheme lerp(covariant ThemeExtension<StRoleTheme>? other, double t) {
    if (other is! StRoleTheme) return this;
    return StRoleTheme(role: Color.lerp(role, other.role, t) ?? role);
  }
}

/// `context.roleColor`: the accent of the nearest [StRoleTheme].
extension StRoleColorContext on BuildContext {
  Color get roleColor =>
      Theme.of(this).extension<StRoleTheme>()?.role ?? StColors.customer;
}
