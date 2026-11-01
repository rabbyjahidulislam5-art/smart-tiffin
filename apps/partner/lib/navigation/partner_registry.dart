import 'package:flutter/widgets.dart';
import 'package:st_shared_screens/st_shared_screens.dart';
import 'package:st_shell/st_shell.dart';

import '../features/auth/screens/rider_apply_screen.dart';
import '../features/auth/screens/supplier_apply_screen.dart';
import '../features/auth/screens/under_review_screen.dart';
import '../features/rider/deliveries/screens/rider_confirm_screen.dart';
import '../features/rider/deliveries/screens/rider_delivered_screen.dart';
import '../features/rider/deliveries/screens/rider_home_screen.dart';
import '../features/rider/deliveries/screens/rider_nav_screen.dart';
import '../features/rider/deliveries/screens/rider_offer_screen.dart';
import '../features/rider/deliveries/screens/rider_queue_screen.dart';
import '../features/rider/deliveries/screens/rider_sos_screen.dart';
import '../features/rider/earnings/screens/rider_earnings_screen.dart';
import '../features/rider/history/screens/rider_history_screen.dart';
import '../features/rider/profile/screens/rider_profile_screen.dart';
import '../features/supplier/dashboard/screens/cooking_req_screen.dart';
import '../features/supplier/dashboard/screens/order_request_screen.dart';
import '../features/supplier/dashboard/screens/supplier_dash_screen.dart';
import '../features/supplier/earnings/screens/payout_history_screen.dart';
import '../features/supplier/earnings/screens/supplier_earnings_screen.dart';
import '../features/supplier/kitchen/screens/kitchen_profile_screen.dart';
import '../features/supplier/kitchen/screens/operating_settings_screen.dart';
import '../features/supplier/kitchen/screens/verification_docs_screen.dart';
import '../features/supplier/menu/screens/meal_form_screen.dart';
import '../features/supplier/menu/screens/menu_manager_screen.dart';
import '../features/supplier/orders/screens/commitments_screen.dart';
import '../features/supplier/orders/screens/supplier_orders_screen.dart';
import '../features/supplier_earnings/screens/payout_request_screen.dart';
import '../features/supplier_earnings/screens/supplier_earnings_overview_screen.dart';
import '../features/supplier_earnings/screens/supplier_payout_history_screen.dart';
import '../features/kitchen_capacity/screens/capacity_section_screen.dart';
import '../features/menu_pricing/screens/price_versions_section_screen.dart';
import '../features/pickup_handoff/screens/handoff_sheet_screen.dart';
import '../features/supplier_forecast/screens/forecast_section_screen.dart';
import '../features/cod_collection/screens/cod_collection_sheet_screen.dart';
import '../features/cod_collection/screens/cod_discrepancy_screen.dart';
import '../features/cod_collection/screens/cod_remittance_screen.dart';
import '../features/delivery_disputes/screens/delivery_failure_report_screen.dart';
import '../features/rider_earnings/screens/rider_earnings_overview_screen.dart';
import '../features/rider_earnings/screens/rider_payout_screen.dart';
// New_Screen imports
import 'partner_host_entries.dart';

/// The Partner app registry (design "Registry rules"): one arm per id.
Widget buildPartnerScreen(String id) {
  final screen = _partnerScreen(id);
  final entries = partnerHostEntries[id];
  return entries == null
      ? screen
      : StHostEntries(entries: entries, child: screen);
}

Widget _partnerScreen(String id) {
  return switch (id) {
    'AU-03' => const LoginScreen(),
    'AU-04' => const ForgotPasswordScreen(),
    'AU-05' => const OtpScreen(),
    'AU-06' => const NewPasswordScreen(),
    'AU-09' => const SupplierApplyScreen(),
    'AU-10' => const RiderApplyScreen(),
    'AU-11' => const UnderReviewScreen(),
    'AU-12' => const ChooseTypeScreen(),
    'S-01' => const SupplierDashScreen(),
    'S-02' => const OrderRequestScreen(),
    'S-03' => const CookingReqScreen(),
    'S-04' => const MenuManagerScreen(),
    'S-05' => const MealFormScreen(),
    'S-06' => const SupplierOrdersScreen(),
    'S-07' => const CommitmentsScreen(),
    'S-08' => const SupplierEarningsScreen(),
    'S-09' => const PayoutHistoryScreen(),
    'S-10' => const KitchenProfileScreen(),
    'S-11' => const VerificationDocsScreen(),
    'S-12' => const OperatingSettingsScreen(),
    'R-01' => const RiderHomeScreen(),
    'R-02' => const RiderNavScreen(),
    'R-03' => const RiderConfirmScreen(),
    'R-04' => const RiderDeliveredScreen(),
    'R-05' => const RiderSosScreen(),
    'R-06' => const RiderQueueScreen(),
    'R-07' => const RiderHistoryScreen(),
    'R-08' => const RiderEarningsScreen(),
    'R-09' => const RiderProfileScreen(),
    'R-10' => const RiderOfferScreen(),
    'SH-01' => const NotificationsScreen(),
    'SH-02' => const ChatScreen(),
    'SH-04' => const SupportScreen(),
    'SH-05' => const SettingsScreen(),
    'SH-06' => const ReportProblemScreen(),
    'SH-07' => const TicketStatusScreen(),
    'SH-08' => const EditProfileScreen(),
    'SH-09' => const NotifSettingsScreen(),
    'SH-10' => const EmailHistoryScreen(),
    'NS-01' => const SupplierEarningsOverviewScreen(),
    'NS-02' => const PayoutRequestScreen(),
    'NS-03' => const SupplierPayoutHistoryScreen(),
    'NS-04' => const ForecastSectionScreen(),
    'NS-05' => const CapacitySectionScreen(),
    'NS-06' => const PriceVersionsSectionScreen(),
    'NS-07' => const HandoffSheetScreen(),
    'NR-01' => const RiderEarningsOverviewScreen(),
    'NR-02' => const RiderPayoutScreen(),
    'NR-03' => const CodCollectionSheetScreen(),
    'NR-04' => const CodRemittanceScreen(),
    'NR-05' => const CodDiscrepancyScreen(),
    'NR-06' => const DeliveryFailureReportScreen(),
    // New_Screen arms
    _ => StUnbuiltScreen(id: id),
  };
}
