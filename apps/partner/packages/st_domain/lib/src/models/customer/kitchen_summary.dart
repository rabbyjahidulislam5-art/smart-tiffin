import '../../result/slot.dart';

/// Public projection of a published kitchen (NC-01 card).
class KitchenSummary {
  const KitchenSummary({
    required this.id,
    required this.nameEn,
    required this.nameBn,
    required this.img,
    required this.verified,
    required this.rating,
    required this.ratingCount,
    required this.slots,
    required this.cuisine,
    required this.dietary,
    required this.zones,
    required this.accepting,
  });

  final String id;
  final String nameEn;
  final String nameBn;
  final String img;

  /// Only from an approved verification state.
  final bool verified;
  final double rating;
  final int ratingCount;
  final Set<Slot> slots;
  final String cuisine;
  final Set<String> dietary;
  final Set<String> zones;
  final bool accepting;

  bool serves(String? zone) => zone == null || zones.contains(zone);
}
