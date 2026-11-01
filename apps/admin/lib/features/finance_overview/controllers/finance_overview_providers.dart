import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// NF-01 full finance KPIs (accounting only).
final fullFinanceKpisProvider = FutureProvider.autoDispose<FullFinanceKpis>(
  (ref) => stUnwrap(
    ref.watch(financeKpiRepositoryProvider).full(ref.watch(actorProvider)),
  ),
);
