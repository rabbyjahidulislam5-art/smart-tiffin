import 'package:st_domain/st_domain.dart';

/// The last refused navigation (LC-2). Cleared by `clearDenied`, `back`, or
/// a successful `go`/`reset`.
class DeniedRequest {
  const DeniedRequest(this.id, this.reason);

  final String id;
  final DeniedReason reason;

  @override
  bool operator ==(Object other) => other is DeniedRequest && other.id == id && other.reason == reason;

  @override
  int get hashCode => Object.hash(id, reason);

  @override
  String toString() => 'DeniedRequest($id, ${reason.name})';
}
