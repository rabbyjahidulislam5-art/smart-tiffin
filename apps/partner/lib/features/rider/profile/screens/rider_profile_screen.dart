import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class RiderProfileScreen extends ConsumerWidget {
  const RiderProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    return Theme(
      data: Theme.of(context)
          .copyWith(extensions: [const StRoleTheme(role: StColors.rider)]),
      child: StScreen(
        title: t('Rider Profile', 'রাইডার প্রোফাইল'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
                  children: [
                    const StAvatar(name: 'Rokon Talukder', size: 64),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Rokon Talukder',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 18)),
                          const SizedBox(height: 4),
                          StChip(
                              tone: StTone.warning,
                              child: const Text('4.9 ★ · 312 trips')),
                          Text('DHAKA-METRO-HA-1234',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).hintColor)),
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
              child: Row(
                children: [
                  Expanded(
                    child: StStat(
                      label: t('This week', 'এই সপ্তাহ'),
                      value: '48',
                      icon: Icons.local_shipping_outlined,
                      sub: Text(t('trips', 'ট্রিপ'),
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).hintColor)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StStat(
                      label: t('Earned', 'আয়'),
                      value: '৳2,960',
                      icon: Icons.account_balance_wallet_outlined,
                      onTap: () => ctrl.go('R-08'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 2,
              child: StCard(
                child: Column(
                  children: [
                    _Tile(
                        icon: Icons.badge_outlined,
                        label: t('NID verified', 'এনআইডি যাচাইকৃত'),
                        value: '✓'),
                    _Tile(
                        icon: Icons.two_wheeler,
                        label: t('Vehicle', 'যানবাহন'),
                        value: 'Honda Dio'),
                    _Tile(
                        icon: Icons.phone,
                        label: t('Phone', 'ফোন'),
                        value: '+880 17•••'),
                    _Tile(
                        icon: Icons.account_balance_wallet_outlined,
                        label: t('Payout', 'পেমেন্ট'),
                        value: 'bKash'),
                    _Tile(
                        icon: Icons.shield_outlined,
                        label: t('Insurance', 'বীমা'),
                        value: t('Active', 'সক্রিয়')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 3,
              child: StBtn(
                label: t('Edit profile', 'প্রোফাইল সম্পাদনা'),
                full: true,
                variant: StBtnVariant.outline,
                icon: Icons.edit_outlined,
                onTap: () => ctrl.go('SH-08'),
              ),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 4,
              child: StBtn(
                label: t('Settings', 'সেটিংস'),
                full: true,
                variant: StBtnVariant.soft,
                icon: Icons.settings_outlined,
                onTap: () => ctrl.go('SH-05'),
              ),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 5,
              child: StBtn(
                label: t('SOS / emergency', 'জরুরি'),
                full: true,
                variant: StBtnVariant.danger,
                icon: Icons.emergency_outlined,
                onTap: () => ctrl.go('R-05'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).hintColor),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      );
}
