import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final heights = [40.0, 70.0, 55.0, 90.0, 80.0, 95.0, 60.0];
    final labels = [t('M', 'স'), t('T', 'ম'), t('W', 'ব'), t('T', 'ব'), t('F', 'শ'), t('S', 'শ'), t('S', 'র')];
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('Reports', 'রিপোর্ট'),
        child: Column(
          children: [
            AppReveal(
              index: 0,
              child: Row(
                children: [
                  Expanded(child: StStat(label: t('GMV today', 'আজকের GMV'), value: '৳84k', icon: Icons.trending_up, sub: AppCountUp(value: 12, format: (v) => '+${v.round()}%', style: TextStyle(fontSize: 11, color: StColors.success, fontWeight: FontWeight.w700)))),
                  const SizedBox(width: 8),
                  Expanded(child: StStat(label: t('On-time', 'সময়মতো'), value: '94%', icon: Icons.schedule)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 1,
              child: Row(
                children: [
                  Expanded(child: StStat(label: t('Active subs', 'সক্রিয় সাব'), value: '312', icon: Icons.calendar_month)),
                  const SizedBox(width: 8),
                  Expanded(child: StStat(label: t('NPS', 'NPS'), value: '62', icon: Icons.sentiment_satisfied_alt)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppReveal(
              index: 2,
              child: StCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('Weekly deliveries', 'সাপ্তাহিক ডেলিভারি'), style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (var i = 0; i < heights.length; i++)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AppReveal(
                                      index: i + 3,
                                      child: Container(
                                        height: heights[i],
                                        decoration: BoxDecoration(color: role.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(labels[i], style: TextStyle(fontSize: 10, color: Theme.of(context).hintColor)),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 10,
              child: StBtn(label: t('Export CSV', 'CSV এক্সপোর্ট'), full: true, variant: StBtnVariant.outline, onTap: () => ctrl.toast(t('Report exported (sample)', 'রিপোর্ট এক্সপোর্ট'))),
            ),
          ],
        ),
      ),
    );
  }
}
