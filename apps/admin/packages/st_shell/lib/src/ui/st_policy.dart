import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../state/app_controller.dart';

class StPolicy extends ConsumerWidget {
  const StPolicy({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appProvider).t;
    return StNote(
      tone: StNoteTone.policy,
      child: Text(t('Policy pending — final rule not yet approved. Sample only.', 'নীতিমালা অপেক্ষমাণ — চূড়ান্ত নিয়ম অনুমোদিত হয়নি। নমুনা মাত্র।')),
    );
  }
}
