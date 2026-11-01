import 'package:flutter/widgets.dart';
import 'package:st_domain/st_domain.dart';

/// One entry control the registry adds to a Built host screen (LC-11). The
/// host file itself is not edited; `StScreen` renders the entries below the
/// host's content.
class StHostEntry {
  const StHostEntry({
    required this.id,
    required this.label,
    this.sub,
    this.icon,
    this.params = const {},
    this.forward = const [],
    this.rename = const {},
  });

  final String id;
  final StText label;
  final StText? sub;
  final IconData? icon;
  final Map<String, String> params;

  /// Keys of the host's route parameters passed on to the target. [params]
  /// are defaults that a forwarded host parameter replaces.
  final List<String> forward;

  /// Host route parameters passed on under another key (host key to target
  /// key), for example the meal `id` of C-05 as the `meal` of NC-02.
  final Map<String, String> rename;
}
