import 'package:st_shell/st_shell.dart';

import 'partner_handoff.dart';
import 'partner_registry.dart';
import 'partner_tabs.dart';

/// Documented ids of the Partner app; must equal the registry arms (R-REG-IDS).
const partnerKnownIds = <String>{
  'AU-03', 'AU-04', 'AU-05', 'AU-06', 'AU-09', 'AU-10', 'AU-11', 'AU-12',
  'S-01',
  'S-02',
  'S-03',
  'S-04',
  'S-05',
  'S-06',
  'S-07',
  'S-08',
  'S-09',
  'S-10',
  'S-11',
  'S-12',
  'R-01',
  'R-02',
  'R-03',
  'R-04',
  'R-05',
  'R-06',
  'R-07',
  'R-08',
  'R-09',
  'R-10',
  'SH-01',
  'SH-02',
  'SH-04',
  'SH-05',
  'SH-06',
  'SH-07',
  'SH-08',
  'SH-09',
  'SH-10',
  'NS-01', 'NS-02', 'NS-03',
  'NS-04',
  'NS-05',
  'NS-06',
  'NS-07',
  'NR-01',
  'NR-02',
  'NR-03',
  'NR-04',
  'NR-05',
  'NR-06',
  // New_Screens
};

/// Ids whose specified form is a sheet.
const partnerSheetIds = <String>{'NS-07', 'NR-03'};

const partnerAppConfig = StShellConfig(
  appTitle: 'Smart Tiffin Partner',
  roles: {StRole.supplier, StRole.rider},
  initialRole: StRole.supplier,
  initialRoute: 'AU-03',
  signInRoute: 'AU-03',
  homeOf: {StRole.supplier: 'S-01', StRole.rider: 'R-01'},
  tabsOf: partnerTabs,
  buildScreen: buildPartnerScreen,
  knownIds: partnerKnownIds,
  sheetIds: partnerSheetIds,
  handoffFor: partnerHandoffFor,
);
