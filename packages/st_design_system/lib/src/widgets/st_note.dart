import 'package:flutter/material.dart';

import '../theme/st_colors.dart';
import '../theme/st_role_theme.dart';

class StNote extends StatelessWidget {
  const StNote({super.key, required this.child, this.tone = StNoteTone.info});
  final Widget child;
  final StNoteTone tone;

  @override
  Widget build(BuildContext context) {
    final role = context.roleColor;
    final bg = switch (tone) {
      StNoteTone.warning => StColors.warning.withValues(alpha: 0.1),
      StNoteTone.policy => Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
      StNoteTone.info => role.withValues(alpha: 0.05),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: tone == StNoteTone.policy
            ? Border.all(color: Theme.of(context).dividerColor, style: BorderStyle.solid)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: role),
          const SizedBox(width: 8),
          Expanded(child: DefaultTextStyle(style: const TextStyle(fontSize: 12), child: child)),
        ],
      ),
    );
  }
}

enum StNoteTone { info, warning, policy }
