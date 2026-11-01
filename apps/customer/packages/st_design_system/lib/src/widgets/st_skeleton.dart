import 'package:flutter/material.dart';

import '../theme/st_colors.dart';
import '../theme/st_radius.dart';
import '../theme/st_size.dart';
import '../theme/st_space.dart';

/// Loading placeholder: the loading look of the legacy `StStateView`
/// (three muted rounded rows), composed from existing tokens.
class StSkeleton extends StatelessWidget {
  const StSkeleton({super.key, this.rows = 3, this.rowHeight = StSize.skeletonRow});

  final int rows;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      label: 'Loading',
      child: Column(
        children: List.generate(
          rows,
          (i) => Container(
            height: rowHeight,
            margin: const EdgeInsets.only(bottom: StSpace.sm),
            decoration: BoxDecoration(
              color: dark ? StColors.darkMuted : StColors.muted,
              borderRadius: BorderRadius.circular(StRadius.field),
            ),
          ),
        ),
      ),
    );
  }
}
