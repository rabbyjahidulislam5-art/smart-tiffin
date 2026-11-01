import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final faqs = [
      (t('How do I pause meals?', 'খাবার কীভাবে পজ করব?'), t('Open Subscriptions → Pause', 'সাবস্ক্রিপশন → পজ')),
      (t('When is lunch delivered?', 'লাঞ্চ কখন পৌঁছায়?'), t('Usually 12:30–1:15 PM', 'সাধারণত ১২:৩০–১:১৫')),
      (t('How do payouts work for cooks?', 'রাঁধুনির পেআউট?'), t('Weekly batch every Friday', 'প্রতি শুক্রবার')),
      (t('Can I change dinner after lunch cutoff?', 'লাঞ্চ কাটঅফের পর ডিনার বদল?'), t('Yes, until 5:30 PM', 'হ্যাঁ, বিকেল ৫:৩০ পর্যন্ত')),
    ];
    return StScreen(
      title: t('Help & Support', 'সাহায্য ও সাপোর্ট'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StCard(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      meals[1].img,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 48, height: 48, color: StColors.muted),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('We\'re here for your tiffin', 'আপনার টিফিনের জন্য আমরা আছি'), style: const TextStyle(fontWeight: FontWeight.w800)),
                        Text(t('Typical reply under 2 hours', 'সাধারণত ২ ঘণ্টার মধ্যে উত্তর'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
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
            child: StList(
              children: [
                StRowTile(icon: Icons.chat_bubble_outline, label: t('Chat with support', 'সাপোর্ট চ্যাট'), sub: t('Typical reply under 2 hours', 'সাধারণত ২ ঘণ্টার মধ্যে'), onTap: () => ctrl.go('SH-02', {'who': 'Support'})),
                if (ref.watch(shellConfigProvider).knows('SH-06')) StRowTile(icon: Icons.report_problem_outlined, label: t('Report a problem', 'সমস্যা জানান'), onTap: () => ctrl.go('SH-06')),
                StRowTile(icon: Icons.confirmation_number_outlined, label: t('My tickets', 'আমার টিকেট'), onTap: () => ctrl.go('SH-07')),
                StRowTile(icon: Icons.mail_outline, label: t('Email history', 'ইমেইল ইতিহাস'), onTap: () => ctrl.go('SH-10')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(index: 2, child: Text(t('FAQs', 'সাধারণ প্রশ্ন'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
          const SizedBox(height: 8),
          for (var i = 0; i < faqs.length; i++)
            AppReveal(
              index: i + 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StCard(
                  onTap: () => ctrl.toast(faqs[i].$2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(faqs[i].$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(faqs[i].$2, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
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
