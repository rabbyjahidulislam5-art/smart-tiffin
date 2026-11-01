import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class PlanReviewScreen extends ConsumerWidget {
  const PlanReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final p = plans.firstWhere((x) => x.id == (s.current.params['plan'] ?? 'monthly-ld'), orElse: () => plans[2]);

    return StScreen(
      title: t('Plan review', 'প্ল্যান পর্যালোচনা'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          meals[1].img,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: StColors.muted),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t(p.en, p.bn), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                            Text(p.meals, style: TextStyle(color: Theme.of(context).hintColor)),
                            const SizedBox(height: 6),
                            StChip(tone: StTone.success, child: Text(t('Homestyle kitchens', 'ঘরোয়া কিচেন'))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row( // layout-ok
                    children: [
                      Text(t('Monthly total', 'মাসিক মোট'), style: const TextStyle(fontWeight: FontWeight.w700)),
                      const Spacer(),
                      AppCountUp(
                        value: p.price,
                        format: (v) => '৳${fmtBdt(v.round())}',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: role),
                      ),
                    ],
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
                StRowTile(icon: Icons.calendar_month_outlined, label: t('Starts today', 'আজ থেকে শুরু'), sub: t('First lunch tomorrow if before cutoff', 'কাটঅফের আগে হলে আগামীকাল লাঞ্চ')),
                StRowTile(icon: Icons.pause_circle_outline, label: t('Pause anytime', 'যখন খুশি পজ'), sub: t('Before lunch/dinner cutoff', 'লাঞ্চ/ডিনার কাটঅফের আগে')),
                StRowTile(icon: Icons.account_balance_wallet_outlined, label: t('Pay with bKash', 'বিকাশ দিয়ে পেমেন্ট'), sub: '01XXX-XXX401', onTap: () => ctrl.go('C-22')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 2,
            child: StNote(child: Text(t('Billing starts today. Pause anytime before cutoff.', 'বিলিং আজ থেকে। কাটঅফের আগে পজ করা যায়।'))),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 3,
            child: StBtn(
              label: t('Pay now · ৳${fmtBdt(p.price)}', 'এখনই পেমেন্ট · ৳${fmtBdt(p.price)}'),
              full: true,
              size: StBtnSize.lg,
              icon: Icons.lock_outline,
              onTap: () => ctrl.go('C-09', {'status': 'success'}),
            ),
          ),
        ],
      ),
    );
  }
}
