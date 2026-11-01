import '../../text/st_text.dart';
import 'incident_severity.dart';
import 'incident_status.dart';

/// One incident in the NA-01 queue.
class IncidentSummary {
  const IncidentSummary({
    required this.id,
    required this.title,
    required this.severity,
    required this.status,
    required this.ageMinutes,
  });

  final String id;
  final StText title;
  final IncidentSeverity severity;
  final IncidentStatus status;
  final int ageMinutes;
}
