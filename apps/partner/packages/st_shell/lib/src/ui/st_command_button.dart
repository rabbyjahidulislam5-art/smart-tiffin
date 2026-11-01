import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../state/app_controller.dart';

/// A command control: disabled while [busy], while offline (requirement 11.6)
/// or when [disabledReason] is given, and then it shows the reason.
class StCommandButton extends ConsumerWidget {
  const StCommandButton({
    super.key,
    required this.label,
    required this.onTap,
    this.busy = false,
    this.disabledReason,
    this.variant = StBtnVariant.primary,
    this.icon,
    this.full = true,
    this.size = StBtnSize.md,
    this.needsConnection = true,
  });

  final String label;
  final VoidCallback? onTap;
  final bool busy;
  final String? disabledReason;
  final StBtnVariant variant;
  final IconData? icon;
  final bool full;
  final StBtnSize size;
  final bool needsConnection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final offlineReason = needsConnection && s.offline ? s.t('Needs a connection', 'সংযোগ প্রয়োজন') : null;
    final reason = disabledReason ?? offlineReason;
    return StBtn(
      label: busy ? s.t('Working…', 'কাজ চলছে…') : label,
      icon: icon,
      variant: variant,
      full: full,
      size: size,
      disabled: busy || reason != null || onTap == null,
      reason: busy ? null : reason,
      onTap: onTap,
    );
  }
}
