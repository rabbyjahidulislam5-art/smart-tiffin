import 'package:st_domain/st_domain.dart';
import 'package:test/test.dart';

void main() {
  test('accepts the boundaries', () {
    expect(parseAmountMinor('0.01').minor, 1);
    expect(parseAmountMinor('999999.99').minor, 99999999);
    expect(parseAmountMinor('১২৩.৫').minor, 12350);
  });

  test('rejects invalid amounts', () {
    expect(parseAmountMinor('0').error, AmountError.range);
    expect(parseAmountMinor('0.001').error, AmountError.format);
    expect(parseAmountMinor('1000000').error, AmountError.format);
    expect(parseAmountMinor('12a').error, AmountError.format);
    expect(parseAmountMinor('').error, AmountError.empty);
    expect(parseAmountMinor('600', maxMinor: 50000).error,
        AmountError.aboveBalance);
    expect(parseAmountMinor('500', maxMinor: 50000).minor, 50000);
  });
}
