import '../../access/actor.dart';
import '../../models/customer/billing_frequency.dart';
import '../../models/customer/invoice.dart';
import '../../models/customer/prepaid_liability.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Subscription billing of the signed-in customer (NC-12, NC-13).
abstract interface class BillingRepository {
  Future<RepoResult<List<Invoice>>> invoices(Actor actor, BillingFrequency variant);

  Future<RepoResult<PrepaidLiability>> prepaidLiability(Actor actor);

  Future<RepoResult<Invoice>> payInstalment(Actor actor, RequestId requestId, {required String invoiceId});
}
