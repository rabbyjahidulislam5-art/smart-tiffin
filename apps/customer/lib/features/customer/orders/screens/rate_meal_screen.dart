import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class RateMealScreen extends ConsumerStatefulWidget {
  const RateMealScreen({super.key});

  @override
  ConsumerState<RateMealScreen> createState() => _RateMealScreenState();
}

class _RateMealScreenState extends ConsumerState<RateMealScreen> {
  int stars = 5;
  var tip = 'portion';
  final note = TextEditingController();

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final meal = meals[1];

    return StScreen(
      title: t('Rate meal', 'খাবার রেট'),
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
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: StColors.muted),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t(meal.en, meal.bn), style: const TextStyle(fontWeight: FontWeight.w800)),
                        Text("Maa's Kitchen · TK-911", style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(index: 1, child: Text(t('How was your meal?', 'খাবার কেমন ছিল?'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18))),
          AppReveal(
            index: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    onPressed: () => setState(() => stars = i),
                    icon: Icon(i <= stars ? Icons.star_rounded : Icons.star_outline_rounded, color: StColors.warning, size: 32),
                  ),
              ],
            ),
          ),
          AppReveal(
            index: 3,
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(t('What stood out?', 'কী ভালো লেগেছে?'), style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  StSegmented(
                    options: [
                      (v: 'taste', l: t('Taste', 'স্বাদ')),
                      (v: 'portion', l: t('Portion', 'পরিমাণ')),
                      (v: 'pack', l: t('Packing', 'প্যাকিং')),
                    ],
                    value: tip,
                    onChanged: (v) => setState(() => tip = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(index: 4, child: StField(label: t('Comment', 'মন্তব্য'), controller: note, maxLines: 3)),
          const SizedBox(height: 12),
          AppReveal(
            index: 5,
            child: StBtn(
              label: t('Submit rating', 'রেটিং জমা'),
              full: true,
              size: StBtnSize.lg,
              onTap: () {
                ctrl.toast(t('Thanks for rating!', 'রেটিংয়ের জন্য ধন্যবাদ!'));
                ctrl.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
