import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final meal = mealById(s.store.cartMeal) ?? meals.first;
    final qty = s.store.cart;

    return StScreen(
      title: t('Cart', 'কার্ট'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (qty == 0)
            AppReveal(
              index: 0,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      meals[1].img,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      color: Colors.black.withValues(alpha: 0.25),
                      colorBlendMode: BlendMode.darken,
                      errorBuilder: (_, __, ___) => Container(height: 140, color: StColors.muted),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(t('Your tiffin bag is empty', 'টিফিন ব্যাগ খালি'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 6),
                  Text(t('Add a lunch box from the menu to continue.', 'চালিয়ে যেতে মেনু থেকে লাঞ্চ যোগ করুন।'), textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).hintColor)),
                  const SizedBox(height: 16),
                  StBtn(label: t('Browse menu', 'মেনু দেখুন'), full: true, onTap: () => ctrl.go('C-04')),
                ],
              ),
            )
          else ...[
            AppReveal(
              index: 0,
              child: StCard(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                      child: Image.asset(
                        meal.img,
                        width: 96,
                        height: 110,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 96, height: 110, color: StColors.muted),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t(meal.en, meal.bn), style: const TextStyle(fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text(meal.kitchen, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                            const SizedBox(height: 8),
                            Text('BDT ${meal.price}', style: TextStyle(fontWeight: FontWeight.w800, color: role)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(t('Portions', 'পোরশন'), style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    StSegmented(
                      value: '$qty',
                      onChanged: (v) => ctrl.patchStore((st) => st.copyWith(cart: int.parse(v))),
                      options: [
                        (v: '1', l: '1'),
                        (v: '2', l: '2'),
                        (v: '3', l: '3'),
                        (v: '4', l: '4'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 2,
              child: StCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(t('Subtotal', 'সাবটোটাল'), style: const TextStyle(fontWeight: FontWeight.w600))),
                        Text('BDT ${meal.price * qty}', style: TextStyle(fontWeight: FontWeight.w800, color: role)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(child: Text(t('Delivery', 'ডেলিভারি'))),
                        Text(t('Free lunch window', 'ফ্রি লাঞ্চ উইন্ডো'), style: TextStyle(color: StColors.success, fontWeight: FontWeight.w700, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppReveal(
              index: 3,
              child: StBtn(label: t('Checkout', 'চেকআউট'), full: true, size: StBtnSize.lg, icon: Icons.lock_outline_rounded, onTap: () => ctrl.go('C-08')),
            ),
            AppReveal(
              index: 4,
              child: TextButton(
                onPressed: () => ctrl.patchStore((st) => st.copyWith(cart: 0)),
                child: Text(t('Clear cart', 'কার্ট খালি'), style: TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
