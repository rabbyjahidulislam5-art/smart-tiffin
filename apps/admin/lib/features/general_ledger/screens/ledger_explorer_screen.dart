import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/general_ledger_providers.dart';
import 'general_ledger_text.dart';

/// NF-11 General ledger explorer: balanced journals with source and policy
/// version; the only action is `reverseJournal`.
class LedgerExplorerScreen extends ConsumerWidget {
  const LedgerExplorerScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };
  static const accounts = [
    'cash_and_clearing',
    'customer_prepaid_obligation',
    'customer_credit_liability',
    'supplier_payable',
    'cod_receivable',
    'platform_revenue',
  ];

  static void _open(WidgetRef ref, Journal j) {
    final repo = ref.read(ledgerRepositoryProvider);
    final actor = ref.read(actorProvider);
    final ctrl = ref.read(appProvider.notifier);
    ctrl.showSheet(
      Consumer(
        builder: (context, ref, _) {
          final s = ref.watch(appProvider);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${s.digits(j.id)} · ${j.source}',
                style: const TextStyle(
                  fontSize: StFont.heading,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${s.digits(j.date)} · ${j.policyVersion}',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              if (j.reversalOf != null)
                Text(s.tx(GeneralLedgerText.reversalOf, [j.reversalOf!])),
              if (j.reversedBy != null)
                Text(s.tx(GeneralLedgerText.reversedBy, [j.reversedBy!])),
              const SizedBox(height: StSpace.xs),
              Text(
                s.tx(GeneralLedgerText.lines),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              for (final l in j.lines)
                StInfoRow(
                  label: l.account,
                  trailing: StMoneyText.minor(
                    l.debitMinor > 0 ? l.debitMinor : -l.creditMinor,
                    align: Alignment.centerRight,
                  ),
                ),
              StStatusChip(
                label: s.tx(
                  j.balanced
                      ? GeneralLedgerText.balanced
                      : GeneralLedgerText.unbalanced,
                ),
                tone: j.balanced ? StTone.success : StTone.danger,
              ),
              const SizedBox(height: StSpace.sm),
              if (j.status == JournalStatus.posted && j.reversalOf == null)
                StBtn(
                  label: s.tx(GeneralLedgerText.reverse),
                  variant: StBtnVariant.danger,
                  icon: Icons.undo_rounded,
                  onTap: () => ctrl.showSheet(
                    StReasonSheet(
                      title: GeneralLedgerText.reverseTitle,
                      body: GeneralLedgerText.reverseBody,
                      commandName: GeneralLedgerText.reverseName,
                      success: GeneralLedgerText.reverseDone,
                      confirmLabel: GeneralLedgerText.reverse,
                      minLength: 10,
                      danger: true,
                      onSubmit: (reason) => repo.reverseJournal(
                        actor,
                        RequestId.next('reverse'),
                        journalId: j.id,
                        reason: reason,
                      ),
                      onDone: () =>
                          ref.read(journalsProvider.notifier).reload(),
                    ),
                  ),
                ),
              const SizedBox(height: StSpace.xs),
              StBtn(
                label: s.tx(GeneralLedgerText.close),
                variant: StBtnVariant.outline,
                onTap: ctrl.closeSheet,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final account = ref.watch(ledgerAccountFilterProvider);
    final journals = ref.read(journalsProvider.notifier);
    return StScreen(
      title: s.tx(GeneralLedgerText.ledgerTitle),
      eyebrow: s.tx(GeneralLedgerText.eyebrow),
      back: false,
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(GeneralLedgerText.ledgerIntro))),
          const SizedBox(height: StSpace.sm),
          StChipRow(
            options: [
              (v: 'all', l: s.tx(GeneralLedgerText.allAccounts)),
              for (final a in accounts) (v: a, l: a),
            ],
            value: account ?? 'all',
            onChanged: (v) =>
                ref.read(ledgerAccountFilterProvider.notifier).state =
                    v == 'all' ? null : v,
          ),
          const SizedBox(height: StSpace.sm),
          StAsyncView<StPagedList<Journal>>(
            value: ref.watch(journalsProvider),
            supported: states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: GeneralLedgerText.noJournals,
            onRetry: journals.reload,
            builder: (context, list) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StFinTable<Journal>(
                  rows: list.items,
                  idLabel: GeneralLedgerText.colJournal,
                  idOf: (j) => j.id,
                  subtitleOf: (j) => '${s.digits(j.date)} · ${j.source}',
                  amountLabel: GeneralLedgerText.debit,
                  amountMinorOf: (j) => j.debitMinor,
                  statusOf: (j) => StStatusChip(
                    label: s.tx(
                      j.status == JournalStatus.posted
                          ? GeneralLedgerText.posted
                          : GeneralLedgerText.reversedStatus,
                    ),
                    tone: j.status == JournalStatus.posted
                        ? StTone.success
                        : StTone.muted,
                  ),
                  columns: [
                    StFinColumn(
                      label: GeneralLedgerText.colDate,
                      cell: (j) => j.date,
                    ),
                    StFinColumn(
                      label: GeneralLedgerText.colSource,
                      cell: (j) => j.source,
                    ),
                    StFinColumn(
                      label: GeneralLedgerText.colPolicy,
                      cell: (j) => j.policyVersion,
                    ),
                    StFinColumn(
                      label: GeneralLedgerText.credit,
                      cell: (j) => s.moneyMinor(j.creditMinor),
                      numeric: true,
                    ),
                  ],
                  onTap: (j) => _open(ref, j),
                ),
                StLoadMore<Journal>(list: list, onMore: journals.loadMore),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
