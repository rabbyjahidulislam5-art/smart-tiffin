import 'package:st_domain/st_domain.dart';

/// Turns a repository result into a value for `FutureProvider`/`AsyncValue`:
/// an `Err` becomes an error whose object is the [RepoError] itself (no
/// exception text), which `StAsyncView` maps to a localized panel.
Future<T> stUnwrap<T>(Future<RepoResult<T>> result) async {
  final r = await result;
  return switch (r) {
    Ok<T>(:final value) => value,
    Err<T>(:final error) => throw error,
  };
}
