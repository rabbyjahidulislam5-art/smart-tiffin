import '../text/digits.dart';
import 'amount_error.dart';
import 'amount_result.dart';

/// Lowest accepted amount: 0.01 taka.
const int minAmountMinor = 1;

/// Highest accepted amount: 999,999.99 taka.
const int maxAmountMinor = 99999999;

final _shape = RegExp(r'^\d{1,6}(\.\d{1,2})?$');

/// Parses a typed amount (Latin or Bangla digits) into minor units.
///
/// Rules (requirement 7.5): one to six integer digits, at most two decimals,
/// a value from 0.01 to 999,999.99, and, when [maxMinor] is given (the
/// eligible balance), not above it.
AmountResult parseAmountMinor(String input, {int? maxMinor}) {
  final text = latinDigits(input).trim();
  if (text.isEmpty) return const AmountResult.fail(AmountError.empty);
  if (!_shape.hasMatch(text)) return const AmountResult.fail(AmountError.format);
  final parts = text.split('.');
  final whole = int.parse(parts[0]);
  final frac = parts.length == 2 ? int.parse(parts[1].padRight(2, '0')) : 0;
  final minor = whole * 100 + frac;
  if (minor < minAmountMinor || minor > maxAmountMinor) {
    return const AmountResult.fail(AmountError.range);
  }
  if (maxMinor != null && minor > maxMinor) {
    return const AmountResult.fail(AmountError.aboveBalance);
  }
  return AmountResult.ok(minor);
}
