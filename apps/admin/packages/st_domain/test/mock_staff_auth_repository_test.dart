import 'package:st_domain/st_domain.dart';
import 'package:test/test.dart';

void main() {
  late MockBehavior behavior;
  late MockStaffAuthRepository repo;

  setUp(() {
    behavior = MockBehavior.instant();
    repo = MockStaffAuthRepository(behavior: behavior);
  });

  test('admin credentials grant admin (reads approved mock data, no network)',
      () async {
    expect(
        await repo.verifyCredentials('nadia@smarttiffin.bd', 'demo-password'),
        const Ok(StRole.admin));
  });

  test('the sample account grants accounting', () async {
    expect(
        await repo.verifyCredentials(
            'accounts@smarttiffin.bd', 'demo-password'),
        const Ok(StRole.accounting));
  });

  test('wrong credentials return an error', () async {
    expect(
        (await repo.verifyCredentials('someone@gmail.com', 'demo-password'))
            .errorOrNull
            ?.kind,
        RepoErrorKind.unauthenticated);
    expect(
        (await repo.verifyCredentials('nadia@smarttiffin.bd', 'short'))
            .errorOrNull
            ?.kind,
        RepoErrorKind.unauthenticated);
  });

  test('failure mode returns Err', () async {
    behavior.failNext(RepoErrorKind.temporarilyUnavailable);
    expect(
        (await repo.verifyCredentials('nadia@smarttiffin.bd', 'demo-password'))
            .errorOrNull
            ?.kind,
        RepoErrorKind.temporarilyUnavailable);
  });
}
