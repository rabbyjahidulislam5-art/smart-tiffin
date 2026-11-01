import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/customer/billing_frequency.dart';
import '../../models/customer/draft_status.dart';
import '../../models/customer/quote.dart';
import '../../models/customer/quote_line.dart';
import '../../models/customer/quote_line_kind.dart';
import '../../models/customer/quote_status.dart';
import '../../models/customer/recurrence_rule.dart';
import '../../models/customer/renewal_offer.dart';
import '../../models/customer/renewal_status.dart';
import '../../models/customer/schedule_cell.dart';
import '../../models/customer/schedule_exception.dart';
import '../../models/customer/subscription_change.dart';
import '../../models/customer/subscription_change_kind.dart';
import '../../models/customer/subscription_draft.dart';
import '../../repositories/customer/subscription_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../result/st_page.dart';
import '../../text/st_text.dart';
import '../mock_behavior.dart';
import '../mock_clock.dart';
import '../mock_repository_base.dart';
import 'customer_fixtures.dart';

/// Drafts, history and renewal of the demo customer's subscription SUB-301.
class MockSubscriptionRepository extends MockRepositoryBase implements SubscriptionRepository {
  MockSubscriptionRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.customer};
  static const activeSubscription = 'SUB-301';
  static const expiredOfferSubscription = 'SUB-299';

  final Map<String, SubscriptionDraft> _drafts = {};
  int _seq = 1000;

  static const _history = <SubscriptionChange>[
    SubscriptionChange(id: 'CH-6', at: '2026-11-01', kind: SubscriptionChangeKind.invoiceRevised, actor: 'System', summary: StText('November invoice issued after a skip credit', 'স্কিপ ক্রেডিটের পরে নভেম্বরের ইনভয়েস'), adjustmentRef: 'INV-M-11'),
    SubscriptionChange(id: 'CH-5', at: '2026-10-29', kind: SubscriptionChangeKind.swapped, actor: 'You', summary: StText('Thursday lunch changed to Khichuri', 'বৃহস্পতিবারের লাঞ্চ খিচুড়িতে বদল'), before: 'Bengali Thali', after: 'Bhuna Khichuri'),
    SubscriptionChange(id: 'CH-4', at: '2026-10-21', kind: SubscriptionChangeKind.paused, actor: 'You', summary: StText('Paused 2 days (Oct 22–23)', '২ দিন বিরতি (২২–২৩ অক্টো)'), adjustmentRef: 'CR-218'),
    SubscriptionChange(id: 'CH-3', at: '2026-10-12', kind: SubscriptionChangeKind.rescheduled, actor: 'You', summary: StText('Delivery window moved to 13:00', 'ডেলিভারির সময় ১৩:০০ তে সরানো'), before: '12:30', after: '13:00'),
    SubscriptionChange(id: 'CH-1', at: '2026-10-01', kind: SubscriptionChangeKind.created, actor: 'You', summary: StText('Monthly Lunch started', 'মাসিক লাঞ্চ শুরু')),
  ];

  RenewalOffer _offer = const RenewalOffer(
    id: 'RO-301',
    subscriptionId: activeSubscription,
    term: StText('Monthly Lunch · December 2026', 'মাসিক লাঞ্চ · ডিসেম্বর ২০২৬'),
    changes: [StText('Same kitchen, meals and delivery window', 'একই কিচেন, খাবার ও ডেলিভারির সময়'), StText('Prices from the current price version', 'বর্তমান দামের সংস্করণ অনুযায়ী দাম')],
    expiresAt: '2026-11-28',
    status: RenewalStatus.open,
    quote: Quote(id: 'Q-RO-301', sourceId: 'RO-301', status: QuoteStatus.open, expiresAt: '2026-11-28 23:59', policyVersions: ['delivery_fee.rules · not configured'], lines: [
      QuoteLine(kind: QuoteLineKind.food, label: StText('26 lunches', '২৬টি লাঞ্চ'), amountMinor: 390000),
      QuoteLine(kind: QuoteLineKind.fee, label: StText('Delivery fee (not yet configured)', 'ডেলিভারি চার্জ (এখনো নির্ধারিত নয়)'), amountMinor: 0, configured: false),
    ]),
  );

  static const _expiredOffer = RenewalOffer(
    id: 'RO-299',
    subscriptionId: expiredOfferSubscription,
    term: StText('Weekly Lunch · renewal', 'সাপ্তাহিক লাঞ্চ · নবায়ন'),
    changes: [],
    expiresAt: '2026-10-15',
    status: RenewalStatus.expired,
    quote: Quote(id: 'Q-RO-299', sourceId: 'RO-299', status: QuoteStatus.expired, expiresAt: '2026-10-15 23:59', policyVersions: [], lines: []),
  );

  /// A draft by id (read by the quote mock).
  SubscriptionDraft? draftNow(String id) => _drafts[id];

  RepoResult<SubscriptionDraft> _editable(String id, int expectedVersion) {
    final d = _drafts[id];
    if (d == null || d.status == DraftStatus.discarded) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
    if (d.version != expectedVersion) return MockRepositoryBase.fail(RepoErrorKind.conflict);
    return Ok(d);
  }

  @override
  Future<RepoResult<SubscriptionDraft>> createDraft(Actor actor, RequestId requestId, {required String kitchenId}) =>
      guardCommand(actor, roles, 'createDraft', requestId, () {
        final k = publishedKitchens.where((k) => k.id == kitchenId || k.nameEn == kitchenId).toList();
        if (k.isEmpty) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (!k.first.accepting) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        final d = SubscriptionDraft(
          id: 'DR-${++_seq}',
          version: 1,
          kitchenId: k.first.id,
          startDate: '2026-11-03',
          weeks: 4,
          billing: BillingFrequency.monthly,
          cells: const [],
          status: DraftStatus.draft,
          addressLabel: 'Banani Block D, Road 11',
          window: '12:30–14:00',
        );
        _drafts[d.id] = d;
        return Ok(d);
      });

  @override
  Future<RepoResult<SubscriptionDraft>> draft(Actor actor, String id) => guardRead(actor, roles, 'draft', () {
        final d = _drafts[id];
        if (d == null || d.status == DraftStatus.discarded) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        return Ok(d);
      });

  @override
  Future<RepoResult<SubscriptionDraft>> saveSchedule(Actor actor, RequestId requestId,
          {required String draftId,
          required int expectedVersion,
          required String startDate,
          required int weeks,
          required BillingFrequency billing,
          required List<ScheduleCell> cells,
          String? addressLabel,
          String? window}) =>
      guardCommand(actor, roles, 'saveSchedule', requestId, () {
        final current = _editable(draftId, expectedVersion);
        if (current is Err<SubscriptionDraft>) return current;
        final d = (current as Ok<SubscriptionDraft>).value;
        if (startDate.compareTo(mockToday) <= 0) return MockRepositoryBase.invalid('startDate');
        if (weeks < 1 || weeks > 12) return MockRepositoryBase.invalid('weeks');
        final seen = <String>{};
        for (final c in cells) {
          final item = menuItemById(c.menuItemId);
          if (item == null || item.kitchenId != d.kitchenId || item.slot != c.slot) return MockRepositoryBase.invalid('cells');
          if (c.qty < 1 || c.qty > 10) return MockRepositoryBase.invalid('qty');
          if (!seen.add('${c.date}|${c.slot.name}|${c.menuItemId}')) return MockRepositoryBase.invalid('cells');
        }
        final next = d.copyWith(version: d.version + 1, startDate: startDate, weeks: weeks, billing: billing, cells: List.unmodifiable(cells), addressLabel: addressLabel, window: window);
        _drafts[draftId] = next;
        return Ok(next);
      });

  @override
  Future<RepoResult<SubscriptionDraft>> savePattern(Actor actor, RequestId requestId,
          {required String draftId, required int expectedVersion, required RecurrenceRule rule, List<ScheduleException> exceptions = const []}) =>
      guardCommand(actor, roles, 'savePattern', requestId, () {
        final current = _editable(draftId, expectedVersion);
        if (current is Err<SubscriptionDraft>) return current;
        final d = (current as Ok<SubscriptionDraft>).value;
        final item = menuItemById(rule.menuItemId);
        if (item == null || item.kitchenId != d.kitchenId || item.slot != rule.slot) return MockRepositoryBase.invalid('menuItem');
        if (rule.weekdays.isEmpty || rule.weekdays.any((w) => w < 1 || w > 7)) return MockRepositoryBase.invalid('weekdays');
        if (rule.qty < 1 || rule.qty > 10) return MockRepositoryBase.invalid('qty');
        final dates = <String>{for (final e in exceptions) e.date};
        if (dates.length != exceptions.length) return MockRepositoryBase.fail(RepoErrorKind.conflict);
        final start = DateTime.utc(int.parse(d.startDate.substring(0, 4)), int.parse(d.startDate.substring(5, 7)), int.parse(d.startDate.substring(8, 10)));
        final cells = <ScheduleCell>[];
        for (var i = 0; i < rule.weeks * 7; i++) {
          final day = start.add(Duration(days: i));
          if (!rule.weekdays.contains(day.weekday)) continue;
          final date = '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
          final ex = exceptions.where((e) => e.date == date).toList();
          if (ex.isNotEmpty && ex.first.skip) continue;
          cells.add(ScheduleCell(date: date, slot: rule.slot, menuItemId: ex.isNotEmpty ? (ex.first.menuItemId ?? rule.menuItemId) : rule.menuItemId, qty: rule.qty));
        }
        final next = d.copyWith(version: d.version + 1, weeks: rule.weeks, cells: List.unmodifiable(cells));
        _drafts[draftId] = next;
        return Ok(next);
      });

  @override
  Future<RepoResult<SubscriptionDraft>> discard(Actor actor, RequestId requestId, {required String draftId}) =>
      guardCommand(actor, roles, 'discard', requestId, () {
        final d = _drafts[draftId];
        if (d == null || d.status == DraftStatus.discarded) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final next = d.copyWith(status: DraftStatus.discarded, version: d.version + 1);
        _drafts[draftId] = next;
        return Ok(next);
      });

  @override
  Future<RepoResult<StPage<SubscriptionChange>>> changeHistory(Actor actor, String subscriptionId, {String? cursor}) =>
      guardRead(actor, roles, 'changeHistory', () {
        if (subscriptionId != activeSubscription) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        return Ok(StPage.slice(_history, cursor: cursor, size: 10));
      });

  @override
  Future<RepoResult<RenewalOffer>> renewalOffer(Actor actor, String subscriptionId) => guardRead(actor, roles, 'renewalOffer', () {
        if (subscriptionId == activeSubscription) return Ok(_offer);
        if (subscriptionId == expiredOfferSubscription) return const Ok(_expiredOffer);
        return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
      });

  @override
  Future<RepoResult<RenewalOffer>> respondToRenewal(Actor actor, RequestId requestId, {required String offerId, required bool accept}) =>
      guardCommand(actor, roles, 'respondToRenewal', requestId, () {
        if (offerId == _expiredOffer.id) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'expired'));
        if (offerId != _offer.id) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (_offer.status != RenewalStatus.open) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        _offer = _offer.withStatus(accept ? RenewalStatus.accepted : RenewalStatus.declined);
        return Ok(_offer);
      });
}
