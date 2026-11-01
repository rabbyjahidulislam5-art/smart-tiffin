import 'package:flutter/material.dart';

import '../theme/st_font.dart';
import '../theme/st_space.dart';

/// A label and value line for detail panels and sheets.
class StInfoRow extends StatelessWidget {
  const StInfoRow({super.key, required this.label, this.value, this.trailing});

  final String label;
  final String? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: StSpace.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: StFont.label, color: Theme.of(context).hintColor)),
          ),
          const SizedBox(width: StSpace.sm),
          Flexible(
            child: trailing ??
                Text(
                  value ?? '',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: StFont.body, fontWeight: FontWeight.w600),
                ),
          ),
        ],
      ),
    );
  }
}
