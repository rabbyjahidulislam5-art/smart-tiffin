import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final id = s.current.params['id'] ?? 'TK-911';
    final meal = meals.firstWhere((m) => m.en.contains('Thali'), orElse: () => meals.first);

    return StScreen(
      title: t('Order detail', 'অর্ডার বিবরণ'),
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
                      Expanded(child: Text(id, style: TextStyle(fontWeight: FontWeight.w800, color: role), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      StChip(tone: StTone.success, child: Text(t('Out for delivery', 'ডেলিভারিতে'))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      meal.img,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(height: 140, color: StColors.muted),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(t('Bengali Homestyle Thali', 'বাঙালি ঘরোয়া থালি'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  Text("Maa's Kitchen · Lunch", style: TextStyle(color: Theme.of(context).hintColor)),
                  const SizedBox(height: 8),
                  Text(t('৳185 · paid by bKash', '৳১৮৫ · বিকাশে পরিশোধ'), style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: StCard(
              child: StTimeline(
                current: 2,
                steps: [
                  (label: t('Placed', 'অর্ডার'), sub: '11:02', icon: Icons.receipt_long_outlined),
                  (label: t('Kitchen', 'রান্না'), sub: '11:18', icon: Icons.soup_kitchen_outlined),
                  (label: t('On the way', 'পথে'), sub: '11:41', icon: Icons.two_wheeler),
                  (label: t('Delivered', 'ডেলিভারড'), sub: null, icon: Icons.home_outlined),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 2,
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t('Delivery', 'ডেলিভারি'), style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(t('House 12, Road 4 · Dhanmondi', 'বাড়ি ১২, রোড ৪ · ধানমন্ডি')),
                  Text(t('Rider · Karim · ETA 11 min', 'রাইডার · করিম · ১১ মিনিট'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(index: 3, child: StBtn(label: t('Track', 'ট্র্যাক'), full: true, icon: Icons.near_me_outlined, onTap: () => ctrl.go('C-18'))),
          const SizedBox(height: 8),
          AppReveal(index: 4, child: StBtn(label: t('Invoice', 'ইনভয়েস'), full: true, variant: StBtnVariant.outline, onTap: () => ctrl.go('C-21'))),
          const SizedBox(height: 8),
          AppReveal(index: 5, child: StBtn(label: t('Chat support', 'সাপোর্ট চ্যাট'), full: true, variant: StBtnVariant.soft, onTap: () => ctrl.go('SH-02', {'who': 'Support · $id'}))),
          const SizedBox(height: 8),
          AppReveal(index: 6, child: StBtn(label: t('Report a problem', 'সমস্যা জানান'), full: true, variant: StBtnVariant.ghost, onTap: () => ctrl.go('SH-06'))),
        ],
      ),
    );
  }
}
