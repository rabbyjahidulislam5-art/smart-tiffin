import 'package:flutter/material.dart';

import '../theme/st_colors.dart';
import '../theme/st_role_theme.dart';

class StTimeline extends StatelessWidget {
  const StTimeline({super.key, required this.steps, required this.current});
  final List<({String label, String? sub, IconData icon})> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    final role = context.roleColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          Expanded(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (i > 0)
                      Positioned(
                        left: 0,
                        right: MediaQuery.sizeOf(context).width,
                        child: const SizedBox.shrink(),
                      ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: i <= current ? role : (Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted),
                        shape: BoxShape.circle,
                        boxShadow: i == current
                            ? [BoxShadow(color: role.withValues(alpha: 0.25), blurRadius: 8, spreadRadius: 4)]
                            : null,
                      ),
                      child: Icon(
                        i < current ? Icons.check : steps[i].icon,
                        size: 16,
                        color: i <= current ? Colors.white : Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  steps[i].label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: i == current ? role : null),
                ),
                if (steps[i].sub != null)
                  Text(steps[i].sub!, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Theme.of(context).hintColor)),
              ],
            ),
          ),
      ],
    );
  }
}
