import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../state/app_controller.dart';
import 'st_error_text.dart';

/// Neutral "no longer available" panel. Identical for an absent record and a
/// record the user may not view, so it never reveals which (requirement 5.8).
class StUnavailablePanel extends ConsumerWidget {
  const StUnavailablePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final role = context.roleColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: StSpace.xxl),
      child: Column(
        children: [
          Container(
            width: StSize.hero,
            height: StSize.hero,
            decoration: BoxDecoration(color: role.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(StRadius.card)),
            child: Icon(Icons.visibility_off_outlined, color: role, size: StSize.iconLg),
          ),
          const SizedBox(height: StSpace.sm),
          Text(s.tx(StErrorText.unavailable), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: StSpace.xxs),
          Text(
            s.tx(StErrorText.unavailableSub),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: StFont.body, color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: StSpace.sm),
          StBtn(label: s.tx(StErrorText.back), variant: StBtnVariant.soft, icon: Icons.arrow_back_rounded, onTap: ctrl.back),
        ],
      ),
    );
  }
}
