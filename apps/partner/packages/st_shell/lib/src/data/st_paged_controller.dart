import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

import 'st_paged_list.dart';

/// Loads a cursor-paged repository list page by page. The first page maps to
/// `AsyncValue` states; a failed "load more" keeps the rows and records the
/// error kind instead.
class StPagedController<T> extends StateNotifier<AsyncValue<StPagedList<T>>> {
  StPagedController(this.fetch) : super(AsyncLoading<StPagedList<T>>()) {
    _loadFirst();
  }

  final Future<RepoResult<StPage<T>>> Function(String? cursor) fetch;

  Future<void> _loadFirst() async {
    final r = await fetch(null);
    if (!mounted) return;
    state = switch (r) {
      Ok(:final value) => AsyncData(StPagedList<T>(value.items,
          cursor: value.cursor, atEnd: value.atEnd)),
      Err(:final error) => AsyncError<StPagedList<T>>(error, StackTrace.empty),
    };
  }

  /// Reloads from the first page (Retry, or after a command changed the list).
  Future<void> reload() async {
    state = AsyncLoading<StPagedList<T>>();
    await _loadFirst();
  }

  /// Appends the next page.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.atEnd || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true, clearError: true));
    final r = await fetch(current.cursor);
    if (!mounted) return;
    state = switch (r) {
      Ok(:final value) => AsyncData(StPagedList<T>(
          [...current.items, ...value.items],
          cursor: value.cursor, atEnd: value.atEnd)),
      Err(:final error) =>
        AsyncData(current.copyWith(loadingMore: false, moreError: error.kind)),
    };
  }
}
