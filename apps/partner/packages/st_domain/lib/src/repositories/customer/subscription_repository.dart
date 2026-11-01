import '../../access/actor.dart';
import '../../models/customer/billing_frequency.dart';
import '../../models/customer/recurrence_rule.dart';
import '../../models/customer/renewal_offer.dart';
import '../../models/customer/schedule_cell.dart';
import '../../models/customer/schedule_exception.dart';
import '../../models/customer/subscription_change.dart';
import '../../models/customer/subscription_draft.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../result/st_page.dart';

/// Subscription drafts, history and renewal of the signed-in customer.
abstract interface class SubscriptionRepository {
  Future<RepoResult<SubscriptionDraft>> createDraft(Actor actor, RequestId requestId, {required String kitchenId});

  Future<RepoResult<SubscriptionDraft>> draft(Actor actor, String id);

  /// A stale [expectedVersion] returns `conflict`.
  Future<RepoResult<SubscriptionDraft>> saveSchedule(
    Actor actor,
    RequestId requestId, {
    required String draftId,
    required int expectedVersion,
    required String startDate,
    required int weeks,
    required BillingFrequency billing,
    required List<ScheduleCell> cells,
    String? addressLabel,
    String? window,
  });

  Future<RepoResult<SubscriptionDraft>> savePattern(
    Actor actor,
    RequestId requestId, {
    required String draftId,
    required int expectedVersion,
    required RecurrenceRule rule,
    List<ScheduleException> exceptions = const [],
  });

  Future<RepoResult<SubscriptionDraft>> discard(Actor actor, RequestId requestId, {required String draftId});

  Future<RepoResult<StPage<SubscriptionChange>>> changeHistory(Actor actor, String subscriptionId, {String? cursor});

  Future<RepoResult<RenewalOffer>> renewalOffer(Actor actor, String subscriptionId);

  Future<RepoResult<RenewalOffer>> respondToRenewal(Actor actor, RequestId requestId, {required String offerId, required bool accept});
}
