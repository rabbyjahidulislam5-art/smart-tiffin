import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

String _mealImgFor(String item) {
  final lower = item.toLowerCase();
  if (lower.contains('khichuri')) return meals[2].img;
  if (lower.contains('beef') || lower.contains('kala')) return meals[4].img;
  if (lower.contains('roti') || lower.contains('paratha')) return meals[3].img;
  if (lower.contains('biryani')) return meals[0].img;
  return meals[1].img;
}

class SupplierOrdersScreen extends ConsumerStatefulWidget {
  const SupplierOrdersScreen({super.key});
  @override
  ConsumerState<SupplierOrdersScreen> createState() => _SupplierOrdersScreenState();
}

class _SupplierOrdersScreenState extends ConsumerState<SupplierOrdersScreen> {
  String tab = 'new';

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final list = requests.where((r) {
      if (tab == 'new') return !s.store.accepted.contains(r.id) && !s.store.declined.contains(r.id);
      if (tab == 'cooking') return s.store.accepted.contains(r.id);
      return false;
    }).toList();

    return StScreen(
      title: t('Orders', 'অর্ডার'),
      back: false,
      actions: [StIconBtn(icon: Icons.event_available, label: 'Commitments', onTap: () => ctrl.go('S-07'))],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StSegmented(
              value: tab,
              onChanged: (v) => setState(() => tab = v),
              options: [
                (v: 'new', l: t('New', 'নতুন')),
                (v: 'cooking', l: t('Cooking', 'রান্না')),
                (v: 'done', l: t('Handed off', 'হস্তান্তর')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (tab == 'done')
            AppReveal(
              index: 1,
              child: StCard(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        meals[1].img,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 52, height: 52, color: StColors.muted),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('#TK-880 · Bengali Thali ×3', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                    StChip(tone: StTone.success, child: Text(t('Picked up', 'নেওয়া হয়েছে'))),
                  ],
                ),
              ),
            ),
          if (tab != 'done' && list.isEmpty)
            AppReveal(
              index: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  t('No orders here', 'কোনো অর্ডার নেই'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ),
            ),
          for (var i = 0; i < list.length; i++)
            AppReveal(
              index: i + 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: StCard(
                  onTap: () => ctrl.go('S-02', {'id': list[i].id}),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          _mealImgFor(list[i].item),
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
                            Text('#${list[i].id}', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                            Text('${list[i].qty} ${list[i].item}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Text('৳${list[i].amount}', style: const TextStyle(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ),
          AppReveal(
            index: list.length + 2,
            child: StBtn(
              label: t('Subscription commitments', 'সাবস্ক্রিপশন প্রতিশ্রুতি'),
              full: true,
              variant: StBtnVariant.soft,
              icon: Icons.event_available,
              onTap: () => ctrl.go('S-07'),
            ),
          ),
        ],
      ),
    );
  }
}
