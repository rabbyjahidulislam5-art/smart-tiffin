import 'package:st_domain/st_domain.dart';
import 'package:test/test.dart';

void main() {
  const known = {
    'AU-03',
    'SH-01',
    'C-01',
    'NC-01',
    'S-01',
    'NS-01',
    'R-01',
    'A-01',
    'NF-01'
  };

  AccessDecision decide(String id, StRole active, Set<StRole> sessions,
          Set<StRole> appRoles) =>
      decideAccess(
        screenId: id,
        activeRole: active,
        sessions: sessions,
        appRoles: appRoles,
        knownIds: known,
      );

  group('decideAccess decision table', () {
    test('row 1: unknown id is denied first', () {
      expect(decide('X-99', StRole.admin, {StRole.admin}, {StRole.admin}),
          const Denied(DeniedReason.unknownId));
    });
    test('row 2: role-less ids are allowed', () {
      expect(decide('AU-03', StRole.customer, {}, {StRole.customer}),
          const Allowed());
      expect(
          decide('SH-01', StRole.rider, {}, {StRole.rider}), const Allowed());
    });
    test('row 3: role not in the app', () {
      expect(
          decide('S-01', StRole.customer, {StRole.supplier}, {StRole.customer}),
          const Denied(DeniedReason.roleNotInApp));
    });
    test('row 4: role mismatch', () {
      expect(
          decide('R-01', StRole.supplier, {StRole.supplier, StRole.rider},
              {StRole.supplier, StRole.rider}),
          const Denied(DeniedReason.roleMismatch));
    });
    test('row 5: no session for a non-customer role', () {
      expect(
          decide('NF-01', StRole.accounting, {},
              {StRole.admin, StRole.accounting}),
          const Denied(DeniedReason.noSession));
    });
    test('row 6: allowed', () {
      expect(
          decide('A-01', StRole.admin, {StRole.admin},
              {StRole.admin, StRole.accounting}),
          const Allowed());
      expect(decide('C-01', StRole.customer, {}, {StRole.customer}),
          const Allowed());
    });
    test('first failing reason wins', () {
      expect(decide('NS-99', StRole.customer, {}, {StRole.customer}),
          const Denied(DeniedReason.unknownId));
      expect(decide('NS-01', StRole.customer, {}, {StRole.customer}),
          const Denied(DeniedReason.roleNotInApp));
    });
  });

  test('roleForScreenId prefixes', () {
    expect(roleForScreenId('C-12'), StRole.customer);
    expect(roleForScreenId('NC-04'), StRole.customer);
    expect(roleForScreenId('S-02'), StRole.supplier);
    expect(roleForScreenId('NS-07'), StRole.supplier);
    expect(roleForScreenId('R-05'), StRole.rider);
    expect(roleForScreenId('NR-03'), StRole.rider);
    expect(roleForScreenId('A-19'), StRole.admin);
    expect(roleForScreenId('NA-05'), StRole.admin);
    expect(roleForScreenId('NF-17'), StRole.accounting);
    expect(roleForScreenId('AU-13'), isNull);
    expect(roleForScreenId('SH-10'), isNull);
    expect(roleForScreenId('P-01'), isNull);
  });
}
