import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';

import '../nav/st_open.dart';
import '../state/app_controller.dart';

class QuickActions extends ConsumerWidget {
  const QuickActions({super.key, required this.kind});
  final String kind; // customer|supplier|rider|admin|guest

  static const _main =
      <String, List<({String en, String bn, IconData icon, String to})>>{
    'customer': [
      (
        en: 'Order',
        bn: 'অর্ডার',
        icon: Icons.shopping_bag_outlined,
        to: 'C-04'
      ),
      (
        en: 'Plans',
        bn: 'প্ল্যান',
        icon: Icons.calendar_today_outlined,
        to: 'C-10'
      ),
      (en: 'Track', bn: 'ট্র্যাক', icon: Icons.navigation_outlined, to: 'C-18'),
    ],
    'supplier': [
      (en: 'Menu', bn: 'মেনু', icon: Icons.restaurant_outlined, to: 'S-04'),
      (
        en: 'Orders',
        bn: 'অর্ডার',
        icon: Icons.receipt_long_outlined,
        to: 'S-06'
      ),
      (
        en: 'Cooking',
        bn: 'রান্না',
        icon: Icons.soup_kitchen_outlined,
        to: 'S-03'
      ),
    ],
    'rider': [
      (en: 'Navigate', bn: 'নেভিগেট', icon: Icons.route_outlined, to: 'R-02'),
      (en: 'Queue', bn: 'কিউ', icon: Icons.format_list_numbered, to: 'R-06'),
      (
        en: 'Earnings',
        bn: 'আয়',
        icon: Icons.account_balance_wallet_outlined,
        to: 'R-08'
      ),
    ],
    'admin': [
      (
        en: 'Applications',
        bn: 'আবেদন',
        icon: Icons.fact_check_outlined,
        to: 'A-06'
      ),
      (en: 'Incidents', bn: 'ঘটনা', icon: Icons.sos_outlined, to: 'A-03'),
      // Port adaptation: 'Payouts' (A-13) removed; the admin workspace has no
      // payout or settlement route (requirement 8.4). No screen uses kind 'admin'.
    ],
    'guest': [
      (en: 'Meals', bn: 'খাবার', icon: Icons.restaurant_outlined, to: 'P-02'),
      (
        en: 'Plans',
        bn: 'প্ল্যান',
        icon: Icons.calendar_today_outlined,
        to: 'P-03'
      ),
      (
        en: 'Kitchens',
        bn: 'কিচেন',
        icon: Icons.storefront_outlined,
        to: 'P-02'
      ),
    ],
  };

  static const _more =
      <String, List<({String en, String bn, IconData icon, String to})>>{
    'customer': [
      (en: 'Cart', bn: 'কার্ট', icon: Icons.shopping_cart_outlined, to: 'C-07'),
      (
        en: 'Meal calendar',
        bn: 'ক্যালেন্ডার',
        icon: Icons.calendar_month,
        to: 'C-13'
      ),
      (
        en: 'Pause meals',
        bn: 'বিরতি',
        icon: Icons.pause_circle_outline,
        to: 'C-14'
      ),
      (en: 'Billing', bn: 'বিল', icon: Icons.receipt_outlined, to: 'C-20'),
      (en: 'Addresses', bn: 'ঠিকানা', icon: Icons.place_outlined, to: 'C-02'),
      (en: 'Food prefs', bn: 'পছন্দ', icon: Icons.favorite_outline, to: 'C-24'),
      (
        en: 'Complaints',
        bn: 'অভিযোগ',
        icon: Icons.report_problem_outlined,
        to: 'C-25'
      ),
      (en: 'Support', bn: 'সাপোর্ট', icon: Icons.help_outline, to: 'SH-04'),
      (
        en: 'Kitchens',
        bn: 'কিচেন',
        icon: Icons.storefront_outlined,
        to: 'NC-01'
      ),
    ],
    'supplier': [
      (
        en: 'Earnings',
        bn: 'আয়',
        icon: Icons.account_balance_wallet_outlined,
        to: 'S-08'
      ),
      (
        en: 'Commitments',
        bn: 'প্রতিশ্রুতি',
        icon: Icons.event_available,
        to: 'S-07'
      ),
      (en: 'Payouts', bn: 'পেআউট', icon: Icons.payments_outlined, to: 'S-09'),
      (
        en: 'Kitchen profile',
        bn: 'প্রোফাইল',
        icon: Icons.storefront_outlined,
        to: 'S-10'
      ),
      (
        en: 'Documents',
        bn: 'কাগজপত্র',
        icon: Icons.verified_outlined,
        to: 'S-11'
      ),
      (
        en: 'Operating',
        bn: 'পরিচালনা',
        icon: Icons.settings_outlined,
        to: 'S-12'
      ),
      (
        en: 'Alerts',
        bn: 'সতর্কতা',
        icon: Icons.notifications_outlined,
        to: 'SH-09'
      ),
      (en: 'Support', bn: 'সাপোর্ট', icon: Icons.help_outline, to: 'SH-04'),
      (
        en: 'Forecast',
        bn: 'পূর্বাভাস',
        icon: Icons.insights_outlined,
        to: 'NS-04'
      ),
      (
        en: 'Capacity',
        bn: 'ধারণক্ষমতা',
        icon: Icons.tune_outlined,
        to: 'NS-05'
      ),
      (
        en: 'Price manager',
        bn: 'দাম ব্যবস্থাপনা',
        icon: Icons.sell_outlined,
        to: 'NS-06'
      ),
      (
        en: 'Handoff',
        bn: 'হস্তান্তর',
        icon: Icons.handshake_outlined,
        to: 'NS-07'
      ),
    ],
    'rider': [
      (en: 'History', bn: 'ইতিহাস', icon: Icons.history, to: 'R-07'),
      (en: 'New offer', bn: 'নতুন অফার', icon: Icons.two_wheeler, to: 'R-10'),
      (
        en: 'Proof',
        bn: 'প্রমাণ',
        icon: Icons.photo_camera_outlined,
        to: 'R-03'
      ),
      (en: 'Profile', bn: 'প্রোফাইল', icon: Icons.badge_outlined, to: 'R-09'),
      (en: 'Emails', bn: 'ইমেইল', icon: Icons.mail_outline, to: 'SH-10'),
      (en: 'Support', bn: 'সাপোর্ট', icon: Icons.help_outline, to: 'SH-04'),
    ],
    'admin': [
      (en: 'Users', bn: 'ইউজার', icon: Icons.groups_outlined, to: 'A-08'),
      (
        en: 'Orders',
        bn: 'অর্ডার',
        icon: Icons.receipt_long_outlined,
        to: 'A-10'
      ),
      // Port adaptation: 'Treasury' (A-12) removed (requirement 8.4).
      (en: 'Reports', bn: 'রিপোর্ট', icon: Icons.bar_chart_rounded, to: 'A-14'),
      (
        en: 'Audit log',
        bn: 'অডিট লগ',
        icon: Icons.article_outlined,
        to: 'A-17'
      ),
      (
        en: 'Security',
        bn: 'নিরাপত্তা',
        icon: Icons.shield_outlined,
        to: 'A-18'
      ),
      (en: 'Emails', bn: 'ইমেইল', icon: Icons.mail_outline, to: 'SH-10'),
      (en: 'Settings', bn: 'সেটিংস', icon: Icons.settings_outlined, to: 'A-15'),
    ],
    'guest': [
      (
        en: 'How it works',
        bn: 'কীভাবে কাজ করে',
        icon: Icons.info_outline,
        to: 'P-04'
      ),
      (
        en: 'Cook with us',
        bn: 'রাঁধুনি হোন',
        icon: Icons.soup_kitchen_outlined,
        to: 'P-04'
      ),
      (
        en: 'Deliver with us',
        bn: 'রাইডার হোন',
        icon: Icons.two_wheeler,
        to: 'P-04'
      ),
      (en: 'Sign in', bn: 'সাইন ইন', icon: Icons.login, to: 'AU-03'),
      (
        en: 'Create account',
        bn: 'অ্যাকাউন্ট খুলুন',
        icon: Icons.person_add_alt,
        to: 'AU-12'
      ),
    ],
  };

  Widget _tile(
      BuildContext context,
      WidgetRef ref,
      ({String en, String bn, IconData icon, String to}) q,
      VoidCallback onTap) {
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          constraints: const BoxConstraints(minHeight: 80),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.7)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: role.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16)),
                child: Icon(q.icon, color: role, size: 20),
              ),
              const SizedBox(height: 6),
              Text(t(q.en, q.bn),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final main = _main[kind]!;
    final more = _more[kind]!;
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.85,
      mainAxisExtent: MediaQuery.sizeOf(context).width <= 400 ? 104 : null,
      children: [
        for (final q in main) _tile(context, ref, q, () => stOpen(ref, q.to)),
        _tile(
          context,
          ref,
          (en: 'More', bn: 'আরও', icon: Icons.grid_view_rounded, to: ''),
          () {
            ctrl.showSheet(
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(t('More', 'আরও'),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.9,
                    children: [
                      for (final q in more)
                        _tile(context, ref, q, () {
                          ctrl.closeSheet();
                          final params = <String, String>{};
                          if (q.to == 'P-04') {
                            if (q.en.contains('Cook'))
                              params['r'] = 'supplier';
                            else if (q.en.contains('Deliver'))
                              params['r'] = 'rider';
                            else
                              params['r'] = 'customer';
                          }
                          if (q.to == 'P-02' && q.en == 'Kitchens')
                            params['tab'] = 'kitchens';
                          stOpen(ref, q.to, params.isEmpty ? null : params);
                        }),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
