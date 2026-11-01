import 'package:test/test.dart';

import 'support/checks/admin_checks.dart';

void main() {
  for (final c in policyChecks) {
    test(c.name, () async => expect(await c.run(), isTrue));
  }
}
