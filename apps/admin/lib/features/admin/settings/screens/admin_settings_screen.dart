import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('Admin Settings', 'অ্যাডমিন সেটিংস'),
        back: false,
        child: Column(
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: StColors.admin.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.tune, color: StColors.admin),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t('Platform controls', 'প্ল্যাটফর্ম নিয়ন্ত্রণ'), style: const TextStyle(fontWeight: FontWeight.w800)),
                          Text(t('Escrow, windows, commission, SLAs', 'এস্ক্রো, উইন্ডো, কমিশন, SLA'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StSection(
                title: t('Operations policy', 'অপারেশন নীতি'),
                child: StList(
                  children: [
                    StRowTile(icon: Icons.account_balance, label: t('Escrow rules', 'এস্ক্রো নিয়ম'), sub: t('Hold until delivery + 2h', 'ডেলিভারি + ২ ঘণ্টা'), onTap: () => ctrl.go('A-16', {'s': 'escrow'})),
                    StRowTile(icon: Icons.schedule, label: t('Delivery windows', 'ডেলিভারি উইন্ডো'), sub: '12:00–14:00 · 19:00–21:00', onTap: () => ctrl.go('A-16', {'s': 'windows'})),
                    StRowTile(icon: Icons.percent, label: t('Commission rates', 'কমিশন হার'), sub: t('Platform 12%', 'প্ল্যাটফর্ম ১২%'), onTap: () => ctrl.go('A-16', {'s': 'commission'})),
                    StRowTile(icon: Icons.support_agent, label: t('Support SLAs', 'সাপোর্ট SLA'), sub: t('P1 under 10 min', 'P1 ১০ মিনিট'), onTap: () => ctrl.go('A-16', {'s': 'sla'})),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppReveal(
              index: 2,
              child: StSection(
                title: t('Access & logs', 'অ্যাক্সেস ও লগ'),
                child: StList(
                  children: [
                    StRowTile(icon: Icons.history, label: t('Audit log', 'অডিট লগ'), onTap: () => ctrl.go('A-17')),
                    StRowTile(icon: Icons.lock_outline, label: t('Security', 'নিরাপত্তা'), onTap: () => ctrl.go('A-18')),
                    StRowTile(icon: Icons.language, label: t('Language & notifications', 'ভাষা ও নোটিফিকেশন'), onTap: () => ctrl.go('SH-05')),
                    StRowTile(icon: Icons.person_outline, label: t('Admin profile', 'অ্যাডমিন প্রোফাইল'), onTap: () => ctrl.go('A-19')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
