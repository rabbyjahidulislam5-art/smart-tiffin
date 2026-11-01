import 'package:st_domain/st_domain.dart';

/// Rows of a cursor-paged list loaded so far.
class StPagedList<T> {
  const StPagedList(this.items,
      {this.cursor,
      this.atEnd = true,
      this.loadingMore = false,
      this.moreError});

  final List<T> items;
  final String? cursor;
  final bool atEnd;
  final bool loadingMore;

  /// Error of the last "load more" call; the loaded rows stay visible.
  final RepoErrorKind? moreError;

  bool get isEmpty => items.isEmpty;

  StPagedList<T> copyWith(
          {bool? loadingMore,
          RepoErrorKind? moreError,
          bool clearError = false}) =>
      StPagedList<T>(
        items,
        cursor: cursor,
        atEnd: atEnd,
        loadingMore: loadingMore ?? this.loadingMore,
        moreError: clearError ? null : (moreError ?? this.moreError),
      );
}
