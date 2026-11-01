/// Non-motion timing tokens. Added in B2 (DD-6).
abstract final class StTiming {
  /// How long a success confirmation stays visible (requirement 14.5: at least 3 s).
  static const Duration confirmationHold = Duration(seconds: 4);

  /// Debounce of a search field before the query runs (NC-01). Added in B15.
  static const Duration searchDebounce = Duration(milliseconds: 350);
}
