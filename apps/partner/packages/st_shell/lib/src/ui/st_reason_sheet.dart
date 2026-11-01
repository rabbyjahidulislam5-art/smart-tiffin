import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';

import '../state/app_controller.dart';
import 'st_command_button.dart';
import 'st_command_scope.dart';

/// Sheet for a command that needs a written reason (reject, hold, void,
/// reverse, request information). Validates the length before any call.
class StReasonSheet extends ConsumerStatefulWidget {
  const StReasonSheet({
    super.key,
    required this.title,
    required this.commandName,
    required this.success,
    required this.confirmLabel,
    required this.onSubmit,
    this.body,
    this.minLength = 5,
    this.danger = false,
    this.onDone,
    this.fieldLabel = reasonLabel,
  });

  final StText title;
  final StText? body;
  final StText commandName;
  final StText success;
  final StText confirmLabel;
  final Future<RepoResult<Object?>> Function(String reason) onSubmit;
  final int minLength;
  final bool danger;
  final VoidCallback? onDone;

  /// Label of the text field (defaults to "Reason"; for example "Evidence reference").
  final StText fieldLabel;

  static const reasonLabel = StText('Reason', 'কারণ');
  static const tooShort =
      StText('Write at least {0} characters.', 'অন্তত {0}টি অক্ষর লিখুন।');

  @override
  ConsumerState<StReasonSheet> createState() => _StReasonSheetState();
}

class _StReasonSheetState extends ConsumerState<StReasonSheet> {
  final _reason = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    return StCommandScope(
      onConfirmationEnd: ctrl.closeSheet,
      builder: (context, cmd) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(s.tx(widget.title),
              style: const TextStyle(
                  fontSize: StFont.heading, fontWeight: FontWeight.w800)),
          if (widget.body != null) ...[
            const SizedBox(height: StSpace.xs),
            Text(s.tx(widget.body!),
                style: TextStyle(color: Theme.of(context).hintColor)),
          ],
          const SizedBox(height: StSpace.sm),
          StField(
              label: s.tx(widget.fieldLabel),
              controller: _reason,
              error: _error,
              maxLines: 3),
          const SizedBox(height: StSpace.sm),
          StCommandButton(
            label: s.tx(widget.confirmLabel),
            busy: cmd.busy,
            variant: widget.danger ? StBtnVariant.danger : StBtnVariant.primary,
            onTap: () {
              final text = _reason.text.trim();
              if (text.length < widget.minLength) {
                setState(() => _error =
                    s.tx(StReasonSheet.tooShort, ['${widget.minLength}']));
                return;
              }
              setState(() => _error = null);
              cmd.run(() => widget.onSubmit(text),
                  name: widget.commandName,
                  success: widget.success,
                  onSuccess: widget.onDone);
            },
          ),
        ],
      ),
    );
  }
}
