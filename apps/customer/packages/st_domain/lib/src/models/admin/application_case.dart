import 'application_kind.dart';
import 'application_status.dart';

/// A supplier or rider application under review (NA-03).
class ApplicationCase {
  const ApplicationCase({
    required this.id,
    required this.kind,
    required this.name,
    required this.owner,
    required this.area,
    required this.submittedAgo,
    required this.status,
    required this.checklist,
    this.reason,
  });

  final String id;
  final ApplicationKind kind;
  final String name;
  final String owner;
  final String area;
  final String submittedAgo;
  final ApplicationStatus status;

  /// Review checks (`identity`, `premises`, `compliance`), persisted with the case.
  final Map<String, bool> checklist;
  final String? reason;

  bool get allChecked => checklist.values.every((v) => v);

  ApplicationCase copyWith({ApplicationStatus? status, Map<String, bool>? checklist, String? reason}) => ApplicationCase(
        id: id,
        kind: kind,
        name: name,
        owner: owner,
        area: area,
        submittedAgo: submittedAgo,
        status: status ?? this.status,
        checklist: checklist ?? this.checklist,
        reason: reason ?? this.reason,
      );
}
