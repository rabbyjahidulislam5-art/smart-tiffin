import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/customer/credit_account.dart';
import '../../models/customer/credit_class.dart';
import '../../models/customer/credit_transaction.dart';
import '../../models/customer/credit_tx_kind.dart';
import '../../repositories/customer/credit_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../result/st_page.dart';
import '../mock_behavior.dart';
import '../mock_clock.dart';
import '../mock_repository_base.dart';

/// Credits of the demo customer. Reservations are kept per quote, so one
/// credit can never be applied to two checkouts in flight (SC-23).
class MockCreditRepository extends MockRepositoryBase implements CreditRepository {
  MockCreditRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.customer};

  int _available = 41000;
  int _consumed = 18000;
  final int _expired = 0;
  final Map<String, int> _reserved = {};
  final List<CreditTransaction> _tx = [
    const CreditTransaction(id: 'CT-41', creditClass: CreditClass.promotional, kind: CreditTxKind.issued, amountMinor: 5000, sourceRef: 'Welcome offer', at: '2026-10-25'),
    const CreditTransaction(id: 'CT-44', creditClass: CreditClass.service, kind: CreditTxKind.issued, amountMinor: 18000, sourceRef: 'Skip · OB-1988', at: '2026-10-29'),
    const CreditTransaction(id: 'CT-45', creditClass: CreditClass.service, kind: CreditTxKind.consumed, amountMinor: 18000, sourceRef: 'Invoice INV-W-44', at: '2026-10-31'),
    const CreditTransaction(id: 'CT-47', creditClass: CreditClass.service, kind: CreditTxKind.issued, amountMinor: 36000, sourceRef: 'Missing item · TK-901', at: '2026-11-01'),
  ];
  int _seq = 47;

  CreditAccount get _account => CreditAccount(
        availableMinor: _available,
        reservedMinor: _reserved.values.fold(0, (a, b) => a + b),
        consumedMinor: _consumed,
        expiredMinor: _expired,
      );

  /// Issues a service credit (used by the schedule mock for skips).
  void issue(int amountMinor, String sourceRef) {
    _available += amountMinor;
    _tx.insert(0, CreditTransaction(id: 'CT-${++_seq}', creditClass: CreditClass.service, kind: CreditTxKind.issued, amountMinor: amountMinor, sourceRef: sourceRef, at: mockToday));
  }

  /// Credit reserved for [quoteId] (read by the quote mock).
  int reservedOn(String quoteId) => _reserved[quoteId] ?? 0;

  @override
  Future<RepoResult<CreditAccount>> account(Actor actor) => guardRead(actor, roles, 'account', () => Ok(_account));

  @override
  Future<RepoResult<StPage<CreditTransaction>>> transactions(Actor actor, {CreditClass? creditClass, String? cursor}) =>
      guardRead(actor, roles, 'transactions', () {
        final list = [for (final t in _tx) if (creditClass == null || t.creditClass == creditClass) t];
        return Ok(StPage.slice(list, cursor: cursor, size: 10));
      });

  @override
  Future<RepoResult<int>> reservedFor(Actor actor, String quoteId) => guardRead(actor, roles, 'reservedFor', () => Ok(reservedOn(quoteId)));

  @override
  Future<RepoResult<CreditAccount>> reserveCredit(Actor actor, RequestId requestId, {required String quoteId, required int amountMinor}) =>
      guardCommand(actor, roles, 'reserveCredit', requestId, () {
        if (amountMinor <= 0) return MockRepositoryBase.invalid('amount');
        if (amountMinor > _available) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'amount'));
        if (_reserved.containsKey(quoteId)) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        _available -= amountMinor;
        _reserved[quoteId] = amountMinor;
        _tx.insert(0, CreditTransaction(id: 'CT-${++_seq}', creditClass: CreditClass.service, kind: CreditTxKind.reserved, amountMinor: amountMinor, sourceRef: 'Quote $quoteId', at: mockToday));
        return Ok(_account);
      });

  @override
  Future<RepoResult<CreditAccount>> consumeCredit(Actor actor, RequestId requestId, {required String quoteId}) =>
      guardCommand(actor, roles, 'consumeCredit', requestId, () {
        final amount = _reserved.remove(quoteId);
        if (amount == null) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        _consumed += amount;
        _tx.insert(0, CreditTransaction(id: 'CT-${++_seq}', creditClass: CreditClass.service, kind: CreditTxKind.consumed, amountMinor: amount, sourceRef: 'Quote $quoteId', at: mockToday));
        return Ok(_account);
      });

  @override
  Future<RepoResult<CreditAccount>> releaseCredit(Actor actor, RequestId requestId, {required String quoteId}) =>
      guardCommand(actor, roles, 'releaseCredit', requestId, () {
        final amount = _reserved.remove(quoteId);
        if (amount == null) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        _available += amount;
        _tx.insert(0, CreditTransaction(id: 'CT-${++_seq}', creditClass: CreditClass.service, kind: CreditTxKind.released, amountMinor: amount, sourceRef: 'Quote $quoteId', at: mockToday));
        return Ok(_account);
      });
}
