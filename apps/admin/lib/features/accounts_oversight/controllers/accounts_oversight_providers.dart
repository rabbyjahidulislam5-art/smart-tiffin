import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// NA-05 limited finance indicators (`FinanceKpiRepository.limited`).
final limitedFinanceKpisProvider =
    FutureProvider.autoDispose<LimitedFinanceKpis>(
      (ref) => stUnwrap(
        ref
            .watch(financeKpiRepositoryProvider)
            .limited(ref.watch(actorProvider)),
      ),
    );
