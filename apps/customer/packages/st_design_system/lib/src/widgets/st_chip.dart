import 'package:flutter/material.dart';

import '../theme/st_colors.dart';
import '../theme/st_role_theme.dart';

enum StTone { role, success, warning, danger, muted, info }

class StChip extends StatelessWidget {
  const StChip(
      {super.key, required this.child, this.tone = StTone.muted, this.icon});

  final Widget child;
  final StTone tone;
  final IconData? icon;

  Color _bg(BuildContext c) {
    final role = c.roleColor;
    return switch (tone) {
      StTone.role => role.withValues(alpha: 0.12),
      StTone.success => StColors.success.withValues(alpha: 0.15),
      StTone.warning => StColors.warning.withValues(alpha: 0.15),
      StTone.danger => StColors.danger.withValues(alpha: 0.1),
      StTone.info => StColors.info.withValues(alpha: 0.1),
      StTone.muted => Theme.of(c).brightness == Brightness.dark
          ? StColors.darkMuted
          : StColors.muted,
    };
  }

  Color _fg(BuildContext c) {
    final role = c.roleColor;
    return switch (tone) {
      StTone.role => role,
      StTone.success => StColors.success,
      StTone.warning => StColors.warning,
      StTone.danger => StColors.danger,
      StTone.info => StColors.info,
      StTone.muted => Theme.of(c).brightness == Brightness.dark
          ? StColors.darkMutedForeground
          : StColors.mutedForeground,
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = DefaultTextStyle(
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _fg(context),
          ),
          child: child,
        );
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _bg(context),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12, color: _fg(context)),
                const SizedBox(width: 4),
              ],
              if (constraints.hasBoundedWidth)
                Flexible(fit: FlexFit.loose, child: content)
              else
                content,
            ],
          ),
        );
      },
    );
  }
}
