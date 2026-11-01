import 'amount_error.dart';

/// Result of `parseAmountMinor`: minor units when valid, else an [AmountError].
class AmountResult {
  const AmountResult.ok(int this.minor) : error = null;

  const AmountResult.fail(AmountError this.error) : minor = null;

  final int? minor;
  final AmountError? error;

  bool get isValid => error == null;

  @override
  bool operator ==(Object other) => other is AmountResult && other.minor == minor && other.error == error;

  @override
  int get hashCode => Object.hash(minor, error);

  @override
  String toString() => isValid ? 'AmountResult($minor)' : 'AmountResult(${error!.name})';
}
