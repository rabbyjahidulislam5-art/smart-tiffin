import 'package:test/test.dart';

import 'support/catalogue_checks.dart';

// Feature: tiffin-three-app-completion, Properties 3, 12, 13, 14 (catalogue-driven).
void main() {
  for (final c in catalogueChecks()) {
    test(c.name, () async => expect(await c.run(), isTrue));
  }
}
