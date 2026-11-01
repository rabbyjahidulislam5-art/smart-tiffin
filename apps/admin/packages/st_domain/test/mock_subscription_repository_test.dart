import 'package:test/test.dart';

import 'support/checks/customer_checks.dart';

void main() {
  for (final c in subscriptionChecks) {
    test(c.name, () async => expect(await c.run(), isTrue));
  }
}
