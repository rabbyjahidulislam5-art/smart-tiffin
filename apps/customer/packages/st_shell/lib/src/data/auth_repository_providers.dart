import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

import '../state/mock_behavior_provider.dart';

/// AU-13 credential check (LC-9, D-03 option A).
final staffAuthRepositoryProvider = Provider<StaffAuthRepository>(
  (ref) => MockStaffAuthRepository(behavior: ref.watch(mockBehaviorProvider)),
);
