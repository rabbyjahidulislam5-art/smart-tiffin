import 'package:st_domain/st_domain.dart';

/// Messages of `parseAmountMinor` failures (requirement 7.5), shown next to
/// the amount field; no repository call is made while one is shown.
abstract final class StAmountText {
  static const empty = StText('Enter an amount.', 'পরিমাণ লিখুন।');
  static const format = StText('Use up to 6 digits and 2 decimals.',
      'সর্বোচ্চ ৬ অঙ্ক ও ২ দশমিক ব্যবহার করুন।');
  static const range = StText('Enter an amount from ৳0.01 to ৳9,99,999.99.',
      '৳০.০১ থেকে ৳৯,৯৯,৯৯৯.৯৯ এর মধ্যে পরিমাণ লিখুন।');
  static const aboveBalance = StText(
      'The amount is above your eligible balance.',
      'পরিমাণটি আপনার উত্তোলনযোগ্য ব্যালেন্সের বেশি।');

  static StText of(AmountError e) => switch (e) {
        AmountError.empty => empty,
        AmountError.format => format,
        AmountError.range => range,
        AmountError.aboveBalance => aboveBalance,
      };

  /// Field errors for an amount typed against an optional [maxMinor].
  static Map<String, StText> errors(String amount,
      {int? maxMinor, String field = 'amount'}) {
    final e = parseAmountMinor(amount, maxMinor: maxMinor).error;
    return e == null ? const {} : {field: of(e)};
  }
}
