import 'package:st_domain/st_domain.dart';
import 'package:test/test.dart';

void main() {
  test('bnDigits and latinDigits', () {
    expect(bnDigits('৳1,234 at 12:30'), '৳১,২৩৪ at ১২:৩০');
    expect(latinDigits('১২৩৪৫'), '12345');
    expect(latinDigits(bnDigits('0123456789')), '0123456789');
    expect(bnDigits('no digits'), 'no digits');
  });

  test('localized falls back to English for blank Bangla', () {
    expect(localized('bn', 'Hello', ''), 'Hello');
    expect(localized('bn', 'Hello', '   '), 'Hello');
    expect(localized('bn', 'Hello', 'হ্যালো'), 'হ্যালো');
    expect(localized('en', 'Hello', 'হ্যালো'), 'Hello');
  });

  test('StText.fill replaces placeholders', () {
    expect(StText.fill('{0} of {1}', ['2', '5']), '2 of 5');
  });
}
