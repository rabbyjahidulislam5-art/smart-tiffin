import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../state/app_controller.dart';
import 'st_screen.dart';

/// Placeholder of a registry's default arm until the closeout batch (B20).
class StUnbuiltScreen extends ConsumerWidget {
  const StUnbuiltScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appProvider).t;
    return StScreen(
      title: id,
      states: false,
      child: StNote(child: Text(t('This screen is not built yet.', 'এই স্ক্রিন এখনো তৈরি হয়নি।'))),
    );
  }
}
