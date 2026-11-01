import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';
import '../../dashboard/screens/supplier_dash_screen.dart';

class MenuManagerScreen extends ConsumerWidget {
  const MenuManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final list = meals.take(5).toList();
    return StScreen(
      title: t('Menu & stock', 'মেনু ও স্টক'),
      back: false,
      actions: [StIconBtn(icon: Icons.add, label: 'Add meal', onTap: () => ctrl.go('S-05'))],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StNote(child: Text(t('Toggle availability for lunch cutoff. Sold-out meals stay listed for restock.', 'লাঞ্চ কাটঅফের জন্য উপলব্ধতা টগল করুন। শেষ খাবার তালিকায় থাকবে।'))),
          ),
          const SizedBox(height: 12),
          AppReveal(index: 1, child: Text(t("Today's stock", 'আজকের স্টক'), style: const TextStyle(fontWeight: FontWeight.w800))),
          const SizedBox(height: 8),
          AppReveal(index: 2, child: const StockList()),
          const SizedBox(height: 16),
          AppReveal(index: 3, child: Text(t('All meals', 'সব খাবার'), style: const TextStyle(fontWeight: FontWeight.w800))),
          const SizedBox(height: 8),
          for (var i = 0; i < list.length; i++)
            AppReveal(
              index: i + 4,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: StCard(
                  onTap: () => ctrl.go('S-05', {'id': list[i].id}),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          list[i].img,
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
                            Text(t(list[i].en, list[i].bn), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            Text('BDT ${list[i].price} · Mon–Sat', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                          ],
                        ),
                      ),
                      Icon(Icons.edit_outlined, size: 16, color: Theme.of(context).hintColor),
                    ],
                  ),
                ),
              ),
            ),
          AppReveal(
            index: list.length + 4,
            child: StBtn(label: t('Add meal', 'খাবার যোগ'), full: true, icon: Icons.add, onTap: () => ctrl.go('S-05')),
          ),
        ],
      ),
    );
  }
}
