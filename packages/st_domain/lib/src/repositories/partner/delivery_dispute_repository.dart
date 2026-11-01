import '../../access/actor.dart';
import '../../models/partner/delivery_failure_kind.dart';
import '../../models/partner/delivery_failure_report.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Delivery failure reports of the signed-in rider (NR-06).
abstract interface class DeliveryDisputeRepository {
  Future<RepoResult<List<DeliveryFailureReport>>> reports(Actor actor);

  Future<RepoResult<DeliveryFailureReport>> reportDeliveryFailure(
    Actor actor,
    RequestId requestId, {
    required String deliveryRef,
    required DeliveryFailureKind kind,
    required String note,
  });
}
