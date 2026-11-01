import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class KitchenDetailScreen extends ConsumerWidget {
  const KitchenDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final name = s.current.params['kitchen'] ?? "Rina's Kitchen";
    final kitchenMeals = meals.where((m) => m.kitchen == name).toList();
    final list = kitchenMeals.isEmpty ? meals.take(3).toList() : kitchenMeals;
    final cover = list.first;

    return StScreen(
      title: t('Kitchen detail', 'কিচেনের বিবরণ'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  Image.asset(cover.img, height: 160, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 160, color: StColors.muted)),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.55)])),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 14,
                    child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: StCard(
              child: Row(
                children: [
                  StAvatar(name: name, size: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('Verified home kitchen', 'যাচাইকৃত ঘরোয়া কিচেন'), style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text(t('Banani · Dhaka', 'বনানী · ঢাকা'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                      ],
                    ),
                  ),
                  StChip(tone: StTone.success, child: Text(t('Open', 'খোলা'))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(index: 2, child: Text(t('On the menu', 'মেনুতে'), style: const TextStyle(fontWeight: FontWeight.w800))),
          const SizedBox(height: 8),
          for (var i = 0; i < list.length; i++)
            AppReveal(
              index: i + 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StCard(
                  onTap: () => ctrl.go('C-05', {'id': list[i].id}),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(list[i].img, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: StColors.muted)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t(list[i].en, list[i].bn), style: const TextStyle(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('BDT ${list[i].price}', style: TextStyle(fontWeight: FontWeight.w800, color: role)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: Theme.of(context).hintColor),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
