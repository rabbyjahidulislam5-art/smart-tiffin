import '../state/app_state.dart';

/// What a data-backed screen area shows.
enum StResolvedState { loading, error, offline, empty, data }

/// Pure screen-state resolution (design "Screen-state pattern", Property 15).
///
/// Loading always wins (no stale or partial records); an error shows the error
/// panel, or the offline panel when offline is a supported state; empty only
/// when the data is empty and `empty` is supported; otherwise the data.
StResolvedState resolveScreenState({
  required bool loading,
  required bool hasError,
  required bool isEmpty,
  required bool offline,
  required Set<StVariant> supported,
}) {
  if (loading) return StResolvedState.loading;
  if (hasError) {
    return offline && supported.contains(StVariant.offline) ? StResolvedState.offline : StResolvedState.error;
  }
  if (isEmpty && supported.contains(StVariant.empty)) return StResolvedState.empty;
  return StResolvedState.data;
}

/// True when the offline banner is shown above loaded data.
bool showsOfflineBanner({required bool offline, required Set<StVariant> supported}) =>
    offline && supported.contains(StVariant.offline);
