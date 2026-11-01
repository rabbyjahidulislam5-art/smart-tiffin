import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/handoff_text.dart';

/// NS-07 orders waiting for custody transfer.
final pendingHandoffsProvider = FutureProvider.autoDispose<List<Handoff>>(
  (ref) => stUnwrap(
    ref
        .watch(kitchenOperationsRepositoryProvider)
        .pendingHandoffs(ref.watch(actorProvider)),
  ),
);

/// NS-07 form values.
typedef HandoffValues = ({
  String handoffId,
  String code,
  bool counted,
  bool sealed,
});

/// NS-07 handoff form (`recordHandoff`).
final handoffFormProvider =
    StateNotifierProvider.autoDispose<
      StFormController<HandoffValues>,
      StFormState<HandoffValues>
    >((ref) {
      final repo = ref.watch(kitchenOperationsRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<HandoffValues>(
        initial: (handoffId: '', code: '', counted: false, sealed: false),
        validate: (v) => {
          if (v.handoffId.isEmpty) 'handoff': HandoffText.chooseOrder,
          if (!RegExp(r'^\d{4}$').hasMatch(latinDigits(v.code).trim()))
            'code': HandoffText.enterCode,
          if (!v.counted || !v.sealed) 'checks': HandoffText.checksNeeded,
        },
        command: (v, id) => repo.recordHandoff(
          actor,
          id,
          handoffId: v.handoffId,
          pickupCode: latinDigits(v.code).trim(),
          itemsCounted: v.counted,
          sealed: v.sealed,
        ),
      );
    });
