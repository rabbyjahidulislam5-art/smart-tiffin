import 'package:st_domain/st_domain.dart';

/// A column of `StFinTable` shown in the medium band and wider.
class StFinColumn<T> {
  const StFinColumn({required this.label, required this.cell, this.width = 140, this.numeric = false});

  final StText label;

  /// Text of the cell for a row (already localized by the caller).
  final String Function(T row) cell;
  final double width;
  final bool numeric;
}
