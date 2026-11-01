import 'package:flutter/material.dart';

import '../motion/app_motion.dart';
import '../theme/st_colors.dart';
import '../theme/st_role_theme.dart';

class StSegmented extends StatelessWidget {
  const StSegmented({super.key, required this.options, required this.value, required this.onChanged});
  final List<({String v, String l})> options;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final role = context.roleColor;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children: [
          for (final o in options)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(o.v),
                child: AnimatedContainer(
                  duration: AppMotion.sm,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: value == o.v ? Theme.of(context).cardColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: value == o.v
                        ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4)]
                        : null,
                  ),
                  child: Text(
                    o.l,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: value == o.v ? role : Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
