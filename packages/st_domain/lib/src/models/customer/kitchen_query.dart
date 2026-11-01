import '../../result/slot.dart';
import 'kitchen_sort.dart';

/// Search state of NC-01. `toParams`/`fromParams` carry it through a
/// sign-in intent and back (Property 8).
class KitchenQuery {
  const KitchenQuery({
    this.q = '',
    this.cuisine,
    this.dietary,
    this.slots = const {},
    this.verifiedOnly = false,
    this.favouritesOnly = false,
    this.sort = KitchenSort.relevance,
    this.zone,
  });

  /// Longest accepted query (NC-01.9).
  static const maxQueryLength = 60;

  final String q;
  final String? cuisine;
  final String? dietary;
  final Set<Slot> slots;
  final bool verifiedOnly;
  final bool favouritesOnly;
  final KitchenSort sort;
  final String? zone;

  bool get hasFilters => cuisine != null || dietary != null || slots.isNotEmpty || verifiedOnly || favouritesOnly;

  Map<String, String> toParams() => {
        if (q.isNotEmpty) 'q': q,
        if (cuisine != null) 'cuisine': cuisine!,
        if (dietary != null) 'dietary': dietary!,
        if (slots.isNotEmpty) 'slots': (slots.map((s) => s.name).toList()..sort()).join(','),
        if (verifiedOnly) 'verified': '1',
        if (favouritesOnly) 'fav': '1',
        if (sort != KitchenSort.relevance) 'sort': sort.name,
        if (zone != null) 'zone': zone!,
      };

  factory KitchenQuery.fromParams(Map<String, String> p) => KitchenQuery(
        q: p['q'] ?? '',
        cuisine: p['cuisine'],
        dietary: p['dietary'],
        slots: {
          for (final n in (p['slots'] ?? '').split(','))
            for (final s in Slot.values)
              if (s.name == n) s,
        },
        verifiedOnly: p['verified'] == '1',
        favouritesOnly: p['fav'] == '1',
        sort: KitchenSort.values.firstWhere((s) => s.name == p['sort'], orElse: () => KitchenSort.relevance),
        zone: p['zone'],
      );

  KitchenQuery copyWith({
    String? q,
    String? cuisine,
    bool clearCuisine = false,
    String? dietary,
    bool clearDietary = false,
    Set<Slot>? slots,
    bool? verifiedOnly,
    bool? favouritesOnly,
    KitchenSort? sort,
    String? zone,
    bool clearZone = false,
  }) =>
      KitchenQuery(
        q: q ?? this.q,
        cuisine: clearCuisine ? null : (cuisine ?? this.cuisine),
        dietary: clearDietary ? null : (dietary ?? this.dietary),
        slots: slots ?? this.slots,
        verifiedOnly: verifiedOnly ?? this.verifiedOnly,
        favouritesOnly: favouritesOnly ?? this.favouritesOnly,
        sort: sort ?? this.sort,
        zone: clearZone ? null : (zone ?? this.zone),
      );

  /// Same query and zone without any filter.
  KitchenQuery cleared() => KitchenQuery(q: q, sort: sort, zone: zone);

  @override
  bool operator ==(Object other) =>
      other is KitchenQuery &&
      other.q == q &&
      other.cuisine == cuisine &&
      other.dietary == dietary &&
      other.slots.length == slots.length &&
      other.slots.containsAll(slots) &&
      other.verifiedOnly == verifiedOnly &&
      other.favouritesOnly == favouritesOnly &&
      other.sort == sort &&
      other.zone == zone;

  @override
  int get hashCode => Object.hash(q, cuisine, dietary, Object.hashAllUnordered(slots), verifiedOnly, favouritesOnly, sort, zone);

  @override
  String toString() => 'KitchenQuery(${toParams()})';
}
