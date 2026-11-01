import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class PayoutHistoryScreen extends ConsumerWidget {
  const PayoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final rows = [
      ('Oct 30', 12600, 'warning'),
      ('Oct 23', 11800, 'success'),
      ('Oct 16', 10250, 'success'),
      ('Oct 9', 9800, 'success'),
      ('Oct 2', 11150, 'success'),
    ];
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.supplier)]),
      child: StScreen(
        title: t('Payout history', 'পেআউট ইতিহাস'),
        actions: [
          StIconBtn(icon: Icons.account_balance_wallet_outlined, label: 'Earnings', onTap: () => ctrl.go('S-08')),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Column(
                  children: [
                    Text(t('Paid this month', 'এই মাসে পরিশোধ'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                    AppCountUp(
                      value: 55600,
                      format: (v) => '৳${fmtBdt(v.round())}',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: role),
                    ),
                    Text('5 ${t('batches', 'ব্যাচ')}', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < rows.length; i++)
              AppReveal(
                index: i + 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StCard(
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: role.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                          child: Icon(Icons.payments_outlined, color: role, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('৳${fmtBdt(rows[i].$2)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                              Text(rows[i].$1, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                            ],
                          ),
                        ),
                        StChip(
                          tone: rows[i].$3 == 'success' ? StTone.success : StTone.warning,
                          child: Text(rows[i].$3 == 'success' ? t('Recorded', 'রেকর্ডকৃত') : t('Scheduled', 'নির্ধারিত')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            AppReveal(
              index: 6,
              child: StNote(
                tone: StNoteTone.policy,
                child: Text(t('"Recorded" means logged by admin, not a verified bank transfer.', '"রেকর্ডকৃত" মানে অ্যাডমিন লিপিবদ্ধ করেছেন, যাচাইকৃত ট্রান্সফার নয়।')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
