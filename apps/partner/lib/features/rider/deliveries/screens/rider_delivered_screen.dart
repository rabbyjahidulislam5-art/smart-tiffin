import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class RiderDeliveredScreen extends ConsumerWidget {
  const RiderDeliveredScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.rider)]),
      child: StScreen(
        title: t('Delivered', 'ডেলিভারি সম্পন্ন'),
        back: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            AppReveal(
              index: 0,
              child: Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(color: StColors.success.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle, size: 48, color: StColors.success),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppReveal(
              index: 1,
              child: Text(t('Delivery complete', 'ডেলিভারি সম্পন্ন'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 2,
              child: Text('#TK-911 · Tanvir Ahmed', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).hintColor)),
            ),
            const SizedBox(height: 16),
            AppReveal(
              index: 3,
              child: StCard(
                child: Row(
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t(meals[1].en, meals[1].bn), style: const TextStyle(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(t('Proof photo saved · doorstep', 'প্রুফ ফটো সংরক্ষিত · দরজায়'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 4,
              child: StCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('৳50', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: role)),
                        Text(t('Earned', 'আয়'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('11m', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: role)),
                        Text(t('Trip time', 'সময়'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('2.4', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: role)),
                        Text(t('km', 'কিমি'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppReveal(
              index: 5,
              child: StBtn(
                label: t('Back to deliveries', 'ডেলিভারিতে ফিরুন'),
                full: true,
                size: StBtnSize.lg,
                onTap: () {
                  ctrl.patchStore((st) => st.copyWith(riderStep: 3));
                  ctrl.reset('R-01');
                },
              ),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 6,
              child: StBtn(label: t('View earnings', 'আয় দেখুন'), full: true, variant: StBtnVariant.soft, onTap: () => ctrl.go('R-08')),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 7,
              child: StBtn(label: t('Next in queue', 'কিউয়ের পরবর্তী'), full: true, variant: StBtnVariant.outline, onTap: () => ctrl.go('R-06')),
            ),
          ],
        ),
      ),
    );
  }
}
