import 'st_role.dart';

/// Who calls a repository. `id == null` is a guest (no signed-in session).
class Actor {
  const Actor(this.role, {this.id});

  final StRole role;
  final String? id;

  bool get isGuest => id == null;

  @override
  bool operator ==(Object other) => other is Actor && other.role == role && other.id == id;

  @override
  int get hashCode => Object.hash(role, id);

  @override
  String toString() => 'Actor(${role.name}, ${id ?? 'guest'})';
}
