import 'package:flutter/widgets.dart';
import 'package:st_shared_screens/st_shared_screens.dart';
import 'package:st_shell/st_shell.dart';

import '../features/auth/screens/customer_onboard_screen.dart';
import '../features/auth/screens/language_pick_screen.dart';
import '../features/auth/screens/sign_up_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/customer/addresses/screens/add_address_screen.dart';
import '../features/customer/addresses/screens/addresses_screen.dart';
import '../features/customer/billing/screens/billing_screen.dart';
import '../features/customer/billing/screens/invoice_screen.dart';
import '../features/customer/billing/screens/payment_methods_screen.dart';
import '../features/customer/cart/screens/cart_screen.dart';
import '../features/customer/cart/screens/checkout_screen.dart';
import '../features/customer/cart/screens/payment_result_screen.dart';
import '../features/customer/home/screens/customer_home_screen.dart';
import '../features/customer/menu/screens/kitchen_detail_screen.dart';
import '../features/customer/menu/screens/meal_detail_screen.dart';
import '../features/customer/menu/screens/menu_screen.dart';
import '../features/customer/orders/screens/live_tracking_screen.dart';
import '../features/customer/orders/screens/order_detail_screen.dart';
import '../features/customer/orders/screens/orders_screen.dart';
import '../features/customer/orders/screens/rate_meal_screen.dart';
import '../features/customer/profile/screens/complaints_screen.dart';
import '../features/customer/profile/screens/customer_profile_screen.dart';
import '../features/customer/profile/screens/food_prefs_screen.dart';
import '../features/customer/subscriptions/screens/meal_calendar_screen.dart';
import '../features/customer/subscriptions/screens/modify_routine_screen.dart';
import '../features/customer/subscriptions/screens/pause_meals_screen.dart';
import '../features/customer/subscriptions/screens/plan_picker_screen.dart';
import '../features/customer/subscriptions/screens/plan_review_screen.dart';
import '../features/customer/subscriptions/screens/subscriptions_screen.dart';
import '../features/guest/screens/guest_home_screen.dart';
import '../features/guest/screens/guest_menu_screen.dart';
import '../features/guest/screens/guest_plans_screen.dart';
import '../features/guest/screens/role_info_screen.dart';
import '../features/kitchen_discovery/screens/kitchen_discovery_screen.dart';
import '../features/kitchen_favourites/screens/favourite_kitchens_section_screen.dart';
import '../features/kitchen_profile/screens/kitchen_menu_section_screen.dart';
import '../features/kitchen_profile/screens/kitchen_profile_section_screen.dart';
// New_Screen imports
import 'customer_host_entries.dart';

/// The Customer app registry (design "Registry rules"): one arm per id.
Widget buildCustomerScreen(String id) {
  final screen = _customerScreen(id);
  final entries = customerHostEntries[id];
  return entries == null ? screen : StHostEntries(entries: entries, child: screen);
}

Widget _customerScreen(String id) {
  return switch (id) {
    'AU-01' => const SplashScreen(),
    'AU-02' => const LanguagePickScreen(),
    'AU-03' => const LoginScreen(),
    'AU-04' => const ForgotPasswordScreen(),
    'AU-05' => const OtpScreen(),
    'AU-06' => const NewPasswordScreen(),
    'AU-07' => const SignUpScreen(),
    'AU-08' => const CustomerOnboardScreen(),
    'AU-12' => const ChooseTypeScreen(),
    'P-01' => const GuestHomeScreen(),
    'P-02' => const GuestMenuScreen(),
    'P-03' => const GuestPlansScreen(),
    'P-04' => const RoleInfoScreen(),
    'C-01' => const CustomerHomeScreen(),
    'C-02' => const AddressesScreen(),
    'C-03' => const AddAddressScreen(),
    'C-04' => const MenuScreen(),
    'C-05' => const MealDetailScreen(),
    'C-06' => const KitchenDetailScreen(),
    'C-07' => const CartScreen(),
    'C-08' => const CheckoutScreen(),
    'C-09' => const PaymentResultScreen(),
    'C-10' => const SubscriptionsScreen(),
    'C-11' => const PlanPickerScreen(),
    'C-12' => const PlanReviewScreen(),
    'C-13' => const MealCalendarScreen(),
    'C-14' => const PauseMealsScreen(),
    'C-15' => const ModifyRoutineScreen(),
    'C-16' => const OrdersScreen(),
    'C-17' => const OrderDetailScreen(),
    'C-18' => const LiveTrackingScreen(),
    'C-19' => const RateMealScreen(),
    'C-20' => const BillingScreen(),
    'C-21' => const InvoiceScreen(),
    'C-22' => const PaymentMethodsScreen(),
    'C-23' => const CustomerProfileScreen(),
    'C-24' => const FoodPrefsScreen(),
    'C-25' => const ComplaintsScreen(),
    'SH-01' => const NotificationsScreen(),
    'SH-02' => const ChatScreen(),
    'SH-04' => const SupportScreen(),
    'SH-05' => const SettingsScreen(),
    'SH-06' => const ReportProblemScreen(),
    'SH-07' => const TicketStatusScreen(),
    'SH-08' => const EditProfileScreen(),
    'SH-09' => const NotifSettingsScreen(),
    'SH-10' => const EmailHistoryScreen(),
    'NC-01' => const KitchenDiscoveryScreen(),
    'NC-02' => const KitchenProfileSectionScreen(),
    'NC-03' => const KitchenMenuSectionScreen(),
    'NC-18' => const FavouriteKitchensSectionScreen(),
    // New_Screen arms
    _ => StUnbuiltScreen(id: id),
  };
}
