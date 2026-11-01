import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/finance/credit_liability_row.dart';
import '../../models/finance/credit_movement.dart';
import '../../models/finance/refund_ops_case.dart';
import '../../models/finance/refund_ops_kind.dart';
import '../../models/finance/refund_ops_status.dart';
import '../../repositories/finance/credit_and_refund_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../mock_behavior.dart';
import '../mock_clock.dart';
import '../mock_repository_base.dart';

class MockCreditAndRefundRepository extends MockRepositoryBase implements CreditAndRefundRepository {
  MockCreditAndRefundRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.accounting};

  final List<CreditLiabilityRow> _rows = [
    const CreditLiabilityRow(id: 'CL-91', customerRef: 'CUS-1042 · Tanvir', movement: CreditMovement.issued, amountMinor: 18000, date: '2026-10-29', sourceRef: 'Skip · OB-1988'),
    const CreditLiabilityRow(id: 'CL-92', customerRef: 'CUS-1042 · Tanvir', movement: CreditMovement.consumed, amountMinor: 18000, date: '2026-10-31', sourceRef: 'Invoice INV-W-44'),
    const CreditLiabilityRow(id: 'CL-95', customerRef: 'CUS-1077 · Nusrat', movement: CreditMovement.issued, amountMinor: 36000, date: '2026-11-01', sourceRef: 'Missing item · TK-901'),
  ];

  final List<RefundOpsCase> _cases = [
    const RefundOpsCase(id: 'RF-21', kind: RefundOpsKind.refund, orderRef: 'TK-918', amountMinor: 24000, status: RefundOpsStatus.pending),
    const RefundOpsCase(id: 'RF-22', kind: RefundOpsKind.refund, orderRef: 'TK-901', amountMinor: 36000, status: RefundOpsStatus.pending, creditIssued: true),
    const RefundOpsCase(id: 'RF-19', kind: RefundOpsKind.refund, orderRef: 'TK-880', amountMinor: 18000, status: RefundOpsStatus.executed, providerRef: 'SSL-R-4410'),
    const RefundOpsCase(id: 'CB-03', kind: RefundOpsKind.chargeback, orderRef: 'TK-866', amountMinor: 54000, status: RefundOpsStatus.disputed),
  ];
  int _seq = 95;

  @override
  Future<RepoResult<List<CreditLiabilityRow>>> liability(Actor actor) => guardRead(actor, roles, 'liability', () => Ok(List.unmodifiable(_rows)));

  @override
  Future<RepoResult<CreditLiabilityRow>> voidCredit(Actor actor, RequestId requestId, {required String rowId, required String reason}) =>
      guardCommand(actor, roles, 'voidCredit', requestId, () {
        final row = _rows.where((r) => r.id == rowId).toList();
        if (row.isEmpty) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final r = row.first;
        if (r.movement != CreditMovement.issued || _rows.any((x) => x.movement == CreditMovement.voided && x.sourceRef == 'Void ${r.id}')) {
          return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        }
        if (reason.trim().length < 5) return MockRepositoryBase.invalid('reason');
        final v = CreditLiabilityRow(id: 'CL-${++_seq}', customerRef: r.customerRef, movement: CreditMovement.voided, amountMinor: r.amountMinor, date: mockToday, sourceRef: 'Void ${r.id}');
        _rows.insert(0, v);
        return Ok(v);
      });

  @override
  Future<RepoResult<List<RefundOpsCase>>> cases(Actor actor) => guardRead(actor, roles, 'cases', () => Ok(List.unmodifiable(_cases)));

  @override
  Future<RepoResult<RefundOpsCase>> initiateRefund(Actor actor, RequestId requestId, {required String caseId}) =>
      guardCommand(actor, roles, 'initiateRefund', requestId, () {
        final i = _cases.indexWhere((c) => c.id == caseId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final c = _cases[i];
        if (c.kind != RefundOpsKind.refund || c.status != RefundOpsStatus.pending) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (c.creditIssued) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'credit'));
        final next = c.withStatus(RefundOpsStatus.approved);
        _cases[i] = next;
        return Ok(next);
      });

  @override
  Future<RepoResult<RefundOpsCase>> recordRefundResult(Actor actor, RequestId requestId, {required String caseId, required bool executed, required String providerRef}) =>
      guardCommand(actor, roles, 'recordRefundResult', requestId, () {
        final i = _cases.indexWhere((c) => c.id == caseId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (_cases[i].status != RefundOpsStatus.approved) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (executed && providerRef.trim().length < 4) return MockRepositoryBase.invalid('reference');
        final next = _cases[i].withStatus(executed ? RefundOpsStatus.executed : RefundOpsStatus.pending, providerRef: executed ? providerRef.trim() : null);
        _cases[i] = next;
        return Ok(next);
      });
}
