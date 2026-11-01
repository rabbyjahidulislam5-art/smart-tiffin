import 'package:flutter/material.dart';

import '../theme/st_role_theme.dart';
import 'st_card.dart';

class StStat extends StatelessWidget {
  const StStat({super.key, required this.label, required this.value, required this.icon, this.sub, this.onTap});
  final String label;
  final String value;
  final IconData icon;
  final Widget? sub;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final role = context.roleColor;
    return StCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: role.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 16, color: role),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          if (sub != null) ...[const SizedBox(height: 4), sub!],
        ],
      ),
    );
  }
}
