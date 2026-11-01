import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String f = 'all';

  List<({String en, String bn, String when, String to, Map<String, String>? p})> _items(StRole role) {
    return switch (role) {
      StRole.customer => [
        (en: 'Rider is nearby', bn: 'রাইডার কাছে', when: '2m', to: 'C-18', p: null),
        (en: 'Lunch confirmed · ৳360', bn: 'লাঞ্চ নিশ্চিত', when: '1h', to: 'C-17', p: {'id': 'TK-911'}),
        (en: 'Pause starts tomorrow', bn: 'কাল থেকে পজ', when: 'Yesterday', to: 'C-14', p: null),
        (en: 'Your renewal offer is ready', bn: 'আপনার নবায়ন অফার প্রস্তুত', when: '1d', to: 'NC-19', p: null),
      ],
      StRole.supplier => [
        (en: 'New order request #TK-911', bn: 'নতুন অর্ডার', when: '5m', to: 'S-02', p: {'id': 'TK-911'}),
        (en: 'Payout scheduled Friday', bn: 'শুক্র পেআউট', when: '2h', to: 'S-08', p: null),
        (en: 'Hygiene cert renews soon', bn: 'হাইজিন নবায়ন', when: '1d', to: 'S-11', p: null),
        (en: 'Payout request update', bn: 'পেআউট অনুরোধের আপডেট', when: '2d', to: 'NS-03', p: null),
      ],
      StRole.rider => [
        (en: 'New assignment offer', bn: 'নতুন অফার', when: '1m', to: 'R-10', p: null),
        (en: 'Earnings updated · ৳650', bn: 'আয় আপডেট', when: '3h', to: 'R-08', p: null),
        (en: 'Weekly tip summary', bn: 'সাপ্তাহিক টিপ', when: 'Mon', to: 'R-07', p: null),
        (en: 'COD remittance due today', bn: 'আজ সিওডি জমা দিতে হবে', when: '4h', to: 'NR-04', p: null),
      ],
      StRole.admin => [
        (en: 'Incident #INC-14 opened', bn: 'ঘটনা খোলা', when: '12m', to: 'A-02', p: null),
        (en: '3 cook apps pending', bn: '৩ আবেদন অপেক্ষমাণ', when: '1h', to: 'A-06', p: null),
        // A-13 item removed: the admin workspace has no payout route (requirement 8.4).
      ],
      StRole.accounting => [
        (en: 'Gateway statement has deviations', bn: 'গেটওয়ে স্টেটমেন্টে অমিল আছে', when: '30m', to: 'NF-17', p: null),
        (en: 'Period close checklist pending', bn: 'পিরিয়ড ক্লোজ চেকলিস্ট বাকি', when: '2h', to: 'NF-12', p: null),
        (en: 'Payout requests awaiting review', bn: 'পেআউট অনুরোধ পর্যালোচনার অপেক্ষায়', when: 'Today', to: 'NF-07', p: null),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = s.role;
    final items = _items(role);
    bool isRead(int i) => s.store.readAll || s.store.readIds.contains('${role.name}-$i');
    final unread = unreadCountOf(s.store, role);
    final shown = items.asMap().entries.where((e) => f == 'all' || !isRead(e.key)).toList();

    return StScreen(
      title: t('Notifications', 'নোটিফিকেশন'),
      actions: [
        StIconBtn(icon: Icons.tune_rounded, label: t('Notification settings', 'নোটিফিকেশন সেটিংস'), onTap: () => ctrl.go('SH-09')),
        const SizedBox(width: 4),
        StIconBtn(icon: Icons.mail_outline_rounded, label: t('Email history', 'ইমেইল ইতিহাস'), onTap: () => ctrl.go('SH-10')),
      ],
      child: Column(
        children: [
          AppReveal(
            index: 0,
            child: Row(
              children: [
                Expanded(
                  child: StSegmented(
                    options: [
                      (v: 'all', l: t('All', 'সব')),
                      (v: 'unread', l: '${t('Unread', 'অপঠিত')} ($unread)'),
                    ],
                    value: f,
                    onChanged: (v) => setState(() => f = v),
                  ),
                ),
                TextButton(
                  onPressed: unread == 0
                      ? null
                      : () {
                          ctrl.patchStore((st) => st.copyWith(readAll: true));
                          ctrl.toast(t('All marked read', 'সব পড়া হয়েছে'));
                        },
                  child: Text(
                    t('Mark all read', 'সব পড়া'),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: unread == 0 ? Theme.of(context).hintColor : context.roleColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (shown.isEmpty)
            AppReveal(
              index: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    Icon(Icons.notifications_none_rounded, size: 40, color: Theme.of(context).hintColor),
                    const SizedBox(height: 8),
                    Text(t("You're all caught up", 'সব পড়া হয়েছে'), style: TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            )
          else
            for (var i = 0; i < shown.length; i++)
              AppReveal(
                index: i + 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StCard(
                    color: isRead(shown[i].key) ? null : context.roleColor.withValues(alpha: 0.05),
                    onTap: () {
                      ctrl.patchStore((st) => st.copyWith(readIds: [...st.readIds, '${role.name}-${shown[i].key}']));
                      ctrl.go(shown[i].value.to, shown[i].value.p);
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: context.roleColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                          child: Icon(Icons.notifications_none_rounded, color: context.roleColor, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t(shown[i].value.en, shown[i].value.bn), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                              Text(shown[i].value.when, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                            ],
                          ),
                        ),
                        if (!isRead(shown[i].key)) Container(width: 8, height: 8, decoration: BoxDecoration(color: context.roleColor, shape: BoxShape.circle)),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
