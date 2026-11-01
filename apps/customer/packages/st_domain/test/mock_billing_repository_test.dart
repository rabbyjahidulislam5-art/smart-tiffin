import 'package:test/test.dart';

import 'support/checks/customer_billing_checks.dart';

void main() {
  for (final c in billingChecks) {
    test(c.name, () async => expect(await c.run(), isTrue));
  }
}
