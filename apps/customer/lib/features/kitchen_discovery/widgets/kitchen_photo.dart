import 'package:flutter/material.dart';
import 'package:st_design_system/st_design_system.dart';

/// A kitchen or meal photo. The legacy images are not in this workspace
/// (Unavailable_Source), so a missing asset shows a neutral tile.
class KitchenPhoto extends StatelessWidget {
  const KitchenPhoto({
    super.key,
    required this.img,
    this.size = StSize.hero,
    this.icon = Icons.storefront_rounded,
  });

  final String img;
  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final role = context.roleColor;
    final fallback = Container(
      width: size,
      height: size,
      color: role.withValues(alpha: 0.1),
      child: Icon(icon, color: role, size: StSize.iconLg),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(StRadius.tile),
      child: img.isEmpty
          ? fallback
          : Image.asset(
              img,
              width: size,
              height: size,
              fit: BoxFit.cover,
              excludeFromSemantics: true,
              errorBuilder: (context, error, stackTrace) => fallback,
            ),
    );
  }
}
