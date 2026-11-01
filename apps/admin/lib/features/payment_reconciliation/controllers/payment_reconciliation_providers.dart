import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// NF-02 match table.
final reconMatchesProvider = FutureProvider.autoDispose<List<ReconItem>>(
  (ref) => stUnwrap(
    ref
        .watch(paymentReconciliationRepositoryProvider)
        .matches(ref.watch(actorProvider)),
  ),
);

/// NF-13 exception queue.
final reconExceptionsProvider =
    FutureProvider.autoDispose<List<ReconException>>(
      (ref) => stUnwrap(
        ref
            .watch(paymentReconciliationRepositoryProvider)
            .exceptions(ref.watch(actorProvider)),
      ),
    );

/// NF-13 selected exception ids (bulk assignment).
final selectedExceptionsProvider = StateProvider.autoDispose<Set<String>>(
  (ref) => const {},
);

/// NF-13 chosen assignee.
final exceptionAssigneeProvider = StateProvider.autoDispose<String>(
  (ref) => 'Rahim',
);

/// NF-02 and NF-17 gateway statements.
final gatewayStatementsProvider =
    FutureProvider.autoDispose<List<GatewayStatement>>(
      (ref) => stUnwrap(
        ref
            .watch(paymentReconciliationRepositoryProvider)
            .statements(ref.watch(actorProvider)),
      ),
    );

/// NF-17 selected statement id.
final selectedStatementProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);
