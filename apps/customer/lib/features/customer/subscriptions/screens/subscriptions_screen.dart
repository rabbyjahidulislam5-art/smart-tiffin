import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class SubscriptionsScreen extends ConsumerWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;

    return StScreen(
      title: t('Subscriptions', 'সাবস্ক্রিপশন'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          meals[1].img,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: StColors.muted),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(t('Monthly Homemade Package', 'মাসিক ঘরোয়া প্যাকেজ'), style: const TextStyle(fontWeight: FontWeight.w800))),
                      StChip(tone: s.store.paused ? StTone.warning : StTone.success, child: Text(s.store.paused ? t('Paused', 'বিরতি') : t('Active', 'চালু'))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(t('Lunch + Dinner daily · Maa\'s Kitchen', 'প্রতিদিন লাঞ্চ + ডিনার · মায়ের কিচেন'), style: TextStyle(color: Theme.of(context).hintColor)),
                  const SizedBox(height: 8),
                  Text(t('৳7,200 / month · renews 1 Dec', '৳৭,২০০ / মাস · ১ ডিসেম্বরে নবায়ন'), style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: Text(t('22 meals left', '২২ মিল বাকি'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor))),
                      Text(t('Next: today lunch', 'পরবর্তী: আজ লাঞ্চ'), style: TextStyle(fontSize: 12, color: role, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: StBtn(label: t('Pause', 'বিরতি'), variant: StBtnVariant.soft, onTap: () => ctrl.go('C-14'))),
                      const SizedBox(width: 8),
                      Expanded(child: StBtn(label: t('Calendar', 'ক্যালেন্ডার'), variant: StBtnVariant.outline, onTap: () => ctrl.go('C-13'))),
                    ],
                  ),
                  TextButton(
                    onPressed: () => ctrl.go('C-11'),
                    child: Text(t('Change plan', 'প্ল্যান বদলান'), style: TextStyle(color: role, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: StCard(
              onTap: () => ctrl.go('C-20'),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long_outlined),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('Billing & invoices', 'বিলিং ও ইনভয়েস'), style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text(t('Last charge ৳7,200 · 1 Nov', 'শেষ চার্জ ৳৭,২০০ · ১ নভেম্বর'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
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
            index: 2,
            child: StBtn(label: t('Browse other plans', 'অন্য প্ল্যান দেখুন'), full: true, variant: StBtnVariant.outline, onTap: () => ctrl.go('C-11')),
          ),
        ],
      ),
    );
  }
}
