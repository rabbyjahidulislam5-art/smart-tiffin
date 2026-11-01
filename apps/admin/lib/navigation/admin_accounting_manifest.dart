import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../features/accounts_oversight/dashboards/accounts_oversight_text.dart';
import '../features/incident_dispatch/screens/incident_dispatch_text.dart';
import '../features/ops_command_centre/dashboards/ops_command_centre_text.dart';
import '../features/ops_reports/screens/ops_reports_text.dart';
import '../features/policy_config/screens/policy_config_text.dart';
import '../features/verification_queue/screens/verification_queue_text.dart';

import '../features/cod_verification/screens/cod_verification_text.dart';
import '../features/credit_and_refunds/screens/credit_and_refunds_text.dart';
import '../features/finance_overview/dashboards/finance_overview_text.dart';
import '../features/finance_reports/screens/finance_reports_text.dart';
import '../features/finance_roles/screens/finance_roles_text.dart';
import '../features/general_ledger/screens/general_ledger_text.dart';
import '../features/payment_reconciliation/screens/payment_reconciliation_text.dart';
import '../features/payout_operations/screens/payout_operations_text.dart';
import '../features/settlement_ledgers/screens/settlement_ledgers_text.dart';

// New_Screen text imports

/// `StScreenSpec` entries of the Admin and Accounting app's New_Screens.
const adminAccountingManifest = <StScreenSpec>[
  StScreenSpec(
    id: 'NA-01',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: OpsCommandCentreText.title,
    source:
        'design/screens/ADMIN_SCREENS.md NA-01; admin-web/ADMIN_DASHBOARD.md',
    hosts: ['A-01'],
    links: [
      'NA-02',
      'NA-03',
      'NA-04',
      'NA-05',
      'NA-06',
      'A-02',
      'A-03',
      'A-08',
      'A-10',
    ],
  ),
  StScreenSpec(
    id: 'NA-02',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: PolicyConfigText.title,
    source: 'design/screens/ADMIN_SCREENS.md NA-02; admin-web/OPERATIONS_MANAGEMENT.md policy configuration',
    connectedControls: {'publishPolicyVersion'},
    hosts: ['NA-01'],
  ),
  StScreenSpec(
    id: 'NA-03',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: VerificationQueueText.title,
    source: 'design/screens/ADMIN_SCREENS.md NA-03; admin-web/APPROVAL_WORKFLOWS.md',
    connectedControls: {'decideApplication'},
    hosts: ['NA-01', 'A-06', 'A-07'],
  ),
  StScreenSpec(
    id: 'NA-04',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: IncidentDispatchText.title,
    source: 'design/screens/ADMIN_SCREENS.md NA-04; admin-web/OPERATIONS_MANAGEMENT.md delivery operations (WF-J)',
    connectedControls: {'reassignDelivery'},
    hosts: ['NA-01', 'A-03', 'A-04'],
  ),
  StScreenSpec(
    id: 'NA-05',
    form: StScreenForm.section,
    states: {StVariant.loading, StVariant.error, StVariant.offline},
    anchor: AccountsOversightText.title,
    source: 'design/screens/ADMIN_SCREENS.md NA-05; admin-web/ADMIN_DASHBOARD.md (C-06)',
    hosts: ['NA-01'],
  ),
  StScreenSpec(
    id: 'NA-06',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: OpsReportsText.title,
    source: 'design/screens/ADMIN_SCREENS.md NA-06; admin-web/OPERATIONS_MANAGEMENT.md reports',
    connectedControls: {'exportReport'},
    hosts: ['NA-01'],
  ),
  StScreenSpec(
    id: 'NF-01',
    form: StScreenForm.fullScreen,
    states: {StVariant.loading, StVariant.error, StVariant.offline},
    anchor: FinanceOverviewText.title,
    source: 'design/screens/ACCOUNTS_SCREENS.md NF-01; accounts-web/FINANCE_DASHBOARD.md',
    hosts: ['AU-13'],
    links: [
      'NF-02',
      'NF-03',
      'NF-05',
      'NF-06',
      'NF-08',
      'NF-09',
      'NF-10',
      'NF-11',
      'NF-13',
    ],
  ),
  StScreenSpec(
    id: 'NF-02',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: PaymentReconciliationText.title,
    source: 'accounts-web/PAYMENT_RECONCILIATION.md NF-02',
    connectedControls: {'reconcileGatewayStatement'},
    hosts: ['NF-01'],
    links: ['NF-13', 'NF-17'],
  ),
  StScreenSpec(
    id: 'NF-03',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: CodVerificationText.custodyTitle,
    source: 'accounts-web/COD_RECONCILIATION.md NF-03',
    hosts: ['NF-01'],
    links: ['NF-04'],
  ),
  StScreenSpec(
    id: 'NF-04',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: CodVerificationText.verifyTitle,
    source: 'accounts-web/COD_RECONCILIATION.md NF-04 (INV-12)',
    connectedControls: {'verifyCodRemittance'},
    hosts: ['NF-03'],
  ),
  StScreenSpec(
    id: 'NF-05',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: SettlementLedgersText.supplierTitle,
    source: 'accounts-web/SUPPLIER_SETTLEMENT.md',
    connectedControls: {'placeHold', 'releaseHold'},
    hosts: ['NF-01'],
  ),
  StScreenSpec(
    id: 'NF-06',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: SettlementLedgersText.riderTitle,
    source: 'accounts-web/RIDER_SETTLEMENT.md',
    connectedControls: {'placeHold', 'releaseHold'},
    hosts: ['NF-01'],
  ),
  StScreenSpec(
    id: 'NF-07',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: PayoutOperationsText.reviewTitle,
    source: 'accounts-web/PAYOUT_MANAGEMENT.md NF-07',
    connectedControls: {'reviewPayout', 'rejectPayout'},
    hosts: ['NF-01', 'SH-01'],
    links: ['NF-08'],
  ),
  StScreenSpec(
    id: 'NF-08',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: PayoutOperationsText.batchTitle,
    source: 'accounts-web/PAYOUT_MANAGEMENT.md NF-08 (ADR-010)',
    connectedControls: {
      'createPayoutBatch',
      'releasePayoutBatch',
      'recordPayoutResult',
    },
    hosts: ['NF-07'],
  ),
  StScreenSpec(
    id: 'NF-09',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: CreditAndRefundsText.creditTitle,
    source: 'accounts-web/REFUNDS_AND_ADJUSTMENTS.md NF-09',
    connectedControls: {'voidCredit'},
    hosts: ['NF-01'],
  ),
  StScreenSpec(
    id: 'NF-10',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: CreditAndRefundsText.refundTitle,
    source: 'accounts-web/REFUNDS_AND_ADJUSTMENTS.md NF-10 (INV-17)',
    connectedControls: {'initiateRefund', 'recordRefundResult'},
    hosts: ['NF-01'],
    links: ['NF-09', 'NF-16'],
  ),
  StScreenSpec(
    id: 'NF-11',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: GeneralLedgerText.ledgerTitle,
    source: 'accounts-web/FINANCIAL_LEDGER.md NF-11',
    connectedControls: {'reverseJournal'},
    hosts: ['NF-01'],
  ),
  StScreenSpec(
    id: 'NF-12',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: GeneralLedgerText.periodTitle,
    source: 'accounts-web/FINANCIAL_LEDGER.md NF-12 (INV-16)',
    connectedControls: {'closePeriod', 'reopenPeriod'},
    hosts: ['SH-01'],
  ),
  StScreenSpec(
    id: 'NF-13',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: PaymentReconciliationText.exTitle,
    source: 'accounts-web/PAYMENT_RECONCILIATION.md; ACCOUNTS_UI_UX.md bulk actions',
    connectedControls: {'assignException'},
    hosts: ['NF-01', 'NF-02'],
    links: ['NF-02'],
  ),
  StScreenSpec(
    id: 'NF-14',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: FinanceReportsText.title,
    source: 'design/screens/ACCOUNTS_SCREENS.md NF-14; ACCOUNTS_UI_UX.md',
    connectedControls: {'exportReport'},
  ),
  StScreenSpec(
    id: 'NF-15',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: FinanceRolesText.title,
    source: 'accounts-web/ACCOUNTS_ARCHITECTURE.md section 2',
    connectedControls: {'grantStaffRole', 'revokeStaffRole'},
  ),
  StScreenSpec(
    id: 'NF-16',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: CreditAndRefundsText.adjTitle,
    source: 'accounts-web/REFUNDS_AND_ADJUSTMENTS.md NF-16 (INV-02)',
    connectedControls: {'requestAdjustment', 'approveAdjustment'},
    hosts: ['NF-10'],
  ),
  StScreenSpec(
    id: 'NF-17',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: PaymentReconciliationText.stTitle,
    source: 'accounts-web/PAYMENT_RECONCILIATION.md NF-17',
    connectedControls: {'reconcileGatewayStatement'},
    hosts: ['NF-02', 'SH-01'],
  ),
  // New_Screen specs
];

/// Text tables of the app's new features (key-completeness test).
const adminAccountingTextTables = <String, Map<String, StText>>{
  'ops_command_centre': OpsCommandCentreText.all,
  'policy_config': PolicyConfigText.all,
  'verification_queue': VerificationQueueText.all,
  'incident_dispatch': IncidentDispatchText.all,
  'accounts_oversight': AccountsOversightText.all,
  'ops_reports': OpsReportsText.all,
  'finance_overview': FinanceOverviewText.all,
  'payment_reconciliation': PaymentReconciliationText.all,
  'cod_verification': CodVerificationText.all,
  'settlement_ledgers': SettlementLedgersText.all,
  'payout_operations': PayoutOperationsText.all,
  'credit_and_refunds': CreditAndRefundsText.all,
  'general_ledger': GeneralLedgerText.all,
  'finance_reports': FinanceReportsText.all,
  'finance_roles': FinanceRolesText.all,
  // New_Screen texts
};
