import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class InvoiceScreen extends ConsumerWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final lines = [
      (t(meals[1].en, meals[1].bn), '22×', '৳3,960', meals[1].img),
      (t(meals[0].en, meals[0].bn), '12×', '৳2,160', meals[0].img),
      (t(meals[2].en, meals[2].bn), '8×', '৳1,080', meals[2].img),
    ];
    return StScreen(
      title: t('Invoice', 'ইনভয়েস'),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t('Invoice', 'ইনভয়েস'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                            Text('INV-2026-10-001 · Oct 2026', style: TextStyle(color: Theme.of(context).hintColor)),
                          ],
                        ),
                      ),
                      const AppDrawCheck(size: 40, color: StColors.success),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(t('Monthly Homemade Package', 'মাসিক ঘরোয়া প্যাকেজ'), style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(t('Tanvir Ahmed · Banani Block D', 'তানভীর আহমেদ · বনানী'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < lines.length; i++)
            AppReveal(
              index: i + 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StCard(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          lines[i].$4,
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
                            Text(lines[i].$1, style: const TextStyle(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(lines[i].$2, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                          ],
                        ),
                      ),
                      Text(lines[i].$3, style: const TextStyle(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ),
          AppReveal(
            index: 4,
            child: StCard(
              child: Column(
                children: [
                  Row( // layout-ok
                    children: [
                      Text(t('Subtotal', 'সাবটোটাল')),
                      const Spacer(),
                      const Text('৳7,200'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row( // layout-ok
                    children: [
                      Text(t('Delivery', 'ডেলিভারি')),
                      const Spacer(),
                      Text(t('Included', 'অন্তর্ভুক্ত'), style: TextStyle(color: Theme.of(context).hintColor)),
                    ],
                  ),
                  const Divider(),
                  Row( // layout-ok
                    children: [
                      Text(t('Total paid', 'মোট পরিশোধ'), style: const TextStyle(fontWeight: FontWeight.w800)),
                      const Spacer(),
                      const Text('৳7,200', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  StChip(tone: StTone.success, child: Text(t('Paid via bKash · 1 Oct', 'বিকাশ · ১ অক্টোবর'))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 5,
            child: StBtn(
              label: t('Download PDF (sample)', 'পিডিএফ ডাউনলোড (নমুনা)'),
              full: true,
              variant: StBtnVariant.outline,
              icon: Icons.download_outlined,
              onTap: () => ctrl.toast(t('Invoice PDF prepared (sample)', 'ইনভয়েস পিডিএফ প্রস্তুত')),
            ),
          ),
        ],
      ),
    );
  }
}
