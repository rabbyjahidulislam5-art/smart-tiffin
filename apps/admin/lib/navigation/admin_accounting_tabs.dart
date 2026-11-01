import 'package:flutter/material.dart';
import 'package:st_shell/st_shell.dart';

/// Bottom tabs. Admin: copied from the legacy `tabsOf`. Accounting: the four
/// most used finance workspaces (compact band).
const adminAccountingTabs = <StRole, List<TabDef>>{
  StRole.admin: [
    TabDef('A-01', 'Overview', 'ওভারভিউ', Icons.grid_view_rounded),
    TabDef('A-08', 'Users & Cooks', 'ইউজার', Icons.groups_rounded),
    TabDef('A-10', 'Orders', 'অর্ডার', Icons.receipt_long_rounded),
    TabDef('A-15', 'Settings', 'সেটিংস', Icons.settings_rounded),
  ],
  StRole.accounting: [
    TabDef('NF-01', 'Overview', 'ওভারভিউ', Icons.dashboard_rounded),
    TabDef('NF-02', 'Payments', 'পেমেন্ট', Icons.payments_rounded),
    TabDef('NF-07', 'Payouts', 'পেআউট', Icons.account_balance_rounded),
    TabDef('NF-11', 'Ledger', 'লেজার', Icons.menu_book_rounded),
  ],
};

/// Side navigation of the accounting workspace (expanded and large bands).
/// The admin workspace uses its tabs (no NF target, R-ROLE-BOUNDARY).
const adminAccountingRailTabs = <StRole, List<TabDef>>{
  StRole.accounting: [
    TabDef('NF-01', 'Overview', 'ওভারভিউ', Icons.dashboard_rounded),
    TabDef('NF-02', 'Payments', 'পেমেন্ট', Icons.payments_rounded),
    TabDef('NF-17', 'Statements', 'স্টেটমেন্ট', Icons.receipt_long_rounded),
    TabDef('NF-13', 'Exceptions', 'ব্যতিক্রম', Icons.report_problem_rounded),
    TabDef('NF-03', 'COD custody', 'সিওডি জিম্মা', Icons.local_atm_rounded),
    TabDef(
      'NF-05',
      'Supplier payables',
      'সরবরাহকারী পাওনা',
      Icons.storefront_rounded,
    ),
    TabDef(
      'NF-06',
      'Rider payables',
      'রাইডার পাওনা',
      Icons.two_wheeler_rounded,
    ),
    TabDef('NF-07', 'Payouts', 'পেআউট', Icons.account_balance_rounded),
    TabDef('NF-09', 'Credits', 'ক্রেডিট', Icons.card_giftcard_rounded),
    TabDef('NF-10', 'Refunds', 'রিফান্ড', Icons.undo_rounded),
    TabDef('NF-11', 'Ledger', 'লেজার', Icons.menu_book_rounded),
    TabDef(
      'NF-12',
      'Period close',
      'পিরিয়ড ক্লোজ',
      Icons.event_available_rounded,
    ),
    TabDef('NF-14', 'Reports', 'রিপোর্ট', Icons.insert_chart_rounded),
    TabDef(
      'NF-15',
      'Staff roles',
      'স্টাফ রোল',
      Icons.admin_panel_settings_rounded,
    ),
  ],
};
