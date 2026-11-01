import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

import '../state/mock_behavior_provider.dart';

// One mock instance per ProviderScope, so every screen of an app reads the
// same in-memory fixture store (design "Repository catalogue").

final mockPayoutRepositoryProvider = Provider<MockPayoutRepository>(
  (ref) => MockPayoutRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NS-02, NS-03, NR-02.
final payoutRepositoryProvider = Provider<PayoutRepository>((ref) => ref.watch(mockPayoutRepositoryProvider));

/// NS-01, NR-01. Reads the payout mock so the balances always agree.
final earningsRepositoryProvider = Provider<EarningsRepository>(
  (ref) => MockEarningsRepository(behavior: ref.watch(mockBehaviorProvider), payouts: ref.watch(mockPayoutRepositoryProvider)),
);

/// NS-04..NS-07.
final kitchenOperationsRepositoryProvider = Provider<KitchenOperationsRepository>(
  (ref) => MockKitchenOperationsRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NR-03, NR-04, NR-05.
final codRepositoryProvider = Provider<CodRepository>(
  (ref) => MockCodRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NR-06.
final deliveryDisputeRepositoryProvider = Provider<DeliveryDisputeRepository>(
  (ref) => MockDeliveryDisputeRepository(behavior: ref.watch(mockBehaviorProvider)),
);
