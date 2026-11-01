import 'denied_reason.dart';

// The sealed type and its two cases must share one library (Dart rule for
// sealed class hierarchies).

/// Result of [decideAccess].
sealed class AccessDecision {
  const AccessDecision();
}

class Allowed extends AccessDecision {
  const Allowed();

  @override
  bool operator ==(Object other) => other is Allowed;

  @override
  int get hashCode => 1;

  @override
  String toString() => 'Allowed';
}

class Denied extends AccessDecision {
  const Denied(this.reason);

  final DeniedReason reason;

  @override
  bool operator ==(Object other) => other is Denied && other.reason == reason;

  @override
  int get hashCode => reason.hashCode;

  @override
  String toString() => 'Denied(${reason.name})';
}
