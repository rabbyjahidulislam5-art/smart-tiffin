import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class CookingReqScreen extends ConsumerStatefulWidget {
  const CookingReqScreen({super.key});
  @override
  ConsumerState<CookingReqScreen> createState() => _CookingReqScreenState();
}

class _CookingReqScreenState extends ConsumerState<CookingReqScreen> {
  String slot = 'lunch';

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final rows = slot == 'lunch'
        ? [
            (meals[1], 28, 22),
            (meals[2], 12, 10),
            (meals[0], 5, 3),
          ]
        : [
            (meals[3], 18, 0),
            (meals[1], 14, 0),
          ];
    return StScreen(
      title: t('Cooking requirements', 'রান্নার চাহিদা'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StSegmented(
              value: slot,
              onChanged: (v) => setState(() => slot = v),
              options: [
                (v: 'lunch', l: t('Lunch · 45', 'লাঞ্চ · ৪৫')),
                (v: 'dinner', l: t('Dinner · 32', 'ডিনার · ৩২')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < rows.length; i++)
            AppReveal(
              index: i + 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: StCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(rows[i].$1.img, width: 52, height: 52, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 52, height: 52, color: StColors.muted)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(t(rows[i].$1.en, rows[i].$1.bn), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis)),
                          Text('${rows[i].$3}/${rows[i].$2}', style: const TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: rows[i].$2 == 0 ? 0 : rows[i].$3 / rows[i].$2,
                          minHeight: 8,
                          color: role,
                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          AppReveal(
            index: rows.length + 1,
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t('Ingredients needed', 'প্রয়োজনীয় উপকরণ'), style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text('Rice 9 kg · Dal 3 kg · Chicken 6 kg · Eggs 30', style: TextStyle(color: Theme.of(context).hintColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
