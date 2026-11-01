import 'package:flutter/material.dart';

import '../theme/st_colors.dart';
import '../theme/st_role_theme.dart';

class StLogoMark extends StatelessWidget {
  const StLogoMark({super.key, this.size = 80});
  final double size;

  @override
  Widget build(BuildContext context) {
    final role = context.roleColor;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.35),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [role, StColors.warning],
        ),
        boxShadow: [BoxShadow(color: role.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Icon(Icons.restaurant, color: Colors.white, size: size * 0.45),
    );
  }
}
