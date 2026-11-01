import 'package:st_domain/st_domain.dart';

import '../state/app_state.dart';

enum StScreenForm { fullScreen, section, sheet }

/// Manifest entry of one New_Screen (design "Screen manifest").
class StScreenSpec {
  const StScreenSpec({
    required this.id,
    required this.form,
    required this.states,
    required this.anchor,
    required this.source,
    this.connectedControls = const {},
    this.hosts = const [],
    this.guestReadable = false,
    this.signedInControls = const {},
    this.links = const [],
  });

  final String id;
  final StScreenForm form;

  /// States the specification lists (normal is implied).
  final Set<StVariant> states;
  final Set<String> connectedControls;
  final List<String> hosts;
  final bool guestReadable;
  final Set<String> signedInControls;

  /// A visible title the widget test looks for.
  final StText anchor;
  final List<String> links;
  final String source;
}
