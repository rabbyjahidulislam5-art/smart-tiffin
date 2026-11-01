import '../../access/actor.dart';
import '../../models/admin/backup_rider.dart';
import '../../models/admin/delayed_delivery.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Incident dispatch (NA-04), admin only.
abstract interface class DispatchRepository {
  Future<RepoResult<List<DelayedDelivery>>> delayedDeliveries(Actor actor);

  Future<RepoResult<List<BackupRider>>> backupRiders(Actor actor, String deliveryId);

  Future<RepoResult<DelayedDelivery>> reassignDelivery(Actor actor, RequestId requestId, {required String deliveryId, required String riderId});
}
