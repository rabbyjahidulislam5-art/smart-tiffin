import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class KitchenProfileScreen extends ConsumerWidget {
  const KitchenProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.supplier)]),
      child: StScreen(
        title: t('Kitchen profile', 'কিচেন প্রোফাইল'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        meals[1].img,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const StAvatar(name: 'Rina Kitchen', size: 64),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Flexible(child: Text("Rina's Kitchen", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
                              const SizedBox(width: 4),
                              Icon(Icons.verified, color: role, size: 18),
                            ],
                          ),
                          Text('Rina Akter · Moghbazar', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                          const SizedBox(height: 4),
                          StChip(tone: StTone.success, child: Text(t('Verified cook', 'যাচাইকৃত রাঁধুনি'))),
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
                  Expanded(child: StStat(label: t("Today's orders", 'আজকের অর্ডার'), value: '24', icon: Icons.shopping_bag_outlined, onTap: () => ctrl.go('S-06'))),
                  const SizedBox(width: 8),
                  Expanded(child: StStat(label: t('Earnings', 'আয়'), value: '৳4.3k', icon: Icons.account_balance_wallet_outlined, onTap: () => ctrl.go('S-08'))),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 2,
              child: StList(
                children: [
                  StRowTile(icon: Icons.verified_outlined, label: t('Verification documents', 'যাচাই কাগজপত্র'), right: const StChip(tone: StTone.success, child: Text('3/3')), onTap: () => ctrl.go('S-11')),
                  StRowTile(icon: Icons.storefront_outlined, label: t('Operating settings', 'পরিচালনা সেটিংস'), onTap: () => ctrl.go('S-12')),
                  StRowTile(icon: Icons.restaurant_menu_outlined, label: t('Menu & stock', 'মেনু ও স্টক'), onTap: () => ctrl.go('S-04')),
                  StRowTile(icon: Icons.payments_outlined, label: t('Payout history', 'পেআউট ইতিহাস'), onTap: () => ctrl.go('S-09')),
                  StRowTile(icon: Icons.notifications_none, label: t('Notifications', 'নোটিফিকেশন'), onTap: () => ctrl.go('SH-01')),
                  StRowTile(icon: Icons.help_outline, label: t('Support', 'সাপোর্ট'), onTap: () => ctrl.go('SH-04')),
                  StRowTile(icon: Icons.settings_outlined, label: t('Settings & language', 'সেটিংস ও ভাষা'), onTap: () => ctrl.go('SH-05')),
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
