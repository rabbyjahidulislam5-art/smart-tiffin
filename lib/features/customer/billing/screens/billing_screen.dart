import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class BillingScreen extends ConsumerWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final invoices = [
      (t('Invoice Oct 2026', 'ইনভয়েস অক্টোবর ২০২৬'), 'INV-2026-10-001', '৳7,200', t('Paid', 'পরিশোধিত'), StTone.success, meals[1].img),
      (t('Invoice Sep 2026', 'ইনভয়েস সেপ্টেম্বর ২০২৬'), 'INV-2026-09-001', '৳7,200', t('Paid', 'পরিশোধিত'), StTone.success, meals[0].img),
      (t('Invoice Aug 2026', 'ইনভয়েস আগস্ট ২০২৬'), 'INV-2026-08-001', '৳6,800', t('Paid', 'পরিশোধিত'), StTone.success, meals[2].img),
    ];
    return StScreen(
      title: t('Billing', 'বিলিং'),
      actions: [
        StIconBtn(icon: Icons.credit_card_rounded, label: 'Methods', onTap: () => ctrl.go('C-22')),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StCard(
              child: Column(
                children: [
                  Text(t('This month', 'এই মাস'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                  AppCountUp(
                    value: 7200,
                    format: (v) => '৳${v.round()}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                  ),
                  Text(t('Monthly Homemade Package · bKash', 'মাসিক ঘরোয়া প্যাকেজ · বিকাশ'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: Row(
              children: [
                Expanded(child: StStat(label: t('Meals', 'খাবার'), value: '42', icon: Icons.restaurant_outlined)),
                const SizedBox(width: 8),
                Expanded(child: StStat(label: t('Next charge', 'পরবর্তী চার্জ'), value: '1 Nov', icon: Icons.event_outlined, onTap: () => ctrl.go('C-10'))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(index: 2, child: Text(t('Invoices', 'ইনভয়েস'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
          const SizedBox(height: 8),
          for (var i = 0; i < invoices.length; i++)
            AppReveal(
              index: i + 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StCard(
                  onTap: () => ctrl.go('C-21'),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          invoices[i].$6,
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
                            Text(invoices[i].$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(invoices[i].$2, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(invoices[i].$3, style: const TextStyle(fontWeight: FontWeight.w800)),
                          StChip(tone: invoices[i].$5, child: Text(invoices[i].$4)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          AppReveal(
            index: 6,
            child: StBtn(
              label: t('Payment methods', 'পেমেন্ট মাধ্যম'),
              full: true,
              variant: StBtnVariant.soft,
              icon: Icons.credit_card_rounded,
              onTap: () => ctrl.go('C-22'),
            ),
          ),
        ],
      ),
    );
  }
}
