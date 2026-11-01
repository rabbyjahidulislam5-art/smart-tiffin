import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/menu_pricing_text.dart';

/// NS-06 price versions of the kitchen's meals.
final priceVersionsProvider = FutureProvider.autoDispose<List<PriceVersion>>(
  (ref) => stUnwrap(
    ref
        .watch(kitchenOperationsRepositoryProvider)
        .priceVersions(ref.watch(actorProvider)),
  ),
);

/// NS-06 schedule-change form values.
typedef PriceChangeValues = ({
  String mealId,
  String amount,
  String effectiveFrom,
  String reason,
});

/// NS-06 schedule-change form (`schedulePriceChange`).
final priceChangeFormProvider =
    StateNotifierProvider.autoDispose<
      StFormController<PriceChangeValues>,
      StFormState<PriceChangeValues>
    >((ref) {
      final repo = ref.watch(kitchenOperationsRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<PriceChangeValues>(
        initial: (mealId: '', amount: '', effectiveFrom: '', reason: ''),
        validate: (v) {
          final date = latinDigits(v.effectiveFrom).trim();
          final okDate =
              RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) &&
              DateTime.tryParse(date) != null &&
              date.compareTo(ref.read(todayProvider)) > 0;
          return {
            if (v.mealId.isEmpty) 'meal': MenuPricingText.chooseMeal,
            ...StAmountText.errors(v.amount),
            if (!okDate) 'effectiveFrom': MenuPricingText.futureDate,
            if (v.reason.trim().length < 5)
              'reason': MenuPricingText.reasonShort,
          };
        },
        command: (v, id) => repo.schedulePriceChange(
          actor,
          id,
          mealId: v.mealId,
          amountMinor: parseAmountMinor(v.amount).minor ?? 0,
          effectiveFrom: latinDigits(v.effectiveFrom).trim(),
          reason: v.reason,
        ),
      );
    });
