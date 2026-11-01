import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/admin/export_receipt.dart';
import '../../models/admin/report_definition.dart';
import '../../models/admin/report_scope.dart';
import '../../repositories/admin/report_repository.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../text/st_text.dart';
import '../mock_behavior.dart';
import '../mock_clock.dart';
import '../mock_repository_base.dart';

/// Report definitions per scope; the scope decides the allowed role.
class MockReportRepository extends MockRepositoryBase implements ReportRepository {
  MockReportRepository({MockBehavior? behavior}) : super(behavior);

  static Set<StRole> rolesFor(ReportScope scope) => scope == ReportScope.operational ? const {StRole.admin} : const {StRole.accounting};

  static const definitionFixtures = <ReportDefinition>[
    ReportDefinition(id: 'OPS-MEALS', scope: ReportScope.operational, title: StText('Meal volume', 'খাবারের পরিমাণ'), description: StText('Meals delivered by day, slot and kitchen.', 'দিন, সময় ও কিচেন অনুযায়ী ডেলিভারি হওয়া খাবার।')),
    ReportDefinition(id: 'OPS-LATE', scope: ReportScope.operational, title: StText('Late orders', 'দেরিতে পৌঁছানো অর্ডার'), description: StText('Orders delivered after their window.', 'নির্ধারিত সময়ের পরে পৌঁছানো অর্ডার।')),
    ReportDefinition(id: 'OPS-QUALITY', scope: ReportScope.operational, title: StText('Supplier quality', 'সাপ্লায়ারের মান'), description: StText('Complaints and ratings by kitchen.', 'কিচেন অনুযায়ী অভিযোগ ও রেটিং।')),
    ReportDefinition(id: 'FIN-TB', scope: ReportScope.financial, title: StText('Trial balance', 'ট্রায়াল ব্যালান্স'), description: StText('Balances of every ledger account for the period.', 'পিরিয়ডের প্রতিটি লেজার অ্যাকাউন্টের ব্যালান্স।')),
    ReportDefinition(id: 'FIN-PAYOUTS', scope: ReportScope.financial, title: StText('Settlements', 'সেটেলমেন্ট'), description: StText('Payout requests, batches and results.', 'পেআউট অনুরোধ, ব্যাচ ও ফলাফল।')),
    ReportDefinition(id: 'FIN-COD', scope: ReportScope.financial, title: StText('COD custody', 'সিওডি জিম্মা'), description: StText('Cash collected, remitted and verified.', 'সংগৃহীত, জমা ও যাচাই করা নগদ।')),
  ];

  final List<ExportReceipt> _log = [
    const ExportReceipt(id: 'EX-201', definitionId: 'OPS-LATE', range: '2026-10-01..2026-10-31', at: '2026-11-01 09:12', provenance: 'Nadia · Admin Web'),
    const ExportReceipt(id: 'EX-198', definitionId: 'FIN-TB', range: '2026-10-01..2026-10-31', at: '2026-11-01 08:40', provenance: 'Rahim · Accounts Web'),
  ];
  int _seq = 210;

  static final _range = RegExp(r'^\d{4}-\d{2}-\d{2}\.\.\d{4}-\d{2}-\d{2}$');

  ReportDefinition? _definition(String id) {
    for (final d in definitionFixtures) {
      if (d.id == id) return d;
    }
    return null;
  }

  @override
  Future<RepoResult<List<ReportDefinition>>> definitions(Actor actor, ReportScope scope) =>
      guardRead(actor, rolesFor(scope), 'definitions', () => Ok([for (final d in definitionFixtures) if (d.scope == scope) d]));

  @override
  Future<RepoResult<ExportReceipt>> exportReport(Actor actor, RequestId requestId, {required String definitionId, required String range}) {
    final scope = _definition(definitionId)?.scope ?? (actor.role == StRole.admin ? ReportScope.operational : ReportScope.financial);
    return guardCommand(actor, rolesFor(scope), 'exportReport', requestId, () {
      if (_definition(definitionId) == null) return MockRepositoryBase.invalid('report');
      if (!_range.hasMatch(range)) return MockRepositoryBase.invalid('range');
      final parts = range.split('..');
      if (parts[0].compareTo(parts[1]) > 0 || parts[1].compareTo(mockToday) > 0) return MockRepositoryBase.invalid('range');
      final who = actor.role == StRole.admin ? 'Nadia · Admin Web' : 'You · Accounts Web';
      final r = ExportReceipt(id: 'EX-${++_seq}', definitionId: definitionId, range: range, at: '$mockToday 12:00', provenance: who);
      _log.insert(0, r);
      return Ok(r);
    });
  }

  @override
  Future<RepoResult<List<ExportReceipt>>> exportLog(Actor actor, ReportScope scope) => guardRead(actor, rolesFor(scope), 'exportLog', () {
        final ids = {for (final d in definitionFixtures) if (d.scope == scope) d.id};
        return Ok([for (final r in _log) if (ids.contains(r.definitionId)) r]);
      });
}
