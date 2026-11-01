import '../../text/st_text.dart';
import 'report_scope.dart';

class ReportDefinition {
  const ReportDefinition({required this.id, required this.scope, required this.title, required this.description});

  final String id;
  final ReportScope scope;
  final StText title;
  final StText description;
}
