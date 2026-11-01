import 'package:flutter/material.dart';

import '../theme/st_role_theme.dart';

class StSection extends StatelessWidget {
  const StSection({super.key, required this.title, required this.child, this.action, this.onAction});
  final String title;
  final Widget child;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final role = context.roleColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
            if (action != null)
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(foregroundColor: role, padding: EdgeInsets.zero),
                child: Row(
                  children: [
                    Text(action!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    const Icon(Icons.chevron_right, size: 14),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
