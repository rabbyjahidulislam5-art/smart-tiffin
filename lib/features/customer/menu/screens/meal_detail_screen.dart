import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class MealDetailScreen extends ConsumerStatefulWidget {
  const MealDetailScreen({super.key});

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  var portions = '1';

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final m = mealById(s.current.params['id'] ?? 'biryani') ?? meals.first;

    return StScreen(
      title: t('Meal detail', 'খাবারের বিবরণ'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                m.img,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 220, color: StColors.muted),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.kitchen, style: TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.w600)),
                Text(t(m.en, m.bn), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.2)),
                const SizedBox(height: 6),
                Text(t(m.desc, m.descBn), style: TextStyle(color: Theme.of(context).hintColor, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppReveal(
            index: 2,
            child: Row(
              children: [
                Expanded(child: Text('BDT ${m.price}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: role), maxLines: 1, overflow: TextOverflow.ellipsis)),
                Icon(Icons.star_rounded, color: StColors.warning, size: 18),
                Text(' ${m.rating} (${m.reviews})', style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          if (m.badge != null) ...[
            const SizedBox(height: 8),
            AppReveal(index: 3, child: Align(alignment: Alignment.centerLeft, child: StChip(tone: StTone.role, child: Text(m.badge!)))),
          ],
          if (m.soldOut) ...[
            const SizedBox(height: 8),
            AppReveal(index: 4, child: StNote(tone: StNoteTone.warning, child: Text(t('Sold out for today — restocks tomorrow.', 'আজ শেষ — আগামীকাল আবার।')))),
          ],
          const SizedBox(height: 12),
          AppReveal(
            index: 5,
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(t('How many boxes?', 'কয়টি বক্স?'), style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  StSegmented(
                    value: portions,
                    onChanged: (v) => setState(() => portions = v),
                    options: [
                      (v: '1', l: '1'),
                      (v: '2', l: '2'),
                      (v: '3', l: '3'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(
            index: 6,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StBtn(
                label: m.soldOut ? t('Unavailable', 'পাওয়া যাচ্ছে না') : t('Add $portions to bag · ৳${m.price * int.parse(portions)}', 'ব্যাগে $portions · ৳${m.price * int.parse(portions)}'),
                size: StBtnSize.lg,
                icon: Icons.lunch_dining_outlined,
                disabled: m.soldOut,
                onTap: () {
                  ctrl.patchStore((st) => st.copyWith(cart: int.parse(portions), cartMeal: m.id));
                  ctrl.toast(t('Added to cart', 'কার্টে যোগ হয়েছে'));
                  ctrl.go('C-07');
                },
              ),
            ),
          ),
          AppReveal(
            index: 7,
            child: TextButton(
              onPressed: () => ctrl.go('C-06', {'kitchen': m.kitchen}),
              child: Text(t('View kitchen', 'কিচেন দেখুন'), style: TextStyle(color: role, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
