import 'package:flutter/widgets.dart';
import 'package:st_shared_screens/st_shared_screens.dart';
import 'package:st_shell/st_shell.dart';

import '../features/admin/applications/screens/applicant_dossier_screen.dart';
import '../features/admin/applications/screens/applications_screen.dart';
import '../features/admin/incidents/screens/backup_rider_screen.dart';
import '../features/admin/incidents/screens/dispute_detail_screen.dart';
import '../features/admin/incidents/screens/incident_detail_screen.dart';
import '../features/admin/incidents/screens/incident_log_screen.dart';
import '../features/admin/orders/screens/admin_order_detail_screen.dart';
import '../features/admin/orders/screens/admin_orders_screen.dart';
import '../features/admin/overview/screens/admin_console_screen.dart';
import '../features/admin/reports/screens/reports_screen.dart';
import '../features/admin/settings/screens/admin_profile_screen.dart';
import '../features/admin/settings/screens/admin_settings_screen.dart';
import '../features/admin/settings/screens/audit_log_screen.dart';
import '../features/admin/settings/screens/security_screen.dart';
import '../features/admin/settings/screens/setting_detail_screen.dart';
import '../features/admin/users/screens/user_detail_screen.dart';
import '../features/admin/users/screens/users_cooks_screen.dart';
import '../features/auth/screens/admin_sign_in_screen.dart';
import '../features/accounts_oversight/dashboards/accounts_oversight_dashboard.dart';
import '../features/incident_dispatch/screens/incident_dispatch_screen.dart';
import '../features/ops_command_centre/dashboards/ops_command_centre_dashboard.dart';
import '../features/ops_reports/screens/ops_reports_screen.dart';
import '../features/policy_config/screens/policy_config_screen.dart';
import '../features/verification_queue/screens/verification_queue_screen.dart';
import '../features/cod_verification/screens/cod_custody_screen.dart';
import '../features/cod_verification/screens/cod_deposit_verification_screen.dart';
import '../features/credit_and_refunds/screens/adjustment_approval_screen.dart';
import '../features/credit_and_refunds/screens/credit_liability_screen.dart';
import '../features/credit_and_refunds/screens/refund_cases_screen.dart';
import '../features/finance_overview/dashboards/finance_overview_dashboard.dart';
import '../features/finance_reports/screens/finance_reports_screen.dart';
import '../features/finance_roles/screens/finance_roles_screen.dart';
import '../features/general_ledger/screens/ledger_explorer_screen.dart';
import '../features/general_ledger/screens/period_close_screen.dart';
import '../features/payment_reconciliation/screens/gateway_statement_screen.dart';
import '../features/payment_reconciliation/screens/payment_reconciliation_screen.dart';
import '../features/payment_reconciliation/screens/recon_exceptions_screen.dart';
import '../features/payout_operations/screens/payout_batch_screen.dart';
import '../features/payout_operations/screens/payout_review_screen.dart';
import '../features/settlement_ledgers/screens/rider_payables_screen.dart';
import '../features/settlement_ledgers/screens/supplier_payables_screen.dart';
// New_Screen imports
import 'admin_accounting_host_entries.dart';

/// The Admin and Accounting app registry (design "Registry rules").
Widget buildAdminAccountingScreen(String id) {
  final screen = _adminAccountingScreen(id);
  final entries = adminAccountingHostEntries[id];
  return entries == null
      ? screen
      : StHostEntries(entries: entries, child: screen);
}

Widget _adminAccountingScreen(String id) {
  return switch (id) {
    'AU-13' => const AdminSignInScreen(),
    'A-01' => const AdminConsoleScreen(),
    'A-02' => const IncidentDetailScreen(),
    'A-03' => const IncidentLogScreen(),
    'A-04' => const BackupRiderScreen(),
    'A-05' => const DisputeDetailScreen(),
    'A-06' => const ApplicationsScreen(),
    'A-07' => const ApplicantDossierScreen(),
    'A-08' => const UsersCooksScreen(),
    'A-09' => const UserDetailScreen(),
    'A-10' => const AdminOrdersScreen(),
    'A-11' => const AdminOrderDetailScreen(),
    'A-14' => const ReportsScreen(),
    'A-15' => const AdminSettingsScreen(),
    'A-16' => const SettingDetailScreen(),
    'A-17' => const AuditLogScreen(),
    'A-18' => const SecurityScreen(),
    'A-19' => const AdminProfileScreen(),
    'SH-01' => const NotificationsScreen(),
    'SH-02' => const ChatScreen(),
    'SH-04' => const SupportScreen(),
    'SH-05' => const SettingsScreen(),
    'SH-07' => const TicketStatusScreen(),
    'SH-08' => const EditProfileScreen(),
    'SH-09' => const NotifSettingsScreen(),
    'SH-10' => const EmailHistoryScreen(),
    'NA-01' => const OpsCommandCentreDashboard(),
    'NA-02' => const PolicyConfigScreen(),
    'NA-03' => const VerificationQueueScreen(),
    'NA-04' => const IncidentDispatchScreen(),
    'NA-05' => const AccountsOversightDashboard(),
    'NA-06' => const OpsReportsScreen(),
    'NF-01' => const FinanceOverviewDashboard(),
    'NF-02' => const PaymentReconciliationScreen(),
    'NF-03' => const CodCustodyScreen(),
    'NF-04' => const CodDepositVerificationScreen(),
    'NF-05' => const SupplierPayablesScreen(),
    'NF-06' => const RiderPayablesScreen(),
    'NF-07' => const PayoutReviewScreen(),
    'NF-08' => const PayoutBatchScreen(),
    'NF-09' => const CreditLiabilityScreen(),
    'NF-10' => const RefundCasesScreen(),
    'NF-11' => const LedgerExplorerScreen(),
    'NF-12' => const PeriodCloseScreen(),
    'NF-13' => const ReconExceptionsScreen(),
    'NF-14' => const FinanceReportsScreen(),
    'NF-15' => const FinanceRolesScreen(),
    'NF-16' => const AdjustmentApprovalScreen(),
    'NF-17' => const GatewayStatementScreen(),
    // New_Screen arms
    _ => StUnbuiltScreen(id: id),
  };
}
