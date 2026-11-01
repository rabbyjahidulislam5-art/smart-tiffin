import 'package:flutter/material.dart';
import 'package:st_shell/st_shell.dart';

import '../features/kitchen_discovery/screens/kitchen_discovery_text.dart';
import '../features/kitchen_favourites/screens/kitchen_favourites_text.dart';
import '../features/kitchen_profile/screens/kitchen_profile_text.dart';

// Host entry text imports

/// Entry controls added to Built host screens (LC-11). The registry wraps a
/// host in `StHostEntries`; the host files are not edited. `params` are the
/// legacy defaults of the host (C-05 shows `biryani`, C-06 Rina's Kitchen)
/// and a forwarded or renamed host parameter replaces them.
const customerHostEntries = <String, List<StHostEntry>>{
  'P-02': [
    StHostEntry(
      id: 'NC-01',
      label: KitchenDiscoveryText.title,
      sub: KitchenDiscoveryText.search,
      icon: Icons.storefront_rounded,
    ),
  ],
  'C-01': [
    StHostEntry(
      id: 'NC-01',
      label: KitchenDiscoveryText.title,
      sub: KitchenDiscoveryText.search,
      icon: Icons.storefront_rounded,
    ),
  ],
  'C-04': [
    StHostEntry(
      id: 'NC-01',
      label: KitchenDiscoveryText.title,
      sub: KitchenDiscoveryText.search,
      icon: Icons.storefront_rounded,
    ),
  ],
  'C-05': [
    StHostEntry(
      id: 'NC-02',
      label: KitchenProfileText.aboutTitle,
      icon: Icons.info_outline_rounded,
      params: {'meal': 'biryani'},
      rename: {'id': 'meal'},
    ),
    StHostEntry(
      id: 'NC-03',
      label: KitchenProfileText.menuTitle,
      icon: Icons.restaurant_menu_rounded,
      params: {'meal': 'biryani'},
      rename: {'id': 'meal'},
    ),
  ],
  'C-06': [
    StHostEntry(
      id: 'NC-02',
      label: KitchenProfileText.aboutTitle,
      icon: Icons.info_outline_rounded,
      params: {'kitchen': 'rinas-kitchen'},
      forward: ['kitchen'],
    ),
    StHostEntry(
      id: 'NC-03',
      label: KitchenProfileText.menuTitle,
      icon: Icons.restaurant_menu_rounded,
      params: {'kitchen': 'rinas-kitchen'},
      forward: ['kitchen'],
    ),
  ],
  'C-24': [
    StHostEntry(
      id: 'NC-18',
      label: KitchenFavouritesText.title,
      icon: Icons.favorite_border_rounded,
    ),
  ],
  // New_Screen hosts
};
