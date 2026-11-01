import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/ops_reports_text.dart';

/// NA-06 operational report definitions.
final opsReportDefinitionsProvider =
    FutureProvider.autoDispose<List<ReportDefinition>>(
      (ref) => stUnwrap(
        ref
            .watch(reportRepositoryProvider)
            .definitions(ref.watch(actorProvider), ReportScope.operational),
      ),
    );

/// NA-06 export log (operational scope).
final opsExportLogProvider = FutureProvider.autoDispose<List<ExportReceipt>>(
  (ref) => stUnwrap(
    ref
        .watch(reportRepositoryProvider)
        .exportLog(ref.watch(actorProvider), ReportScope.operational),
  ),
);

/// NA-06 export form values.
typedef OpsExportValues = ({String definitionId, String from, String to});

/// NA-06 export form (`exportReport`, operational scope).
final opsExportFormProvider =
    StateNotifierProvider.autoDispose<
      StFormController<OpsExportValues>,
      StFormState<OpsExportValues>
    >((ref) {
      final repo = ref.watch(reportRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<OpsExportValues>(
        initial: (definitionId: '', from: '2026-10-01', to: '2026-10-31'),
        validate: (v) => {
          if (v.definitionId.isEmpty) 'definition': OpsReportsText.chooseReport,
          if (!StReportRange.valid(v.from, v.to, ref.read(todayProvider)))
            'range': OpsReportsText.badRange,
        },
        command: (v, id) => repo.exportReport(
          actor,
          id,
          definitionId: v.definitionId,
          range: StReportRange.of(v.from, v.to),
        ),
      );
    });
