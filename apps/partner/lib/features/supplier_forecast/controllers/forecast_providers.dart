import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// NS-04 slot filter (null = all slots).
final forecastSlotFilterProvider = StateProvider.autoDispose<Slot?>(
  (ref) => null,
);

/// NS-04 future portions by date, slot and meal.
final forecastProvider = FutureProvider.autoDispose<List<ForecastRow>>(
  (ref) => stUnwrap(
    ref
        .watch(kitchenOperationsRepositoryProvider)
        .forecast(ref.watch(actorProvider)),
  ),
);
