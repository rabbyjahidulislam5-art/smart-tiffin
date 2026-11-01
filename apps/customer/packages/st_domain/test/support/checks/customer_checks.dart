import 'package:st_domain/st_domain.dart';

import '../repo_check.dart';

const customerActor = Actor(StRole.customer, id: 'demo-customer');
const guestCustomer = Actor(StRole.customer);
const _supplier = Actor(StRole.supplier, id: 'demo-supplier');

MockBehavior _instant() => MockBehavior.instant();

RequestId _id() => RequestId.next('t');

/// MockKitchenRepository (NC-01, NC-02, NC-03). Guests read the public
/// projection; an absent and an unpublished kitchen are indistinguishable.
final kitchenChecks = <RepoCheck>[
  (
    name:
        'kitchens: a guest reads the first page of published kitchens without a network call',
    run: () async {
      final page = (await MockKitchenRepository(behavior: _instant())
              .search(guestCustomer, const KitchenQuery()))
          .valueOrNull;
      return page != null &&
          page.items.length == MockKitchenRepository.pageSize &&
          !page.atEnd;
    },
  ),
  (
    name: 'kitchens: the next page continues without duplicate or missing rows',
    run: () async {
      final repo = MockKitchenRepository(behavior: _instant());
      final first =
          (await repo.search(guestCustomer, const KitchenQuery())).valueOrNull;
      final second = (await repo.search(guestCustomer, const KitchenQuery(),
              cursor: first?.cursor))
          .valueOrNull;
      if (first == null || second == null) return false;
      final ids = [
        for (final k in first.items) k.id,
        for (final k in second.items) k.id,
      ];
      return ids.toSet().length == ids.length &&
          ids.length == publishedKitchens.length &&
          second.atEnd;
    },
  ),
  (
    name:
        'kitchens: a Bangla name matches and the area filter keeps only kitchens that serve it',
    run: () async {
      final repo = MockKitchenRepository(behavior: _instant());
      final bn =
          (await repo.search(guestCustomer, const KitchenQuery(q: 'রিনার')))
              .valueOrNull;
      final zone =
          (await repo.search(guestCustomer, const KitchenQuery(zone: 'Uttara')))
              .valueOrNull;
      return bn != null &&
          bn.items.length == 1 &&
          bn.items.first.id == 'rinas-kitchen' &&
          zone != null &&
          zone.items.length == 1 &&
          zone.items.first.id == 'uttara-diet';
    },
  ),
  (
    name:
        'kitchens: the rating sort orders by rating and the slot filter needs every slot',
    run: () async {
      final repo = MockKitchenRepository(behavior: _instant());
      final rated = (await repo.search(
              guestCustomer, const KitchenQuery(sort: KitchenSort.rating)))
          .valueOrNull;
      final breakfast = (await repo.search(
              guestCustomer, const KitchenQuery(slots: {Slot.breakfast})))
          .valueOrNull;
      if (rated == null || breakfast == null) return false;
      for (var i = 1; i < rated.items.length; i++) {
        if (rated.items[i - 1].rating < rated.items[i].rating) return false;
      }
      return breakfast.items.length == 1 &&
          breakfast.items.first.id == 'gulshan-bites';
    },
  ),
  (
    name:
        'kitchens: a query longer than 60 characters is invalid input on the q field',
    run: () async {
      final r = await MockKitchenRepository(behavior: _instant())
          .search(guestCustomer, KitchenQuery(q: 'x' * 61));
      return r.errorOrNull ==
          const RepoError(RepoErrorKind.invalidInput, field: 'q');
    },
  ),
  (
    name:
        'kitchens: an absent and an unpublished kitchen return the same notAvailable',
    run: () async {
      final repo = MockKitchenRepository(behavior: _instant());
      final absent = await repo.kitchen(guestCustomer, 'no-such-kitchen');
      final hidden =
          await repo.kitchen(guestCustomer, unpublishedKitchenIds.first);
      final absentMenu = await repo.menuDates(guestCustomer, 'no-such-kitchen');
      final hiddenMenu =
          await repo.menuDates(guestCustomer, unpublishedKitchenIds.first);
      return absent.errorOrNull?.kind == RepoErrorKind.notAvailable &&
          absent == hidden &&
          absentMenu.errorOrNull == hiddenMenu.errorOrNull &&
          absentMenu.errorOrNull?.kind == RepoErrorKind.notAvailable;
    },
  ),
  (
    name:
        'kitchens: the profile by English name equals the profile by id (C-06 parameter)',
    run: () async {
      final repo = MockKitchenRepository(behavior: _instant());
      final byId =
          (await repo.kitchen(guestCustomer, 'rinas-kitchen')).valueOrNull;
      final byName =
          (await repo.kitchen(guestCustomer, "Rina's Kitchen")).valueOrNull;
      return byId != null &&
          byName != null &&
          byId.summary.id == byName.summary.id &&
          byId.slotWindows.keys.toSet().containsAll(byId.summary.slots) &&
          byId.reviews.length <= 3;
    },
  ),
  (
    name:
        'kitchens: a date past cutoff is marked and an unpublished date is invalid',
    run: () async {
      final repo = MockKitchenRepository(behavior: _instant());
      final today = (await repo.menu(guestCustomer, 'rinas-kitchen',
              slot: Slot.lunch, date: mockToday))
          .valueOrNull;
      final next = (await repo.menu(guestCustomer, 'rinas-kitchen',
              slot: Slot.lunch, date: publishedDates[1]))
          .valueOrNull;
      final bad = await repo.menu(guestCustomer, 'rinas-kitchen',
          slot: Slot.lunch, date: '2027-01-01');
      return today?.cutoffPassed == true &&
          next != null &&
          !next.cutoffPassed &&
          next.items.isNotEmpty &&
          next.items.every((m) => m.slot == Slot.lunch) &&
          bad.errorOrNull?.kind == RepoErrorKind.invalidInput;
    },
  ),
  (
    name: 'kitchens: reviews page without duplicate rows',
    run: () async {
      final repo = MockKitchenRepository(behavior: _instant());
      final p1 =
          (await repo.reviews(guestCustomer, 'maas-kitchen')).valueOrNull;
      final p2 = (await repo.reviews(guestCustomer, 'maas-kitchen',
              cursor: p1?.cursor))
          .valueOrNull;
      return p1 != null &&
          p2 != null &&
          p1.items.length + p2.items.length == reviewFixtures.length &&
          p2.atEnd;
    },
  ),
  (
    name:
        'kitchens: a supplier actor is refused and an injected failure returns Err',
    run: () async {
      final b = _instant();
      final repo = MockKitchenRepository(behavior: b);
      final supplier = await repo.search(_supplier, const KitchenQuery());
      b.failNext(RepoErrorKind.temporarilyUnavailable);
      final failed = await repo.search(guestCustomer, const KitchenQuery());
      return supplier.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          failed.errorOrNull?.kind == RepoErrorKind.temporarilyUnavailable;
    },
  ),
  (
    name:
        'kitchens: a query survives toParams and fromParams (sample of Property 8)',
    run: () async {
      const q = KitchenQuery(
        q: 'thali',
        cuisine: 'bengali',
        dietary: 'halal',
        slots: {Slot.lunch, Slot.dinner},
        verifiedOnly: true,
        favouritesOnly: true,
        sort: KitchenSort.rating,
        zone: 'Banani',
      );
      return KitchenQuery.fromParams(q.toParams()) == q &&
          KitchenQuery.fromParams(const KitchenQuery().toParams()) ==
              const KitchenQuery();
    },
  ),
];

/// MockFavouriteRepository (NC-01, NC-02, NC-18): signed-in customer only.
final favouriteChecks = <RepoCheck>[
  (
    name: 'favourites: a read after setFavourite returns the written value',
    run: () async {
      final repo = MockFavouriteRepository(behavior: _instant());
      final on = await repo.setFavourite(customerActor, _id(),
          kitchenId: 'maas-kitchen', favourite: true);
      final read1 = (await repo.favourites(customerActor)).valueOrNull;
      final off = await repo.setFavourite(customerActor, _id(),
          kitchenId: 'maas-kitchen', favourite: false);
      final read2 = (await repo.favourites(customerActor)).valueOrNull;
      return on.isOk &&
          off.isOk &&
          read1 != null &&
          read1.contains('maas-kitchen') &&
          read2 != null &&
          !read2.contains('maas-kitchen');
    },
  ),
  (
    name:
        'favourites: a guest is refused with permissionDenied and nothing changes',
    run: () async {
      final repo = MockFavouriteRepository(behavior: _instant());
      final read = await repo.favourites(guestCustomer);
      final write = await repo.setFavourite(guestCustomer, _id(),
          kitchenId: 'maas-kitchen', favourite: true);
      return read.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          write.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          repo.revision == 0;
    },
  ),
  (
    name: 'favourites: a failed write leaves the favourites unchanged',
    run: () async {
      final b = _instant();
      final repo = MockFavouriteRepository(behavior: b);
      final before = (await repo.favourites(customerActor)).valueOrNull;
      b.failNext(RepoErrorKind.temporarilyUnavailable);
      final w = await repo.setFavourite(customerActor, _id(),
          kitchenId: 'maas-kitchen', favourite: true);
      final after = (await repo.favourites(customerActor)).valueOrNull;
      return w.errorOrNull?.kind == RepoErrorKind.temporarilyUnavailable &&
          before != null &&
          after != null &&
          before.length == after.length &&
          after.containsAll(before) &&
          repo.revision == 0;
    },
  ),
  (
    name:
        'favourites: an absent and an unpublished kitchen return the same notAvailable',
    run: () async {
      final repo = MockFavouriteRepository(behavior: _instant());
      final absent = await repo.setFavourite(customerActor, _id(),
          kitchenId: 'no-such-kitchen', favourite: true);
      final hidden = await repo.setFavourite(customerActor, _id(),
          kitchenId: unpublishedKitchenIds.first, favourite: true);
      return absent.errorOrNull?.kind == RepoErrorKind.notAvailable &&
          absent.errorOrNull == hidden.errorOrNull &&
          repo.revision == 0;
    },
  ),
];

/// MockSubscriptionRepository (NC-04, NC-05, NC-15, NC-19).
final subscriptionChecks = <RepoCheck>[
  (
    name: 'subscriptions: a created draft is read back at version 1',
    run: () async {
      final repo = MockSubscriptionRepository(behavior: _instant());
      final d = (await repo.createDraft(customerActor, _id(),
              kitchenId: 'rinas-kitchen'))
          .valueOrNull;
      final read = d == null
          ? null
          : (await repo.draft(customerActor, d.id)).valueOrNull;
      return d != null &&
          read != null &&
          read.id == d.id &&
          read.version == 1 &&
          read.kitchenId == 'rinas-kitchen' &&
          read.cells.isEmpty;
    },
  ),
  (
    name:
        'subscriptions: a kitchen that is not accepting orders cannot start a draft',
    run: () async {
      final repo = MockSubscriptionRepository(behavior: _instant());
      final r = await repo.createDraft(customerActor, _id(),
          kitchenId: 'dhaka-tiffin');
      return r.errorOrNull?.kind == RepoErrorKind.businessRuleRejected &&
          repo.revision == 0;
    },
  ),
  (
    name: 'subscriptions: a saved schedule is read back with the next version',
    run: () async {
      final repo = MockSubscriptionRepository(behavior: _instant());
      final d = (await repo.createDraft(customerActor, _id(),
              kitchenId: 'rinas-kitchen'))
          .valueOrNull!;
      final saved = await repo.saveSchedule(customerActor, _id(),
          draftId: d.id,
          expectedVersion: 1,
          startDate: '2026-11-03',
          weeks: 2,
          billing: BillingFrequency.weekly,
          cells: const [
            ScheduleCell(
                date: '2026-11-03',
                slot: Slot.lunch,
                menuItemId: 'rk-thali',
                qty: 2),
          ]);
      final read = (await repo.draft(customerActor, d.id)).valueOrNull;
      return saved.isOk &&
          read != null &&
          read.version == 2 &&
          read.weeks == 2 &&
          read.billing == BillingFrequency.weekly &&
          read.cells.length == 1;
    },
  ),
  (
    name:
        'subscriptions: a stale expected version is a conflict and changes nothing',
    run: () async {
      final repo = MockSubscriptionRepository(behavior: _instant());
      final d = (await repo.createDraft(customerActor, _id(),
              kitchenId: 'rinas-kitchen'))
          .valueOrNull!;
      final r = await repo.saveSchedule(customerActor, _id(),
          draftId: d.id,
          expectedVersion: 5,
          startDate: '2026-11-03',
          weeks: 2,
          billing: BillingFrequency.weekly,
          cells: const []);
      final read = (await repo.draft(customerActor, d.id)).valueOrNull;
      return r.errorOrNull?.kind == RepoErrorKind.conflict &&
          read?.version == 1 &&
          repo.revision == 1;
    },
  ),
  (
    name:
        'subscriptions: a start date on or before today and 13 weeks are invalid',
    run: () async {
      final repo = MockSubscriptionRepository(behavior: _instant());
      final d = (await repo.createDraft(customerActor, _id(),
              kitchenId: 'rinas-kitchen'))
          .valueOrNull!;
      final early = await repo.saveSchedule(customerActor, _id(),
          draftId: d.id,
          expectedVersion: 1,
          startDate: mockToday,
          weeks: 2,
          billing: BillingFrequency.weekly,
          cells: const []);
      final long = await repo.saveSchedule(customerActor, _id(),
          draftId: d.id,
          expectedVersion: 1,
          startDate: '2026-11-03',
          weeks: 13,
          billing: BillingFrequency.weekly,
          cells: const []);
      return early.errorOrNull?.field == 'startDate' &&
          long.errorOrNull?.field == 'weeks' &&
          repo.revision == 1;
    },
  ),
  (
    name: 'subscriptions: a weekly pattern repeats on the chosen weekdays only',
    run: () async {
      final repo = MockSubscriptionRepository(behavior: _instant());
      final d = (await repo.createDraft(customerActor, _id(),
              kitchenId: 'rinas-kitchen'))
          .valueOrNull!;
      final r = await repo.savePattern(customerActor, _id(),
          draftId: d.id,
          expectedVersion: 1,
          rule: const RecurrenceRule(
              weekdays: {1, 3, 5},
              slot: Slot.lunch,
              menuItemId: 'rk-thali',
              qty: 1,
              weeks: 2),
          exceptions: const [
            ScheduleException(date: '2026-11-06', skip: true)
          ]);
      final cells = r.valueOrNull?.cells;
      if (cells == null) return false;
      for (final c in cells) {
        final day = DateTime.utc(int.parse(c.date.substring(0, 4)),
            int.parse(c.date.substring(5, 7)), int.parse(c.date.substring(8)));
        if (!{1, 3, 5}.contains(day.weekday)) return false;
      }
      return cells.length == 5 && cells.every((c) => c.date != '2026-11-06');
    },
  ),
  (
    name:
        'subscriptions: two exceptions on the same date are a conflict, never merged',
    run: () async {
      final repo = MockSubscriptionRepository(behavior: _instant());
      final d = (await repo.createDraft(customerActor, _id(),
              kitchenId: 'rinas-kitchen'))
          .valueOrNull!;
      final r = await repo.savePattern(customerActor, _id(),
          draftId: d.id,
          expectedVersion: 1,
          rule: const RecurrenceRule(
              weekdays: {1, 3},
              slot: Slot.lunch,
              menuItemId: 'rk-thali',
              qty: 1,
              weeks: 1),
          exceptions: const [
            ScheduleException(date: '2026-11-04', skip: true),
            ScheduleException(date: '2026-11-04', menuItemId: 'rk-khichuri'),
          ]);
      final read = (await repo.draft(customerActor, d.id)).valueOrNull;
      return r.errorOrNull?.kind == RepoErrorKind.conflict &&
          read?.version == 1;
    },
  ),
  (
    name:
        'subscriptions: a guest is refused and an absent draft is notAvailable',
    run: () async {
      final repo = MockSubscriptionRepository(behavior: _instant());
      final guest = await repo.createDraft(guestCustomer, _id(),
          kitchenId: 'rinas-kitchen');
      final absent = await repo.draft(customerActor, 'DR-404');
      return guest.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          absent.errorOrNull?.kind == RepoErrorKind.notAvailable &&
          repo.revision == 0;
    },
  ),
  (
    name:
        'subscriptions: the change history pages and a foreign subscription is notAvailable',
    run: () async {
      final repo = MockSubscriptionRepository(behavior: _instant());
      final page = (await repo.changeHistory(
              customerActor, MockSubscriptionRepository.activeSubscription))
          .valueOrNull;
      final foreign = await repo.changeHistory(customerActor, 'SUB-999');
      return page != null &&
          page.items.length == 5 &&
          page.atEnd &&
          foreign.errorOrNull?.kind == RepoErrorKind.notAvailable;
    },
  ),
  (
    name:
        'subscriptions: an accepted renewal is read back; an expired offer is refused',
    run: () async {
      final repo = MockSubscriptionRepository(behavior: _instant());
      final accepted = await repo.respondToRenewal(customerActor, _id(),
          offerId: 'RO-301', accept: true);
      final read = (await repo.renewalOffer(
              customerActor, MockSubscriptionRepository.activeSubscription))
          .valueOrNull;
      final again = await repo.respondToRenewal(customerActor, _id(),
          offerId: 'RO-301', accept: false);
      final expired = await repo.respondToRenewal(customerActor, _id(),
          offerId: 'RO-299', accept: true);
      return accepted.isOk &&
          read?.status == RenewalStatus.accepted &&
          again.errorOrNull?.kind == RepoErrorKind.businessRuleRejected &&
          expired.errorOrNull ==
              const RepoError(RepoErrorKind.businessRuleRejected,
                  field: 'expired');
    },
  ),
  (
    name: 'subscriptions: a failed save leaves the draft unchanged',
    run: () async {
      final b = _instant();
      final repo = MockSubscriptionRepository(behavior: b);
      final d = (await repo.createDraft(customerActor, _id(),
              kitchenId: 'rinas-kitchen'))
          .valueOrNull!;
      b.failNext(RepoErrorKind.temporarilyUnavailable);
      final r = await repo.saveSchedule(customerActor, _id(),
          draftId: d.id,
          expectedVersion: 1,
          startDate: '2026-11-03',
          weeks: 2,
          billing: BillingFrequency.weekly,
          cells: const [
            ScheduleCell(
                date: '2026-11-03',
                slot: Slot.lunch,
                menuItemId: 'rk-thali',
                qty: 1),
          ]);
      final read = (await repo.draft(customerActor, d.id)).valueOrNull;
      return r.errorOrNull?.kind == RepoErrorKind.temporarilyUnavailable &&
          read != null &&
          read.version == 1 &&
          read.cells.isEmpty;
    },
  ),
];

/// MockQuoteRepository (NC-07, NC-08, NC-14, NC-19): total = sum of lines.
final quoteChecks = <RepoCheck>[
  (
    name: 'quotes: a quote of a saved draft totals the sum of its lines',
    run: () async {
      final subs = MockSubscriptionRepository(behavior: _instant());
      final quotes = MockQuoteRepository(
          behavior: _instant(),
          subscriptions: subs,
          credits: MockCreditRepository(behavior: _instant()));
      final d = (await subs.createDraft(customerActor, _id(),
              kitchenId: 'rinas-kitchen'))
          .valueOrNull!;
      await subs.saveSchedule(customerActor, _id(),
          draftId: d.id,
          expectedVersion: 1,
          startDate: '2026-11-03',
          weeks: 1,
          billing: BillingFrequency.weekly,
          cells: const [
            ScheduleCell(
                date: '2026-11-03',
                slot: Slot.lunch,
                menuItemId: 'rk-thali',
                qty: 2),
            ScheduleCell(
                date: '2026-11-04',
                slot: Slot.lunch,
                menuItemId: 'rk-khichuri',
                qty: 1),
          ]);
      final q = (await quotes.createQuote(customerActor, _id(), draftId: d.id))
          .valueOrNull;
      final read = q == null
          ? null
          : (await quotes.quote(customerActor, q.id)).valueOrNull;
      if (read == null) return false;
      final sum = read.lines.fold<int>(0, (a, l) => a + l.amountMinor);
      return read.totalMinor == sum && sum == 2 * 18000 + 16000;
    },
  ),
  (
    name: 'quotes: a draft without meals cannot be quoted',
    run: () async {
      final subs = MockSubscriptionRepository(behavior: _instant());
      final quotes =
          MockQuoteRepository(behavior: _instant(), subscriptions: subs);
      final d = (await subs.createDraft(customerActor, _id(),
              kitchenId: 'rinas-kitchen'))
          .valueOrNull!;
      final r = await quotes.createQuote(customerActor, _id(), draftId: d.id);
      return r.errorOrNull ==
              const RepoError(RepoErrorKind.invalidInput, field: 'cells') &&
          quotes.revision == 0;
    },
  ),
  (
    name: 'quotes: confirming an expired quote is refused and changes nothing',
    run: () async {
      final quotes = MockQuoteRepository(behavior: _instant());
      final r = await quotes.confirmQuote(customerActor, _id(),
          quoteId: MockQuoteRepository.expiredQuoteId);
      final read = (await quotes.quote(
              customerActor, MockQuoteRepository.expiredQuoteId))
          .valueOrNull;
      return r.errorOrNull ==
              const RepoError(RepoErrorKind.businessRuleRejected,
                  field: 'expired') &&
          read?.status == QuoteStatus.expired &&
          quotes.revision == 0;
    },
  ),
  (
    name: 'quotes: a confirmed quote is read back as confirmed',
    run: () async {
      final quotes = MockQuoteRepository(behavior: _instant());
      final r = await quotes.confirmQuote(customerActor, _id(),
          quoteId: MockQuoteRepository.cartQuoteId);
      final read =
          (await quotes.quote(customerActor, MockQuoteRepository.cartQuoteId))
              .valueOrNull;
      return r.isOk && read?.status == QuoteStatus.confirmed;
    },
  ),
  (
    name:
        'quotes: a reserved credit is its own line and the total stays the sum of the lines',
    run: () async {
      final credits = MockCreditRepository(behavior: _instant());
      final quotes =
          MockQuoteRepository(behavior: _instant(), credits: credits);
      await credits.reserveCredit(customerActor, _id(),
          quoteId: MockQuoteRepository.cartQuoteId, amountMinor: 5000);
      final q =
          (await quotes.quote(customerActor, MockQuoteRepository.cartQuoteId))
              .valueOrNull;
      if (q == null) return false;
      final sum = q.lines.fold<int>(0, (a, l) => a + l.amountMinor);
      return q.lines.any((l) =>
              l.kind == QuoteLineKind.credit && l.amountMinor == -5000) &&
          q.totalMinor == sum &&
          sum == 18000 - 5000;
    },
  ),
  (
    name:
        'quotes: an unknown quote is notAvailable for the quote and its price explanation',
    run: () async {
      final quotes = MockQuoteRepository(behavior: _instant());
      final q = await quotes.quote(customerActor, 'Q-404');
      final e = await quotes.priceExplanation(customerActor, 'Q-404');
      return q.errorOrNull?.kind == RepoErrorKind.notAvailable &&
          e.errorOrNull?.kind == RepoErrorKind.notAvailable;
    },
  ),
  (
    name:
        'quotes: the price explanation never invents an unconfigured fee (BR-007)',
    run: () async {
      final quotes = MockQuoteRepository(behavior: _instant());
      final e = (await quotes.priceExplanation(
              customerActor, MockQuoteRepository.cartQuoteId))
          .valueOrNull;
      return e != null && !e.feeConfigured && !e.groupedDelivery;
    },
  ),
  (
    name: 'quotes: a guest is refused',
    run: () async {
      final quotes = MockQuoteRepository(behavior: _instant());
      final r =
          await quotes.quote(guestCustomer, MockQuoteRepository.cartQuoteId);
      return r.errorOrNull?.kind == RepoErrorKind.permissionDenied;
    },
  ),
];
