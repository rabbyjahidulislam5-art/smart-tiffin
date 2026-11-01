import '../../access/actor.dart';
import '../../models/customer/price_explanation.dart';
import '../../models/customer/quote.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Server quotes (pattern 3.3) of the signed-in customer.
abstract interface class QuoteRepository {
  Future<RepoResult<Quote>> createQuote(Actor actor, RequestId requestId, {required String draftId});

  Future<RepoResult<Quote>> quote(Actor actor, String id);

  /// Records consent against the snapshot; an expired quote is refused.
  Future<RepoResult<Quote>> confirmQuote(Actor actor, RequestId requestId, {required String quoteId});

  Future<RepoResult<PriceExplanation>> priceExplanation(Actor actor, String quoteId);
}
