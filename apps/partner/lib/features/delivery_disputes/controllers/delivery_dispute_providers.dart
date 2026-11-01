import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../screens/delivery_dispute_text.dart';

/// NR-06 earlier reports of the rider.
final deliveryReportsProvider =
    FutureProvider.autoDispose<List<DeliveryFailureReport>>(
      (ref) => stUnwrap(
        ref
            .watch(deliveryDisputeRepositoryProvider)
            .reports(ref.watch(actorProvider)),
      ),
    );

/// NR-06 form values.
typedef DeliveryFailureValues = ({
  String delivery,
  DeliveryFailureKind? kind,
  String note,
});

/// NR-06 form (`reportDeliveryFailure`).
final deliveryFailureFormProvider =
    StateNotifierProvider.autoDispose<
      StFormController<DeliveryFailureValues>,
      StFormState<DeliveryFailureValues>
    >((ref) {
      final repo = ref.watch(deliveryDisputeRepositoryProvider);
      final actor = ref.watch(actorProvider);
      return StFormController<DeliveryFailureValues>(
        initial: (delivery: '', kind: null, note: ''),
        validate: (v) => {
          if (!RegExp(r'^DL-\d+$').hasMatch(v.delivery.trim().toUpperCase()))
            'delivery': DeliveryDisputeText.deliveryNeeded,
          if (v.kind == null) 'kind': DeliveryDisputeText.kindNeeded,
          if (v.note.trim().length < 10) 'note': DeliveryDisputeText.noteShort,
        },
        command: (v, id) => repo.reportDeliveryFailure(
          actor,
          id,
          deliveryRef: v.delivery.trim().toUpperCase(),
          kind: v.kind ?? DeliveryFailureKind.failed,
          note: v.note,
        ),
      );
    });
