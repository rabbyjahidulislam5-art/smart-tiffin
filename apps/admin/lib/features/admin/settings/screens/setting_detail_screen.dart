import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class SettingDetailScreen extends ConsumerWidget {
  const SettingDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final key = s.current.params['s'] ?? 'escrow';
    final titles = {
      'escrow': (
        t('Escrow rules', 'এস্ক্রো নিয়ম'),
        t('Hold cook payout until delivery confirmed + 2h buffer.', 'ডেলিভারি নিশ্চিত + ২ ঘণ্টা বাফার পর পেআউট।'),
        [
          t('Customer prepaid → escrow', 'গ্রাহক প্রিপেইড → এস্ক্রো'),
          t('Delivery confirmed by rider', 'রাইডার ডেলিভারি নিশ্চিত'),
          t('2-hour dispute window', '২ ঘণ্টা বিরোধ উইন্ডো'),
          t('Release to cook + rider fee', 'রাঁধুনি + রাইডার ফি রিলিজ'),
        ],
      ),
      'windows': (
        t('Delivery windows', 'ডেলিভারি উইন্ডো'),
        t('Lunch 12:00–14:00 · Dinner 19:00–21:00 (Dhaka).', 'লাঞ্চ ১২–২ · ডিনার ৭–৯ (ঢাকা)।'),
        [
          t('Cutoff lunch orders: 10:30 AM', 'লাঞ্চ কাটঅফ: সকাল ১০:৩০'),
          t('Cutoff dinner orders: 5:30 PM', 'ডিনার কাটঅফ: বিকেল ৫:৩০'),
          t('Zones: Banani, Gulshan, Dhanmondi, Mirpur', 'জোন: বনানী, গুলশান, ধানমন্ডি, মিরপুর'),
        ],
      ),
      'commission': (
        t('Commission rates', 'কমিশন হার'),
        t('Platform 12% · Rider fee ৳40–৳60 by zone.', 'প্ল্যাটফর্ম ১২% · রাইডার ৳৪০–৬০।'),
        [
          t('Cook net after platform fee', 'প্ল্যাটফর্ম ফি বাদ রাঁধুনি নেট'),
          t('Rider fee paid from escrow line', 'রাইডার ফি এস্ক্রো লাইন থেকে'),
          t('Subscription plans: same %', 'সাবস্ক্রিপশন: একই %'),
        ],
      ),
      'sla': (
        t('Support SLAs', 'সাপোর্ট SLA'),
        t('P1 incidents: first response under 10 minutes.', 'P1: ১০ মিনিটের মধ্যে প্রথম সাড়া।'),
        [
          t('P1 · Rider offline / food safety', 'P1 · রাইডার অফলাইন / খাদ্য নিরাপত্তা'),
          t('P2 · Missing item disputes', 'P2 · মিসিং আইটেম বিরোধ'),
          t('P3 · General support tickets', 'P3 · সাধারণ টিকিট'),
        ],
      ),
    };
    final info = titles[key] ?? titles['escrow']!;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: info.$1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(child: Text(info.$2, style: const TextStyle(fontWeight: FontWeight.w600, height: 1.4))),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('How it works', 'কীভাবে কাজ করে'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
                    const SizedBox(height: 8),
                    for (var i = 0; i < info.$3.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${i + 1}.', style: const TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(info.$3[i])),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 2,
              child: StNote(tone: StNoteTone.policy, child: Text(t('Editing live policy is disabled in this prototype.', 'এই প্রোটোটাইপে লাইভ নীতি সম্পাদনা বন্ধ।'))),
            ),
            const SizedBox(height: 16),
            AppReveal(
              index: 3,
              child: StBtn(label: t('Request change', 'পরিবর্তন অনুরোধ'), full: true, icon: Icons.edit_note_outlined, onTap: () => ctrl.toast(t('Change request logged (sample)', 'পরিবর্তন অনুরোধ লগ'))),
            ),
          ],
        ),
      ),
    );
  }
}
