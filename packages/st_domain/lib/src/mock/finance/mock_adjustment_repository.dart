import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/finance/adjustment.dart';
import '../../models/finance/adjustment_status.dart';
import '../../repositories/finance/adjustment_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';
import 'finance_staff.dart';

class MockAdjustmentRepository extends MockRepositoryBase implements AdjustmentRepository {
  MockAdjustmentRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.accounting};

  final List<Adjustment> _items = [
    const Adjustment(id: 'ADJ-14', description: 'Reverse duplicate delivery fee on TK-899', amountMinor: 4000, maker: FinanceStaff.operator, status: AdjustmentStatus.requested, evidenceRef: 'EV-1203'),
    const Adjustment(id: 'ADJ-15', description: 'Correct rider payable after reassignment DL-874', amountMinor: -6000, maker: FinanceStaff.me, status: AdjustmentStatus.requested, evidenceRef: 'EV-1207'),
    const Adjustment(id: 'ADJ-11', description: 'Supplier commission rounding, October', amountMinor: 1200, maker: FinanceStaff.operator, status: AdjustmentStatus.approved, evidenceRef: 'EV-1150', checker: FinanceStaff.approver),
  ];
  int _seq = 15;

  @override
  Future<RepoResult<List<Adjustment>>> adjustments(Actor actor) => guardRead(actor, roles, 'adjustments', () => Ok(List.unmodifiable(_items)));

  @override
  Future<RepoResult<Adjustment>> requestAdjustment(Actor actor, RequestId requestId,
          {required String description, required int amountMinor, required String evidenceRef}) =>
      guardCommand(actor, roles, 'requestAdjustment', requestId, () {
        if (description.trim().length < 10) return MockRepositoryBase.invalid('description');
        if (amountMinor == 0 || amountMinor.abs() > 99999999) return MockRepositoryBase.invalid('amount');
        if (evidenceRef.trim().length < 4) return MockRepositoryBase.invalid('evidence');
        final a = Adjustment(
          id: 'ADJ-${++_seq}',
          description: description.trim(),
          amountMinor: amountMinor,
          maker: actor.id ?? FinanceStaff.me,
          status: AdjustmentStatus.requested,
          evidenceRef: evidenceRef.trim(),
        );
        _items.insert(0, a);
        return Ok(a);
      });

  @override
  Future<RepoResult<Adjustment>> approveAdjustment(Actor actor, RequestId requestId, {required String adjustmentId, required bool approve}) =>
      guardCommand(actor, roles, 'approveAdjustment', requestId, () {
        final i = _items.indexWhere((a) => a.id == adjustmentId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final a = _items[i];
        if (a.status != AdjustmentStatus.requested) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (a.maker == actor.id) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'checker'));
        final next = a.decided(approve ? AdjustmentStatus.approved : AdjustmentStatus.rejected, actor.id ?? FinanceStaff.me);
        _items[i] = next;
        return Ok(next);
      });
}
