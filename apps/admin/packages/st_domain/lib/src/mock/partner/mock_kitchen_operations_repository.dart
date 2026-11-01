import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/partner/capacity_rule.dart';
import '../../models/partner/forecast_row.dart';
import '../../models/partner/handoff.dart';
import '../../models/partner/handoff_status.dart';
import '../../models/partner/price_version.dart';
import '../../models/partner/price_version_status.dart';
import '../../models/partner/slot_availability.dart';
import '../../repositories/partner/kitchen_operations_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../result/slot.dart';
import '../mock_behavior.dart';
import '../mock_clock.dart';
import '../mock_repository_base.dart';

/// Kitchen operations of Rina's Kitchen (sample).
class MockKitchenOperationsRepository extends MockRepositoryBase implements KitchenOperationsRepository {
  MockKitchenOperationsRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.supplier};

  /// Legacy validator of S-12: capacity 1 to 500.
  static const maxCapacity = 500;

  final Map<Slot, CapacityRule> _capacity = {
    Slot.lunch: const CapacityRule(slot: Slot.lunch, maxPortions: 60, committed: 41, open: true, version: 3),
    Slot.dinner: const CapacityRule(slot: Slot.dinner, maxPortions: 40, committed: 22, open: true, version: 2),
  };

  final List<PriceVersion> _prices = [
    const PriceVersion(id: 'PV-31', mealId: 'thali', variant: 'Regular', amountMinor: 18000, effectiveFrom: '2026-09-01', status: PriceVersionStatus.active, author: 'Rina', reason: 'Season menu', boundCommitments: 34),
    const PriceVersion(id: 'PV-22', mealId: 'thali', variant: 'Regular', amountMinor: 17000, effectiveFrom: '2026-06-01', status: PriceVersionStatus.superseded, author: 'Rina', reason: 'Launch price'),
    const PriceVersion(id: 'PV-32', mealId: 'khichuri', variant: 'Regular', amountMinor: 16000, effectiveFrom: '2026-09-01', status: PriceVersionStatus.active, author: 'Rina', reason: 'Season menu', boundCommitments: 12),
    const PriceVersion(id: 'PV-33', mealId: 'roti', variant: 'Regular', amountMinor: 20000, effectiveFrom: '2026-09-01', status: PriceVersionStatus.active, author: 'Rina', reason: 'Season menu', boundCommitments: 6),
  ];

  final List<Handoff> _handoffs = [
    const Handoff(id: 'HO-81', orderRef: 'TK-911', riderName: 'Rokon', vehicle: 'Motorcycle', items: 2, status: HandoffStatus.ready, pickupCode: '4821'),
    const Handoff(id: 'HO-82', orderRef: 'TK-912', riderName: 'Mitu', vehicle: 'Bicycle', items: 1, status: HandoffStatus.ready, pickupCode: '7730'),
  ];

  int _seq = 40;

  @override
  Future<RepoResult<List<CapacityRule>>> capacity(Actor actor) => guardRead(actor, roles, 'capacity', () => Ok(_capacity.values.toList()));

  @override
  Future<RepoResult<CapacityRule>> saveCapacity(Actor actor, RequestId requestId,
          {required Slot slot, required int maxPortions, required int expectedVersion}) =>
      guardCommand(actor, roles, 'saveCapacity', requestId, () {
        final rule = _capacity[slot];
        if (rule == null) return MockRepositoryBase.invalid('slot');
        if (maxPortions < 1 || maxPortions > maxCapacity) return MockRepositoryBase.invalid('maxPortions');
        if (rule.version != expectedVersion) return MockRepositoryBase.fail(RepoErrorKind.conflict);
        if (maxPortions < rule.committed) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'maxPortions'));
        final next = rule.copyWith(maxPortions: maxPortions, version: rule.version + 1);
        _capacity[slot] = next;
        return Ok(next);
      });

  @override
  Future<RepoResult<SlotAvailability>> setSlotAvailability(Actor actor, RequestId requestId, {required Slot slot, required bool open}) =>
      guardCommand(actor, roles, 'setSlotAvailability', requestId, () {
        final rule = _capacity[slot];
        if (rule == null) return MockRepositoryBase.invalid('slot');
        _capacity[slot] = rule.copyWith(open: open, version: rule.version + 1);
        return Ok(SlotAvailability(slot: slot, open: open));
      });

  @override
  Future<RepoResult<List<PriceVersion>>> priceVersions(Actor actor) => guardRead(actor, roles, 'priceVersions', () => Ok(List.unmodifiable(_prices)));

  @override
  Future<RepoResult<PriceVersion>> schedulePriceChange(Actor actor, RequestId requestId,
          {required String mealId, required int amountMinor, required String effectiveFrom, required String reason}) =>
      guardCommand(actor, roles, 'schedulePriceChange', requestId, () {
        if (!_prices.any((p) => p.mealId == mealId)) return MockRepositoryBase.invalid('meal');
        if (amountMinor <= 0 || amountMinor > 99999999) return MockRepositoryBase.invalid('amount');
        if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(effectiveFrom) || effectiveFrom.compareTo(mockToday) <= 0) {
          return MockRepositoryBase.invalid('effectiveFrom');
        }
        if (_prices.any((p) => p.mealId == mealId && p.effectiveFrom == effectiveFrom && p.status != PriceVersionStatus.cancelled)) {
          return MockRepositoryBase.invalid('effectiveFrom');
        }
        if (reason.trim().length < 5) return MockRepositoryBase.invalid('reason');
        final v = PriceVersion(
          id: 'PV-${++_seq}',
          mealId: mealId,
          variant: 'Regular',
          amountMinor: amountMinor,
          effectiveFrom: effectiveFrom,
          status: PriceVersionStatus.scheduled,
          author: 'Rina',
          reason: reason.trim(),
        );
        _prices.insert(0, v);
        return Ok(v);
      });

  @override
  Future<RepoResult<List<ForecastRow>>> forecast(Actor actor) => guardRead(actor, roles, 'forecast', () {
        const dates = ['2026-11-03', '2026-11-04', '2026-11-05', '2026-11-06', '2026-11-07'];
        const lunch = [38, 41, 44, 63, 35];
        const dinner = [20, 22, 19, 25, 18];
        final rows = <ForecastRow>[];
        for (var i = 0; i < dates.length; i++) {
          rows.add(ForecastRow(date: dates[i], slot: Slot.lunch, mealId: i.isEven ? 'thali' : 'khichuri', portions: lunch[i], capacity: _capacity[Slot.lunch]!.maxPortions));
          rows.add(ForecastRow(date: dates[i], slot: Slot.dinner, mealId: 'roti', portions: dinner[i], capacity: _capacity[Slot.dinner]!.maxPortions));
        }
        return Ok(rows);
      });

  @override
  Future<RepoResult<List<Handoff>>> pendingHandoffs(Actor actor) => guardRead(actor, roles, 'pendingHandoffs', () => Ok(List.unmodifiable(_handoffs)));

  @override
  Future<RepoResult<Handoff>> recordHandoff(Actor actor, RequestId requestId,
          {required String handoffId, required String pickupCode, required bool itemsCounted, required bool sealed}) =>
      guardCommand(actor, roles, 'recordHandoff', requestId, () {
        final i = _handoffs.indexWhere((h) => h.id == handoffId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final h = _handoffs[i];
        if (h.status != HandoffStatus.ready) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (!itemsCounted || !sealed) return MockRepositoryBase.invalid('checks');
        if (pickupCode.trim() != h.pickupCode) return MockRepositoryBase.invalid('code');
        final done = h.withStatus(HandoffStatus.handedOff);
        _handoffs[i] = done;
        return Ok(done);
      });
}
