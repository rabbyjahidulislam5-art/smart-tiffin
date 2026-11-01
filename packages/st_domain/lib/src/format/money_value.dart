import 'money.dart';

/// An amount of BDT held as integer minor units (paisa).
class Money implements Comparable<Money> {
  const Money(this.minor);

  /// Whole taka.
  const Money.taka(int taka) : minor = taka * 100;

  static const zero = Money(0);

  final int minor;

  /// Whole-taka part (truncated towards zero).
  int get taka => minor ~/ 100;

  bool get isNegative => minor < 0;

  Money operator +(Money other) => Money(minor + other.minor);

  Money operator -(Money other) => Money(minor - other.minor);

  Money operator -() => Money(-minor);

  bool operator >(Money other) => minor > other.minor;

  bool operator <(Money other) => minor < other.minor;

  bool operator >=(Money other) => minor >= other.minor;

  bool operator <=(Money other) => minor <= other.minor;

  /// `৳` label through [fmtBdtMinor].
  String format({bool bn = false}) => moneyLabelMinor(minor, bn: bn);

  @override
  int compareTo(Money other) => minor.compareTo(other.minor);

  @override
  bool operator ==(Object other) => other is Money && other.minor == minor;

  @override
  int get hashCode => minor.hashCode;

  @override
  String toString() => 'Money($minor)';
}
