import 'package:flutter/material.dart';
import 'package:st_shell/st_shell.dart';

/// Bottom tabs of the Partner app (copied from the legacy `tabsOf`).
const partnerTabs = <StRole, List<TabDef>>{
  StRole.supplier: [
    TabDef('S-01', 'Dashboard', 'ড্যাশবোর্ড', Icons.grid_view_rounded),
    TabDef('S-04', 'Menu', 'মেনু', Icons.restaurant_rounded),
    TabDef('S-06', 'Orders', 'অর্ডার', Icons.receipt_long_rounded),
    TabDef('S-08', 'Earnings', 'আয়', Icons.account_balance_wallet_rounded),
  ],
  StRole.rider: [
    TabDef('R-01', 'Deliveries', 'ডেলিভারি', Icons.two_wheeler_rounded),
    TabDef('R-07', 'History', 'ইতিহাস', Icons.receipt_long_rounded),
    TabDef('R-09', 'Profile', 'প্রোফাইল', Icons.person_rounded),
  ],
};
