/// Thrown by a registry's default arm for an id it does not register. The
/// access guard denies unknown ids first, so the UI never reaches it; direct
/// misuse (a test or a future deep link) fails loudly (requirement 19.1).
class StUnknownScreenId implements Exception {
  const StUnknownScreenId(this.id);

  final String id;

  @override
  String toString() => 'StUnknownScreenId($id)';
}
