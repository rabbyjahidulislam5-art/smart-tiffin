import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class CommitmentsScreen extends ConsumerWidget {
  const CommitmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final days = [
      (t('Mon', 'সোম'), 40, 30),
      (t('Tue', 'মঙ্গল'), 39, 29),
      (t('Wed', 'বুধ'), 38, 28),
      (t('Thu', 'বৃহ'), 37, 27),
      (t('Fri', 'শুক্র'), 36, 26),
      (t('Sat', 'শনি'), 35, 25),
    ];
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.supplier)]),
      child: StScreen(
        title: t('Subscription commitments', 'সাবস্ক্রিপশন প্রতিশ্রুতি'),
        actions: [
          StIconBtn(icon: Icons.soup_kitchen_outlined, label: 'Cooking', onTap: () => ctrl.go('S-03')),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: Row(
                children: [
                  Expanded(
                    child: StStat(
                      label: t('Active subscribers', 'সক্রিয় গ্রাহক'),
                      value: '38',
                      icon: Icons.groups_outlined,
                      sub: AppCountUp(value: 38, format: (v) => '${v.round()} locked-in', style: TextStyle(fontSize: 11, color: role, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: StStat(label: t('Paused tomorrow', 'আগামীকাল বিরতি'), value: '4', icon: Icons.event_available)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StNote(
                tone: StNoteTone.policy,
                child: Text(t('These counts drive tomorrow’s cooking requirements.', 'এই সংখ্যা আগামীকালের রান্নার চাহিদা নির্ধারণ করে।')),
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < days.length; i++)
              AppReveal(
                index: i + 2,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 40, child: Text(days[i].$1, style: const TextStyle(fontWeight: FontWeight.w800))),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text(t('Lunch', 'লাঞ্চ'), style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor))),
                                      Text('${days[i].$2}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(99),
                                    child: LinearProgressIndicator(
                                      value: days[i].$2 / 45,
                                      minHeight: 8,
                                      color: role,
                                      backgroundColor: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(child: Text(t('Dinner', 'ডিনার'), style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor))),
                                      Text('${days[i].$3}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(99),
                                    child: LinearProgressIndicator(
                                      value: days[i].$3 / 35,
                                      minHeight: 8,
                                      color: role.withValues(alpha: 0.55),
                                      backgroundColor: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
