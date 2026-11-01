import 'package:st_domain/st_domain.dart';

enum StFormStatus { idle, submitting, succeeded, failed }

/// State of one form (design "Form and command pattern").
class StFormState<V> {
  const StFormState({
    required this.values,
    required this.requestId,
    this.fieldErrors = const {},
    this.status = StFormStatus.idle,
    this.errorKind,
    this.errorField,
    this.confirmedAt,
  });

  final V values;
  final Map<String, StText> fieldErrors;
  final StFormStatus status;
  final RepoErrorKind? errorKind;
  final String? errorField;
  final DateTime? confirmedAt;

  /// Identity of the current intent; reused by retries, renewed after success.
  final RequestId requestId;

  bool get submitting => status == StFormStatus.submitting;
  bool get failed => status == StFormStatus.failed;
  bool get confirmed => confirmedAt != null;

  StText? errorFor(String field) => fieldErrors[field];

  StFormState<V> copyWith({
    V? values,
    Map<String, StText>? fieldErrors,
    StFormStatus? status,
    RepoErrorKind? errorKind,
    String? errorField,
    bool clearError = false,
    DateTime? confirmedAt,
    bool clearConfirmation = false,
    RequestId? requestId,
  }) {
    return StFormState<V>(
      values: values ?? this.values,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      status: status ?? this.status,
      errorKind: clearError ? null : (errorKind ?? this.errorKind),
      errorField: clearError ? null : (errorField ?? this.errorField),
      confirmedAt: clearConfirmation ? null : (confirmedAt ?? this.confirmedAt),
      requestId: requestId ?? this.requestId,
    );
  }
}
