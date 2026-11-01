import 'package:flutter/material.dart';

import '../theme/st_role_theme.dart';

class StAvatar extends StatelessWidget {
  const StAvatar({super.key, required this.name, this.size = 44});
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final role = context.roleColor;
    final parts = name.trim().split(RegExp(r'\s+'));
    final ini = parts.take(2).map((p) => p.isEmpty ? '' : p[0]).join().toUpperCase();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: role.withValues(alpha: 0.15), shape: BoxShape.circle),
      child: Text(ini, style: TextStyle(color: role, fontWeight: FontWeight.w700, fontSize: size * 0.32)),
    );
  }
}
