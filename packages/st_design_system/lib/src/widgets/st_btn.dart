import 'package:flutter/material.dart';

import '../theme/st_colors.dart';
import '../theme/st_role_theme.dart';

enum StBtnVariant { primary, soft, outline, danger, ghost, success }

class StBtn extends StatelessWidget {
  const StBtn({
    super.key,
    required this.label,
    this.onTap,
    this.variant = StBtnVariant.primary,
    this.icon,
    this.full = false,
    this.disabled = false,
    this.reason,
    this.size = StBtnSize.md,
  });

  final String label;
  final VoidCallback? onTap;
  final StBtnVariant variant;
  final IconData? icon;
  final bool full;
  final bool disabled;
  final String? reason;
  final StBtnSize size;

  @override
  Widget build(BuildContext context) {
    final role = context.roleColor;
    final h = switch (size) { StBtnSize.sm => 36.0, StBtnSize.md => 44.0, StBtnSize.lg => 56.0 };
    final fs = switch (size) { StBtnSize.sm => 12.0, StBtnSize.md => 14.0, StBtnSize.lg => 16.0 };
    Color bg;
    Color fg;
    Border? border;
    if (disabled) {
      bg = Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted;
      fg = Theme.of(context).brightness == Brightness.dark ? StColors.darkMutedForeground : StColors.mutedForeground;
    } else {
      switch (variant) {
        case StBtnVariant.primary:
          bg = role;
          fg = Colors.white;
        case StBtnVariant.soft:
          bg = role.withValues(alpha: 0.12);
          fg = role;
        case StBtnVariant.outline:
          bg = Theme.of(context).cardColor;
          fg = Theme.of(context).colorScheme.onSurface;
          border = Border.all(color: Theme.of(context).dividerColor);
        case StBtnVariant.danger:
          bg = StColors.danger;
          fg = Colors.white;
        case StBtnVariant.ghost:
          bg = Colors.transparent;
          fg = role;
        case StBtnVariant.success:
          bg = StColors.success;
          fg = Colors.white;
      }
    }
    final btn = Material(
      color: bg,
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(99),
        child: Container(
          height: h,
          width: full ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(99), border: border),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: full ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 16, color: fg), const SizedBox(width: 8)],
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: fs),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (!disabled || reason == null) return btn;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        btn,
        const SizedBox(height: 4),
        Text(reason!, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
      ],
    );
  }
}

enum StBtnSize { sm, md, lg }
