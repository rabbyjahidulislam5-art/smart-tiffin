import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final addr = TextEditingController(text: 'Banani, Block D, Dhaka');
  String pay = 'bkash';

  @override
  void dispose() {
    addr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final meal = mealById(s.store.cartMeal) ?? meals.first;
    final qty = s.store.cart == 0 ? 1 : s.store.cart;
    final total = meal.price * qty;

    return StScreen(
      title: t('Checkout', 'চেকআউট'),
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
                        Text(t(meal.en, meal.bn), style: const TextStyle(fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('${meal.kitchen} · ×$qty', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                      ],
                    ),
                  ),
                  Text('৳${meal.price}', style: TextStyle(fontWeight: FontWeight.w800, color: role)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(index: 1, child: StField(label: t('Delivery address', 'ডেলিভারি ঠিকানা'), controller: addr)),
          const SizedBox(height: 8),
          AppReveal(
            index: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => ctrl.go('C-02'),
                child: Text(t('Change saved address', 'সংরক্ষিত ঠিকানা বদলান'), style: TextStyle(color: role, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
          AppReveal(
            index: 3,
            child: Text(t('Pay with', 'পেমেন্ট মাধ্যম'), style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 8),
          AppReveal(
            index: 4,
            child: StSegmented(
              value: pay,
              onChanged: (v) => setState(() => pay = v),
              options: [
                (v: 'bkash', l: 'bKash'),
                (v: 'nagad', l: 'Nagad'),
                (v: 'card', l: t('Card', 'কার্ড')),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(
            index: 5,
            child: StCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(t('Subtotal', 'সাবটোটাল'))),
                      Text('৳$total'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: Text(t('Delivery', 'ডেলিভারি'))),
                      Text(t('Free', 'ফ্রি'), style: TextStyle(color: StColors.success, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    children: [
                      Expanded(child: Text(t('Total', 'মোট'), style: const TextStyle(fontWeight: FontWeight.w700))),
                      Text('BDT $total', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: role)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 6,
            child: StBtn(
              label: t('Place order', 'অর্ডার করুন'),
              full: true,
              size: StBtnSize.lg,
              onTap: () {
                ctrl.patchStore((st) => st.copyWith(cart: 0));
                ctrl.go('C-09', {'status': 'success'});
              },
            ),
          ),
        ],
      ),
    );
  }
}
