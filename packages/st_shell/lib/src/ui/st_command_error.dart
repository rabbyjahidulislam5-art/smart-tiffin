import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';

import '../state/app_controller.dart';
import 'st_error_text.dart';

/// Inline error after a failed command: names the command and the reason,
/// never shows exception text (requirements 6.5, 11.4, 14.8).
class StCommandError extends ConsumerWidget {
  const StCommandError({super.key, required this.name, required this.kind});

  final StText name;
  final RepoErrorKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    return Semantics(
      liveRegion: true,
      child: StNote(
        tone: StNoteTone.warning,
        child: Text('${s.tx(StErrorText.commandFailed, [s.tx(name)])} ${s.tx(StErrorText.message(kind))}'),
      ),
    );
  }
}
