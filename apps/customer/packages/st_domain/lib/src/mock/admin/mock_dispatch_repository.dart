import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/admin/backup_rider.dart';
import '../../models/admin/delayed_delivery.dart';
import '../../models/admin/dispatch_status.dart';
import '../../repositories/admin/dispatch_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';

/// Delayed deliveries and backup riders (sample). The no-double-pay rule is
/// enforced by the server in production; here a second reassignment is refused.
class MockDispatchRepository extends MockRepositoryBase implements DispatchRepository {
  MockDispatchRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.admin};

  static const riders = <BackupRider>[
    BackupRider(id: 'rider-sabbir', name: 'Sabbir Hasan', distance: '1.2 km', vehicle: 'Motorcycle'),
    BackupRider(id: 'rider-mitu', name: 'Mitu Akter', distance: '2.0 km', vehicle: 'Bicycle'),
    BackupRider(id: 'rider-jamal', name: 'Jamal Uddin', distance: '3.4 km', vehicle: 'Motorcycle'),
  ];

  final List<DelayedDelivery> _deliveries = [
    const DelayedDelivery(id: 'DL-913', orderRef: 'TK-913', kitchen: 'Dhaka Tiffin Co.', delayMinutes: 18, riderName: 'Rokon', status: DispatchStatus.delayed),
    const DelayedDelivery(id: 'DL-917', orderRef: 'TK-917', kitchen: "Rina's Kitchen", delayMinutes: 9, riderName: 'Unassigned', status: DispatchStatus.delayed),
  ];

  @override
  Future<RepoResult<List<DelayedDelivery>>> delayedDeliveries(Actor actor) =>
      guardRead(actor, roles, 'delayedDeliveries', () => Ok(List.unmodifiable(_deliveries)));

  @override
  Future<RepoResult<List<BackupRider>>> backupRiders(Actor actor, String deliveryId) => guardRead(actor, roles, 'backupRiders', () {
        if (!_deliveries.any((d) => d.id == deliveryId)) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        return const Ok(riders);
      });

  @override
  Future<RepoResult<DelayedDelivery>> reassignDelivery(Actor actor, RequestId requestId, {required String deliveryId, required String riderId}) =>
      guardCommand(actor, roles, 'reassignDelivery', requestId, () {
        final i = _deliveries.indexWhere((d) => d.id == deliveryId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final rider = riders.where((r) => r.id == riderId).toList();
        if (rider.isEmpty) return MockRepositoryBase.invalid('rider');
        final d = _deliveries[i];
        if (d.status == DispatchStatus.reassigned) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        final next = DelayedDelivery(id: d.id, orderRef: d.orderRef, kitchen: d.kitchen, delayMinutes: d.delayMinutes, riderName: d.riderName, status: DispatchStatus.reassigned, backupRider: rider.first.name);
        _deliveries[i] = next;
        return Ok(next);
      });
}
