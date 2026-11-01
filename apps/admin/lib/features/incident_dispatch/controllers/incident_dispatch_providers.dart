import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// NA-04 delayed deliveries.
final delayedDeliveriesProvider =
    FutureProvider.autoDispose<List<DelayedDelivery>>(
      (ref) => stUnwrap(
        ref
            .watch(dispatchRepositoryProvider)
            .delayedDeliveries(ref.watch(actorProvider)),
      ),
    );

/// NA-04 selected delivery.
final selectedDeliveryProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

/// NA-04 backup riders of one delivery.
final backupRidersProvider = FutureProvider.autoDispose
    .family<List<BackupRider>, String>(
      (ref, deliveryId) => stUnwrap(
        ref
            .watch(dispatchRepositoryProvider)
            .backupRiders(ref.watch(actorProvider), deliveryId),
      ),
    );
