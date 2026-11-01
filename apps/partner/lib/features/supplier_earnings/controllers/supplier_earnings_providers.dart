import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/supplier_earnings_text.dart';

/// NS-01 status filter (null = all statuses).
final supplierEarningFilterProvider = StateProvider.autoDispose<EarningStatus?>(
  (ref) => null,
);

/// NS-01 statement rows for the current filter.
final supplierEarningsProvider =
    FutureProvider.autoDispose<List<SupplierEarning>>((ref) {
      final status = ref.watch(supplierEarningFilterProvider);
      return stUnwrap(
        ref
            .watch(earningsRepositoryProvider)
            .supplierEarnings(ref.watch(actorProvider), status: status),
      );
    });

/// NS-01 balance classes.
final supplierBalancesProvider = FutureProvider.autoDispose<EarningBalances>(
  (ref) => stUnwrap(
    ref
        .watch(earningsRepositoryProvider)
        .supplierBalances(ref.watch(actorProvider)),
  ),
);

/// NS-02 eligible balance and destination.
final supplierEligibleBalanceProvider =
    FutureProvider.autoDispose<EligibleBalance>(
      (ref) => stUnwrap(
        ref
            .watch(payoutRepositoryProvider)
            .eligibleBalance(ref.watch(actorProvider)),
      ),
    );

/// NS-03 payout requests, cursor paged.
final supplierPayoutHistoryProvider =
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

/// NS-02 form values: the typed amount and the destination confirmation.
typedef SupplierPayoutValues = ({String amount, bool confirmed});

/// NS-02 form: validates the amount against the eligible balance, then calls
/// `requestPayout` once per activation.
final supplierPayoutFormProvider =
    StateNotifierProvider.autoDispose<
      StFormController<SupplierPayoutValues>,
      StFormState<SupplierPayoutValues>
    >((ref) {
      final repo = ref.watch(payoutRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<SupplierPayoutValues>(
        initial: (amount: '', confirmed: false),
        validate: (v) => {
          ...StAmountText.errors(
            v.amount,
            maxMinor: ref
                .read(supplierEligibleBalanceProvider)
                .valueOrNull
                ?.eligibleMinor,
          ),
          if (!v.confirmed) 'confirmed': SupplierEarningsText.confirmNeeded,
        },
        command: (v, id) => repo.requestPayout(
          actor,
          id,
          amountMinor: parseAmountMinor(v.amount).minor ?? 0,
        ),
      );
    });
