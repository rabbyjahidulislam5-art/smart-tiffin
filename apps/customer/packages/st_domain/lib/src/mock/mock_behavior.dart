import '../result/repo_error.dart';

/// Latency and failure injection shared by every mock repository.
///
/// Default latency is 120 ms in the apps and `Duration.zero` in tests
/// ([MockBehavior.instant]); it is capped at [maxLatency] (requirement 3.2).
class MockBehavior {
  MockBehavior({Duration latency = defaultLatency})
      : _latency = latency > maxLatency ? maxLatency : latency;

  /// No latency: for tests.
  factory MockBehavior.instant() => MockBehavior(latency: Duration.zero);

  static const Duration defaultLatency = Duration(milliseconds: 120);
  static const Duration maxLatency = Duration(milliseconds: 500);

  Duration _latency;
  RepoErrorKind? _next;
  RepoErrorKind? _always;

  Duration get latency => _latency;

  set latency(Duration value) => _latency = value > maxLatency ? maxLatency : value;

  /// The next call (one call only) fails with [kind].
  void failNext(RepoErrorKind kind) => _next = kind;

  /// Every call fails with [kind] until [clear].
  void failAlways(RepoErrorKind kind) => _always = kind;

  void clear() {
    _next = null;
    _always = null;
  }

  /// Returns the injected failure for one call, consuming a `failNext`.
  RepoErrorKind? takeFailure() {
    final always = _always;
    if (always != null) return always;
    final next = _next;
    _next = null;
    return next;
  }
}
