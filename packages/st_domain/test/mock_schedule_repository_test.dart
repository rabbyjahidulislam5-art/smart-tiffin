import 'package:test/test.dart';

import 'support/checks/customer_billing_checks.dart';

void main() {
  for (final c in scheduleChecks) {
    test(c.name, () async => expect(await c.run(), isTrue));
  }
}
