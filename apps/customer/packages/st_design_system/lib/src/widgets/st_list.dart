import 'package:flutter/material.dart';

import 'st_card.dart';

class StList extends StatelessWidget {
  const StList({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return StCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) Divider(height: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.7)),
          ],
        ],
      ),
    );
  }
}
