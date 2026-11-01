import 'package:flutter/material.dart';

import 'st_chip.dart';

/// Status as icon plus text, never colour alone (DESIGN_SYSTEM.md).
class StStatusChip extends StatelessWidget {
  const StStatusChip({super.key, required this.label, this.tone = StTone.muted, this.icon});

  final String label;
  final StTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => StChip(tone: tone, icon: icon, child: Text(label));
}
