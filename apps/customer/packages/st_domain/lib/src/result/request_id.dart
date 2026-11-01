/// Identity of one user intent. Created when the intent starts and reused by
/// every retry, so a repeated command returns the first outcome.
class RequestId {
  const RequestId(this.value);

  static int _counter = 0;

  /// A new id for a new intent (in-memory counter; mock phase only).
  factory RequestId.next([String prefix = 'req']) => RequestId('$prefix-${++_counter}');

  final String value;

  @override
  bool operator ==(Object other) => other is RequestId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
