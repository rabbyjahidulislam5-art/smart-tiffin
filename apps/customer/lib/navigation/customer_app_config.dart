import 'package:st_shell/st_shell.dart';

import 'customer_handoff.dart';
import 'customer_registry.dart';
import 'customer_tabs.dart';

/// Documented ids of the Customer app; must equal the registry arms (R-REG-IDS).
const customerKnownIds = <String>{
  'AU-01', 'AU-02', 'AU-03', 'AU-04', 'AU-05', 'AU-06', 'AU-07', 'AU-08', 'AU-12',
  'P-01', 'P-02', 'P-03', 'P-04',
  'C-01', 'C-02', 'C-03', 'C-04', 'C-05', 'C-06', 'C-07', 'C-08', 'C-09', 'C-10', 'C-11', 'C-12', 'C-13',
  'C-14', 'C-15', 'C-16', 'C-17', 'C-18', 'C-19', 'C-20', 'C-21', 'C-22', 'C-23', 'C-24', 'C-25',
  'SH-01', 'SH-02', 'SH-04', 'SH-05', 'SH-06', 'SH-07', 'SH-08', 'SH-09', 'SH-10',
  'NC-01', 'NC-02', 'NC-03', 'NC-18',
  // New_Screens
};

/// Ids whose specified form is a sheet.
const customerSheetIds = <String>{'NC-07', 'NC-09', 'NC-16'};

const customerAppConfig = StShellConfig(
  appTitle: 'Smart Tiffin',
  roles: {StRole.customer},
  initialRole: StRole.customer,
  initialRoute: 'P-01',
  signInRoute: 'AU-03',
  homeOf: {StRole.customer: 'C-01'},
  tabsOf: customerTabs,
  buildScreen: buildCustomerScreen,
  knownIds: customerKnownIds,
  sheetIds: customerSheetIds,
  handoffFor: customerHandoffFor,
);
