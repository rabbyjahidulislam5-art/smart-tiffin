import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/finance_reports_text.dart';

/// NF-14 financial report definitions.
final financeReportDefinitionsProvider =
    FutureProvider.autoDispose<List<ReportDefinition>>(
      (ref) => stUnwrap(
        ref
            .watch(reportRepositoryProvider)
            .definitions(ref.watch(actorProvider), ReportScope.financial),
      ),
    );

/// NF-14 export log (financial scope).
final financeExportLogProvider =
    FutureProvider.autoDispose<List<ExportReceipt>>(
      (ref) => stUnwrap(
        ref
            .watch(reportRepositoryProvider)
            .exportLog(ref.watch(actorProvider), ReportScope.financial),
      ),
    );

/// NF-14 export form values.
typedef FinanceExportValues = ({String definitionId, String from, String to});

/// NF-14 export form (`exportReport`, financial scope).
final financeExportFormProvider =
    StateNotifierProvider.autoDispose<
      StFormController<FinanceExportValues>,
      StFormState<FinanceExportValues>
    >((ref) {
      final repo = ref.watch(reportRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<FinanceExportValues>(
        initial: (definitionId: '', from: '2026-10-01', to: '2026-10-31'),
        validate: (v) => {
          if (v.definitionId.isEmpty)
            'definition': FinanceReportsText.chooseReport,
          if (!StReportRange.valid(v.from, v.to, ref.read(todayProvider)))
            'range': FinanceReportsText.badRange,
        },
        command: (v, id) => repo.exportReport(
          actor,
          id,
          definitionId: v.definitionId,
          range: StReportRange.of(v.from, v.to),
        ),
      );
    });
