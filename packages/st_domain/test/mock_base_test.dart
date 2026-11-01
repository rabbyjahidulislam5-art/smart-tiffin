import 'package:st_domain/st_domain.dart';
import 'package:test/test.dart';

class _Probe extends MockRepositoryBase {
  _Probe(super.behavior);

  int state = 0;
  int reads = 0;

  Future<RepoResult<int>> read(Actor a) =>
      guardRead(a, {StRole.supplier}, 'read', () {
        reads++;
        return Ok(state);
      });

  Future<RepoResult<int>> add(Actor a, RequestId id, int n) =>
      guardCommand(a, {StRole.supplier}, 'add', id, () {
        if (n <= 0) return MockRepositoryBase.invalid<int>('n');
        state += n;
        return Ok(state);
      });
}

void main() {
  const supplier = Actor(StRole.supplier, id: 's-1');
  const rider = Actor(StRole.rider, id: 'r-1');

  test('latency is capped at 500 ms and zero in tests', () {
    expect(MockBehavior(latency: const Duration(seconds: 3)).latency,
        MockBehavior.maxLatency);
    expect(MockBehavior.instant().latency, Duration.zero);
    expect(MockBehavior().latency, const Duration(milliseconds: 120));
  });

  test('requireRole refuses before any state read', () async {
    final p = _Probe(MockBehavior.instant());
    final r = await p.read(rider);
    expect(r, const Err<int>(RepoError(RepoErrorKind.permissionDenied)));
    expect(p.reads, 0);
  });

  test('guests are refused on signed-in methods', () async {
    final p = _Probe(MockBehavior.instant());
    expect((await p.read(const Actor(StRole.supplier))).errorOrNull?.kind,
        RepoErrorKind.permissionDenied);
  });

  test('failNext fails one call, failAlways until clear', () async {
    final b = MockBehavior.instant();
    final p = _Probe(b);
    b.failNext(RepoErrorKind.temporarilyUnavailable);
    expect((await p.read(supplier)).errorOrNull?.kind,
        RepoErrorKind.temporarilyUnavailable);
    expect((await p.read(supplier)).isOk, isTrue);
    b.failAlways(RepoErrorKind.internalError);
    expect((await p.read(supplier)).isOk, isFalse);
    expect((await p.read(supplier)).isOk, isFalse);
    b.clear();
    expect((await p.read(supplier)).isOk, isTrue);
  });

  test('commit returns the first outcome for a repeated request id', () async {
    final p = _Probe(MockBehavior.instant());
    const id = RequestId('r-1');
    expect(await p.add(supplier, id, 5), const Ok(5));
    expect(await p.add(supplier, id, 5), const Ok(5));
    expect(p.state, 5);
  });

  test('a failed command changes nothing', () async {
    final p = _Probe(MockBehavior.instant());
    expect(
        (await p.add(supplier, const RequestId('r-2'), 0)).errorOrNull?.field,
        'n');
    expect(p.state, 0);
  });
}
