import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/credit_and_refunds_text.dart';

/// NF-09 credit movements.
final creditLiabilityProvider =
    FutureProvider.autoDispose<List<CreditLiabilityRow>>(
      (ref) => stUnwrap(
        ref
            .watch(creditAndRefundRepositoryProvider)
            .liability(ref.watch(actorProvider)),
      ),
    );

/// NF-10 refund and chargeback cases.
final refundOpsCasesProvider = FutureProvider.autoDispose<List<RefundOpsCase>>(
  (ref) => stUnwrap(
    ref
        .watch(creditAndRefundRepositoryProvider)
        .cases(ref.watch(actorProvider)),
  ),
);

/// NF-16 adjustments.
final adjustmentsProvider = FutureProvider.autoDispose<List<Adjustment>>(
  (ref) => stUnwrap(
    ref
        .watch(adjustmentRepositoryProvider)
        .adjustments(ref.watch(actorProvider)),
  ),
);

/// NF-16 request form values.
typedef AdjustmentValues = ({
  String description,
  String amount,
  bool reduces,
  String evidence,
});

/// NF-16 request form (`requestAdjustment`).
final adjustmentFormProvider =
    StateNotifierProvider.autoDispose<
      StFormController<AdjustmentValues>,
      StFormState<AdjustmentValues>
    >((ref) {
      final repo = ref.watch(adjustmentRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<AdjustmentValues>(
        initial: (description: '', amount: '', reduces: false, evidence: ''),
        validate: (v) => {
          if (v.description.trim().length < 10)
            'description': CreditAndRefundsText.adjDescShort,
          ...StAmountText.errors(v.amount),
          if (v.evidence.trim().length < 4)
            'evidence': CreditAndRefundsText.adjEvidenceShort,
        },
        command: (v, id) {
          final minor = parseAmountMinor(v.amount).minor ?? 0;
          return repo.requestAdjustment(
            actor,
            id,
            description: v.description.trim(),
            amountMinor: v.reduces ? -minor : minor,
            evidenceRef: v.evidence.trim(),
          );
        },
      );
    });
