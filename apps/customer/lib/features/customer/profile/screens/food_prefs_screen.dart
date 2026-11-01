import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class FoodPrefsScreen extends ConsumerStatefulWidget {
  const FoodPrefsScreen({super.key});

  @override
  ConsumerState<FoodPrefsScreen> createState() => _FoodPrefsScreenState();
}

class _FoodPrefsScreenState extends ConsumerState<FoodPrefsScreen> {
  String spice = 'medium';
  final avoid = <String>{'Peanuts'};
  String diet = 'regular';

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final avoids = [
      (t('Beef', 'গরুর মাংস'), 'Beef'),
      (t('Fish bones', 'মাছের কাঁটা'), 'Fish bones'),
      (t('Peanuts', 'চিনাবাদাম'), 'Peanuts'),
      (t('Dairy', 'দুগ্ধ'), 'Dairy'),
    ];
    return StScreen(
      title: t('Food preferences', 'খাবার পছন্দ'),
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
                      meals[1].img,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: StColors.muted),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t('Cooks use these preferences for your next lunch and dinner.', 'পরবর্তী লাঞ্চ ও ডিনারে রাঁধুনি এগুলো মেনে চলবেন।'),
                      style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(index: 1, child: Text(t('Diet style', 'ডায়েট স্টাইল'), style: const TextStyle(fontWeight: FontWeight.w700))),
          const SizedBox(height: 8),
          AppReveal(
            index: 2,
            child: StSegmented(
              value: diet,
              onChanged: (v) => setState(() => diet = v),
              options: [
                (v: 'regular', l: t('Regular', 'সাধারণ')),
                (v: 'diet', l: t('Light', 'হালকা')),
                (v: 'veg', l: t('Veg', 'নিরামিষ')),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(index: 3, child: Text(t('Spice level', 'ঝালের মাত্রা'), style: const TextStyle(fontWeight: FontWeight.w700))),
          const SizedBox(height: 8),
          AppReveal(
            index: 4,
            child: StSegmented(
              value: spice,
              onChanged: (v) => setState(() => spice = v),
              options: [
                (v: 'mild', l: t('Mild', 'কম')),
                (v: 'medium', l: t('Medium', 'মাঝারি')),
                (v: 'hot', l: t('Hot', 'ঝাল')),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(index: 5, child: Text(t('Avoid', 'এড়িয়ে চলুন'), style: const TextStyle(fontWeight: FontWeight.w700))),
          const SizedBox(height: 8),
          AppReveal(
            index: 6,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final x in avoids)
                  FilterChip(
                    label: Text(x.$1),
                    selected: avoid.contains(x.$2),
                    selectedColor: StColors.customer.withValues(alpha: 0.15),
                    checkmarkColor: StColors.customer,
                    onSelected: (v) => setState(() => v ? avoid.add(x.$2) : avoid.remove(x.$2)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 7,
            child: StBtn(
              label: t('Save preferences', 'পছন্দ সংরক্ষণ'),
              full: true,
              size: StBtnSize.lg,
              icon: Icons.check_rounded,
              onTap: () {
                ctrl.toast(t('Preferences saved', 'পছন্দ সংরক্ষিত'));
                ctrl.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
