import 'repo_error.dart';

// The sealed type and its two cases must share one library (Dart rule for
// sealed class hierarchies).

/// Outcome of a repository call.
sealed class RepoResult<T> {
  const RepoResult();

  bool get isOk => this is Ok<T>;

  /// The value of an [Ok], or null.
  T? get valueOrNull => switch (this) {
        Ok<T>(:final value) => value,
        Err<T>() => null,
      };

  /// The error of an [Err], or null.
  RepoError? get errorOrNull => switch (this) {
        Ok<T>() => null,
        Err<T>(:final error) => error,
      };

  /// Maps the value of an [Ok]; an [Err] passes through unchanged.
  RepoResult<R> map<R>(R Function(T value) f) => switch (this) {
        Ok<T>(:final value) => Ok<R>(f(value)),
        Err<T>(:final error) => Err<R>(error),
      };
}

class Ok<T> extends RepoResult<T> {
  const Ok(this.value);

  final T value;

  @override
  bool operator ==(Object other) => other is Ok<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Ok($value)';
}

class Err<T> extends RepoResult<T> {
  const Err(this.error);

  final RepoError error;

  @override
  bool operator ==(Object other) => other is Err<T> && other.error == error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Err($error)';
}
