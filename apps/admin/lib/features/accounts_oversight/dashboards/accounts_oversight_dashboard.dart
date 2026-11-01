import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/accounts_oversight_providers.dart';
import 'accounts_oversight_text.dart';

/// NA-05 Accounts oversight (limited view, section): non-sensitive finance
/// indicators only; no balance, ledger, payout or credit detail (C-06).
class AccountsOversightDashboard extends ConsumerWidget {
  const AccountsOversightDashboard({super.key});

  static const states = {StVariant.loading, StVariant.error, StVariant.offline};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    return StScreen(
      title: s.tx(AccountsOversightText.title),
      eyebrow: s.tx(AccountsOversightText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(AccountsOversightText.intro))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<LimitedFinanceKpis>(
            value: ref.watch(limitedFinanceKpisProvider),
            supported: states,
            onRetry: () => ref.invalidate(limitedFinanceKpisProvider),
            builder: (context, k) => StKpiGrid(
              children: [
                StStat(
                  label: s.tx(AccountsOversightText.volume),
                  value: s.tx(AccountsOversightText.volumeValue, [
                    '${k.orderVolumeChangePercent >= 0 ? '+' : ''}${k.orderVolumeChangePercent}',
                  ]),
                  icon: Icons.trending_up_rounded,
                ),
                StStat(
                  label: s.tx(AccountsOversightText.collection),
                  value: s.tx(AccountsOversightText.percent, [
                    '${k.collectionRatePercent}',
                  ]),
                  icon: Icons.donut_large_rounded,
                ),
                StStat(
                  label: s.tx(AccountsOversightText.exceptions),
                  value: s.digits('${k.openExceptionCount}'),
                  icon: Icons.report_problem_outlined,
                ),
                StStat(
                  label: s.tx(AccountsOversightText.payouts),
                  value: s.digits('${k.pendingPayoutRequestCount}'),
                  icon: Icons.schedule_rounded,
                ),
                StStat(
                  label: s.tx(AccountsOversightText.period),
                  value: s.tx(switch (k.periodStatus) {
                    PeriodStatus.open => AccountsOversightText.periodOpen,
                    PeriodStatus.closing => AccountsOversightText.periodClosing,
                    PeriodStatus.closed => AccountsOversightText.periodClosed,
                    PeriodStatus.reopened =>
                      AccountsOversightText.periodReopened,
                  }),
                  icon: Icons.event_note_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: StSpace.sm),
          StNote(
            tone: StNoteTone.policy,
            child: Text(s.tx(AccountsOversightText.noAuthority)),
          ),
        ],
      ),
    );
  }
}
