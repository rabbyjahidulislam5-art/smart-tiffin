import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/finance/batch_status.dart';
import '../../models/finance/payout_batch.dart';
import '../../models/finance/payout_case_status.dart';
import '../../models/finance/payout_request_case.dart';
import '../../repositories/finance/payout_operations_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';
import 'finance_staff.dart';

/// Payout review and batches with the preparer and approver rule (ADR-010).
class MockPayoutOperationsRepository extends MockRepositoryBase implements PayoutOperationsRepository {
  MockPayoutOperationsRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.accounting};

  final List<PayoutRequestCase> _requests = [
    const PayoutRequestCase(id: 'PO-311', partyName: "Rina's Kitchen", partyKind: 'supplier', amountMinor: 1260000, eligibleMinor: 1845000, beneficiaryVerified: true, status: PayoutCaseStatus.requested),
    const PayoutRequestCase(id: 'PO-312', partyName: "Maa's Kitchen", partyKind: 'supplier', amountMinor: 900000, eligibleMinor: 1555500, beneficiaryVerified: true, status: PayoutCaseStatus.approved),
    const PayoutRequestCase(id: 'PO-313', partyName: 'Rokon', partyKind: 'rider', amountMinor: 200000, eligibleMinor: 260000, beneficiaryVerified: true, status: PayoutCaseStatus.approved),
    const PayoutRequestCase(id: 'PO-314', partyName: 'Sabbir Hasan', partyKind: 'rider', amountMinor: 350000, eligibleMinor: 318000, beneficiaryVerified: false, status: PayoutCaseStatus.requested),
  ];

  final List<PayoutBatch> _batches = [
    const PayoutBatch(id: 'PB-21', requestIds: ['PO-300', 'PO-301'], totalMinor: 1840000, status: BatchStatus.prepared, preparedBy: FinanceStaff.operator),
    const PayoutBatch(id: 'PB-20', requestIds: ['PO-298'], totalMinor: 980000, status: BatchStatus.settled, preparedBy: FinanceStaff.operator, approvedBy: FinanceStaff.approver, resultRef: 'BK-77120'),
  ];
  int _seq = 21;

  @override
  Future<RepoResult<List<PayoutRequestCase>>> requests(Actor actor) => guardRead(actor, roles, 'requests', () => Ok(List.unmodifiable(_requests)));

  @override
  Future<RepoResult<PayoutRequestCase>> reviewPayout(Actor actor, RequestId requestId, {required String caseId}) =>
      guardCommand(actor, roles, 'reviewPayout', requestId, () {
        final i = _requests.indexWhere((r) => r.id == caseId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final r = _requests[i];
        if (r.status != PayoutCaseStatus.requested) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (r.amountMinor > r.eligibleMinor || !r.beneficiaryVerified) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'eligibility'));
        final next = r.withStatus(PayoutCaseStatus.approved);
        _requests[i] = next;
        return Ok(next);
      });

  @override
  Future<RepoResult<PayoutRequestCase>> rejectPayout(Actor actor, RequestId requestId, {required String caseId, required String reason}) =>
      guardCommand(actor, roles, 'rejectPayout', requestId, () {
        final i = _requests.indexWhere((r) => r.id == caseId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (_requests[i].status != PayoutCaseStatus.requested) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (reason.trim().length < 5) return MockRepositoryBase.invalid('reason');
        final next = _requests[i].withStatus(PayoutCaseStatus.rejected, reason: reason.trim());
        _requests[i] = next;
        return Ok(next);
      });

  @override
  Future<RepoResult<List<PayoutBatch>>> batches(Actor actor) => guardRead(actor, roles, 'batches', () => Ok(List.unmodifiable(_batches)));

  @override
  Future<RepoResult<PayoutBatch>> createPayoutBatch(Actor actor, RequestId requestId, {required List<String> caseIds}) =>
      guardCommand(actor, roles, 'createPayoutBatch', requestId, () {
        if (caseIds.isEmpty) return MockRepositoryBase.invalid('selection');
        final idx = <int>[];
        for (final id in caseIds) {
          final i = _requests.indexWhere((r) => r.id == id);
          if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
          if (_requests[i].status != PayoutCaseStatus.approved) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
          idx.add(i);
        }
        var total = 0;
        for (final i in idx) {
          total += _requests[i].amountMinor;
          _requests[i] = _requests[i].withStatus(PayoutCaseStatus.batched);
        }
        final b = PayoutBatch(id: 'PB-${++_seq}', requestIds: List.unmodifiable(caseIds), totalMinor: total, status: BatchStatus.prepared, preparedBy: actor.id ?? FinanceStaff.me);
        _batches.insert(0, b);
        return Ok(b);
      });

  @override
  Future<RepoResult<PayoutBatch>> releasePayoutBatch(Actor actor, RequestId requestId, {required String batchId}) =>
      guardCommand(actor, roles, 'releasePayoutBatch', requestId, () {
        final i = _batches.indexWhere((b) => b.id == batchId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final b = _batches[i];
        if (b.status != BatchStatus.prepared) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (b.preparedBy == actor.id) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'approver'));
        final next = b.copyWith(status: BatchStatus.processing, approvedBy: actor.id);
        _batches[i] = next;
        return Ok(next);
      });

  @override
  Future<RepoResult<PayoutBatch>> recordPayoutResult(Actor actor, RequestId requestId, {required String batchId, required bool settled, required String reference}) =>
      guardCommand(actor, roles, 'recordPayoutResult', requestId, () {
        final i = _batches.indexWhere((b) => b.id == batchId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final b = _batches[i];
        if (b.status != BatchStatus.processing) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (settled && reference.trim().length < 4) return MockRepositoryBase.invalid('reference');
        final next = b.copyWith(status: settled ? BatchStatus.settled : BatchStatus.failed, resultRef: settled ? reference.trim() : null);
        _batches[i] = next;
        return Ok(next);
      });
}
