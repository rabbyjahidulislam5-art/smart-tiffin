import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../state/app_controller.dart';
import '../state/app_state.dart';

class StStateView extends ConsumerWidget {
  const StStateView({super.key, required this.variant});
  final StVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appProvider).t;
    final ctrl = ref.read(appProvider.notifier);
    if (variant == StVariant.loading) {
      return Column(
        children: List.generate(
          3,
          (i) => Container(
            height: 96,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }
    final (icon, en, bn, sEn, sBn) = switch (variant) {
      StVariant.empty => (Icons.inbox_outlined, 'Nothing here yet', 'এখানে এখনো কিছু নেই', 'New items will appear here.', 'নতুন আইটেম এখানে দেখাবে।'),
      StVariant.error => (Icons.warning_amber_rounded, 'Something went wrong', 'কিছু ভুল হয়েছে', 'Please try again.', 'আবার চেষ্টা করুন।'),
      StVariant.offline => (Icons.wifi_off_rounded, "You're offline", 'আপনি অফলাইনে', 'Check your connection.', 'ইন্টারনেট সংযোগ দেখুন।'),
      StVariant.denied => (Icons.lock_outline, 'Access denied', 'প্রবেশাধিকার নেই', 'Your account role cannot open this.', 'আপনার অ্যাকাউন্ট এটি খুলতে পারবে না।'),
      _ => (Icons.inbox_outlined, 'Nothing here yet', 'এখানে এখনো কিছু নেই', '', ''),
    };
    final role = context.roleColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: role.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
            child: Icon(icon, color: role, size: 28),
          ),
          const SizedBox(height: 12),
          Text(t(en, bn), style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(t(sEn, sBn), style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
          if (variant == StVariant.error || variant == StVariant.offline) ...[
            const SizedBox(height: 12),
            StBtn(label: t('Retry', 'আবার চেষ্টা'), variant: StBtnVariant.soft, onTap: () => ctrl.setVariant(StVariant.normal)),
          ],
        ],
      ),
    );
  }
}
