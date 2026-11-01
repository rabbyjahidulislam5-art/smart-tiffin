import '../../access/actor.dart';
import '../../models/admin/export_receipt.dart';
import '../../models/admin/report_definition.dart';
import '../../models/admin/report_scope.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Report export. Operational scope: admin (NA-06). Financial scope:
/// accounting only (NF-14).
abstract interface class ReportRepository {
  Future<RepoResult<List<ReportDefinition>>> definitions(Actor actor, ReportScope scope);

  Future<RepoResult<ExportReceipt>> exportReport(Actor actor, RequestId requestId, {required String definitionId, required String range});

  Future<RepoResult<List<ExportReceipt>>> exportLog(Actor actor, ReportScope scope);
}
