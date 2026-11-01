import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class PlanPickerScreen extends ConsumerWidget {
  const PlanPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final thumbs = [meals[1].img, meals[0].img, meals[2].img, meals[3].img];

    return StScreen(
      title: t('Plan picker', 'প্ল্যান বেছে নিন'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StNote(child: Text(t('Pick a plan, then review before paying.', 'প্ল্যান বেছে নিয়ে পেমেন্টের আগে পর্যালোচনা করুন।'))),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < plans.length; i++)
            AppReveal(
              index: i + 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: StCard(
                  onTap: () => ctrl.go('C-12', {'plan': plans[i].id}),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          thumbs[i % thumbs.length],
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
                            Text(t(plans[i].en, plans[i].bn), style: const TextStyle(fontWeight: FontWeight.w800)),
                            Text(plans[i].meals, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                            if (i == 2) ...[
                              const SizedBox(height: 4),
                              StChip(tone: StTone.success, child: Text(t('Most popular', 'সবচেয়ে জনপ্রিয়'))),
                            ],
                          ],
                        ),
                      ),
                      Text('৳${fmtBdt(plans[i].price)}', style: TextStyle(fontWeight: FontWeight.w800, color: role)),
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
