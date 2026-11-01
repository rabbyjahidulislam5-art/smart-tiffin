import '../../access/actor.dart';
import '../../models/partner/capacity_rule.dart';
import '../../models/partner/forecast_row.dart';
import '../../models/partner/handoff.dart';
import '../../models/partner/price_version.dart';
import '../../models/partner/slot_availability.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../result/slot.dart';

/// Kitchen operations of the signed-in supplier (NS-04..NS-07).
abstract interface class KitchenOperationsRepository {
  Future<RepoResult<List<CapacityRule>>> capacity(Actor actor);

  Future<RepoResult<CapacityRule>> saveCapacity(
    Actor actor,
    RequestId requestId, {
    required Slot slot,
    required int maxPortions,
    required int expectedVersion,
  });

  Future<RepoResult<SlotAvailability>> setSlotAvailability(Actor actor, RequestId requestId, {required Slot slot, required bool open});

  Future<RepoResult<List<PriceVersion>>> priceVersions(Actor actor);

  Future<RepoResult<PriceVersion>> schedulePriceChange(
    Actor actor,
    RequestId requestId, {
    required String mealId,
    required int amountMinor,
    required String effectiveFrom,
    required String reason,
  });

  Future<RepoResult<List<ForecastRow>>> forecast(Actor actor);

  Future<RepoResult<List<Handoff>>> pendingHandoffs(Actor actor);

  Future<RepoResult<Handoff>> recordHandoff(
    Actor actor,
    RequestId requestId, {
    required String handoffId,
    required String pickupCode,
    required bool itemsCounted,
    required bool sealed,
  });
}
