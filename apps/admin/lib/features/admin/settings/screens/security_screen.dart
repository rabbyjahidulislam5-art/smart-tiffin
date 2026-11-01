import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});
  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  bool twoStep = true;

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('Security', 'নিরাপত্তা'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
                  children: [
                    const StAvatar(name: 'Nadia Islam', size: 48),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nadia Islam', style: TextStyle(fontWeight: FontWeight.w800)),
                          Text(t('Super Admin · signed in', 'সুপার অ্যাডমিন · সাইন ইন'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                        ],
                      ),
                    ),
                    StChip(tone: StTone.success, child: Text(t('Secure', 'সুরক্ষিত'))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StList(
                children: [
                  StRowTile(
                    icon: Icons.lock_outline,
                    label: t('Change admin PIN', 'অ্যাডমিন পিন বদল'),
                    onTap: () => ctrl.toast(t('PIN change (demo)', 'পিন বদল (নমুনা)')),
                  ),
                  StRowTile(
                    icon: Icons.devices,
                    label: t('Active sessions', 'সক্রিয় সেশন'),
                    sub: '2 devices · Dhaka & web',
                    onTap: () => ctrl.toast(t('Sessions listed (demo)', 'সেশন তালিকা')),
                  ),
                  StRowTile(
                    icon: Icons.shield_outlined,
                    label: t('2-step for payouts', 'পেআউটে ২-ধাপ'),
                    right: StToggle(
                      value: twoStep,
                      onChanged: (v) => setState(() => twoStep = v),
                      label: '2-step',
                    ),
                    onTap: () => setState(() => twoStep = !twoStep),
                  ),
                  StRowTile(
                    icon: Icons.history,
                    label: t('View audit log', 'অডিট লগ দেখুন'),
                    onTap: () => ctrl.go('A-17'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 2,
              child: StNote(
                tone: StNoteTone.policy,
                child: Text(t('Admin secure sign-in uses the hidden AU-13 flow with OTP code 123456 in this prototype.', 'অ্যাডমিন সাইন-ইন AU-13 · OTP ১২৩৪৫৬।')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
