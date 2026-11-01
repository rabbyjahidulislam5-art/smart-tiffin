import 'package:test/test.dart';

import 'support/checks/finance_checks.dart';

void main() {
  for (final c in ledgerChecks) {
    test(c.name, () async => expect(await c.run(), isTrue));
  }
}
