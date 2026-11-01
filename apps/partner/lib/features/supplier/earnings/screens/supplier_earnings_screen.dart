import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class SupplierEarningsScreen extends ConsumerWidget {
  const SupplierEarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    const bars = [42, 55, 38, 61, 72, 48, 66];
    final top = [
      (meals[1], 86, '৳15,480'),
      (meals[2], 54, '৳8,640'),
      (meals[0], 41, '৳7,380'),
    ];
    return StScreen(
      title: t('Earnings', 'আয়'),
      back: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t('This month', 'এই মাস'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                  const Text('৳28,450', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                  Text(t('+12% vs last month · 181 orders', '+১২% গত মাসের চেয়ে · ১৮১ অর্ডার'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 96,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final b in bars)
                          Expanded(
                            child: Container(
                              height: 96 * b / 100,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(color: role.withValues(alpha: 0.8), borderRadius: const BorderRadius.vertical(top: Radius.circular(8))),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(t('Mon–Sun this week', 'সোম–রবি এই সপ্তাহ'), style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: StCard(
              color: role.withValues(alpha: 0.05),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('Next payout', 'পরবর্তী পেআউট'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                        const Text('৳12,600 · Fri 6 PM', style: TextStyle(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  StChip(tone: StTone.warning, child: Text(t('Awaiting admin', 'অ্যাডমিন অপেক্ষমাণ'))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(index: 2, child: Text(t('Top sellers', 'টপ সেলার'), style: const TextStyle(fontWeight: FontWeight.w800))),
          const SizedBox(height: 8),
          for (var i = 0; i < top.length; i++)
            AppReveal(
              index: i + 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StCard(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          top[i].$1.img,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 48, height: 48, color: StColors.muted),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t(top[i].$1.en, top[i].$1.bn), style: const TextStyle(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('${top[i].$2} ${t('orders', 'অর্ডার')}', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                          ],
                        ),
                      ),
                      Text(top[i].$3, style: TextStyle(fontWeight: FontWeight.w800, color: role)),
                    ],
                  ),
                ),
              ),
            ),
          AppReveal(
            index: 6,
            child: StList(
              children: [
                StRowTile(icon: Icons.payments_outlined, label: t('Payout history', 'পেআউট ইতিহাস'), onTap: () => ctrl.go('S-09')),
                StRowTile(icon: Icons.account_balance_wallet_outlined, label: t('Payout account', 'পেআউট অ্যাকাউন্ট'), sub: 'bKash ••771', onTap: () => ctrl.go('S-12')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(index: 7, child: const StPolicy()),
        ],
      ),
    );
  }
}
