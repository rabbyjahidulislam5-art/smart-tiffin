/// One page of a cursor-paged list.
///
/// Named `StPage` instead of the design's `Page` so it never clashes with
/// Flutter's `Page` class in files that import both packages.
class StPage<T> {
  const StPage(this.items, {this.cursor, this.atEnd = true});

  final List<T> items;

  /// Opaque cursor for the next page; null when [atEnd].
  final String? cursor;
  final bool atEnd;

  bool get isEmpty => items.isEmpty;

  /// Cuts [all] into the page that starts at [cursor] (an index string).
  static StPage<T> slice<T>(List<T> all, {String? cursor, int size = 20}) {
    final start = int.tryParse(cursor ?? '') ?? 0;
    if (start >= all.length) return StPage<T>(const [], atEnd: true);
    final end = (start + size).clamp(0, all.length);
    final atEnd = end >= all.length;
    return StPage<T>(List.unmodifiable(all.sublist(start, end)), cursor: atEnd ? null : '$end', atEnd: atEnd);
  }
}
