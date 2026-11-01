import 'catalogue_checks.dart';
import 'checks/admin_checks.dart';
import 'checks/customer_billing_checks.dart';
import 'checks/customer_checks.dart';
import 'checks/finance_checks.dart';
import 'checks/partner_checks.dart';
import 'repo_check.dart';

/// Every repository check, for the offline mirror.
List<RepoCheck> allRepoChecks() => [
      ...earningsChecks,
      ...payoutChecks,
      ...kitchenOperationsChecks,
      ...codChecks,
      ...deliveryDisputeChecks,
      ...opsOverviewChecks,
      ...policyChecks,
      ...applicationReviewChecks,
      ...dispatchChecks,
      ...financeKpiChecks,
      ...reportChecks,
      ...paymentReconciliationChecks,
      ...codVerificationChecks,
      ...settlementLedgerChecks,
      ...payoutOperationsChecks,
      ...creditAndRefundChecks,
      ...ledgerChecks,
      ...staffRoleChecks,
      ...adjustmentChecks,
      ...kitchenChecks,
      ...favouriteChecks,
      ...subscriptionChecks,
      ...quoteChecks,
      ...scheduleChecks,
      ...creditChecks,
      ...billingChecks,
      ...checkoutChecks,
      ...refundChecks,
      // Later batches add their check lists here.
      ...catalogueChecks(),
    ];
