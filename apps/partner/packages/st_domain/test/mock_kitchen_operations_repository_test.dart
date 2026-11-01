import 'package:test/test.dart';

import 'support/checks/partner_checks.dart';

void main() {
  for (final c in kitchenOperationsChecks) {
    test(c.name, () async => expect(await c.run(), isTrue));
  }
}
