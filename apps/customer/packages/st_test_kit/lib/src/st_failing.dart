import 'package:st_domain/st_domain.dart';

/// Instant mocks whose every call fails with [kind].
MockBehavior stFailing(RepoErrorKind kind) =>
    MockBehavior.instant()..failAlways(kind);

/// Instant mocks whose next call fails with [kind].
MockBehavior stFailingOnce(RepoErrorKind kind) =>
    MockBehavior.instant()..failNext(kind);

/// Mocks that answer after [millis] milliseconds (to observe loading).
MockBehavior stSlow(int millis) =>
    MockBehavior(latency: Duration(milliseconds: millis));
