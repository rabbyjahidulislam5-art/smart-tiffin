import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/customer/customer_refund_kind.dart';
import '../../models/customer/customer_refund_status.dart';
import '../../models/customer/refund_case.dart';
import '../../repositories/customer/refund_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/st_page.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';

class MockRefundRepository extends MockRepositoryBase implements RefundRepository {
  MockRefundRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.customer};

  static const fixtures = <RefundCase>[
    RefundCase(id: 'RF-21', kind: CustomerRefundKind.refund, status: CustomerRefundStatus.requested, amountMinor: 24000, orderRef: 'TK-918', createdOn: '2026-11-01'),
    RefundCase(id: 'RF-19', kind: CustomerRefundKind.refund, status: CustomerRefundStatus.executed, amountMinor: 18000, orderRef: 'TK-880', createdOn: '2026-10-24', providerRef: 'SSL-R-4410'),
    RefundCase(id: 'DP-03', kind: CustomerRefundKind.dispute, status: CustomerRefundStatus.disputed, amountMinor: 54000, orderRef: 'TK-866', createdOn: '2026-10-18'),
  ];

  @override
  Future<RepoResult<StPage<RefundCase>>> refunds(Actor actor, {String? cursor}) =>
      guardRead(actor, roles, 'refunds', () => Ok(StPage.slice(fixtures, cursor: cursor, size: 10)));

  @override
  Future<RepoResult<RefundCase>> refund(Actor actor, String id) => guardRead(actor, roles, 'refund', () {
        for (final r in fixtures) {
          if (r.id == id) return Ok(r);
        }
        return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
      });
}
