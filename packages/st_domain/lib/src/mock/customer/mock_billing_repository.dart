import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/customer/billing_frequency.dart';
import '../../models/customer/invoice.dart';
import '../../models/customer/invoice_status.dart';
import '../../models/customer/prepaid_liability.dart';
import '../../repositories/customer/billing_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';

class MockBillingRepository extends MockRepositoryBase implements BillingRepository {
  MockBillingRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.customer};

  final List<Invoice> _invoices = [
    const Invoice(id: 'INV-W-45', variant: BillingFrequency.weekly, period: '2026-11-02..2026-11-07', totalMinor: 102000, appliedCreditMinor: 18000, paidMinor: 0, status: InvoiceStatus.due),
    const Invoice(id: 'INV-W-44', variant: BillingFrequency.weekly, period: '2026-10-26..2026-10-31', totalMinor: 102000, appliedCreditMinor: 18000, paidMinor: 84000, status: InvoiceStatus.paid),
    const Invoice(id: 'INV-W-43', variant: BillingFrequency.weekly, period: '2026-10-19..2026-10-24', totalMinor: 102000, appliedCreditMinor: 0, paidMinor: 0, status: InvoiceStatus.overdue),
    const Invoice(id: 'INV-M-11', variant: BillingFrequency.monthly, period: '2026-11', totalMinor: 390000, appliedCreditMinor: 0, paidMinor: 390000, status: InvoiceStatus.paid),
    const Invoice(id: 'INV-M-10', variant: BillingFrequency.monthly, period: '2026-10', totalMinor: 390000, appliedCreditMinor: 0, paidMinor: 390000, status: InvoiceStatus.paid),
  ];

  @override
  Future<RepoResult<List<Invoice>>> invoices(Actor actor, BillingFrequency variant) =>
      guardRead(actor, roles, 'invoices', () => Ok([for (final i in _invoices) if (i.variant == variant) i]));

  @override
  Future<RepoResult<PrepaidLiability>> prepaidLiability(Actor actor) => guardRead(
        actor,
        roles,
        'prepaidLiability',
        () => const Ok(PrepaidLiability(invoiceId: 'INV-M-11', prepaidMinor: 390000, fulfilledMinor: 18000, creditedMinor: 18000, obligationsTotal: 25, obligationsDone: 2)),
      );

  @override
  Future<RepoResult<Invoice>> payInstalment(Actor actor, RequestId requestId, {required String invoiceId}) =>
      guardCommand(actor, roles, 'payInstalment', requestId, () {
        final i = _invoices.indexWhere((x) => x.id == invoiceId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (_invoices[i].status == InvoiceStatus.paid) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        final next = _invoices[i].paid();
        _invoices[i] = next;
        return Ok(next);
      });
}
