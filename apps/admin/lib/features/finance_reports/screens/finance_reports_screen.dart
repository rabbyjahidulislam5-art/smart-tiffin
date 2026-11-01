import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../controllers/finance_reports_providers.dart';
import 'finance_reports_text.dart';

/// NF-14 Financial report export (`exportReport`, financial scope) with the
/// export log and its provenance.
class FinanceReportsScreen extends ConsumerStatefulWidget {
  const FinanceReportsScreen({super.key});

  static const states = {
    StVariant.loading,
    StVariant.error,
    StVariant.empty,
    StVariant.offline,
  };

  @override
  ConsumerState<FinanceReportsScreen> createState() =>
      _FinanceReportsScreenState();
}

class _FinanceReportsScreenState extends ConsumerState<FinanceReportsScreen> {
  final _from = TextEditingController(text: '2026-10-01');
  final _to = TextEditingController(text: '2026-10-31');

  @override
  void dispose() {
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  Future<void> _export() async {
    final ok = await ref.read(financeExportFormProvider.notifier).submit();
    if (ok && mounted) ref.invalidate(financeExportLogProvider);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final form = ref.watch(financeExportFormProvider);
    final formCtrl = ref.read(financeExportFormProvider.notifier);
    String? err(String f) =>
        form.errorFor(f) == null ? null : s.tx(form.errorFor(f)!);
    return StScreen(
      title: s.tx(FinanceReportsText.title),
      eyebrow: s.tx(FinanceReportsText.eyebrow),
      dense: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StNote(child: Text(s.tx(FinanceReportsText.intro))),
          const SizedBox(height: StSpace.sm),
          StAsyncView<List<ReportDefinition>>(
            value: ref.watch(financeReportDefinitionsProvider),
            supported: FinanceReportsScreen.states,
            isEmpty: (l) => l.isEmpty,
            emptyMessage: FinanceReportsText.empty,
            onRetry: () => ref.invalidate(financeReportDefinitionsProvider),
            builder: (context, defs) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final d in defs)
                  Padding(
                    padding: const EdgeInsets.only(bottom: StSpace.xs),
                    child: StCard(
                      key: ValueKey('fin-report-${d.id}'),
                      color: form.values.definitionId == d.id
                          ? context.roleColor.withValues(alpha: 0.08)
                          : null,
                      onTap: () => formCtrl.update(
                        (v) => (definitionId: d.id, from: v.from, to: v.to),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            form.values.definitionId == d.id
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: context.roleColor,
                          ),
                          const SizedBox(width: StSpace.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.tx(d.title),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  s.tx(d.description),
                                  style: const TextStyle(
                                    fontSize: StFont.label,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (err('definition') != null)
                  Text(
                    err('definition')!,
                    style: const TextStyle(
                      color: StColors.danger,
                      fontSize: StFont.label,
                    ),
                  ),
                const SizedBox(height: StSpace.sm),
                if (form.confirmed) ...[
                  StConfirmation(
                    message: s.tx(FinanceReportsText.success),
                    dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
                    onDismissed: formCtrl.dismissConfirmation,
                  ),
                  const SizedBox(height: StSpace.xs),
                ],
                if (form.failed && form.errorKind != null) ...[
                  StCommandError(
                    name: FinanceReportsText.commandName,
                    kind: form.errorKind!,
                  ),
                  const SizedBox(height: StSpace.xs),
                ],
                Row(
                  children: [
                    Expanded(
                      child: StField(
                        label: s.tx(FinanceReportsText.from),
                        controller: _from,
                        keyboardType: TextInputType.datetime,
                        onChanged: (t) => formCtrl.update(
                          (v) =>
                              (definitionId: v.definitionId, from: t, to: v.to),
                        ),
                      ),
                    ),
                    const SizedBox(width: StSpace.sm),
                    Expanded(
                      child: StField(
                        label: s.tx(FinanceReportsText.to),
                        controller: _to,
                        keyboardType: TextInputType.datetime,
                        onChanged: (t) => formCtrl.update(
                          (v) => (
                            definitionId: v.definitionId,
                            from: v.from,
                            to: t,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (err('range') != null)
                  Text(
                    err('range')!,
                    style: const TextStyle(
                      color: StColors.danger,
                      fontSize: StFont.label,
                    ),
                  ),
                const SizedBox(height: StSpace.sm),
                StCommandButton(
                  label: s.tx(FinanceReportsText.exportLabel),
                  icon: Icons.download_rounded,
                  busy: form.submitting,
                  onTap: _export,
                ),
              ],
            ),
          ),
          const SizedBox(height: StSpace.md),
          StSection(
            title: s.tx(FinanceReportsText.log),
            child: StAsyncView<List<ExportReceipt>>(
              value: ref.watch(financeExportLogProvider),
              supported: const {
                StVariant.loading,
                StVariant.error,
                StVariant.empty,
              },
              isEmpty: (l) => l.isEmpty,
              emptyMessage: FinanceReportsText.noExports,
              onRetry: () => ref.invalidate(financeExportLogProvider),
              builder: (context, log) => StList(
                children: [
                  for (final r in log)
                    StRowTile(
                      icon: Icons.file_download_done_outlined,
                      label: s.tx(FinanceReportsText.logLine, [
                        r.definitionId,
                        r.range,
                      ]),
                      sub: s.tx(FinanceReportsText.logLine, [
                        r.at,
                        r.provenance,
                      ]),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
