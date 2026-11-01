import 'package:st_domain/st_domain.dart';
import 'package:test/test.dart';

void main() {
  test('fmtBdt examples', () {
    expect(fmtBdt(0), '0');
    expect(fmtBdt(999), '999');
    expect(fmtBdt(1000), '1,000');
    expect(fmtBdt(12345), '12,345');
    expect(fmtBdt(999999999), '99,99,99,999');
  });

  test('fmtBdt negative values (DF-1)', () {
    expect(fmtBdt(-12345), '-12,345');
    expect(fmtBdt(-5), '-5');
    expect(fmtBdt(-1000), '-1,000');
  });

  test('fmtBdtMinor shows paisa only when not zero', () {
    expect(fmtBdtMinor(123400), '1,234');
    expect(fmtBdtMinor(123405), '1,234.05');
    expect(fmtBdtMinor(1), '0.01');
    expect(fmtBdtMinor(-250), '-2.50');
  });

  test('moneyLabel in both languages', () {
    expect(moneyLabel(1800), '৳1,800');
    expect(moneyLabel(1800, bn: true), '৳১,৮০০');
    expect(const Money.taka(12).format(), '৳12');
  });
}
