import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class ModifyRoutineScreen extends ConsumerWidget {
  const ModifyRoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final slots = [
      (t('Lunch', 'লাঞ্চ'), t(meals[2].en, meals[2].bn), meals[2].img, true, Icons.wb_sunny_outlined),
      (t('Dinner', 'ডিনার'), t(meals[3].en, meals[3].bn), meals[3].img, false, Icons.nightlight_round),
    ];
    return StScreen(
      title: t("Modify today's meals", 'আজকের খাবার পরিবর্তন'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StNote(
              tone: StNoteTone.warning,
              child: Text(t('Lunch is locked after the 10:30 AM cutoff. Dinner can still be changed.', 'সকাল ১০:৩০ কাটঅফের পর লাঞ্চ লক। ডিনার এখনো বদলানো যায়।')),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < slots.length; i++)
            AppReveal(
              index: i + 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: StCard(
                  onTap: slots[i].$4 ? null : () => ctrl.go('C-04'),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          slots[i].$3,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: StColors.muted),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(slots[i].$5, size: 16, color: Theme.of(context).hintColor),
                                const SizedBox(width: 6),
                                Text(slots[i].$1, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
                              ],
                            ),
                            Text(slots[i].$2, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15), maxLines: 2, overflow: TextOverflow.ellipsis),
                            if (slots[i].$4)
                              StChip(tone: StTone.muted, child: Text(t('Locked', 'লক')))
                            else
                              Text(t('Tap to change', 'বদলাতে ট্যাপ'), style: TextStyle(fontSize: 12, color: StColors.customer)),
                          ],
                        ),
                      ),
                      if (!slots[i].$4) Icon(Icons.chevron_right, color: Theme.of(context).hintColor),
                    ],
                  ),
                ),
              ),
            ),
          AppReveal(
            index: 3,
            child: StBtn(
              label: t('Open full menu', 'পূর্ণ মেনু'),
              full: true,
              variant: StBtnVariant.soft,
              icon: Icons.restaurant_menu_outlined,
              onTap: () => ctrl.go('C-04'),
            ),
          ),
        ],
      ),
    );
  }
}
