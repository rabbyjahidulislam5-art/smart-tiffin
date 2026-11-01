import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class EmailHistoryScreen extends ConsumerWidget {
  const EmailHistoryScreen({super.key});

  StTone _tone(String st) => switch (st) {
        'Delivered' => StTone.success,
        'Accepted by provider' => StTone.info,
        'Failed' => StTone.danger,
        _ => StTone.warning,
      };

  String _label(String Function(String, String) t, String st) => switch (st) {
        'Delivered' => t('Delivered', 'পৌঁছেছে'),
        'Accepted by provider' => t('Accepted by provider', 'প্রোভাইডার গ্রহণ করেছে'),
        'Failed' => t('Failed', 'ব্যর্থ'),
        _ => t('Queued', 'সারিতে'),
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final list = [
      (id: 'EM-2041', en: 'Order #TK-911 confirmed · BDT 360', bn: 'অর্ডার #TK-911 নিশ্চিত · ৳৩৬০', to: 'tanvir@…', when: '12:21', st: 'Delivered'),
      (id: 'EM-2040', en: 'Application ST-APP-0412 approved', bn: 'আবেদন ST-APP-0412 অনুমোদিত', to: 'sultana@…', when: '11:05', st: 'Accepted by provider'),
      (id: 'EM-2039', en: 'Weekly payout BDT 18,400 sent', bn: 'সাপ্তাহিক পেআউট ৳১৮,৪০০ পাঠানো', to: 'rina@…', when: 'Mon', st: 'Failed'),
      (id: 'EM-2038', en: 'New sign-in on Android', bn: 'অ্যান্ড্রয়েডে নতুন সাইন-ইন', to: 'nadia@…', when: 'Sun', st: 'Queued'),
      (id: 'EM-2037', en: 'Subscription renewed · Oct', bn: 'সাবস্ক্রিপশন নবায়ন · অক্টোবর', to: 'tanvir@…', when: '1 Oct', st: 'Delivered'),
    ];
    return StScreen(
      title: t('Email history', 'ইমেইল ইতিহাস'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StNote(
              tone: StNoteTone.policy,
              child: Text(t('Sample statuses — no real emails are sent from this prototype.', 'নমুনা অবস্থা — এই প্রোটোটাইপ থেকে আসল ইমেইল যায় না।')),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < list.length; i++)
            AppReveal(
              index: i + 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t(list[i].en, list[i].bn), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                Text('${list[i].id} · ${list[i].to} · ${list[i].when}', style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
                              ],
                            ),
                          ),
                          StChip(tone: _tone(list[i].st), child: Text(_label(t, list[i].st))),
                        ],
                      ),
                      if (list[i].st == 'Failed') ...[
                        const SizedBox(height: 8),
                        StBtn(
                          label: t('Retry send', 'আবার পাঠান'),
                          size: StBtnSize.sm,
                          variant: StBtnVariant.soft,
                          icon: Icons.refresh,
                          onTap: () => ctrl.toast(t('Retry queued (sample)', 'আবার সারিতে')),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          if (s.role == StRole.admin || s.role == StRole.accounting) ...[
            const SizedBox(height: 8),
            AppReveal(
              index: 6,
              child: StSection(
                title: t('Template preview', 'টেমপ্লেট প্রিভিউ'),
                child: StList(
                  children: [
                    StRowTile(icon: Icons.mail_outline, label: t('Application approved', 'আবেদন অনুমোদিত'), onTap: () => ctrl.toast(t('Preview opened (sample)', 'প্রিভিউ'))),
                    StRowTile(icon: Icons.mail_outline, label: t('Order confirmed', 'অর্ডার নিশ্চিত'), onTap: () => ctrl.toast(t('Preview opened (sample)', 'প্রিভিউ'))),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
