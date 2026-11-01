import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/finance/exception_status.dart';
import '../../models/finance/gateway_statement.dart';
import '../../models/finance/recon_exception.dart';
import '../../models/finance/recon_exception_type.dart';
import '../../models/finance/recon_item.dart';
import '../../models/finance/recon_state.dart';
import '../../models/finance/statement_line.dart';
import '../../models/finance/statement_line_kind.dart';
import '../../models/finance/statement_status.dart';
import '../../repositories/finance/payment_reconciliation_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';

class MockPaymentReconciliationRepository extends MockRepositoryBase implements PaymentReconciliationRepository {
  MockPaymentReconciliationRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.accounting};

  static const matchFixtures = <ReconItem>[
    ReconItem(id: 'RC-501', paymentRef: 'SSL-88401', gatewayMinor: 180000, ledgerMinor: 180000, state: ReconState.matched),
    ReconItem(id: 'RC-502', paymentRef: 'SSL-88402', gatewayMinor: 390000, ledgerMinor: 390000, state: ReconState.matched),
    ReconItem(id: 'RC-503', paymentRef: 'SSL-88409', gatewayMinor: 36000, ledgerMinor: 18000, state: ReconState.exception),
    ReconItem(id: 'RC-504', paymentRef: 'SSL-88412', gatewayMinor: 24000, ledgerMinor: 0, state: ReconState.exception),
    ReconItem(id: 'RC-505', paymentRef: 'SSL-88415', gatewayMinor: 72000, ledgerMinor: 72000, state: ReconState.resolving),
  ];

  final List<ReconException> _exceptions = [
    const ReconException(id: 'EXC-31', type: ReconExceptionType.invalid, ref: 'SSL-88409', amountMinor: 18000, status: ExceptionStatus.open),
    const ReconException(id: 'EXC-32', type: ReconExceptionType.unmatched, ref: 'SSL-88412', amountMinor: 24000, status: ExceptionStatus.open),
    const ReconException(id: 'EXC-29', type: ReconExceptionType.duplicate, ref: 'SSL-88377', amountMinor: 18000, status: ExceptionStatus.assigned, assignedTo: 'Rahim'),
  ];

  final List<GatewayStatement> _statements = [
    const GatewayStatement(id: 'ST-2026-10-B', provider: 'SSLCOMMERZ', period: '2026-10-16..2026-10-31', status: StatementStatus.deviation, lines: [
      StatementLine(ref: 'Payments', kind: StatementLineKind.payment, statementMinor: 4824000, recordMinor: 4806000),
      StatementLine(ref: 'Processor fees', kind: StatementLineKind.fee, statementMinor: -96480, recordMinor: -96480),
      StatementLine(ref: 'Refund deductions', kind: StatementLineKind.refund, statementMinor: -36000, recordMinor: -36000),
      StatementLine(ref: 'Withholding', kind: StatementLineKind.withholding, statementMinor: -12000, recordMinor: 0),
    ]),
    const GatewayStatement(id: 'ST-2026-10-A', provider: 'SSLCOMMERZ', period: '2026-10-01..2026-10-15', status: StatementStatus.reconciled, evidenceRef: 'EV-1180', lines: [
      StatementLine(ref: 'Payments', kind: StatementLineKind.payment, statementMinor: 4410000, recordMinor: 4410000),
      StatementLine(ref: 'Processor fees', kind: StatementLineKind.fee, statementMinor: -88200, recordMinor: -88200),
    ]),
  ];

  @override
  Future<RepoResult<List<ReconItem>>> matches(Actor actor) => guardRead(actor, roles, 'matches', () => const Ok(matchFixtures));

  @override
  Future<RepoResult<List<ReconException>>> exceptions(Actor actor) => guardRead(actor, roles, 'exceptions', () => Ok(List.unmodifiable(_exceptions)));

  @override
  Future<RepoResult<List<GatewayStatement>>> statements(Actor actor) => guardRead(actor, roles, 'statements', () => Ok(List.unmodifiable(_statements)));

  @override
  Future<RepoResult<GatewayStatement>> reconcileGatewayStatement(Actor actor, RequestId requestId, {required String statementId, required String evidenceRef}) =>
      guardCommand(actor, roles, 'reconcileGatewayStatement', requestId, () {
        final i = _statements.indexWhere((s) => s.id == statementId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final s = _statements[i];
        if (s.status == StatementStatus.reconciled) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (evidenceRef.trim().length < 4) return MockRepositoryBase.invalid('evidence');
        final next = GatewayStatement(id: s.id, provider: s.provider, period: s.period, lines: s.lines, status: StatementStatus.reconciled, evidenceRef: evidenceRef.trim());
        _statements[i] = next;
        return Ok(next);
      });

  @override
  Future<RepoResult<List<ReconException>>> assignException(Actor actor, RequestId requestId, {required List<String> exceptionIds, required String assignee}) =>
      guardCommand(actor, roles, 'assignException', requestId, () {
        if (exceptionIds.isEmpty) return MockRepositoryBase.invalid('selection');
        if (assignee.trim().isEmpty) return MockRepositoryBase.invalid('assignee');
        final idx = <int>[];
        for (final id in exceptionIds) {
          final i = _exceptions.indexWhere((e) => e.id == id);
          if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
          if (_exceptions[i].status == ExceptionStatus.resolved) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
          idx.add(i);
        }
        final out = <ReconException>[];
        for (final i in idx) {
          final e = _exceptions[i];
          final next = ReconException(id: e.id, type: e.type, ref: e.ref, amountMinor: e.amountMinor, status: ExceptionStatus.assigned, assignedTo: assignee.trim());
          _exceptions[i] = next;
          out.add(next);
        }
        return Ok(out);
      });
}
