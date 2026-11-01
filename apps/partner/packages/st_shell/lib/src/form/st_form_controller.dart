import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

import 'st_form_state.dart';

/// Validates synchronously, then calls one repository command (design "Form
/// and command pattern", Property 26).
///
/// - A validation error sets `fieldErrors` and makes no repository call.
/// - `submit()` is ignored while submitting, so one activation produces at
///   most one call; the request id makes a retry idempotent.
/// - Values are never cleared; a failure records the error kind and leaves
///   the submit control enabled again.
class StFormController<V> extends StateNotifier<StFormState<V>> {
  StFormController({
    required V initial,
    required this.validate,
    required this.command,
  }) : super(StFormState<V>(values: initial, requestId: RequestId.next('form')));

  final Map<String, StText> Function(V values) validate;
  final Future<RepoResult<Object?>> Function(V values, RequestId requestId) command;

  /// Number of repository calls made (for tests).
  int commandCalls = 0;

  static const checkValue = StText('Check this value.', 'এই মানটি দেখুন।');

  void update(V Function(V values) change) {
    final next = change(state.values);
    final errors = state.fieldErrors.isEmpty ? state.fieldErrors : validate(next);
    state = state.copyWith(values: next, fieldErrors: errors, status: state.failed ? StFormStatus.idle : null);
  }

  void set(V values) => update((_) => values);

  Future<bool> submit() async {
    if (state.submitting) return false;
    final errors = validate(state.values);
    if (errors.isNotEmpty) {
      state = state.copyWith(fieldErrors: errors, status: StFormStatus.idle, clearConfirmation: true);
      return false;
    }
    state = state.copyWith(fieldErrors: const {}, status: StFormStatus.submitting, clearError: true, clearConfirmation: true);
    commandCalls++;
    final result = await command(state.values, state.requestId);
    if (!mounted) return false;
    switch (result) {
      case Ok():
        state = state.copyWith(status: StFormStatus.succeeded, confirmedAt: DateTime.now(), requestId: RequestId.next('form'));
        return true;
      case Err(:final error):
        final field = error.field;
        state = state.copyWith(
          status: StFormStatus.failed,
          errorKind: error.kind,
          errorField: field,
          fieldErrors: error.kind == RepoErrorKind.invalidInput && field != null ? {field: checkValue} : const {},
        );
        return false;
    }
  }

  void dismissConfirmation() => state = state.copyWith(clearConfirmation: true, status: StFormStatus.idle);
}
