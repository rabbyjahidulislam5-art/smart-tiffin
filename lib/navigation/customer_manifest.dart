import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../features/partner_handoff/widgets/partner_handoff_text.dart';

import '../features/kitchen_discovery/screens/kitchen_discovery_text.dart';
import '../features/kitchen_favourites/screens/kitchen_favourites_text.dart';
import '../features/kitchen_profile/screens/kitchen_profile_text.dart';

// New_Screen text imports

/// `StScreenSpec` entries of the Customer app's New_Screens.
const customerManifest = <StScreenSpec>[
  StScreenSpec(
    id: 'NC-01',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: KitchenDiscoveryText.title,
    source: 'design/screens/CUSTOMER_NEW_SCREENS.md NC-01',
    hosts: ['P-02', 'C-01', 'C-04'],
    guestReadable: true,
    signedInControls: {'favourite', 'favouritesFilter', 'changeAddress'},
    links: ['NC-02', 'NC-18', 'C-02'],
  ),
  StScreenSpec(
    id: 'NC-02',
    form: StScreenForm.section,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: KitchenProfileText.aboutTitle,
    source: 'design/screens/CUSTOMER_NEW_SCREENS.md NC-02 (C-06 owns the route, DN-4)',
    hosts: ['C-05', 'C-06', 'NC-01', 'NC-18'],
    guestReadable: true,
    signedInControls: {'favourite', 'subscribe', 'report', 'changeAddress'},
    links: ['NC-03', 'NC-04', 'SH-06', 'C-02'],
  ),
  StScreenSpec(
    id: 'NC-03',
    form: StScreenForm.section,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: KitchenProfileText.menuTitle,
    source: 'design/screens/CUSTOMER_NEW_SCREENS.md NC-03 (C-06 owns the route, DN-4)',
    hosts: ['C-05', 'C-06', 'NC-02'],
    guestReadable: true,
    signedInControls: {'addToOrder'},
    links: ['C-05', 'C-07'],
  ),
  StScreenSpec(
    id: 'NC-18',
    form: StScreenForm.section,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: KitchenFavouritesText.title,
    source: 'design/screens/CUSTOMER_NEW_SCREENS.md NC-18 (C-24 owns the route, DN-4)',
    hosts: ['C-24', 'NC-01'],
    links: ['NC-01', 'NC-02'],
  ),
  // New_Screen specs
];

/// Text tables of the Customer app's new features (key-completeness test).
const customerTextTables = <String, Map<String, StText>>{
  'partner_handoff': PartnerHandoffText.all,
  'kitchen_discovery': KitchenDiscoveryText.all,
  'kitchen_profile': KitchenProfileText.all,
  'kitchen_favourites': KitchenFavouritesText.all,
  // New_Screen texts
};
