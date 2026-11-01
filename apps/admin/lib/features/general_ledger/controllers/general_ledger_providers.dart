import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// NF-11 account filter (null = all accounts).
final ledgerAccountFilterProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

/// NF-11 journals, cursor paged, for the account filter.
final journalsProvider =
    StateNotifierProvider.autoDispose<
      StPagedController<Journal>,
      AsyncValue<StPagedList<Journal>>
    >((ref) {
      final repo = ref.watch(ledgerRepositoryProvider);
      final actor = ref.watch(actorProvider);
      final account = ref.watch(ledgerAccountFilterProvider);
      return StPagedController<Journal>(
        (cursor) => repo.journals(actor, account: account, cursor: cursor),
      );
    });

/// NF-12 periods.
final periodsProvider = FutureProvider.autoDispose<List<Period>>(
  (ref) => stUnwrap(
    ref.watch(ledgerRepositoryProvider).periods(ref.watch(actorProvider)),
  ),
);

/// NF-12 selected period id.
final selectedPeriodProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);
