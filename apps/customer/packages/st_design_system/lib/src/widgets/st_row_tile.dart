import 'package:flutter/material.dart';

import '../theme/st_colors.dart';
import '../theme/st_role_theme.dart';

class StRowTile extends StatelessWidget {
  const StRowTile({
    super.key,
    required this.label,
    this.sub,
    this.icon,
    this.onTap,
    this.right,
    this.danger = false,
  });

  final String label;
  final String? sub;
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? right;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final role = context.roleColor;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: danger ? StColors.danger.withValues(alpha: 0.1) : role.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 18, color: danger ? StColors.danger : role),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: danger ? StColors.danger : null)),
                  if (sub != null) Text(sub!, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                ],
              ),
            ),
            right ??
                (onTap != null
                    ? Icon(Icons.chevron_right, size: 16, color: Theme.of(context).hintColor)
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
