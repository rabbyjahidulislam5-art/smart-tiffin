import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// NF-05 supplier payables.
final supplierPayablesProvider = FutureProvider.autoDispose<List<PayableRow>>(
  (ref) => stUnwrap(
    ref
        .watch(settlementLedgerRepositoryProvider)
        .supplierPayables(ref.watch(actorProvider)),
  ),
);

/// NF-06 rider payables.
final riderPayablesProvider = FutureProvider.autoDispose<List<PayableRow>>(
  (ref) => stUnwrap(
    ref
        .watch(settlementLedgerRepositoryProvider)
        .riderPayables(ref.watch(actorProvider)),
  ),
);
