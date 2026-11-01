import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    return StScreen(
      title: t('Customer profile', 'গ্রাহক প্রোফাইল'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StCard(
              child: Row(
                children: [
                  const StAvatar(name: 'Tanvir Ahmed', size: 72),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tanvir Ahmed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                        Text('+880 1712-892401', style: TextStyle(color: Theme.of(context).hintColor)),
                        const SizedBox(height: 6),
                        StChip(tone: StTone.success, child: Text(t('Active subscriber', 'সক্রিয় সাবস্ক্রাইবার'))),
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
                Expanded(child: StStat(label: t('This month', 'এই মাস'), value: '৳7,200', icon: Icons.receipt_long, onTap: () => ctrl.go('C-20'))),
                const SizedBox(width: 8),
                Expanded(child: StStat(label: t('Meals', 'খাবার'), value: '42', icon: Icons.restaurant_outlined, onTap: () => ctrl.go('C-16'))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 2,
            child: StCard(
              onTap: () => ctrl.go('C-17', {'id': 'TK-911'}),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      meals[1].img,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 52, height: 52, color: StColors.muted),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('Latest order', 'সাম্প্রতিক অর্ডার'), style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
                        Text('#TK-911 · ${t(meals[1].en, meals[1].bn)}', style: const TextStyle(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Theme.of(context).hintColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 3,
            child: StList(
              children: [
                StRowTile(icon: Icons.edit_outlined, label: t('Edit profile', 'প্রোফাইল সম্পাদনা'), onTap: () => ctrl.go('SH-08')),
                StRowTile(icon: Icons.favorite_outline, label: t('Food preferences', 'খাবার পছন্দ'), onTap: () => ctrl.go('C-24')),
                StRowTile(icon: Icons.place_outlined, label: t('Saved addresses', 'সংরক্ষিত ঠিকানা'), onTap: () => ctrl.go('C-02')),
                StRowTile(icon: Icons.report_problem_outlined, label: t('Complaints', 'অভিযোগ'), onTap: () => ctrl.go('C-25')),
                StRowTile(icon: Icons.settings_outlined, label: t('Settings', 'সেটিংস'), onTap: () => ctrl.go('SH-05')),
                StRowTile(
                  icon: Icons.logout_rounded,
                  label: t('Sign out', 'সাইন আউট'),
                  danger: true,
                  onTap: () => ctrl.showConfirm(
                    ConfirmOpts(
                      title: t('Sign out?', 'সাইন আউট?'),
                      ok: t('Sign out', 'সাইন আউট'),
                      danger: true,
                      onOk: ctrl.signOut, // LC-8: opens AU-03 (DN-1)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
