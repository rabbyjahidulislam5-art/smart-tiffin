import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class AdminProfileScreen extends ConsumerWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('Admin Profile', 'অ্যাডমিন প্রোফাইল'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
                  children: [
                    const StAvatar(name: 'Nadia Islam', size: 64),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nadia Islam', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                          Text(t('Super Admin · Smart Tiffin', 'সুপার অ্যাডমিন · স্মার্ট টিফিন'), style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor)),
                          const SizedBox(height: 6),
                          StChip(tone: StTone.success, child: Text(t('Verified owner', 'যাচাইকৃত মালিক'))),
                        ],
                      ),
                    ),
                    StBtn(label: t('Edit', 'এডিট'), size: StBtnSize.sm, variant: StBtnVariant.soft, onTap: () => ctrl.go('SH-08')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: Row(
                children: [
                  Expanded(
                    child: StStat(
                      label: t('Actions today', 'আজকের কাজ'),
                      value: '14',
                      icon: Icons.bolt_outlined,
                      sub: AppCountUp(value: 14, format: (v) => '${v.round()} logged', style: TextStyle(fontSize: 11, color: role, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StStat(
                      label: t('Open incidents', 'খোলা ঘটনা'),
                      value: '2',
                      icon: Icons.warning_amber_outlined,
                      onTap: () => ctrl.go('A-03'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 2,
              child: StList(
                children: [
                  StRowTile(icon: Icons.lock_outline, label: t('Security', 'নিরাপত্তা'), onTap: () => ctrl.go('A-18')),
                  StRowTile(icon: Icons.settings_outlined, label: t('Settings & language', 'সেটিংস ও ভাষা'), onTap: () => ctrl.go('SH-05')),
                  StRowTile(icon: Icons.history, label: t('Audit log', 'অডিট লগ'), onTap: () => ctrl.go('A-17')),
                  StRowTile(icon: Icons.help_outline, label: t('Support', 'সাপোর্ট'), onTap: () => ctrl.go('SH-04')),
                  StRowTile(
                    icon: Icons.logout,
                    label: t('Sign out', 'সাইন আউট'),
                    danger: true,
                    onTap: () => ctrl.showConfirm(
                      ConfirmOpts(
                        title: t('Sign out?', 'সাইন আউট?'),
                        ok: t('Sign out', 'সাইন আউট'),
                        danger: true,
                        onOk: ctrl.signOut, // LC-8
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
