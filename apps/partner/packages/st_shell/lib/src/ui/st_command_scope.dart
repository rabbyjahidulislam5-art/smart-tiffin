import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';

import '../state/app_controller.dart';
import 'st_command_error.dart';

/// Runs repository commands for one screen area (design "Form and command
/// pattern"): at most one call at a time, an inline error that names the
/// failed command, and a confirmation that stays for
/// `StTiming.confirmationHold` or until dismissed (requirement 14.5).
class StCommandScope extends ConsumerStatefulWidget {
  const StCommandScope({super.key, required this.builder, this.onConfirmationEnd});

  final Widget Function(BuildContext context, StCommandScopeState cmd) builder;

  /// Called when the confirmation banner ends (for example to close a sheet).
  final VoidCallback? onConfirmationEnd;

  @override
  ConsumerState<StCommandScope> createState() => StCommandScopeState();
}

class StCommandScopeState extends ConsumerState<StCommandScope> {
  bool _busy = false;
  StText? _confirmed;
  StText? _failedName;
  RepoErrorKind? _failedKind;

  /// Number of commands started (used by tests).
  int calls = 0;

  bool get busy => _busy;

  /// Runs [command] once. Ignored while another command runs or offline.
  Future<bool> run(
    Future<RepoResult<Object?>> Function() command, {
    required StText name,
    required StText success,
    VoidCallback? onSuccess,
  }) async {
    if (_busy) return false;
    if (ref.read(appProvider).offline) {
      setState(() {
        _failedName = name;
        _failedKind = RepoErrorKind.temporarilyUnavailable;
      });
      return false;
    }
    setState(() {
      _busy = true;
      _failedName = null;
      _failedKind = null;
      _confirmed = null;
    });
    calls++;
    final result = await command();
    if (!mounted) return result.isOk;
    switch (result) {
      case Ok():
        setState(() {
          _busy = false;
          _confirmed = success;
        });
        onSuccess?.call();
        return true;
      case Err(:final error):
        setState(() {
          _busy = false;
          _failedName = name;
          _failedKind = error.kind;
        });
        return false;
    }
  }

  void _endConfirmation() {
    if (mounted) setState(() => _confirmed = null);
    widget.onConfirmationEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final confirmed = _confirmed;
    final failedName = _failedName;
    final failedKind = _failedKind;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (confirmed != null) ...[
          StConfirmation(
            key: ValueKey('confirmation-$calls'),
            message: s.tx(confirmed),
            dismissLabel: s.t('Dismiss', 'বন্ধ করুন'),
            onDismissed: _endConfirmation,
          ),
          const SizedBox(height: StSpace.sm),
        ],
        if (failedName != null && failedKind != null) ...[
          StCommandError(name: failedName, kind: failedKind),
          const SizedBox(height: StSpace.sm),
        ],
        widget.builder(context, this),
      ],
    );
  }
}
