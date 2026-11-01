import 'package:st_customer_app/navigation/customer_app_config.dart';
import 'package:st_test_kit/st_test_kit.dart';

// NC family matrix (task 20.13): NC-01 at 360, 720, 1024 and 1440 in en and
// bn, light and dark (16 combinations). Written; not run in this session.
void main() {
  stMatrixTest(
    'NC family',
    config: customerAppConfig,
    id: 'NC-01',
    sessions: const [],
  );
}
