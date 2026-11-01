import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/cod_verification_providers.dart';
import 'cod_verification_text.dart';

/// NF-04 COD deposit verification (`verifyCodRemittance`, INV-12): the typed
/// deposit reference must match the record.
class CodDepositVerificationScreen extends ConsumerWidget {
  const CodDepositVerificationScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  static Widget statusChip(AppState s, VerificationStatus st) => switch (st) {
    VerificationStatus.pending => StStatusChip(
      label: s.tx(CodVerificationText.pending),
      tone: StTone.warning,
    ),
    VerificationStatus.verified => StStatusChip(
      label: s.tx(CodVerificationText.verified),
      tone: StTone.success,
      icon: Icons.verified_outlined,
    ),
    VerificationStatus.rejected => StStatusChip(
      label: s.tx(CodVerificationText.rejected),
      tone: StTone.danger,
    ),
  };

  static void _openCase(WidgetRef ref, CodRemittanceCase c) {
    final repo = ref.read(codVerificationRepositoryProvider);
    final actor = ref.read(actorProvider);
    final field = TextEditingController();
    ref
        .read(appProvider.notifier)
        .showSheet(
          Consumer(
            builder: (context, ref, _) {
              final s = ref.watch(appProvider);
              return StCommandScope(
                onConfirmationEnd: ref.read(appProvider.notifier).closeSheet,
                builder: (context, cmd) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${c.riderName} · ${s.digits(c.id)}',
                      style: const TextStyle(
                        fontSize: StFont.heading,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: StSpace.xs),
                    StInfoRow(
                      label: s.tx(CodVerificationText.method),
                      value: c.method,
                    ),
                    StInfoRow(
                      label: s.tx(CodVerificationText.declared),
                      trailing: StMoneyText.minor(
                        c.declaredMinor,
                        align: Alignment.centerRight,
                      ),
                    ),
                    StInfoRow(
                      label: s.tx(CodVerificationText.expected),
                      trailing: StMoneyText.minor(
                        c.expectedMinor,
                        align: Alignment.centerRight,
                      ),
                    ),
                    StInfoRow(
                      label: s.tx(CodVerificationText.difference),
                      trailing: StMoneyText.minor(
                        c.expectedMinor - c.declaredMinor,
                        align: Alignment.centerRight,
                      ),
                    ),
                    const SizedBox(height: StSpace.xs),
                    StField(
                      label: s.tx(CodVerificationText.reference),
                      hint: s.tx(CodVerificationText.typeReference),
                      controller: field,
                    ),
                    const SizedBox(height: StSpace.sm),
                    StCommandButton(
                      label: s.tx(CodVerificationText.verify),
                      icon: Icons.verified_rounded,
                      variant: StBtnVariant.success,
                      busy: cmd.busy,
                      onTap: () => cmd.run(
                        () => repo.verifyCodRemittance(
                          actor,
                          RequestId.next('cod'),
                          remittanceId: c.id,
                          depositReference: field.text,
                          accept: true,
                        ),
                        name: CodVerificationText.verifyName,
                        success: CodVerificationText.verifyDone,
                        onSuccess: () =>
                            ref.invalidate(codRemittanceCasesProvider),
                      ),
                    ),
                    const SizedBox(height: StSpace.xs),
                    StCommandButton(
                      label: s.tx(CodVerificationText.reject),
                      icon: Icons.block_rounded,
                      variant: StBtnVariant.danger,
                      busy: cmd.busy,
                      onTap: () => cmd.run(
                        () => repo.verifyCodRemittance(
                          actor,
                          RequestId.next('cod'),
                          remittanceId: c.id,
                          depositReference: field.text,
                          accept: false,
                        ),
                        name: CodVerificationText.verifyName,
                        success: CodVerificationText.rejectDone,
                        onSuccess: () =>
                            ref.invalidate(codRemittanceCasesProvider),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    return StScreen(
      title: s.tx(CodVerificationText.verifyTitle),
      eyebrow: s.tx(CodVerificationText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(CodVerificationText.verifyIntro))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<CodRemittanceCase>>(
            value: ref.watch(codRemittanceCasesProvider),
            supported: states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: CodVerificationText.noCases,
            onRetry: () => ref.invalidate(codRemittanceCasesProvider),
            builder: (context, list) => StFinTable<CodRemittanceCase>(
              rows: list,
              idLabel: CodVerificationText.reference,
              idOf: (c) => c.reference,
              subtitleOf: (c) => c.verifiedBy == null
                  ? '${c.riderName} · ${c.method}'
                  : s.tx(CodVerificationText.by, [c.verifiedBy!]),
              amountLabel: CodVerificationText.declared,
              amountMinorOf: (c) => c.declaredMinor,
              statusOf: (c) => statusChip(s, c.status),
              columns: [
                StFinColumn(
                  label: CodVerificationText.colRider,
                  cell: (c) => c.riderName,
                ),
                StFinColumn(
                  label: CodVerificationText.expected,
                  cell: (c) => s.moneyMinor(c.expectedMinor),
                  numeric: true,
                ),
              ],
              onTap: (c) {
                if (c.status == VerificationStatus.pending) _openCase(ref, c);
              },
            ),
          ),
        ],
      ),
    );
  }
}
