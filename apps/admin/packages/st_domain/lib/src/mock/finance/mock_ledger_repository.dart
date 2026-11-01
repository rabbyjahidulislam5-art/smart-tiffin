import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/finance/journal.dart';
import '../../models/finance/journal_line.dart';
import '../../models/finance/journal_status.dart';
import '../../models/finance/period.dart';
import '../../models/finance/period_check.dart';
import '../../models/finance/period_status.dart';
import '../../repositories/finance/ledger_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../result/st_page.dart';
import '../../text/st_text.dart';
import '../mock_behavior.dart';
import '../mock_clock.dart';
import '../mock_repository_base.dart';

class MockLedgerRepository extends MockRepositoryBase implements LedgerRepository {
  MockLedgerRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.accounting};
  static const pageSize = 4;

  final List<Journal> _journals = [
    const Journal(id: 'JE-9012', date: '2026-11-02', source: 'confirmQuote', policyVersion: 'billing.rules · pending', status: JournalStatus.posted, lines: [
      JournalLine(account: 'cash_and_clearing', debitMinor: 390000),
      JournalLine(account: 'customer_prepaid_obligation', creditMinor: 390000),
    ]),
    const Journal(id: 'JE-9011', date: '2026-11-01', source: 'verifyCodRemittance', policyVersion: '-', status: JournalStatus.posted, lines: [
      JournalLine(account: 'cash_and_clearing', debitMinor: 60000),
      JournalLine(account: 'cod_receivable', creditMinor: 60000),
    ]),
    const Journal(id: 'JE-9008', date: '2026-10-31', source: 'recognizeEarning', policyVersion: 'commission · sample', status: JournalStatus.posted, lines: [
      JournalLine(account: 'customer_prepaid_obligation', debitMinor: 36000),
      JournalLine(account: 'supplier_payable', creditMinor: 30600),
      JournalLine(account: 'platform_revenue', creditMinor: 5400),
    ]),
    const Journal(id: 'JE-9004', date: '2026-10-30', source: 'issueCredit', policyVersion: 'credit.formula · pending', status: JournalStatus.posted, lines: [
      JournalLine(account: 'customer_prepaid_obligation', debitMinor: 18000),
      JournalLine(account: 'customer_credit_liability', creditMinor: 18000),
    ]),
    const Journal(id: 'JE-9001', date: '2026-10-29', source: 'recordPayoutResult', policyVersion: '-', status: JournalStatus.posted, lines: [
      JournalLine(account: 'supplier_payable', debitMinor: 980000),
      JournalLine(account: 'cash_and_clearing', creditMinor: 980000),
    ]),
  ];

  final List<Period> _periods = [
    const Period(id: '2026-11', status: PeriodStatus.open, checklist: [
      PeriodCheck(key: 'gateway', label: StText('All gateway settlements reconciled (NF-02)', 'সব গেটওয়ে সেটেলমেন্ট মেলানো হয়েছে (NF-02)'), done: false),
      PeriodCheck(key: 'cod', label: StText('All COD remittances verified (NF-04)', 'সব সিওডি জমা যাচাই হয়েছে (NF-04)'), done: false),
      PeriodCheck(key: 'exceptions', label: StText('Exceptions resolved or carried forward (NF-13)', 'ব্যতিক্রম সমাধান বা পরের পিরিয়ডে নেওয়া হয়েছে (NF-13)'), done: false),
      PeriodCheck(key: 'balances', label: StText('Credit and payable balances agree', 'ক্রেডিট ও পাওনা ব্যালান্স মিলেছে'), done: true),
    ]),
    const Period(id: '2026-10', status: PeriodStatus.closing, checklist: [
      PeriodCheck(key: 'gateway', label: StText('All gateway settlements reconciled (NF-02)', 'সব গেটওয়ে সেটেলমেন্ট মেলানো হয়েছে (NF-02)'), done: true),
      PeriodCheck(key: 'cod', label: StText('All COD remittances verified (NF-04)', 'সব সিওডি জমা যাচাই হয়েছে (NF-04)'), done: true),
      PeriodCheck(key: 'exceptions', label: StText('Exceptions resolved or carried forward (NF-13)', 'ব্যতিক্রম সমাধান বা পরের পিরিয়ডে নেওয়া হয়েছে (NF-13)'), done: true),
      PeriodCheck(key: 'balances', label: StText('Credit and payable balances agree', 'ক্রেডিট ও পাওনা ব্যালান্স মিলেছে'), done: true),
    ]),
    const Period(id: '2026-09', status: PeriodStatus.closed, checklist: []),
  ];
  int _seq = 9012;

  @override
  Future<RepoResult<StPage<Journal>>> journals(Actor actor, {String? account, String? cursor}) => guardRead(actor, roles, 'journals', () {
        final list = [for (final j in _journals) if (account == null || j.lines.any((l) => l.account == account)) j];
        return Ok(StPage.slice(list, cursor: cursor, size: pageSize));
      });

  @override
  Future<RepoResult<Journal>> reverseJournal(Actor actor, RequestId requestId, {required String journalId, required String reason}) =>
      guardCommand(actor, roles, 'reverseJournal', requestId, () {
        final i = _journals.indexWhere((j) => j.id == journalId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final j = _journals[i];
        if (j.status != JournalStatus.posted || j.reversalOf != null) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (reason.trim().length < 10) return MockRepositoryBase.invalid('reason');
        final id = 'JE-${++_seq}';
        final reversal = Journal(
          id: id,
          date: mockToday,
          source: 'reverseJournal',
          policyVersion: j.policyVersion,
          status: JournalStatus.posted,
          reversalOf: j.id,
          lines: [for (final l in j.lines) JournalLine(account: l.account, debitMinor: l.creditMinor, creditMinor: l.debitMinor)],
        );
        _journals[i] = j.reversed(id);
        _journals.insert(0, reversal);
        return Ok(reversal);
      });

  @override
  Future<RepoResult<List<Period>>> periods(Actor actor) => guardRead(actor, roles, 'periods', () => Ok(List.unmodifiable(_periods)));

  @override
  Future<RepoResult<Period>> closePeriod(Actor actor, RequestId requestId, {required String periodId}) =>
      guardCommand(actor, roles, 'closePeriod', requestId, () {
        final i = _periods.indexWhere((p) => p.id == periodId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final p = _periods[i];
        if (p.status == PeriodStatus.closed) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (!p.ready) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'checklist'));
        final next = p.withStatus(PeriodStatus.closed);
        _periods[i] = next;
        return Ok(next);
      });

  @override
  Future<RepoResult<Period>> reopenPeriod(Actor actor, RequestId requestId, {required String periodId, required String reason}) =>
      guardCommand(actor, roles, 'reopenPeriod', requestId, () {
        final i = _periods.indexWhere((p) => p.id == periodId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (_periods[i].status != PeriodStatus.closed) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (reason.trim().length < 10) return MockRepositoryBase.invalid('reason');
        final next = _periods[i].withStatus(PeriodStatus.reopened, note: reason.trim());
        _periods[i] = next;
        return Ok(next);
      });
}
