import 'package:st_shell/st_shell.dart';

import 'admin_accounting_registry.dart';
import 'admin_accounting_tabs.dart';

/// Documented ids of the app; must equal the registry arms (R-REG-IDS).
/// A-12 and A-13 are not ported (requirement 8.4: payouts and settlements
/// exist only in the accounting workspace, NF-07 and NF-08).
const adminAccountingKnownIds = <String>{
  'AU-13',
  'A-01',
  'A-02',
  'A-03',
  'A-04',
  'A-05',
  'A-06',
  'A-07',
  'A-08',
  'A-09',
  'A-10',
  'A-11',
  'A-14', 'A-15', 'A-16', 'A-17', 'A-18', 'A-19',
  'SH-01', 'SH-02', 'SH-04', 'SH-05', 'SH-07', 'SH-08', 'SH-09', 'SH-10',
  'NA-01',
  'NA-02',
  'NA-03',
  'NA-04',
  'NA-05',
  'NA-06',
  'NF-01',
  'NF-02',
  'NF-03',
  'NF-04',
  'NF-05',
  'NF-06',
  'NF-07',
  'NF-08',
  'NF-09',
  'NF-10',
  'NF-11',
  'NF-12',
  'NF-13',
  'NF-14',
  'NF-15',
  'NF-16',
  'NF-17',
  // New_Screens
};

const adminAccountingAppConfig = StShellConfig(
  appTitle: 'Smart Tiffin Admin',
  roles: {StRole.admin, StRole.accounting},
  initialRole: StRole.admin,
  initialRoute: 'AU-13',
  signInRoute: 'AU-13',
  homeOf: {StRole.admin: 'A-01', StRole.accounting: 'NF-01'},
  tabsOf: adminAccountingTabs,
  railTabsOf: adminAccountingRailTabs,
  buildScreen: buildAdminAccountingScreen,
  knownIds: adminAccountingKnownIds,
);
