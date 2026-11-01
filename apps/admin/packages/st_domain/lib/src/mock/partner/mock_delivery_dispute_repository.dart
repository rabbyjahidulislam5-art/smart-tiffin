import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/partner/delivery_failure_kind.dart';
import '../../models/partner/delivery_failure_report.dart';
import '../../repositories/partner/delivery_dispute_repository.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../mock_behavior.dart';
import '../mock_clock.dart';
import '../mock_repository_base.dart';

/// Delivery failure reports of rider Rokon (sample).
class MockDeliveryDisputeRepository extends MockRepositoryBase implements DeliveryDisputeRepository {
  MockDeliveryDisputeRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.rider};

  /// Deliveries of the current assignment that can be reported.
  static const reportable = ['DL-913', 'DL-914'];

  final List<DeliveryFailureReport> _reports = [
    const DeliveryFailureReport(
      id: 'DF-07',
      deliveryRef: 'DL-874',
      kind: DeliveryFailureKind.noShow,
      note: 'Waited 10 minutes, customer did not answer the masked call.',
      reportedOn: '2026-10-27',
      underReview: false,
    ),
  ];
  int _seq = 7;

  @override
  Future<RepoResult<List<DeliveryFailureReport>>> reports(Actor actor) => guardRead(actor, roles, 'reports', () => Ok(List.unmodifiable(_reports)));

  @override
  Future<RepoResult<DeliveryFailureReport>> reportDeliveryFailure(Actor actor, RequestId requestId,
          {required String deliveryRef, required DeliveryFailureKind kind, required String note}) =>
      guardCommand(actor, roles, 'reportDeliveryFailure', requestId, () {
        if (!reportable.contains(deliveryRef)) return MockRepositoryBase.invalid('delivery');
        if (note.trim().length < 10) return MockRepositoryBase.invalid('note');
        final r = DeliveryFailureReport(
          id: 'DF-${(++_seq).toString().padLeft(2, '0')}',
          deliveryRef: deliveryRef,
          kind: kind,
          note: note.trim(),
          reportedOn: mockToday,
        );
        _reports.insert(0, r);
        return Ok(r);
      });
}
