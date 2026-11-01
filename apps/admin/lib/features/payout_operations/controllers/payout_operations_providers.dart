import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// NF-07 and NF-08 payout request cases.
final payoutCasesProvider = FutureProvider.autoDispose<List<PayoutRequestCase>>(
  (ref) => stUnwrap(
    ref
        .watch(payoutOperationsRepositoryProvider)
        .requests(ref.watch(actorProvider)),
  ),
);

/// NF-08 batches.
final payoutBatchesProvider = FutureProvider.autoDispose<List<PayoutBatch>>(
  (ref) => stUnwrap(
    ref
        .watch(payoutOperationsRepositoryProvider)
        .batches(ref.watch(actorProvider)),
  ),
);

/// NF-08 approved requests selected for a new batch.
final batchSelectionProvider = StateProvider.autoDispose<Set<String>>(
  (ref) => const {},
);
