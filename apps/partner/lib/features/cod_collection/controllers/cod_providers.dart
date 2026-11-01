import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/cod_text.dart';

/// NR-03 and NR-04 COD collections of the rider.
final codCollectionsProvider = FutureProvider.autoDispose<List<CodCollection>>(
  (ref) => stUnwrap(
    ref.watch(codRepositoryProvider).collections(ref.watch(actorProvider)),
  ),
);

/// Cash collected and not yet remitted (NR-01, NR-02, NR-04).
final codLiabilityProvider = FutureProvider.autoDispose<int>(
  (ref) => stUnwrap(
    ref.watch(codRepositoryProvider).liability(ref.watch(actorProvider)),
  ),
);

/// NR-04 deposits.
final codRemittancesProvider = FutureProvider.autoDispose<List<CodRemittance>>(
  (ref) => stUnwrap(
    ref.watch(codRepositoryProvider).remittances(ref.watch(actorProvider)),
  ),
);

/// NR-05 mismatch cases.
final codDiscrepanciesProvider =
    FutureProvider.autoDispose<List<CodDiscrepancy>>(
      (ref) => stUnwrap(
        ref
            .watch(codRepositoryProvider)
            .discrepancies(ref.watch(actorProvider)),
      ),
    );

/// NR-03 form values.
typedef CodCollectionValues = ({
  String collectionId,
  String amount,
  bool acknowledged,
});

/// NR-03 form (`recordCodCollection`).
final codCollectionFormProvider =
    StateNotifierProvider.autoDispose<
      StFormController<CodCollectionValues>,
      StFormState<CodCollectionValues>
    >((ref) {
      final repo = ref.watch(codRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<CodCollectionValues>(
        initial: (collectionId: '', amount: '', acknowledged: false),
        validate: (v) => {
          if (v.collectionId.isEmpty) 'collection': CodText.chooseOrder,
          ...StAmountText.errors(v.amount),
          if (!v.acknowledged) 'acknowledged': CodText.ackNeeded,
        },
        command: (v, id) => repo.recordCodCollection(
          actor,
          id,
          collectionId: v.collectionId,
          amountMinor: parseAmountMinor(v.amount).minor ?? 0,
        ),
      );
    });

/// NR-04 form values.
typedef CodRemittanceValues = ({
  String amount,
  String method,
  String reference,
});

/// NR-04 form (`submitCodRemittance`): not above the cash to remit.
final codRemittanceFormProvider =
    StateNotifierProvider.autoDispose<
      StFormController<CodRemittanceValues>,
      StFormState<CodRemittanceValues>
    >((ref) {
      final repo = ref.watch(codRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<CodRemittanceValues>(
        initial: (amount: '', method: 'Bank deposit', reference: ''),
        validate: (v) => {
          ...StAmountText.errors(
            v.amount,
            maxMinor: ref.read(codLiabilityProvider).valueOrNull,
          ),
          if (v.reference.trim().length < 4)
            'reference': CodText.referenceShort,
        },
        command: (v, id) => repo.submitCodRemittance(
          actor,
          id,
          amountMinor: parseAmountMinor(v.amount).minor ?? 0,
          reference: v.reference.trim(),
          method: v.method,
        ),
      );
    });

/// NR-05 response form of one mismatch case (`respondToDiscrepancy`).
final codDiscrepancyFormProvider = StateNotifierProvider.autoDispose
    .family<StFormController<String>, StFormState<String>, String>((
      ref,
      discrepancyId,
    ) {
      final repo = ref.watch(codRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<String>(
        initial: '',
        validate: (v) => v.trim().length < 10
            ? {'response': CodText.responseShort}
            : const {},
        command: (v, id) => repo.respondToDiscrepancy(
          actor,
          id,
          discrepancyId: discrepancyId,
          response: v.trim(),
        ),
      );
    });
