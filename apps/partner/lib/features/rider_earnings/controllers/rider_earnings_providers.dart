import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/rider_earnings_text.dart';

/// NR-01 status filter (null = all).
final riderEarningFilterProvider =
    StateProvider.autoDispose<RiderEarningStatus?>((ref) => null);

/// NR-01 per-delivery earnings for the filter.
final riderEarningsProvider = FutureProvider.autoDispose<List<RiderEarning>>((
  ref,
) {
  final status = ref.watch(riderEarningFilterProvider);
  return stUnwrap(
    ref
        .watch(earningsRepositoryProvider)
        .riderEarnings(ref.watch(actorProvider), status: status),
  );
});

/// NR-01 balance classes.
final riderBalancesProvider = FutureProvider.autoDispose<EarningBalances>(
  (ref) => stUnwrap(
    ref
        .watch(earningsRepositoryProvider)
        .riderBalances(ref.watch(actorProvider)),
  ),
);

/// NR-02 eligible balance and destination.
final riderEligibleBalanceProvider =
    FutureProvider.autoDispose<EligibleBalance>(
      (ref) => stUnwrap(
        ref
            .watch(payoutRepositoryProvider)
            .eligibleBalance(ref.watch(actorProvider)),
      ),
    );

/// NR-02 recent payout requests (cursor paged).
final riderPayoutHistoryProvider =
    StateNotifierProvider.autoDispose<
      StPagedController<PayoutRecord>,
      AsyncValue<StPagedList<PayoutRecord>>
    >((ref) {
      final repo = ref.watch(payoutRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StPagedController<PayoutRecord>(
        (cursor) => repo.history(actor, cursor: cursor),
      );
    });

/// NR-02 form values.
typedef RiderPayoutValues = ({String amount, bool confirmed});

/// NR-02 form: amount up to the eligible balance, then `requestPayout` once.
final riderPayoutFormProvider =
    StateNotifierProvider.autoDispose<
      StFormController<RiderPayoutValues>,
      StFormState<RiderPayoutValues>
    >((ref) {
      final repo = ref.watch(payoutRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<RiderPayoutValues>(
        initial: (amount: '', confirmed: false),
        validate: (v) => {
          ...StAmountText.errors(
            v.amount,
            maxMinor: ref
                .read(riderEligibleBalanceProvider)
                .valueOrNull
                ?.eligibleMinor,
          ),
          if (!v.confirmed) 'confirmed': RiderEarningsText.confirmNeeded,
        },
        command: (v, id) => repo.requestPayout(
          actor,
          id,
          amountMinor: parseAmountMinor(v.amount).minor ?? 0,
        ),
      );
    });
