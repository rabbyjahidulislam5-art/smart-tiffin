// Offline mirror for environments without `dart test` (no pub.dev, no test
// runner subprocesses). It runs dependency-free smoke checks of the pure
// domain logic and then every `test/props/*.dart` main() in its own isolate
// (each property body runs a seeded loop of 100 iterations and throws on a
// failure). This is a smoke check only; it is not counted as the property
// tests, which run with `dart test` and kiri_check.
//
// Usage (packages/st_domain): dart run tool/check.dart
import 'dart:io';
import 'dart:isolate';

import 'package:st_domain/st_domain.dart';

import '../test/support/all_checks.dart';
import '../test/support/legacy_fmt_bdt.dart';

var _passed = 0;
var _failed = 0;

void check(String name, bool ok) {
  if (ok) {
    _passed++;
  } else {
    _failed++;
    stderr.writeln('FAIL: $name');
  }
}

Future<void> main() async {
  _accessChecks();
  _textChecks();
  _moneyChecks();
  _amountChecks();
  await _mockChecks();
  stdout.writeln('smoke checks: $_passed passed, $_failed failed');
  final props = await _runProps();
  final ok = _failed == 0 && props;
  stdout.writeln(ok ? 'check.dart: PASSED' : 'check.dart: FAILED');
  exit(ok ? 0 : 1);
}

void _accessChecks() {
  const known = {'AU-03', 'C-01', 'S-01', 'R-01', 'A-01', 'NF-01'};
  AccessDecision d(String id, StRole a, Set<StRole> s, Set<StRole> app) =>
      decideAccess(screenId: id, activeRole: a, sessions: s, appRoles: app, knownIds: known);
  check('row1 unknown', d('X-1', StRole.admin, {StRole.admin}, {StRole.admin}) == const Denied(DeniedReason.unknownId));
  check('row2 role-less', d('AU-03', StRole.customer, {}, {StRole.customer}) == const Allowed());
  check('row3 not in app', d('S-01', StRole.customer, {}, {StRole.customer}) == const Denied(DeniedReason.roleNotInApp));
  check('row4 mismatch', d('R-01', StRole.supplier, {StRole.supplier, StRole.rider}, {StRole.supplier, StRole.rider}) ==
      const Denied(DeniedReason.roleMismatch));
  check('row5 no session', d('NF-01', StRole.accounting, {}, {StRole.accounting}) == const Denied(DeniedReason.noSession));
  check('row6 allowed', d('A-01', StRole.admin, {StRole.admin}, {StRole.admin}) == const Allowed());
  check('row6 guest customer', d('C-01', StRole.customer, {}, {StRole.customer}) == const Allowed());
  check('prefix NC', roleForScreenId('NC-04') == StRole.customer);
  check('prefix NF', roleForScreenId('NF-11') == StRole.accounting);
  check('prefix AU', roleForScreenId('AU-13') == null);
}

void _textChecks() {
  check('bnDigits', bnDigits('৳1,234') == '৳১,২৩৪');
  check('latinDigits', latinDigits('১২৩') == '123');
  check('localized fallback', localized('bn', 'Hi', ' ') == 'Hi');
  check('localized bn', localized('bn', 'Hi', 'হাই') == 'হাই');
  check('StText.fill', StText.fill('{0}/{1}', ['1', '2']) == '1/2');
}

void _moneyChecks() {
  check('fmtBdt 0', fmtBdt(0) == '0');
  check('fmtBdt 999', fmtBdt(999) == '999');
  check('fmtBdt 1000', fmtBdt(1000) == '1,000');
  check('fmtBdt 12345', fmtBdt(12345) == '12,345');
  check('fmtBdt 999999999', fmtBdt(999999999) == '99,99,99,999');
  check('fmtBdt -12345 (DF-1)', fmtBdt(-12345) == '-12,345');
  check('legacy -12345 was wrong', legacyFmtBdt(-12345) == '-,12,345');
  for (final n in [0, 7, 99, 100, 1000, 54321, 123456, 1234567, 999999999]) {
    check('legacy identical $n', fmtBdt(n) == legacyFmtBdt(n));
  }
  check('fmtBdtMinor whole', fmtBdtMinor(180000) == '1,800');
  check('fmtBdtMinor paisa', fmtBdtMinor(180005) == '1,800.05');
  check('moneyLabel bn', moneyLabel(1800, bn: true) == '৳১,৮০০');
}

void _amountChecks() {
  check('amount 0.01', parseAmountMinor('0.01').minor == 1);
  check('amount max', parseAmountMinor('999999.99').minor == 99999999);
  check('amount 0', parseAmountMinor('0').error == AmountError.range);
  check('amount 0.001', parseAmountMinor('0.001').error == AmountError.format);
  check('amount 1000000', parseAmountMinor('1000000').error == AmountError.format);
  check('amount letters', parseAmountMinor('1a').error == AmountError.format);
  check('amount empty', parseAmountMinor(' ').error == AmountError.empty);
  check('amount above balance', parseAmountMinor('600', maxMinor: 50000).error == AmountError.aboveBalance);
  check('amount bangla', parseAmountMinor('১২.৫').minor == 1250);
}

Future<void> _mockChecks() async {
  final b = MockBehavior.instant();
  final auth = MockStaffAuthRepository(behavior: b);
  check('auth admin', (await auth.verifyCredentials('nadia@smarttiffin.bd', 'demo-password')) == const Ok(StRole.admin));
  check('auth accounting',
      (await auth.verifyCredentials('accounts@smarttiffin.bd', 'demo-password')) == const Ok(StRole.accounting));
  check('auth wrong', !(await auth.verifyCredentials('x@gmail.com', 'demo-password')).isOk);
  b.failNext(RepoErrorKind.temporarilyUnavailable);
  check('auth failNext', (await auth.verifyCredentials('nadia@smarttiffin.bd', 'demo-password')).errorOrNull?.kind ==
      RepoErrorKind.temporarilyUnavailable);
  check('latency cap', MockBehavior(latency: const Duration(seconds: 2)).latency == MockBehavior.maxLatency);
  for (final c in [...extraMockChecks, ...allRepoChecks()]) {
    check(c.name, await c.run());
  }
}

/// Smoke checks contributed by later batches (one per mock repository).
final List<({String name, Future<bool> Function() run})> extraMockChecks = [];

Future<bool> _runProps() async {
  final dir = Directory('test/props');
  if (!dir.existsSync()) {
    stdout.writeln('property bodies: none yet');
    return true;
  }
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.dart')).toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  var ok = true;
  for (final f in files) {
    final exitPort = ReceivePort();
    final errorPort = ReceivePort();
    final errors = <Object?>[];
    errorPort.listen(errors.add);
    await Isolate.spawnUri(f.absolute.uri, const [], null, onExit: exitPort.sendPort, onError: errorPort.sendPort);
    await exitPort.first;
    errorPort.close();
    final name = f.uri.pathSegments.last;
    if (errors.isEmpty) {
      stdout.writeln('property $name: passed');
    } else {
      ok = false;
      stderr.writeln('property $name: FAILED ${errors.first}');
    }
  }
  return ok;
}
