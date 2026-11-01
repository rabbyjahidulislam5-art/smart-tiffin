import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/customer/price_explanation.dart';
import '../../models/customer/quote.dart';
import '../../models/customer/quote_line.dart';
import '../../models/customer/quote_line_kind.dart';
import '../../models/customer/quote_status.dart';
import '../../repositories/customer/quote_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../text/st_text.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';
import 'customer_fixtures.dart';
import 'mock_credit_repository.dart';
import 'mock_subscription_repository.dart';

/// Quotes. The delivery-fee line stays "not yet configured" (BR-007 pending)
/// and a reserved credit appears as its own line, so total = sum of lines.
class MockQuoteRepository extends MockRepositoryBase implements QuoteRepository {
  MockQuoteRepository({MockBehavior? behavior, this.credits, this.subscriptions}) : super(behavior);

  final MockCreditRepository? credits;
  final MockSubscriptionRepository? subscriptions;

  static const roles = {StRole.customer};
  static const cartQuoteId = 'Q-CART-1';
  static const expiredQuoteId = 'Q-OLD-1';

  static const feeLine = QuoteLine(kind: QuoteLineKind.fee, label: StText('Delivery fee (not yet configured)', 'ডেলিভারি চার্জ (এখনো নির্ধারিত নয়)'), amountMinor: 0, configured: false);

  final Map<String, Quote> _quotes = {
    cartQuoteId: const Quote(id: cartQuoteId, sourceId: 'cart', status: QuoteStatus.open, expiresAt: '2026-11-02 23:59', policyVersions: ['delivery_fee.rules · not configured'], lines: [
      QuoteLine(kind: QuoteLineKind.food, label: StText('1× Classic Chicken Biryani & Egg', '১× চিকেন বিরিয়ানি ও ডিম'), amountMinor: 18000),
      feeLine,
    ]),
    expiredQuoteId: const Quote(id: expiredQuoteId, sourceId: 'DR-0900', status: QuoteStatus.expired, expiresAt: '2026-10-20 23:59', policyVersions: ['delivery_fee.rules · not configured'], lines: [
      QuoteLine(kind: QuoteLineKind.food, label: StText('Meals (6)', 'খাবার (৬)'), amountMinor: 108000),
      feeLine,
    ]),
  };
  int _seq = 600;

  Quote _withCredit(Quote q) {
    final reserved = credits?.reservedOn(q.id) ?? 0;
    if (reserved == 0) return q;
    return q.copyWith(lines: [...q.lines, QuoteLine(kind: QuoteLineKind.credit, label: const StText('Service credit applied', 'সার্ভিস ক্রেডিট প্রয়োগ'), amountMinor: -reserved)]);
  }

  /// A quote by id with the current credit line (used by checkout and renewal).
  Quote? quoteNow(String id) {
    final q = _quotes[id];
    return q == null ? null : _withCredit(q);
  }

  /// Registers a quote built by another mock (renewal offers).
  void register(Quote q) => _quotes[q.id] = q;

  @override
  Future<RepoResult<Quote>> createQuote(Actor actor, RequestId requestId, {required String draftId}) =>
      guardCommand(actor, roles, 'createQuote', requestId, () {
        final draft = subscriptions?.draftNow(draftId);
        if (draft == null) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (draft.cells.isEmpty) return MockRepositoryBase.invalid('cells');
        var food = 0;
        var count = 0;
        for (final c in draft.cells) {
          final item = menuItemById(c.menuItemId);
          if (item == null || !item.available) return MockRepositoryBase.invalid('cells');
          food += item.priceMinor * c.qty;
          count += c.qty;
        }
        final q = Quote(
          id: 'Q-${++_seq}',
          sourceId: draftId,
          status: QuoteStatus.open,
          expiresAt: '2026-11-03 23:59',
          policyVersions: const ['delivery_fee.rules · not configured', 'discount.rules · not configured'],
          lines: [QuoteLine(kind: QuoteLineKind.food, label: StText('Meals ($count)', 'খাবার ($count)'), amountMinor: food), feeLine],
        );
        _quotes[q.id] = q;
        return Ok(q);
      });

  @override
  Future<RepoResult<Quote>> quote(Actor actor, String id) => guardRead(actor, roles, 'quote', () {
        final q = quoteNow(id);
        if (q == null) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        return Ok(q);
      });

  @override
  Future<RepoResult<Quote>> confirmQuote(Actor actor, RequestId requestId, {required String quoteId}) =>
      guardCommand(actor, roles, 'confirmQuote', requestId, () {
        final q = _quotes[quoteId];
        if (q == null) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (q.status == QuoteStatus.expired) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'expired'));
        final next = q.copyWith(status: QuoteStatus.confirmed);
        _quotes[quoteId] = next;
        return Ok(_withCredit(next));
      });

  @override
  Future<RepoResult<PriceExplanation>> priceExplanation(Actor actor, String quoteId) => guardRead(actor, roles, 'priceExplanation', () {
        final q = _quotes[quoteId];
        if (q == null) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        return Ok(PriceExplanation(
          quoteId: quoteId,
          zone: 'Banani',
          distanceBand: '0–3 km',
          groupedDelivery: q.sourceId != 'cart',
          policyVersion: 'policy.delivery_fee.rules · not configured',
        ));
      });
}
