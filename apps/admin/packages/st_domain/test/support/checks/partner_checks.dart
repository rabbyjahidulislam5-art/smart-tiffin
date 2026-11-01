import 'package:st_domain/st_domain.dart';

import '../repo_check.dart';

const supplierActor = Actor(StRole.supplier, id: 'demo-supplier');
const riderActor = Actor(StRole.rider, id: 'demo-rider');
const partnerCustomerActor = Actor(StRole.customer, id: 'demo-customer');

MockBehavior _instant() => MockBehavior.instant();

/// MockEarningsRepository (NS-01, NR-01).
final earningsChecks = <RepoCheck>[
  (
    name:
        'earnings: the supplier statement reads the mock rows without a network call',
    run: () async {
      final r = await MockEarningsRepository(behavior: _instant())
          .supplierEarnings(supplierActor);
      return r.valueOrNull?.length ==
          MockEarningsRepository.supplierFixtures.length;
    },
  ),
  (
    name: 'earnings: the status filter returns only that status',
    run: () async {
      final repo = MockEarningsRepository(behavior: _instant());
      for (final s in EarningStatus.values) {
        final rows =
            (await repo.supplierEarnings(supplierActor, status: s)).valueOrNull;
        if (rows == null || rows.any((e) => e.status != s)) return false;
      }
      return true;
    },
  ),
  (
    name: 'earnings: the balances agree with the payout mock',
    run: () async {
      final payouts = MockPayoutRepository(behavior: _instant());
      final repo =
          MockEarningsRepository(behavior: _instant(), payouts: payouts);
      final b = (await repo.supplierBalances(supplierActor)).valueOrNull;
      final e = (await payouts.eligibleBalance(supplierActor)).valueOrNull;
      return b != null &&
          e != null &&
          b.eligibleMinor == e.eligibleMinor &&
          b.heldMinor == e.heldMinor;
    },
  ),
  (
    name: 'earnings: a rider reads own rows and a supplier is refused',
    run: () async {
      final repo = MockEarningsRepository(behavior: _instant());
      final own = await repo.riderEarnings(riderActor);
      final other = await repo.riderEarnings(supplierActor);
      return (own.valueOrNull?.isNotEmpty ?? false) &&
          other.errorOrNull?.kind == RepoErrorKind.permissionDenied;
    },
  ),
  (
    name: 'earnings: an injected failure returns Err',
    run: () async {
      final b = _instant();
      final repo = MockEarningsRepository(behavior: b);
      b.failNext(RepoErrorKind.temporarilyUnavailable);
      return (await repo.supplierBalances(supplierActor)).errorOrNull?.kind ==
          RepoErrorKind.temporarilyUnavailable;
    },
  ),
];

/// MockKitchenOperationsRepository (NS-04..NS-07).
final kitchenOperationsChecks = <RepoCheck>[
  (
    name: 'kitchen ops: capacity reads the two slot rules',
    run: () async {
      final rules = (await MockKitchenOperationsRepository(behavior: _instant())
              .capacity(supplierActor))
          .valueOrNull;
      return rules != null &&
          rules.length == 2 &&
          rules.any((r) => r.slot == Slot.lunch && r.maxPortions == 60);
    },
  ),
  (
    name: 'kitchen ops: a saved limit is read back with the next version',
    run: () async {
      final repo = MockKitchenOperationsRepository(behavior: _instant());
      final r = await repo.saveCapacity(supplierActor, RequestId.next('t'),
          slot: Slot.lunch, maxPortions: 70, expectedVersion: 3);
      final lunch = (await repo.capacity(supplierActor))
          .valueOrNull
          ?.firstWhere((x) => x.slot == Slot.lunch);
      return r.isOk && lunch?.maxPortions == 70 && lunch?.version == 4;
    },
  ),
  (
    name:
        'kitchen ops: a limit below the committed portions is rejected and changes nothing',
    run: () async {
      final repo = MockKitchenOperationsRepository(behavior: _instant());
      final r = await repo.saveCapacity(supplierActor, RequestId.next('t'),
          slot: Slot.lunch, maxPortions: 40, expectedVersion: 3);
      return r.errorOrNull?.kind == RepoErrorKind.businessRuleRejected &&
          repo.revision == 0;
    },
  ),
  (
    name: 'kitchen ops: a stale expected version is a conflict',
    run: () async {
      final repo = MockKitchenOperationsRepository(behavior: _instant());
      final r = await repo.saveCapacity(supplierActor, RequestId.next('t'),
          slot: Slot.lunch, maxPortions: 70, expectedVersion: 1);
      return r.errorOrNull?.kind == RepoErrorKind.conflict &&
          repo.revision == 0;
    },
  ),
  (
    name: 'kitchen ops: slot availability is read back',
    run: () async {
      final repo = MockKitchenOperationsRepository(behavior: _instant());
      await repo.setSlotAvailability(supplierActor, RequestId.next('t'),
          slot: Slot.dinner, open: false);
      final dinner = (await repo.capacity(supplierActor))
          .valueOrNull
          ?.firstWhere((x) => x.slot == Slot.dinner);
      return dinner?.open == false;
    },
  ),
  (
    name:
        'kitchen ops: a scheduled price is read back first; a past date is invalid',
    run: () async {
      final repo = MockKitchenOperationsRepository(behavior: _instant());
      final ok = await repo.schedulePriceChange(
          supplierActor, RequestId.next('t'),
          mealId: 'thali',
          amountMinor: 19000,
          effectiveFrom: '2026-11-10',
          reason: 'Season change');
      final bad = await repo.schedulePriceChange(
          supplierActor, RequestId.next('t'),
          mealId: 'thali',
          amountMinor: 19000,
          effectiveFrom: '2026-10-01',
          reason: 'Season change');
      final first =
          (await repo.priceVersions(supplierActor)).valueOrNull?.first;
      return ok.isOk &&
          first?.status == PriceVersionStatus.scheduled &&
          first?.amountMinor == 19000 &&
          bad.errorOrNull ==
              const RepoError(RepoErrorKind.invalidInput,
                  field: 'effectiveFrom');
    },
  ),
  (
    name: 'kitchen ops: the forecast flags the over-capacity lunch',
    run: () async {
      final rows = (await MockKitchenOperationsRepository(behavior: _instant())
              .forecast(supplierActor))
          .valueOrNull;
      return rows != null &&
          rows.length == 10 &&
          rows.where((r) => r.overCapacity).length == 1;
    },
  ),
  (
    name:
        'kitchen ops: a handoff needs the right code and is read back as handed off',
    run: () async {
      final repo = MockKitchenOperationsRepository(behavior: _instant());
      final wrong = await repo.recordHandoff(supplierActor, RequestId.next('t'),
          handoffId: 'HO-81',
          pickupCode: '0000',
          itemsCounted: true,
          sealed: true);
      final right = await repo.recordHandoff(supplierActor, RequestId.next('t'),
          handoffId: 'HO-81',
          pickupCode: '4821',
          itemsCounted: true,
          sealed: true);
      final h = (await repo.pendingHandoffs(supplierActor))
          .valueOrNull
          ?.firstWhere((x) => x.id == 'HO-81');
      return wrong.errorOrNull ==
              const RepoError(RepoErrorKind.invalidInput, field: 'code') &&
          right.isOk &&
          h?.status == HandoffStatus.handedOff;
    },
  ),
  (
    name: 'kitchen ops: a rider is refused before any change',
    run: () async {
      final repo = MockKitchenOperationsRepository(behavior: _instant());
      final r = await repo.saveCapacity(riderActor, RequestId.next('t'),
          slot: Slot.lunch, maxPortions: 70, expectedVersion: 3);
      return r.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          repo.revision == 0;
    },
  ),
];

/// MockCodRepository (NR-03, NR-04, NR-05).
final codChecks = <RepoCheck>[
  (
    name: 'cod: collections and the liability read the mock data',
    run: () async {
      final repo = MockCodRepository(behavior: _instant());
      final list = (await repo.collections(riderActor)).valueOrNull;
      final liability = (await repo.liability(riderActor)).valueOrNull;
      return list?.length == 3 && liability == 54000;
    },
  ),
  (
    name: 'cod: a recorded collection is read back and raises the liability',
    run: () async {
      final repo = MockCodRepository(behavior: _instant());
      final r = await repo.recordCodCollection(riderActor, RequestId.next('t'),
          collectionId: 'COD-913', amountMinor: 24000);
      final c = (await repo.collections(riderActor))
          .valueOrNull
          ?.firstWhere((x) => x.id == 'COD-913');
      final liability = (await repo.liability(riderActor)).valueOrNull;
      return r.isOk &&
          c?.status == CodStatus.collected &&
          c?.collectedMinor == 24000 &&
          liability == 78000;
    },
  ),
  (
    name: 'cod: a partial remittance reduces but does not close the liability',
    run: () async {
      final repo = MockCodRepository(behavior: _instant());
      final r = await repo.submitCodRemittance(riderActor, RequestId.next('t'),
          amountMinor: 20000, reference: 'DEP-77001', method: 'Bank deposit');
      final liability = (await repo.liability(riderActor)).valueOrNull;
      final first = (await repo.remittances(riderActor)).valueOrNull?.first;
      return r.valueOrNull?.status == RemittanceStatus.partial &&
          liability == 34000 &&
          first?.reference == 'DEP-77001';
    },
  ),
  (
    name: 'cod: a reused deposit reference is rejected and changes nothing',
    run: () async {
      final repo = MockCodRepository(behavior: _instant());
      final r = await repo.submitCodRemittance(riderActor, RequestId.next('t'),
          amountMinor: 1000, reference: 'BK-90214', method: 'bKash transfer');
      return r.errorOrNull?.kind == RepoErrorKind.businessRuleRejected &&
          repo.revision == 0;
    },
  ),
  (
    name: 'cod: a discrepancy response is read back',
    run: () async {
      final repo = MockCodRepository(behavior: _instant());
      final r = await repo.respondToDiscrepancy(riderActor, RequestId.next('t'),
          discrepancyId: 'DS-12', response: 'Paid 60 taka in cash at the hub.');
      final d = (await repo.discrepancies(riderActor)).valueOrNull?.first;
      return r.isOk &&
          d?.status == DiscrepancyStatus.responded &&
          d?.riderResponse != null;
    },
  ),
  (
    name: 'cod: a supplier is refused before any change',
    run: () async {
      final repo = MockCodRepository(behavior: _instant());
      final r = await repo.recordCodCollection(
          supplierActor, RequestId.next('t'),
          collectionId: 'COD-913', amountMinor: 24000);
      return r.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          repo.revision == 0;
    },
  ),
];

/// MockDeliveryDisputeRepository (NR-06).
final deliveryDisputeChecks = <RepoCheck>[
  (
    name: 'disputes: earlier reports read the mock data',
    run: () async =>
        (await MockDeliveryDisputeRepository(behavior: _instant())
                .reports(riderActor))
            .valueOrNull
            ?.length ==
        1,
  ),
  (
    name: 'disputes: a report is read back first and under review',
    run: () async {
      final repo = MockDeliveryDisputeRepository(behavior: _instant());
      final r = await repo.reportDeliveryFailure(
          riderActor, RequestId.next('t'),
          deliveryRef: 'DL-913',
          kind: DeliveryFailureKind.noShow,
          note: 'Waited 10 minutes at the gate.');
      final first = (await repo.reports(riderActor)).valueOrNull?.first;
      return r.isOk &&
          first?.id == r.valueOrNull?.id &&
          first?.underReview == true;
    },
  ),
  (
    name: 'disputes: an unknown delivery and a short note are invalid input',
    run: () async {
      final repo = MockDeliveryDisputeRepository(behavior: _instant());
      final a = await repo.reportDeliveryFailure(
          riderActor, RequestId.next('t'),
          deliveryRef: 'DL-1',
          kind: DeliveryFailureKind.failed,
          note: 'Long enough note here');
      final b = await repo.reportDeliveryFailure(
          riderActor, RequestId.next('t'),
          deliveryRef: 'DL-913',
          kind: DeliveryFailureKind.failed,
          note: 'short');
      return a.errorOrNull?.field == 'delivery' &&
          b.errorOrNull?.field == 'note' &&
          repo.revision == 0;
    },
  ),
  (
    name: 'disputes: an injected failure returns Err',
    run: () async {
      final b = _instant();
      final repo = MockDeliveryDisputeRepository(behavior: b);
      b.failNext(RepoErrorKind.temporarilyUnavailable);
      return (await repo.reports(riderActor)).errorOrNull?.kind ==
          RepoErrorKind.temporarilyUnavailable;
    },
  ),
];

/// MockPayoutRepository (NS-02, NS-03, NR-02).
final payoutChecks = <RepoCheck>[
  (
    name: 'payout: each role reads its own eligible balance',
    run: () async {
      final repo = MockPayoutRepository(behavior: _instant());
      final s = (await repo.eligibleBalance(supplierActor)).valueOrNull;
      final r = (await repo.eligibleBalance(riderActor)).valueOrNull;
      return s?.eligibleMinor == 1845000 && r?.eligibleMinor == 260000;
    },
  ),
  (
    name:
        'payout: a customer and a guest supplier are refused before any change',
    run: () async {
      final repo = MockPayoutRepository(behavior: _instant());
      final a = await repo.requestPayout(
          partnerCustomerActor, RequestId.next('t'),
          amountMinor: 100);
      final g = await repo.eligibleBalance(const Actor(StRole.supplier));
      return a.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          g.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          repo.revision == 0;
    },
  ),
  (
    name: 'payout: a request is read back in the balance and the history',
    run: () async {
      final repo = MockPayoutRepository(behavior: _instant());
      final r = await repo.requestPayout(supplierActor, RequestId.next('t'),
          amountMinor: 100000);
      final b = (await repo.eligibleBalance(supplierActor)).valueOrNull;
      final h = (await repo.history(supplierActor)).valueOrNull;
      return r.isOk &&
          b?.eligibleMinor == 1745000 &&
          b?.pendingMinor == 100000 &&
          h?.items.first.id == r.valueOrNull?.id &&
          h?.items.first.status == PayoutStatus.requested;
    },
  ),
  (
    name:
        'payout: an amount above the eligible balance is rejected and changes nothing',
    run: () async {
      final repo = MockPayoutRepository(behavior: _instant());
      final r = await repo.requestPayout(supplierActor, RequestId.next('t'),
          amountMinor: 1845001);
      final b = (await repo.eligibleBalance(supplierActor)).valueOrNull;
      return r.errorOrNull?.kind == RepoErrorKind.businessRuleRejected &&
          repo.revision == 0 &&
          b?.eligibleMinor == 1845000;
    },
  ),
  (
    name: 'payout: 0 and 100000000 minor units are invalid input',
    run: () async {
      final repo = MockPayoutRepository(behavior: _instant());
      final a = await repo.requestPayout(supplierActor, RequestId.next('t'),
          amountMinor: 0);
      final b = await repo.requestPayout(supplierActor, RequestId.next('t'),
          amountMinor: 100000000);
      return a.errorOrNull ==
              const RepoError(RepoErrorKind.invalidInput, field: 'amount') &&
          b.errorOrNull?.kind == RepoErrorKind.invalidInput;
    },
  ),
  (
    name: 'payout: a repeated request id commits once',
    run: () async {
      final repo = MockPayoutRepository(behavior: _instant());
      final id = RequestId.next('t');
      final a = await repo.requestPayout(riderActor, id, amountMinor: 50000);
      final b = await repo.requestPayout(riderActor, id, amountMinor: 50000);
      final bal = (await repo.eligibleBalance(riderActor)).valueOrNull;
      return a == b && repo.revision == 1 && bal?.eligibleMinor == 210000;
    },
  ),
  (
    name: 'payout: an injected failure returns Err and changes nothing',
    run: () async {
      final b = _instant();
      final repo = MockPayoutRepository(behavior: b);
      b.failNext(RepoErrorKind.temporarilyUnavailable);
      final r = await repo.requestPayout(supplierActor, RequestId.next('t'),
          amountMinor: 100);
      return r.errorOrNull?.kind == RepoErrorKind.temporarilyUnavailable &&
          repo.revision == 0;
    },
  ),
];
