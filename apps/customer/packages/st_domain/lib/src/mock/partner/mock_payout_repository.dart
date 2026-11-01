import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/partner/eligible_balance.dart';
import '../../models/partner/payout_record.dart';
import '../../models/partner/payout_status.dart';
import '../../repositories/partner/payout_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../result/st_page.dart';
import '../../validation/amount.dart';
import '../mock_behavior.dart';
import '../mock_clock.dart';
import '../mock_repository_base.dart';

/// Sample payout accounts for the supplier and the rider (amounts HYPOTHETICAL).
class MockPayoutRepository extends MockRepositoryBase implements PayoutRepository {
  MockPayoutRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.supplier, StRole.rider};

  final Map<StRole, int> _eligible = {StRole.supplier: 1845000, StRole.rider: 260000};
  final Map<StRole, int> _held = {StRole.supplier: 210000, StRole.rider: 7000};
  final Map<StRole, int> _pending = {StRole.supplier: 0, StRole.rider: 0};
  final Map<StRole, String> _destination = {StRole.supplier: 'bKash •••• 4821', StRole.rider: 'Nagad •••• 7710'};
  final Map<StRole, List<PayoutRecord>> _records = {
    StRole.supplier: [
      const PayoutRecord(id: 'PO-311', amountMinor: 1260000, requestedOn: '2026-10-30', status: PayoutStatus.processing, destination: 'bKash •••• 4821'),
      const PayoutRecord(id: 'PO-298', amountMinor: 980000, requestedOn: '2026-10-23', status: PayoutStatus.settled, destination: 'bKash •••• 4821', reference: 'BK-77120'),
      const PayoutRecord(id: 'PO-287', amountMinor: 450000, requestedOn: '2026-10-16', status: PayoutStatus.failed, destination: 'bKash •••• 4821'),
    ],
    StRole.rider: [
      const PayoutRecord(id: 'PO-305', amountMinor: 320000, requestedOn: '2026-10-27', status: PayoutStatus.settled, destination: 'Nagad •••• 7710', reference: 'NG-55018'),
    ],
  };
  int _seq = 400;

  /// Eligible and held balance of [role] (read by the earnings mock so both agree).
  int eligibleOf(StRole role) => _eligible[role] ?? 0;
  int heldOf(StRole role) => _held[role] ?? 0;

  @override
  Future<RepoResult<EligibleBalance>> eligibleBalance(Actor actor) => guardRead(actor, roles, 'eligibleBalance', () {
        final r = actor.role;
        return Ok(EligibleBalance(eligibleMinor: _eligible[r]!, heldMinor: _held[r]!, pendingMinor: _pending[r]!, destination: _destination[r]!));
      });

  @override
  Future<RepoResult<StPage<PayoutRecord>>> history(Actor actor, {String? cursor}) =>
      guardRead(actor, roles, 'history', () => Ok(StPage.slice(_records[actor.role]!, cursor: cursor, size: 10)));

  @override
  Future<RepoResult<PayoutRecord>> requestPayout(Actor actor, RequestId requestId, {required int amountMinor}) =>
      guardCommand(actor, roles, 'requestPayout', requestId, () {
        final r = actor.role;
        if (amountMinor < minAmountMinor || amountMinor > maxAmountMinor) return MockRepositoryBase.invalid('amount');
        if (amountMinor > _eligible[r]!) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'amount'));
        final record = PayoutRecord(
          id: 'PO-${++_seq}',
          amountMinor: amountMinor,
          requestedOn: mockToday,
          status: PayoutStatus.requested,
          destination: _destination[r]!,
        );
        _eligible[r] = _eligible[r]! - amountMinor;
        _pending[r] = _pending[r]! + amountMinor;
        _records[r]!.insert(0, record);
        return Ok(record);
      });
}
