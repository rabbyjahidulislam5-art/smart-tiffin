import 'package:flutter/material.dart';
import 'package:st_design_system/st_design_system.dart';

import 'st_money_text.dart';

/// KPI tile for an amount in minor units, in the legacy `StStat` look; the
/// figure goes through `StMoneyText`, so it is scaled down, never clipped.
class StMoneyStat extends StatelessWidget {
  const StMoneyStat({
    super.key,
    required this.label,
    required this.minor,
    required this.icon,
    this.caption,
    this.tone,
    this.onTap,
  });

  final String label;
  final int minor;
  final IconData icon;
  final String? caption;
  final Color? tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = tone ?? context.roleColor;
    final hint = Theme.of(context).hintColor;
    return StCard(
      onTap: onTap,
      padding: const EdgeInsets.all(StSpace.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(fontSize: StFont.micro, fontWeight: FontWeight.w700, color: hint),
                ),
              ),
              Container(
                width: StSize.statBox,
                height: StSize.statBox,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(StRadius.sm),
                ),
                child: Icon(icon, size: StSize.iconSm, color: color),
              ),
            ],
          ),
          const SizedBox(height: StSpace.xxs),
          StMoneyText.minor(minor, style: const TextStyle(fontSize: StFont.stat, fontWeight: FontWeight.w800)),
          if (caption != null) ...[
            const SizedBox(height: StSpace.xxs),
            Text(caption!, style: TextStyle(fontSize: StFont.caption, color: hint)),
          ],
        ],
      ),
    );
  }
}
