/// One repository check. The same list runs under `dart test` (one `test`
/// per check) and in the offline mirror `tool/check.dart`.
typedef RepoCheck = ({String name, Future<bool> Function() run});
