import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

/// NC-01 search state: text, filters, sort and area. Not auto-disposed, so a
/// return from a kitchen and a cancelled or refused sign-in find the same
/// state (requirement 5.7). The cursor lives in the results controller and
/// the scroll offset in `StScrollMemory`.
class KitchenQueryController extends Notifier<KitchenQuery> {
  String? _appliedParams;

  @override
  KitchenQuery build() => const KitchenQuery();

  void set(KitchenQuery query) {
    if (query != state) state = query;
  }

  /// Applies route parameters (deep link or a restored sign-in intent) once
  /// per parameter set, so a later return to the same entry keeps what the
  /// customer changed since.
  void applyParams(Map<String, String> params) {
    if (params.isEmpty) return;
    final keys = params.keys.toList()..sort();
    final signature = [for (final k in keys) '$k=${params[k]}'].join('&');
    if (signature == _appliedParams) return;
    _appliedParams = signature;
    set(KitchenQuery.fromParams(params));
  }

  void setText(String q) => set(state.copyWith(q: q));

  void setSort(KitchenSort sort) => set(state.copyWith(sort: sort));

  void setZone(String? zone) => set(
    zone == null ? state.copyWith(clearZone: true) : state.copyWith(zone: zone),
  );

  void toggleSlot(Slot slot) {
    final next = {...state.slots};
    if (!next.remove(slot)) next.add(slot);
    set(state.copyWith(slots: next));
  }

  /// Clears the filters and keeps the text, sort and area.
  void clearFilters() => set(state.cleared());

  /// Clears the filters and the text (the "No kitchens match" action).
  void clearAll() => set(KitchenQuery(sort: state.sort, zone: state.zone));
}
