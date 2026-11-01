import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

import '../state/mock_behavior_provider.dart';

/// NA-01.
final opsOverviewRepositoryProvider = Provider<OpsOverviewRepository>(
  (ref) => MockOpsOverviewRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NA-02.
final policyRepositoryProvider = Provider<PolicyRepository>(
  (ref) => MockPolicyRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NA-03.
final applicationReviewRepositoryProvider = Provider<ApplicationReviewRepository>(
  (ref) => MockApplicationReviewRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NA-04.
final dispatchRepositoryProvider = Provider<DispatchRepository>(
  (ref) => MockDispatchRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NA-05 (limited) and NF-01 (full).
final financeKpiRepositoryProvider = Provider<FinanceKpiRepository>(
  (ref) => MockFinanceKpiRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NA-06 (operational scope) and NF-14 (financial scope).
final reportRepositoryProvider = Provider<ReportRepository>(
  (ref) => MockReportRepository(behavior: ref.watch(mockBehaviorProvider)),
);
