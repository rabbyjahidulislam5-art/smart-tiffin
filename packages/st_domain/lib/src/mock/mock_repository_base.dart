import '../access/actor.dart';
import '../access/st_role.dart';
import '../result/repo_error.dart';
import '../result/repo_result.dart';
import '../result/request_id.dart';
import 'mock_behavior.dart';

/// Base of every mock repository: role gate, latency, failure injection and
/// request-id receipts. State lives in memory only (no file, database or
/// network access; static rule R-NO-IO).
abstract class MockRepositoryBase {
  MockRepositoryBase(MockBehavior? behavior) : behavior = behavior ?? MockBehavior();

  final MockBehavior behavior;

  /// Names of the methods called, in order (used by command-spy tests).
  final List<String> calls = [];

  /// Number of committed state changes; a failed or repeated command does
  /// not change it (observation used by the catalogue-driven checks).
  int revision = 0;

  final Map<String, RepoResult<Object?>> _receipts = {};

  /// Role gate. Must be the first statement of every method: a role outside
  /// [allowed] (or a guest when [signedIn]) gets `permissionDenied` before
  /// any state is read or written.
  Future<RepoError?> requireRole(
    Actor actor,
    Set<StRole> allowed, {
    required String op,
    bool signedIn = true,
  }) async {
    calls.add(op);
    if (!allowed.contains(actor.role) || (signedIn && actor.isGuest)) {
      return const RepoError(RepoErrorKind.permissionDenied);
    }
    return open(op, recorded: true);
  }

  /// Latency and injected failure without a role gate (pre-session repositories).
  Future<RepoError?> open(String op, {bool recorded = false}) async {
    if (!recorded) calls.add(op);
    final latency = behavior.latency;
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    final failure = behavior.takeFailure();
    return failure == null ? null : RepoError(failure);
  }

  /// A read: role gate, then [read].
  Future<RepoResult<T>> guardRead<T>(
    Actor actor,
    Set<StRole> allowed,
    String op,
    RepoResult<T> Function() read, {
    bool signedIn = true,
  }) async {
    final e = await requireRole(actor, allowed, op: op, signedIn: signedIn);
    if (e != null) return Err<T>(e);
    return read();
  }

  /// A command: role gate, then [commit].
  Future<RepoResult<T>> guardCommand<T>(
    Actor actor,
    Set<StRole> allowed,
    String op,
    RequestId requestId,
    RepoResult<T> Function() body, {
    bool signedIn = true,
  }) async {
    final e = await requireRole(actor, allowed, op: op, signedIn: signedIn);
    if (e != null) return Err<T>(e);
    return commit(requestId, body);
  }

  /// Runs [body] once per [requestId]. [body] must validate before it changes
  /// state, so an `Err` leaves state unchanged. A successful outcome is stored
  /// and returned again for a repeated [requestId] without a second change.
  RepoResult<T> commit<T>(RequestId requestId, RepoResult<T> Function() body) {
    final prior = _receipts[requestId.value];
    if (prior != null) return prior as RepoResult<T>;
    final outcome = body();
    if (outcome is Ok<T>) {
      _receipts[requestId.value] = outcome;
      revision++;
    }
    return outcome;
  }

  /// Shorthand for an `invalidInput` error naming [field].
  static Err<T> invalid<T>(String field) => Err<T>(RepoError(RepoErrorKind.invalidInput, field: field));

  /// Shorthand for an error of [kind].
  static Err<T> fail<T>(RepoErrorKind kind) => Err<T>(RepoError(kind));
}
