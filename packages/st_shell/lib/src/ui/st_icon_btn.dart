import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../state/app_controller.dart';
import '../state/st_store.dart';

class StIconBtn extends ConsumerWidget {
  const StIconBtn({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.dot = false,
    this.bg,
    this.fg,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool dot;
  final Color? bg;
  final Color? fg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final n = label == 'Notifications' ? unreadCountOf(s.store, s.role) : 0;
    final role = context.roleColor;
    return Material(
      color: bg ?? Theme.of(context).cardColor,
      shape: const CircleBorder(),
      elevation: 0.5,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 18, color: fg ?? Theme.of(context).colorScheme.onSurface),
              if (label == 'Notifications' && n > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: role,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: Theme.of(context).cardColor, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text('$n', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                )
              else if (dot)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: role,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).cardColor, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
