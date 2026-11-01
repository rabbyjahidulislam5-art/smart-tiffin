import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';

import '../state/app_controller.dart';

/// Sheet that explains that a step continues in another Smart Tiffin app
/// (CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md section 2.3). Opening the other app
/// stays disabled with its reason until its distribution is decided (DEC-010).
class StHandoffSheet extends ConsumerWidget {
  const StHandoffSheet({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.openLabel,
  });

  final IconData icon;
  final StText title;
  final StText body;
  final StText openLabel;

  static const pendingReason = StText(
    'Where the app is distributed is not decided yet (DEC-010).',
    'অ্যাপটি কোথায় পাওয়া যাবে তা এখনো ঠিক হয়নি (DEC-010)।',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final role = context.roleColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: StSize.btn,
            height: StSize.btn,
            decoration: BoxDecoration(color: role.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(StRadius.field)),
            child: Icon(icon, color: role, size: StSize.icon),
          ),
        ),
        const SizedBox(height: StSpace.sm),
        Text(s.tx(title), style: const TextStyle(fontSize: StFont.heading, fontWeight: FontWeight.w800)),
        const SizedBox(height: StSpace.xs),
        Text(s.tx(body), style: TextStyle(color: Theme.of(context).hintColor, height: 1.4)),
        const SizedBox(height: StSpace.md),
        StBtn(label: s.tx(openLabel), full: true, size: StBtnSize.lg, disabled: true, reason: s.tx(pendingReason)),
        const SizedBox(height: StSpace.xs),
        StBtn(label: s.t('Close', 'বন্ধ করুন'), full: true, variant: StBtnVariant.outline, onTap: ctrl.closeSheet),
      ],
    );
  }
}
