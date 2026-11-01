import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  String cat = 'all';
  String q = '';

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final list = meals.where((m) {
      final hit = (m.en + m.bn + m.kitchen).toLowerCase().contains(q.toLowerCase());
      return hit && (cat == 'all' || m.cat == cat);
    }).toList();

    return StScreen(
      title: t('Full menu', 'পূর্ণ মেনু'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: TextField(
              onChanged: (v) => setState(() => q = v),
              decoration: InputDecoration(
                hintText: t('Search meals', 'খাবার খুঁজুন'),
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: StChipRow(
              value: cat,
              onChanged: (v) => setState(() => cat = v),
              options: [
                (v: 'all', l: t('All', 'সব')),
                (v: 'thali', l: t('Thali', 'থালি')),
                (v: 'diet', l: t('Diet', 'ডায়েট')),
                (v: 'office', l: t('Office', 'অফিস')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (list.isEmpty)
            AppReveal(
              index: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Text(t('No meals match', 'কোনো খাবার নেই'), textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).hintColor)),
              ),
            )
          else
            for (var i = 0; i < list.length; i++)
              AppReveal(
                index: i + 2,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: StCard(
                    padding: EdgeInsets.zero,
                    onTap: () => ctrl.go('C-05', {'id': list[i].id}),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                          child: Image.asset(
                            list[i].img,
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 88, height: 88, color: StColors.muted),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(list[i].kitchen, style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor, fontWeight: FontWeight.w600)),
                                Text(t(list[i].en, list[i].bn), style: const TextStyle(fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text('BDT ${list[i].price}', style: TextStyle(fontWeight: FontWeight.w800, color: role)),
                                    const Spacer(),
                                    Icon(Icons.star_rounded, size: 14, color: StColors.warning),
                                    Text(' ${list[i].rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
