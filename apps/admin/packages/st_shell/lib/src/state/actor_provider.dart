import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

import 'app_controller.dart';

/// The caller passed to repositories: the active role, signed in or guest.
/// Recomputed only when the role or its session changes.
final actorProvider = Provider<Actor>((ref) {
  final key = ref.watch(appProvider.select((s) => (s.role, s.activeRole != null)));
  final (role, signedIn) = key;
  return Actor(role, id: signedIn ? 'demo-${role.name}' : null);
});
