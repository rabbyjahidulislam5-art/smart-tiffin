import 'package:flutter/material.dart';

import '../theme/st_space.dart';

/// Lays out KPI tiles in two columns (compact), three (medium) or four (wide).
class StKpiGrid extends StatelessWidget {
  const StKpiGrid({super.key, required this.children, this.spacing = StSpace.xs});

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final cols = w >= 900 ? 4 : (w >= 560 ? 3 : 2);
        final itemW = ((w - spacing * (cols - 1)) / cols).floorToDouble();
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [for (final child in children) SizedBox(width: itemW, child: child)],
        );
      },
    );
  }
}
