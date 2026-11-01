import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final statuses = [
      (t('In transit', 'পথে'), StTone.info),
      (t('Preparing', 'প্রস্তুত'), StTone.warning),
      (t('Delivered', 'ডেলিভারড'), StTone.success),
    ];
    final imgs = [meals[1].img, meals[2].img, meals[4].img];

    return StScreen(
      title: t('Orders', 'অর্ডার'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StNote(child: Text(t('Tap an order for detail, tracking, or rating.', 'বিবরণ, ট্র্যাকিং বা রেটিংয়ের জন্য অর্ডার ট্যাপ করুন।'))),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < requests.length; i++)
            AppReveal(
              index: i + 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: StCard(
                  onTap: () => ctrl.go('C-17', {'id': requests[i].id}),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          imgs[i % imgs.length],
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
                            Row(
                              children: [
                                Expanded(child: Text(requests[i].id, style: TextStyle(fontWeight: FontWeight.w700, color: role), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                StChip(tone: statuses[i % statuses.length].$2, child: Text(statuses[i % statuses.length].$1)),
                              ],
                            ),
                            Text(requests[i].item, style: const TextStyle(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('৳${requests[i].amount} · ${requests[i].pay} · ${requests[i].area}', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          AppReveal(
            index: requests.length + 1,
            child: StBtn(
              label: t('Track live order', 'লাইভ অর্ডার ট্র্যাক'),
              full: true,
              variant: StBtnVariant.soft,
              icon: Icons.near_me_outlined,
              onTap: () => ctrl.go('C-18'),
            ),
          ),
          const SizedBox(height: 8),
          AppReveal(
            index: requests.length + 2,
            child: StBtn(
              label: t('Rate a meal', 'খাবার রেট করুন'),
              full: true,
              variant: StBtnVariant.outline,
              onTap: () => ctrl.go('C-19'),
            ),
          ),
        ],
      ),
    );
  }
}
