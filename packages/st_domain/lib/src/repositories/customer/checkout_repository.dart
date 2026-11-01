import '../../access/actor.dart';
import '../../models/customer/checkout_summary.dart';
import '../../models/customer/cod_eligibility.dart';
import '../../models/customer/order_receipt.dart';
import '../../models/customer/payment_choice.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// One-time order checkout (NC-14).
abstract interface class CheckoutRepository {
  Future<RepoResult<CheckoutSummary>> summary(Actor actor);

  Future<RepoResult<CodEligibility>> codEligibility(Actor actor);

  /// Needs a confirmed quote; online payment returns `paymentPending`.
  Future<RepoResult<OrderReceipt>> placeOneTimeOrder(Actor actor, RequestId requestId, {required String quoteId, required PaymentChoice payment});
}
