import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class NotifSettingsScreen extends ConsumerStatefulWidget {
  const NotifSettingsScreen({super.key});
  @override
  ConsumerState<NotifSettingsScreen> createState() => _NotifSettingsScreenState();
}

class _NotifSettingsScreenState extends ConsumerState<NotifSettingsScreen> {
  final v = <String, bool>{'weekly-email': true, 'weekly-app': true, 'menu-app': true, 'offers-app': false};

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appProvider).t;
    final essential = [
      t('Order & delivery updates', 'অর্ডার ও ডেলিভারি আপডেট'),
      t('Payments, receipts & payouts', 'পেমেন্ট, রসিদ ও পেআউট'),
      t('Application decisions', 'আবেদনের সিদ্ধান্ত'),
      t('Security & sign-in alerts', 'নিরাপত্তা ও সাইন-ইন সতর্কতা'),
    ];
    final optional = [
      ('weekly', t('Weekly summary', 'সাপ্তাহিক সারাংশ')),
      ('menu', t('New menus & specials', 'নতুন মেনু ও স্পেশাল')),
      ('offers', t('Offers & discounts', 'অফার ও ছাড়')),
    ];
    return StScreen(
      title: t('Notification settings', 'নোটিফিকেশন সেটিংস'),
      states: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(index: 0, child: Text(t('Essential', 'জরুরি'), style: const TextStyle(fontWeight: FontWeight.w700))),
          const SizedBox(height: 8),
          AppReveal(
            index: 1,
            child: StCard(
              child: Column(
                children: [
                  for (final e in essential)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(child: Text(e, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                          StChip(tone: StTone.muted, icon: Icons.lock_outline, child: Text(t('Always on', 'সবসময় চালু'))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(index: 2, child: Text(t('Optional summaries', 'ঐচ্ছিক সারাংশ'), style: const TextStyle(fontWeight: FontWeight.w700))),
          const SizedBox(height: 8),
          for (var i = 0; i < optional.length; i++)
            AppReveal(
              index: i + 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(optional[i].$2, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row( // layout-ok
                        children: [
                          Text(t('In-app', 'অ্যাপে'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                          const SizedBox(width: 8),
                          StToggle(
                            value: v['${optional[i].$1}-app'] ?? false,
                            label: '${optional[i].$1}-app',
                            onChanged: (x) => setState(() => v['${optional[i].$1}-app'] = x),
                          ),
                          const SizedBox(width: 16),
                          Text(t('Email', 'ইমেইল'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                          const SizedBox(width: 8),
                          StToggle(
                            value: v['${optional[i].$1}-email'] ?? false,
                            label: '${optional[i].$1}-email',
                            onChanged: (x) => setState(() => v['${optional[i].$1}-email'] = x),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          AppReveal(
            index: 6,
            child: StNote(child: Text(t('Emails never contain NID images, codes or passwords.', 'ইমেইলে কখনো NID ছবি, কোড বা পাসওয়ার্ড থাকে না।'))),
          ),
          const SizedBox(height: 8),
          AppReveal(
            index: 7,
            child: StBtn(
              label: t('Open email history', 'ইমেইল ইতিহাস'),
              full: true,
              variant: StBtnVariant.soft,
              icon: Icons.mail_outline,
              onTap: () => ref.read(appProvider.notifier).go('SH-10'),
            ),
          ),
        ],
      ),
    );
  }
}
