import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/cod_providers.dart';
import 'cod_text.dart';

/// NR-05 COD remittance discrepancy (SC-09): mismatch cases raised by
/// Accounts and the rider's response (`respondToDiscrepancy`).
class CodDiscrepancyScreen extends ConsumerStatefulWidget {
  const CodDiscrepancyScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  ConsumerState<CodDiscrepancyScreen> createState() =>
      _CodDiscrepancyScreenState();
}

class _CodDiscrepancyScreenState extends ConsumerState<CodDiscrepancyScreen> {
  final Map<String, TextEditingController> _responses = {};

  TextEditingController _field(String id) =>
      _responses.putIfAbsent(id, TextEditingController.new);

  @override
  void dispose() {
    for (final c in _responses.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _respond(String id) async {
    final ok = await ref.read(codDiscrepancyFormProvider(id).notifier).submit();
    if (!ok || !mounted) return;
    _field(id).clear();
    ref.invalidate(codDiscrepanciesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    return StScreen(
      title: s.tx(CodText.discrepancyTitle),
      eyebrow: s.tx(CodText.eyebrow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(CodText.discrepancyNote))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<CodDiscrepancy>>(
            value: ref.watch(codDiscrepanciesProvider),
            supported: CodDiscrepancyScreen.states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: CodText.noDiscrepancies,
            onRetry: () => ref.invalidate(codDiscrepanciesProvider),
            builder: (context, list) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [for (final d in list) _caseCard(s, d)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _caseCard(AppState s, CodDiscrepancy d) {
    final form = ref.watch(codDiscrepancyFormProvider(d.id));
    final formCtrl = ref.read(codDiscrepancyFormProvider(d.id).notifier);
    final error = form.errorFor('response');
    final (tone, label) = switch (d.status) {
      DiscrepancyStatus.open => (StTone.warning, CodText.statusOpen),
      DiscrepancyStatus.responded => (StTone.info, CodText.statusResponded),
      DiscrepancyStatus.resolved => (StTone.success, CodText.statusResolved),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: StSpace.sm),
      child: StCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    s.digits(d.id),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                StStatusChip(label: s.tx(label), tone: tone),
              ],
            ),
            Text(
              s.tx(CodText.caseLine, [
                d.remittanceId,
                s.moneyMinor(d.expectedMinor),
                s.moneyMinor(d.declaredMinor),
              ]),
            ),
            StInfoRow(
              label: s.tx(CodText.difference),
              trailing: StMoneyText.minor(
                d.differenceMinor,
                align: Alignment.centerRight,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: StColors.danger,
                ),
              ),
            ),
            if (d.riderResponse != null)
              Text(s.tx(CodText.yourResponse, [d.riderResponse!])),
            if (d.status == DiscrepancyStatus.open) ...[
              const SizedBox(height: StSpace.xs),
              if (form.confirmed)
                StConfirmation(
                  message: s.tx(CodText.responded),
                  dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
                  onDismissed: formCtrl.dismissConfirmation,
                ),
              if (form.failed && form.errorKind != null)
                StCommandError(
                  name: CodText.respondName,
                  kind: form.errorKind!,
                ),
              StField(
                label: s.tx(CodText.response),
                controller: _field(d.id),
                maxLines: 3,
                error: error == null ? null : s.tx(error),
                onChanged: formCtrl.set,
              ),
              const SizedBox(height: StSpace.xs),
              StBtn(
                label: s.tx(CodText.attach),
                variant: StBtnVariant.outline,
                icon: Icons.attach_file_rounded,
                disabled: true,
                reason: s.tx(CodText.attachGap),
              ),
              const SizedBox(height: StSpace.xs),
              StCommandButton(
                label: s.tx(CodText.respond),
                icon: Icons.send_rounded,
                busy: form.submitting,
                onTap: () => _respond(d.id),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
