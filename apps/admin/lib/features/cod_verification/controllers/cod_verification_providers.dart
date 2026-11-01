import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// NF-03 custody rows, overdue first.
final codCustodyProvider = FutureProvider.autoDispose<List<CodCustodyRow>>((
  ref,
) async {
  final rows = await stUnwrap(
    ref
        .watch(codVerificationRepositoryProvider)
        .custody(ref.watch(actorProvider)),
  );
  return [...rows]..sort(
    (a, b) => a.overdue == b.overdue
        ? a.date.compareTo(b.date)
        : (a.overdue ? -1 : 1),
  );
});

/// NF-04 remittance cases.
final codRemittanceCasesProvider =
    FutureProvider.autoDispose<List<CodRemittanceCase>>(
      (ref) => stUnwrap(
        ref
            .watch(codVerificationRepositoryProvider)
            .remittances(ref.watch(actorProvider)),
      ),
    );
