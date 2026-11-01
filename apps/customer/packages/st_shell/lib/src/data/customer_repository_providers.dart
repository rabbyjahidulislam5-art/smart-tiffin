import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

import '../state/mock_behavior_provider.dart';

/// NC-01, NC-02, NC-03 (guest allowed).
final kitchenRepositoryProvider = Provider<KitchenRepository>(
  (ref) => MockKitchenRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NC-01, NC-02, NC-18.
final favouriteRepositoryProvider = Provider<FavouriteRepository>(
  (ref) => MockFavouriteRepository(behavior: ref.watch(mockBehaviorProvider)),
);

final mockCreditRepositoryProvider = Provider<MockCreditRepository>(
  (ref) => MockCreditRepository(behavior: ref.watch(mockBehaviorProvider)),
);

final mockSubscriptionRepositoryProvider = Provider<MockSubscriptionRepository>(
  (ref) => MockSubscriptionRepository(behavior: ref.watch(mockBehaviorProvider)),
);

final mockQuoteRepositoryProvider = Provider<MockQuoteRepository>(
  (ref) => MockQuoteRepository(
    behavior: ref.watch(mockBehaviorProvider),
    credits: ref.watch(mockCreditRepositoryProvider),
    subscriptions: ref.watch(mockSubscriptionRepositoryProvider),
  ),
);

/// NC-04, NC-05, NC-15, NC-19.
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) => ref.watch(mockSubscriptionRepositoryProvider));

/// NC-04, NC-07, NC-08, NC-10, NC-13, NC-14, NC-19.
final quoteRepositoryProvider = Provider<QuoteRepository>((ref) => ref.watch(mockQuoteRepositoryProvider));

/// NC-11, NC-16.
final creditRepositoryProvider = Provider<CreditRepository>((ref) => ref.watch(mockCreditRepositoryProvider));

/// NC-06, NC-09, NC-10. A skip issues a service credit in the credit mock.
final scheduleRepositoryProvider = Provider<ScheduleRepository>(
  (ref) => MockScheduleRepository(behavior: ref.watch(mockBehaviorProvider), credits: ref.watch(mockCreditRepositoryProvider)),
);

/// NC-12, NC-13.
final billingRepositoryProvider = Provider<BillingRepository>(
  (ref) => MockBillingRepository(behavior: ref.watch(mockBehaviorProvider)),
);

/// NC-14.
final checkoutRepositoryProvider = Provider<CheckoutRepository>(
  (ref) => MockCheckoutRepository(behavior: ref.watch(mockBehaviorProvider), quotes: ref.watch(mockQuoteRepositoryProvider)),
);

/// NC-17.
final refundRepositoryProvider = Provider<RefundRepository>(
  (ref) => MockRefundRepository(behavior: ref.watch(mockBehaviorProvider)),
);
