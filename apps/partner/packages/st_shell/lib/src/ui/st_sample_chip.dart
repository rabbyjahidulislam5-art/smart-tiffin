import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../state/app_controller.dart';

class StSampleChip extends ConsumerWidget {
  const StSampleChip({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appProvider).t;
    return StChip(tone: StTone.warning, child: Text(t('Sample', 'নমুনা')));
  }
}
