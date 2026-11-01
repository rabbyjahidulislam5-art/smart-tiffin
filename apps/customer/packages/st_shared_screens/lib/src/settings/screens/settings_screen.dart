import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    return StScreen(
      title: t('Settings & language', 'সেটিংস ও ভাষা'),
      child: Column(
        children: [
          AppReveal(
            index: 0,
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(t('Language', 'ভাষা'), style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  StSegmented(
                    options: [(v: 'en', l: 'English'), (v: 'bn', l: 'বাংলা')],
                    value: s.lang == StLang.bn ? 'bn' : 'en',
                    onChanged: (v) => ctrl.setLang(v == 'bn' ? StLang.bn : StLang.en),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(t('Appearance', 'চেহারা'), style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  StSegmented(
                    options: [
                      (v: 'system', l: t('System', 'সিস্টেম')),
                      (v: 'light', l: t('Light', 'লাইট')),
                      (v: 'dark', l: t('Dark', 'ডার্ক')),
                    ],
                    value: s.themeMode.name,
                    onChanged: (v) => ctrl.setThemeMode(StThemeMode.values.byName(v)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 2,
            child: StList(
              children: [
                StRowTile(icon: Icons.notifications_none, label: t('Notification settings', 'নোটিফিকেশন সেটিংস'), onTap: () => ctrl.go('SH-09')),
                StRowTile(icon: Icons.mail_outline, label: t('Email history', 'ইমেইল ইতিহাস'), onTap: () => ctrl.go('SH-10')),
                StRowTile(icon: Icons.person_outline, label: t('Edit profile', 'প্রোফাইল সম্পাদনা'), onTap: () => ctrl.go('SH-08')),
                StRowTile(icon: Icons.help_outline, label: t('Help & support', 'সাহায্য ও সাপোর্ট'), onTap: () => ctrl.go('SH-04')),
                StRowTile(icon: Icons.privacy_tip_outlined, label: t('Privacy note', 'গোপনীয়তা'), onTap: () => ctrl.toast(t('Sample privacy summary', 'গোপনীয়তা সারাংশ (নমুনা)'))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
