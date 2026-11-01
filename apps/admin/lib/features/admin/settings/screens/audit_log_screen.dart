import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final rows = [
      ('Nadia', t('Approved cook application', 'রাঁধুনি আবেদন অনুমোদন'), '2h', Icons.badge_outlined, StTone.success),
      ('Nadia', t('Dispatched backup rider', 'ব্যাকআপ রাইডার পাঠানো'), '3h', Icons.two_wheeler, StTone.info),
      ('System', t('Escrow release · #TK-880', 'এস্ক্রো রিলিজ'), '5h', Icons.account_balance, StTone.muted),
      ('Nadia', t('Recorded payout batch approval', 'পেআউট ব্যাচ অনুমোদন'), '6h', Icons.payments_outlined, StTone.warning),
      ('Nadia', t('Suspended user sample', 'ইউজার স্থগিত নমুনা'), '1d', Icons.block, StTone.danger),
      ('System', t('Nightly ledger export', 'রাতের লেজার এক্সপোর্ট'), '1d', Icons.download_outlined, StTone.muted),
      ('Nadia', t('Updated commission to 12%', 'কমিশন ১২% আপডেট'), '2d', Icons.percent, StTone.info),
    ];
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('Audit log', 'অডিট লগ'),
        actions: [
          StIconBtn(icon: Icons.filter_list, label: 'Filter', onTap: () => ctrl.toast(t('Last 7 days · all actors', 'গত ৭ দিন · সব অ্যাক্টর'))),
        ],
        child: Column(
          children: [
            AppReveal(
              index: 0,
              child: StNote(
                tone: StNoteTone.policy,
                child: Text(t('Every approve, suspend, and payout decision is listed here (sample).', 'প্রতিটি অনুমোদন, স্থগিত ও পেআউট সিদ্ধান্ত এখানে (নমুনা)।')),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StCard(
                child: Row(
                  children: [
                    Expanded(child: Text(t('7 events today', 'আজ ৭টি ইভেন্ট'), style: const TextStyle(fontWeight: FontWeight.w800))),
                    StChip(tone: StTone.danger, child: Text(t('1 high risk', '১ উচ্চ ঝুঁকি'))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < rows.length; i++)
              AppReveal(
                index: i + 2,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StCard(
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(rows[i].$4, size: 20, color: Theme.of(context).hintColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(rows[i].$2, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                              Text('${rows[i].$1} · ${rows[i].$3}', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                            ],
                          ),
                        ),
                        StChip(tone: rows[i].$5, child: Text(rows[i].$3)),
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
