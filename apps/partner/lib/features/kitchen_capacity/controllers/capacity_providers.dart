import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/capacity_text.dart';

/// NS-05 capacity rules per slot.
final capacityProvider = FutureProvider.autoDispose<List<CapacityRule>>(
  (ref) => stUnwrap(
    ref
        .watch(kitchenOperationsRepositoryProvider)
        .capacity(ref.watch(actorProvider)),
  ),
);

CapacityRule? _ruleOf(Ref ref, Slot slot) {
  for (final r
      in ref.read(capacityProvider).valueOrNull ?? const <CapacityRule>[]) {
    if (r.slot == slot) return r;
  }
  return null;
}

/// NS-05 daily limit form of one slot (`saveCapacity` with `expectedVersion`).
final capacityFormProvider = StateNotifierProvider.autoDispose
    .family<StFormController<String>, StFormState<String>, Slot>((ref, slot) {
      final repo = ref.watch(kitchenOperationsRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<String>(
        initial: '',
        validate: (v) {
          final n = int.tryParse(latinDigits(v).trim());
          if (n == null || n < 1 || n > 500)
            return {'max': CapacityText.enterLimit};
          final rule = _ruleOf(ref, slot);
          if (rule != null && n < rule.committed)
            return {'max': CapacityText.belowCommitted};
          return const {};
        },
        command: (v, id) => repo.saveCapacity(
          actor,
          id,
          slot: slot,
          maxPortions: int.parse(latinDigits(v).trim()),
          expectedVersion: _ruleOf(ref, slot)?.version ?? 0,
        ),
      );
    });

/// NS-05 availability of one slot (`setSlotAvailability`); the value is the
/// requested state, the displayed state always comes from the repository.
final slotAvailabilityFormProvider = StateNotifierProvider.autoDispose
    .family<StFormController<bool>, StFormState<bool>, Slot>((ref, slot) {
      final repo = ref.watch(kitchenOperationsRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<bool>(
        initial: true,
        validate: (_) => const {},
        command: (open, id) =>
            repo.setSlotAvailability(actor, id, slot: slot, open: open),
      );
    });
