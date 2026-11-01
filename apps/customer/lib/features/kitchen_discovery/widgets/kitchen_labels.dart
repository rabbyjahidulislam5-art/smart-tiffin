import 'package:st_domain/st_domain.dart';

import '../screens/kitchen_discovery_text.dart';

/// Service areas of the area selector (zone names of the catalogue).
const kitchenZones = ['Banani', 'Gulshan', 'Mohakhali', 'Dhanmondi', 'Uttara'];

/// Cuisine filter values (`KitchenSummary.cuisine`).
const kitchenCuisines = ['bengali', 'biryani', 'beef', 'diet'];

/// Dietary filter values (`KitchenSummary.dietary`).
const kitchenDietary = ['halal', 'diet'];

/// Localized name of a service area; an unknown area shows its name.
StText zoneText(String zone) => switch (zone) {
  'Banani' => KitchenDiscoveryText.zoneBanani,
  'Gulshan' => KitchenDiscoveryText.zoneGulshan,
  'Mohakhali' => KitchenDiscoveryText.zoneMohakhali,
  'Dhanmondi' => KitchenDiscoveryText.zoneDhanmondi,
  'Uttara' => KitchenDiscoveryText.zoneUttara,
  _ => StText(zone, zone),
};

/// Localized cuisine label.
StText cuisineText(String cuisine) => switch (cuisine) {
  'bengali' => KitchenDiscoveryText.cuisineBengali,
  'biryani' => KitchenDiscoveryText.cuisineBiryani,
  'beef' => KitchenDiscoveryText.cuisineBeef,
  'diet' => KitchenDiscoveryText.cuisineDiet,
  _ => StText(cuisine, cuisine),
};

/// Localized dietary tag (the kitchen's own statement, not medical advice).
StText dietaryText(String tag) => switch (tag) {
  'halal' => KitchenDiscoveryText.halal,
  'diet' => KitchenDiscoveryText.diet,
  _ => StText(tag, tag),
};
