import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/customer/cart_line.dart';
import '../../models/customer/checkout_summary.dart';
import '../../models/customer/cod_eligibility.dart';
import '../../models/customer/order_receipt.dart';
import '../../models/customer/order_status.dart';
import '../../models/customer/payment_choice.dart';
import '../../models/customer/quote_status.dart';
import '../../repositories/customer/checkout_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../result/slot.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';
import 'mock_quote_repository.dart';

/// One-time checkout of the demo cart. COD eligibility is a sample check
/// while BR-012 is pending; online payment stays `paymentPending` (SC-13).
class MockCheckoutRepository extends MockRepositoryBase implements CheckoutRepository {
  MockCheckoutRepository({MockBehavior? behavior, required this.quotes}) : super(behavior);

  final MockQuoteRepository quotes;

  static const roles = {StRole.customer};

  /// Sample COD limit (BR-012 pending).
  static const sampleCodLimitMinor = 100000;

  static const cart = [CartLine(menuItemId: 'mk-biryani', mealId: 'biryani', qty: 1, priceMinor: 18000)];
  int _seq = 929;

  @override
  Future<RepoResult<CheckoutSummary>> summary(Actor actor) => guardRead(actor, roles, 'summary', () {
        final q = quotes.quoteNow(MockQuoteRepository.cartQuoteId)!;
        return Ok(CheckoutSummary(lines: cart, addressLabel: 'Banani Block D, Road 11', zoneServed: true, slot: Slot.lunch, quote: q));
      });

  @override
  Future<RepoResult<CodEligibility>> codEligibility(Actor actor) => guardRead(actor, roles, 'codEligibility', () {
        final total = quotes.quoteNow(MockQuoteRepository.cartQuoteId)!.totalMinor;
        return Ok(total <= sampleCodLimitMinor ? const CodEligibility(eligible: true) : const CodEligibility(eligible: false, reasonKey: 'amount'));
      });

  @override
  Future<RepoResult<OrderReceipt>> placeOneTimeOrder(Actor actor, RequestId requestId, {required String quoteId, required PaymentChoice payment}) =>
      guardCommand(actor, roles, 'placeOneTimeOrder', requestId, () {
        final q = quotes.quoteNow(quoteId);
        if (q == null) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (q.status != QuoteStatus.confirmed) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'quote'));
        if (payment == PaymentChoice.cod && q.totalMinor > sampleCodLimitMinor) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'cod'));
        return Ok(OrderReceipt(
          orderId: 'TK-${++_seq}',
          status: payment == PaymentChoice.online ? OrderStatus.paymentPending : OrderStatus.placed,
          totalMinor: q.totalMinor,
          payment: payment,
        ));
      });
}
