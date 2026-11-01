import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../state/app_controller.dart';
import '../state/app_state.dart';
import 'st_screen.dart';
import 'st_state_view.dart';

/// Shown when a navigation is refused (LC-5). Uses the existing denied look of
/// `StStateView` and one Back control that calls `clearDenied()`.
class StDeniedScreen extends ConsumerWidget {
  const StDeniedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: StScreen(
        title: s.t('Access denied', 'প্রবেশাধিকার নেই'),
        back: false,
        states: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StStateView(variant: StVariant.denied),
            StBtn(
              label: s.t('Back', 'ফিরে যান'),
              icon: Icons.arrow_back_rounded,
              full: true,
              variant: StBtnVariant.soft,
              onTap: ctrl.clearDenied,
            ),
          ],
        ),
      ),
    );
  }
}
