import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class RiderEarningsScreen extends ConsumerWidget {
  const RiderEarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final days = [
      (t('Mon', 'সোম'), 520),
      (t('Tue', 'মঙ্গল'), 610),
      (t('Wed', 'বুধ'), 480),
      (t('Thu', 'বৃহ'), 700),
      (t('Fri', 'শুক্র'), 650),
    ];
    final maxDay = 700.0;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.rider)]),
      child: StScreen(
        title: t('Earnings', 'আয়'),
        actions: [
          StIconBtn(icon: Icons.history, label: 'History', onTap: () => ctrl.go('R-07')),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Column(
                  children: [
                    Text(t("Today's earnings", 'আজকের আয়'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                    const SizedBox(height: 4),
                    AppCountUp(
                      value: 650,
                      format: (v) => '৳${v.round()}',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: role),
                    ),
                    Text('12 ${t('deliveries', 'ডেলিভারি')}', style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor)),
                    const SizedBox(height: 12),
                    AppProgressRing(value: 0.72, size: 72, stroke: 7, color: role, child: Text('72%', style: TextStyle(fontWeight: FontWeight.w800, color: role, fontSize: 13))),
                    const SizedBox(height: 6),
                    Text(t('Weekly goal ৳900', 'সাপ্তাহিক লক্ষ্য ৳৯০০'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StSection(
                title: t('This week', 'এই সপ্তাহ'),
                child: StCard(
                  child: Column(
                    children: [
                      for (var i = 0; i < days.length; i++)
                        AppReveal(
                          index: i + 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                SizedBox(width: 44, child: Text(days[i].$1, style: TextStyle(fontWeight: i == 4 ? FontWeight.w800 : FontWeight.w500))),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(99),
                                    child: LinearProgressIndicator(
                                      value: days[i].$2 / maxDay,
                                      minHeight: 10,
                                      color: i == 4 ? role : role.withValues(alpha: 0.45),
                                      backgroundColor: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 56,
                                  child: Text('৳${days[i].$2}', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.w800, color: i == 4 ? role : null)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row( // layout-ok
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(t('Week total', 'সপ্তাহ মোট'), style: const TextStyle(fontWeight: FontWeight.w700)),
                            AppCountUp(
                              value: 2960,
                              format: (v) => '৳${v.round()}',
                              style: TextStyle(fontWeight: FontWeight.w800, color: role),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 7,
              child: StBtn(
                label: t('Request payout', 'পেমেন্ট অনুরোধ'),
                full: true,
                size: StBtnSize.lg,
                icon: Icons.payments_outlined,
                onTap: () => ctrl.showConfirm(
                  ConfirmOpts(
                    title: t('Request payout?', 'পেমেন্ট অনুরোধ?'),
                    body: t('৳2,960 will be sent to your bKash within 24h (demo).', '৳২,৯৬০ বিকাশে ২৪ ঘন্টার মধ্যে পাঠানো হবে।'),
                    ok: t('Request', 'অনুরোধ'),
                    onOk: () => ctrl.toast(t('Payout requested', 'পেমেন্ট অনুরোধ হয়েছে')),
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
