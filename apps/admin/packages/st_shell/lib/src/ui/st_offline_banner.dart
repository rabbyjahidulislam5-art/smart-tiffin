import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../state/app_controller.dart';

/// Banner shown above loaded content while `AppState.offline` is true.
class StOfflineBanner extends ConsumerWidget {
  const StOfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    if (!s.offline) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: StSpace.sm),
      padding: const EdgeInsets.symmetric(horizontal: StSpace.md, vertical: StSpace.sm),
      decoration: BoxDecoration(color: StColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(StRadius.field)),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, size: StSize.iconSm, color: StColors.warning),
          const SizedBox(width: StSpace.xs),
          Expanded(
            child: Text(
              s.t("You're offline. Actions that need a connection are paused.", 'আপনি অফলাইনে। সংযোগ লাগে এমন কাজ বন্ধ আছে।'),
              style: const TextStyle(fontSize: StFont.label, fontWeight: FontWeight.w600, color: StColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}
