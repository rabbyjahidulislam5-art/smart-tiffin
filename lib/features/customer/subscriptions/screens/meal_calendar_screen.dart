import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class MealCalendarScreen extends ConsumerWidget {
  const MealCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final week = [
      (1, t('Sat', 'শনি'), meals[1], true),
      (2, t('Sun', 'রবি'), meals[2], true),
      (3, t('Mon', 'সোম'), meals[1], true),
      (4, t('Tue', 'মঙ্গল'), meals[0], false),
      (5, t('Wed', 'বুধ'), meals[3], true),
      (6, t('Thu', 'বৃহ'), meals[4], true),
      (7, t('Fri', 'শুক্র'), meals[1], true),
    ];

    return StScreen(
      title: t('Meal calendar', 'মিল ক্যালেন্ডার'),
      actions: [
        StIconBtn(icon: Icons.pause_circle_outline, label: 'Pause', onTap: () => ctrl.go('C-14')),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StNote(child: Text(t('Tap a day to view or modify before cutoff.', 'কাটঅফের আগে দিন ট্যাপ করে দেখুন বা পরিবর্তন করুন।'))),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: StCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('November 2026', 'নভেম্বর ২০২৬'), style: const TextStyle(fontWeight: FontWeight.w800)),
                        Text(t('Monthly Homemade Package', 'মাসিক ঘরোয়া প্যাকেজ'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                      ],
                    ),
                  ),
                  StChip(tone: StTone.success, child: Text(t('22 meals left', '২২ মিল বাকি'))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(index: 2, child: Text(t('This week', 'এই সপ্তাহ'), style: const TextStyle(fontWeight: FontWeight.w800))),
          const SizedBox(height: 8),
          for (var i = 0; i < week.length; i++)
            AppReveal(
              index: i + 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StCard(
                  onTap: () => ctrl.showSheet(
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('${week[i].$2} · ${week[i].$1} Nov', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                week[i].$3.img,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(width: 48, height: 48, color: StColors.muted),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                week[i].$4
                                    ? t('${week[i].$3.en} · Lunch + Dinner', '${week[i].$3.bn} · লাঞ্চ + ডিনার')
                                    : t('Paused — no delivery', 'বিরতি — ডেলিভারি নেই'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (week[i].$4)
                          StBtn(
                            label: t('Modify meals', 'খাবার পরিবর্তন'),
                            full: true,
                            onTap: () {
                              ctrl.closeSheet();
                              ctrl.go('C-15');
                            },
                          )
                        else
                          StBtn(
                            label: t('Resume this day', 'এই দিন চালু'),
                            full: true,
                            variant: StBtnVariant.soft,
                            onTap: () {
                              ctrl.closeSheet();
                              ctrl.toast(t('Day resumed (sample)', 'দিন চালু (নমুনা)'));
                            },
                          ),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: week[i].$1 == 3 ? role.withValues(alpha: 0.15) : (Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${week[i].$1}', style: TextStyle(fontWeight: FontWeight.w800, color: week[i].$1 == 3 ? role : null)),
                            Text(week[i].$2, style: TextStyle(fontSize: 9, color: Theme.of(context).hintColor)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ColorFiltered(
                          colorFilter: week[i].$4
                              ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                              : const ColorFilter.matrix(<double>[0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0]),
                          child: Image.asset(
                            week[i].$3.img,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 48, height: 48, color: StColors.muted),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t(week[i].$3.en, week[i].$3.bn), style: TextStyle(fontWeight: FontWeight.w700, decoration: week[i].$4 ? null : TextDecoration.lineThrough)),
                            Text(
                              week[i].$4 ? t('Lunch · Dinner', 'লাঞ্চ · ডিনার') : t('Paused', 'বিরতি'),
                              style: TextStyle(fontSize: 12, color: week[i].$4 ? Theme.of(context).hintColor : StColors.danger),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Theme.of(context).hintColor),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          AppReveal(
            index: 10,
            child: StBtn(
              label: t('Pause meals', 'খাবার বিরতি'),
              full: true,
              variant: StBtnVariant.outline,
              icon: Icons.pause,
              onTap: () => ctrl.go('C-14'),
            ),
          ),
        ],
      ),
    );
  }
}
