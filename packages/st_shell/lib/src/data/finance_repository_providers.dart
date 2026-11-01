import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

import '../state/mock_behavior_provider.dart';

/// NF-02, NF-13, NF-17.
final paymentReconciliationRepositoryProvider = Provider<PaymentReconciliationRepository>(
  (ref) => MockPaymentReconciliationRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NF-03, NF-04.
final codVerificationRepositoryProvider = Provider<CodVerificationRepository>(
  (ref) => MockCodVerificationRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NF-05, NF-06.
final settlementLedgerRepositoryProvider = Provider<SettlementLedgerRepository>(
  (ref) => MockSettlementLedgerRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NF-07, NF-08.
final payoutOperationsRepositoryProvider = Provider<PayoutOperationsRepository>(
  (ref) => MockPayoutOperationsRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NF-09, NF-10.
final creditAndRefundRepositoryProvider = Provider<CreditAndRefundRepository>(
  (ref) => MockCreditAndRefundRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NF-11, NF-12.
final ledgerRepositoryProvider = Provider<LedgerRepository>(
  (ref) => MockLedgerRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NF-15.
final staffRoleRepositoryProvider = Provider<StaffRoleRepository>(
  (ref) => MockStaffRoleRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NF-16.
final adjustmentRepositoryProvider = Provider<AdjustmentRepository>(
  (ref) => MockAdjustmentRepository(behavior: ref.watch(mockBehaviorProvider)),
);
