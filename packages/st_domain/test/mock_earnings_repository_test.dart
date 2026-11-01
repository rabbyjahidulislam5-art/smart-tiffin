import 'package:test/test.dart';

import 'support/checks/partner_checks.dart';

void main() {
  for (final c in earningsChecks) {
    test(c.name, () async => expect(await c.run(), isTrue));
  }
}
