import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/credit_and_refunds_providers.dart';
import 'credit_and_refunds_text.dart';

/// NF-09 Customer credit liability: issued, consumed and voided credits and
/// the remaining liability (`voidCredit`). A credit is never cash.
class CreditLiabilityScreen extends ConsumerWidget {
  const CreditLiabilityScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static StText movementText(CreditMovement m) => switch (m) {
    CreditMovement.issued => CreditAndRefundsText.issued,
    CreditMovement.consumed => CreditAndRefundsText.consumed,
    CreditMovement.voided => CreditAndRefundsText.voided,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final repo = ref.read(creditAndRefundRepositoryProvider);
    final actor = ref.read(actorProvider);
    return StScreen(
      title: s.tx(CreditAndRefundsText.creditTitle),
      eyebrow: s.tx(CreditAndRefundsText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(CreditAndRefundsText.creditIntro))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<CreditLiabilityRow>>(
            value: ref.watch(creditLiabilityProvider),
            supported: states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: CreditAndRefundsText.noCredits,
            onRetry: () => ref.invalidate(creditLiabilityProvider),
            builder: (context, rows) {
              int sum(CreditMovement m) => rows
                  .where((r) => r.movement == m)
                  .fold(0, (a, r) => a + r.amountMinor);
              final remaining =
                  sum(CreditMovement.issued) -
                  sum(CreditMovement.consumed) -
                  sum(CreditMovement.voided);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StKpiGrid(
                    children: [
                      StMoneyStat(
                        label: s.tx(CreditAndRefundsText.issued),
                        minor: sum(CreditMovement.issued),
                        icon: Icons.add_card_rounded,
                      ),
                      StMoneyStat(
                        label: s.tx(CreditAndRefundsText.consumed),
                        minor: sum(CreditMovement.consumed),
                        icon: Icons.restaurant_rounded,
                      ),
                      StMoneyStat(
                        label: s.tx(CreditAndRefundsText.voided),
                        minor: sum(CreditMovement.voided),
                        icon: Icons.block_rounded,
                      ),
                      StMoneyStat(
                        label: s.tx(CreditAndRefundsText.remaining),
                        minor: remaining,
                        icon: Icons.account_balance_wallet_outlined,
                        tone: StColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: StSpace.sm),
                  StFinTable<CreditLiabilityRow>(
                    rows: rows,
                    idLabel: CreditAndRefundsText.colCustomer,
                    idOf: (r) => r.customerRef,
                    subtitleOf: (r) => '${s.digits(r.date)} · ${r.sourceRef}',
                    amountMinorOf: (r) => r.amountMinor,
                    statusOf: (r) => StStatusChip(
                      label: s.tx(movementText(r.movement)),
                      tone: switch (r.movement) {
                        CreditMovement.issued => StTone.info,
                        CreditMovement.consumed => StTone.success,
                        CreditMovement.voided => StTone.muted,
                      },
                    ),
                    onTap: (r) {
                      if (r.movement != CreditMovement.issued) return;
                      ref
                          .read(appProvider.notifier)
                          .showSheet(
                            StReasonSheet(
                              title: CreditAndRefundsText.voidCredit,
                              body: CreditAndRefundsText.voidBody,
                              commandName: CreditAndRefundsText.voidName,
                              success: CreditAndRefundsText.voidDone,
                              confirmLabel: CreditAndRefundsText.voidCredit,
                              danger: true,
                              onSubmit: (reason) => repo.voidCredit(
                                actor,
                                RequestId.next('void'),
                                rowId: r.id,
                                reason: reason,
                              ),
                              onDone: () =>
                                  ref.invalidate(creditLiabilityProvider),
                            ),
                          );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
