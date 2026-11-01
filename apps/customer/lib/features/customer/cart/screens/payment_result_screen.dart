import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class PaymentResultScreen extends ConsumerWidget {
  const PaymentResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final ok = (s.current.params['status'] ?? 'success') == 'success';
    final meal = meals[1];

    return StScreen(
      title: t('Payment result', 'পেমেন্ট ফলাফল'),
      back: false,
      child: Stack(
        children: [
          if (ok) const Positioned.fill(child: IgnorePointer(child: AppConfetti())),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              AppReveal(
                index: 0,
                child: Center(
                  child: ok
                      ? AppDrawCheck(size: 88, color: StColors.success)
                      : Icon(Icons.cancel_rounded, size: 88, color: StColors.danger),
                ),
              ),
              const SizedBox(height: 16),
              AppReveal(
                index: 1,
                child: Text(
                  ok ? t('Payment successful', 'পেমেন্ট সফল') : t('Payment failed', 'পেমেন্ট ব্যর্থ'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 8),
              AppReveal(
                index: 2,
                child: Text(
                  ok
                      ? t('Your tiffin is confirmed for today.', 'আজকের টিফিন নিশ্চিত।')
                      : t('No money was taken. You can try again.', 'কোনো টাকা কাটেনি। আবার চেষ্টা করুন।'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).hintColor, height: 1.35),
                ),
              ),
              if (ok) ...[
                const SizedBox(height: 14),
                AppReveal(
                  index: 3,
                  child: StCard(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            meal.img,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: StColors.muted),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t('Order reference', 'অর্ডার রেফারেন্স'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                              const Text('TK-911', style: TextStyle(fontWeight: FontWeight.w800)),
                              Text(t(meal.en, meal.bn), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        StChip(tone: StTone.success, child: Text(t('Paid', 'পরিশোধ'))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                AppReveal(
                  index: 4,
                  child: StCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('Delivery window', 'ডেলিভারি উইন্ডো'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                        Text(t('Today · 12:30–1:15 PM · Banani', 'আজ · ১২:৩০–১:১৫ · বনানী'), style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              AppReveal(
                index: 5,
                child: StBtn(label: t('Back to home', 'হোমে ফিরুন'), full: true, size: StBtnSize.lg, onTap: () => ctrl.reset('C-01')),
              ),
              if (!ok) ...[
                const SizedBox(height: 8),
                AppReveal(
                  index: 6,
                  child: StBtn(label: t('Try again', 'আবার চেষ্টা'), full: true, variant: StBtnVariant.soft, onTap: () => ctrl.go('C-08')),
                ),
              ],
              if (ok) ...[
                const SizedBox(height: 8),
                AppReveal(
                  index: 6,
                  child: StBtn(label: t('Track order', 'অর্ডার ট্র্যাক'), full: true, variant: StBtnVariant.outline, onTap: () => ctrl.go('C-18')),
                ),
                const SizedBox(height: 8),
                AppReveal(
                  index: 7,
                  child: StBtn(label: t('View invoice', 'ইনভয়েস দেখুন'), full: true, variant: StBtnVariant.ghost, onTap: () => ctrl.go('C-21')),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
