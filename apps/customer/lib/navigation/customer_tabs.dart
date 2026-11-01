import 'package:flutter/material.dart';
import 'package:st_shell/st_shell.dart';

/// Bottom tabs of the Customer app (copied from the legacy `tabsOf`).
const customerTabs = <StRole, List<TabDef>>{
  StRole.customer: [
    TabDef('C-01', 'Home', 'হোম', Icons.home_rounded),
    TabDef('C-10', 'Subscriptions', 'সাবস্ক্রিপশন', Icons.calendar_month_rounded),
    TabDef('C-16', 'Orders', 'অর্ডার', Icons.receipt_long_rounded),
    TabDef('C-23', 'Profile', 'প্রোফাইল', Icons.person_rounded),
  ],
};
