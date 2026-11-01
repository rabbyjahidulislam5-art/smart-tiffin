import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key});
  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen> {
  String tab = 'all';

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final rows = [
      ('#TK-911', 'Tanvir · Banani', t('On route', 'পথে'), StTone.info, meals[1].img, 'live'),
      ('#TK-910', 'Farhana · Gulshan', t('Packed', 'প্যাকড'), StTone.warning, meals[0].img, 'live'),
      ('#TK-909', 'Sabbir · Dhanmondi', t('Delivered', 'পৌঁছানো'), StTone.success, meals[2].img, 'done'),
      ('#TK-908', 'Cluster Banani', t('Incident', 'ঘটনা'), StTone.danger, meals[4].img, 'issue'),
      ('#TK-907', 'Nusrat · Mirpur', t('Cooking', 'রান্না'), StTone.muted, meals[1].img, 'live'),
      ('#TK-906', 'Rafi · Uttara', t('Delivered', 'পৌঁছানো'), StTone.success, meals[3].img, 'done'),
      ('#TK-905', 'Ayesha · DOHS', t('On route', 'পথে'), StTone.info, meals[2].img, 'live'),
      ('#TK-904', "Maa's · Banani", t('Packed', 'প্যাকড'), StTone.warning, meals[0].img, 'live'),
    ];
    final list = rows.where((r) {
      if (tab == 'all') return true;
      if (tab == 'live') return r.$6 == 'live';
      if (tab == 'issue') return r.$6 == 'issue';
      return r.$6 == 'done';
    }).toList();
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('All Orders', 'সব অর্ডার'),
        back: false,
        actions: [
          StIconBtn(icon: Icons.warning_amber_outlined, label: 'Incidents', onTap: () => ctrl.go('A-03')),
        ],
        child: Column(
          children: [
            AppReveal(
              index: 0,
              child: StSegmented(
                value: tab,
                onChanged: (v) => setState(() => tab = v),
                options: [
                  (v: 'all', l: t('All', 'সব')),
                  (v: 'live', l: t('Live', 'লাইভ')),
                  (v: 'issue', l: t('Issues', 'সমস্যা')),
                  (v: 'done', l: t('Done', 'সম্পন্ন')),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (list.isEmpty)
              AppReveal(
                index: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(t('No orders in this filter', 'এই ফিল্টারে অর্ডার নেই'), style: TextStyle(color: Theme.of(context).hintColor)),
                ),
              )
            else
              for (var i = 0; i < list.length; i++)
                AppReveal(
                  index: i + 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: StCard(
                      onTap: () => ctrl.go('A-11', {'id': list[i].$1}),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              list[i].$5,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(width: 52, height: 52, color: StColors.muted),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(list[i].$1, style: const TextStyle(fontWeight: FontWeight.w800)),
                                Text(list[i].$2, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                              ],
                            ),
                          ),
                          StChip(tone: list[i].$4, child: Text(list[i].$3)),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
