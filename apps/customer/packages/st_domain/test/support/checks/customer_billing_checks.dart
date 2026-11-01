import 'package:st_domain/st_domain.dart';

import '../repo_check.dart';
import 'customer_checks.dart';

MockBehavior _instant() => MockBehavior.instant();

RequestId _id() => RequestId.next('t');

/// MockScheduleRepository (NC-06, NC-09, NC-10): own obligations only;
/// a skip issues exactly one service credit (INV-08).
final scheduleChecks = <RepoCheck>[
  (
    name:
        'schedule: November lists one lunch per service day (Sundays excluded)',
    run: () async {
      final list = (await MockScheduleRepository(behavior: _instant())
              .month(customerActor, period: '2026-11'))
          .valueOrNull;
      return list != null &&
          list.length == 25 &&
          list.every(
              (o) => o.slot == Slot.lunch && o.date.startsWith('2026-11'));
    },
  ),
  (
    name: 'schedule: a malformed period is invalid input',
    run: () async {
      final r = await MockScheduleRepository(behavior: _instant())
          .month(customerActor, period: '2026-1');
      return r.errorOrNull?.field == 'period';
    },
  ),
  (
    name: 'schedule: the skip preview shows the credit before confirmation',
    run: () async {
      final p = (await MockScheduleRepository(behavior: _instant())
              .previewChange(customerActor,
                  obligationId: 'OB-20261110', kind: ScheduleChangeKind.skip))
          .valueOrNull;
      return p != null && p.creditMinor == 18000 && p.chargeMinor == 0;
    },
  ),
  (
    name:
        'schedule: a skip is read back and issues exactly one service credit (INV-08)',
    run: () async {
      final credits = MockCreditRepository(behavior: _instant());
      final repo =
          MockScheduleRepository(behavior: _instant(), credits: credits);
      final before = (await credits.account(customerActor)).valueOrNull!;
      final first = await repo.skipMeals(customerActor, _id(),
          obligationId: 'OB-20261110');
      final second = await repo.skipMeals(customerActor, _id(),
          obligationId: 'OB-20261110');
      final read =
          (await repo.obligation(customerActor, 'OB-20261110')).valueOrNull;
      final after = (await credits.account(customerActor)).valueOrNull!;
      return first.isOk &&
          second.errorOrNull?.kind == RepoErrorKind.businessRuleRejected &&
          read?.status == ObligationStatus.skipped &&
          after.availableMinor - before.availableMinor == read!.priceMinor;
    },
  ),
  (
    name: 'schedule: a lost-response retry returns the original skip receipt',
    run: () async {
      final repo = MockScheduleRepository(behavior: _instant());
      final id = _id();
      final first =
          await repo.skipMeals(customerActor, id, obligationId: 'OB-20261110');
      final retry =
          await repo.skipMeals(customerActor, id, obligationId: 'OB-20261110');
      return first.isOk && first == retry && repo.revision == 1;
    },
  ),
  (
    name:
        'schedule: a dearer replacement needs the payment step and the old meal stays until then',
    run: () async {
      final repo = MockScheduleRepository(behavior: _instant());
      final refused = await repo.confirmScheduleChange(customerActor, _id(),
          obligationId: 'OB-20261111', newMenuItemId: 'rk-thali');
      final still =
          (await repo.obligation(customerActor, 'OB-20261111')).valueOrNull;
      final paid = await repo.confirmScheduleChange(customerActor, _id(),
          obligationId: 'OB-20261111',
          newMenuItemId: 'rk-thali',
          paymentConfirmed: true);
      final read =
          (await repo.obligation(customerActor, 'OB-20261111')).valueOrNull;
      return refused.errorOrNull?.field == 'payment' &&
          still?.menuItemId == 'rk-khichuri' &&
          still?.status == ObligationStatus.scheduled &&
          paid.isOk &&
          read?.menuItemId == 'rk-thali' &&
          read?.status == ObligationStatus.replaced;
    },
  ),
  (
    name:
        'schedule: a cheaper replacement credits the difference without a payment step',
    run: () async {
      final credits = MockCreditRepository(behavior: _instant());
      final repo =
          MockScheduleRepository(behavior: _instant(), credits: credits);
      final before = (await credits.account(customerActor)).valueOrNull!;
      final preview = (await repo.previewChange(customerActor,
              obligationId: 'OB-20261110',
              kind: ScheduleChangeKind.replace,
              newMenuItemId: 'rk-khichuri'))
          .valueOrNull;
      final r = await repo.confirmScheduleChange(customerActor, _id(),
          obligationId: 'OB-20261110', newMenuItemId: 'rk-khichuri');
      final after = (await credits.account(customerActor)).valueOrNull!;
      return preview?.creditMinor == 2000 &&
          preview?.chargeMinor == 0 &&
          r.isOk &&
          after.availableMinor - before.availableMinor == 2000;
    },
  ),
  (
    name: 'schedule: a dispatched meal past cutoff cannot be changed',
    run: () async {
      final repo = MockScheduleRepository(behavior: _instant());
      final o =
          (await repo.obligation(customerActor, 'OB-20261102')).valueOrNull;
      final r = await repo.skipMeals(customerActor, _id(),
          obligationId: 'OB-20261102');
      return o?.status == ObligationStatus.dispatched &&
          o?.changeable == false &&
          r.errorOrNull?.kind == RepoErrorKind.businessRuleRejected &&
          repo.revision == 0;
    },
  ),
  (
    name: 'schedule: replacement options stay in the same kitchen and slot',
    run: () async {
      final list = (await MockScheduleRepository(behavior: _instant())
              .replacementOptions(customerActor, 'OB-20261110'))
          .valueOrNull;
      return list != null &&
          list.isNotEmpty &&
          list.every((m) =>
              m.kitchenId == 'rinas-kitchen' &&
              m.slot == Slot.lunch &&
              m.id != 'rk-thali');
    },
  ),
  (
    name:
        'schedule: a guest is refused and an absent obligation is notAvailable',
    run: () async {
      final repo = MockScheduleRepository(behavior: _instant());
      final guest = await repo.month(guestCustomer, period: '2026-11');
      final absent = await repo.obligation(customerActor, 'OB-19990101');
      return guest.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          absent.errorOrNull?.kind == RepoErrorKind.notAvailable;
    },
  ),
  (
    name:
        'schedule: a failed skip leaves the obligation and the credits unchanged',
    run: () async {
      final b = _instant();
      final credits = MockCreditRepository(behavior: _instant());
      final repo = MockScheduleRepository(behavior: b, credits: credits);
      b.failNext(RepoErrorKind.temporarilyUnavailable);
      final r = await repo.skipMeals(customerActor, _id(),
          obligationId: 'OB-20261110');
      final o =
          (await repo.obligation(customerActor, 'OB-20261110')).valueOrNull;
      final a = (await credits.account(customerActor)).valueOrNull;
      return r.errorOrNull?.kind == RepoErrorKind.temporarilyUnavailable &&
          o?.status == ObligationStatus.scheduled &&
          a?.availableMinor == 41000 &&
          repo.revision == 0;
    },
  ),
];

/// MockCreditRepository (NC-11, NC-16): never negative, one reservation per
/// quote (SC-23).
final creditChecks = <RepoCheck>[
  (
    name: 'credits: the account reads the balances without a network call',
    run: () async {
      final a = (await MockCreditRepository(behavior: _instant())
              .account(customerActor))
          .valueOrNull;
      return a != null && a.availableMinor == 41000 && a.reservedMinor == 0;
    },
  ),
  (
    name:
        'credits: a reservation is read back and lowers the available balance',
    run: () async {
      final repo = MockCreditRepository(behavior: _instant());
      final r = await repo.reserveCredit(customerActor, _id(),
          quoteId: 'Q-CART-1', amountMinor: 5000);
      final reserved =
          (await repo.reservedFor(customerActor, 'Q-CART-1')).valueOrNull;
      final a = (await repo.account(customerActor)).valueOrNull;
      return r.isOk &&
          reserved == 5000 &&
          a?.availableMinor == 36000 &&
          a?.reservedMinor == 5000;
    },
  ),
  (
    name:
        'credits: one quote cannot reserve twice and more than the balance is refused',
    run: () async {
      final repo = MockCreditRepository(behavior: _instant());
      await repo.reserveCredit(customerActor, _id(),
          quoteId: 'Q-CART-1', amountMinor: 5000);
      final twice = await repo.reserveCredit(customerActor, _id(),
          quoteId: 'Q-CART-1', amountMinor: 1000);
      final over = await repo.reserveCredit(customerActor, _id(),
          quoteId: 'Q-OTHER', amountMinor: 999999);
      final a = (await repo.account(customerActor)).valueOrNull;
      return twice.errorOrNull?.kind == RepoErrorKind.businessRuleRejected &&
          over.errorOrNull ==
              const RepoError(RepoErrorKind.businessRuleRejected,
                  field: 'amount') &&
          a?.availableMinor == 36000 &&
          repo.revision == 1;
    },
  ),
  (
    name:
        'credits: release returns the amount and consume moves it to consumed',
    run: () async {
      final repo = MockCreditRepository(behavior: _instant());
      await repo.reserveCredit(customerActor, _id(),
          quoteId: 'Q-A', amountMinor: 4000);
      await repo.reserveCredit(customerActor, _id(),
          quoteId: 'Q-B', amountMinor: 3000);
      final released =
          await repo.releaseCredit(customerActor, _id(), quoteId: 'Q-A');
      final consumed =
          await repo.consumeCredit(customerActor, _id(), quoteId: 'Q-B');
      final a = (await repo.account(customerActor)).valueOrNull;
      return released.isOk &&
          consumed.isOk &&
          a?.availableMinor == 41000 - 3000 &&
          a?.reservedMinor == 0 &&
          a?.consumedMinor == 18000 + 3000;
    },
  ),
  (
    name:
        'credits: a zero amount is invalid and nothing reserved cannot be consumed',
    run: () async {
      final repo = MockCreditRepository(behavior: _instant());
      final zero = await repo.reserveCredit(customerActor, _id(),
          quoteId: 'Q-A', amountMinor: 0);
      final none =
          await repo.consumeCredit(customerActor, _id(), quoteId: 'Q-NONE');
      return zero.errorOrNull?.kind == RepoErrorKind.invalidInput &&
          none.errorOrNull?.kind == RepoErrorKind.businessRuleRejected &&
          repo.revision == 0;
    },
  ),
  (
    name: 'credits: the class filter returns only that class, never merged',
    run: () async {
      final repo = MockCreditRepository(behavior: _instant());
      final promo = (await repo.transactions(customerActor,
              creditClass: CreditClass.promotional))
          .valueOrNull;
      final all = (await repo.transactions(customerActor)).valueOrNull;
      return promo != null &&
          promo.items.isNotEmpty &&
          promo.items.every((t) => t.creditClass == CreditClass.promotional) &&
          all != null &&
          all.items.length > promo.items.length;
    },
  ),
  (
    name:
        'credits: a guest is refused and a failed reservation changes nothing',
    run: () async {
      final b = _instant();
      final repo = MockCreditRepository(behavior: b);
      final guest = await repo.account(guestCustomer);
      b.failNext(RepoErrorKind.temporarilyUnavailable);
      final failed = await repo.reserveCredit(customerActor, _id(),
          quoteId: 'Q-A', amountMinor: 1000);
      final a = (await repo.account(customerActor)).valueOrNull;
      return guest.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          failed.errorOrNull?.kind == RepoErrorKind.temporarilyUnavailable &&
          a?.availableMinor == 41000 &&
          repo.revision == 0;
    },
  ),
];

/// MockBillingRepository (NC-12, NC-13).
final billingChecks = <RepoCheck>[
  (
    name: 'billing: weekly and monthly invoices are listed separately',
    run: () async {
      final repo = MockBillingRepository(behavior: _instant());
      final weekly =
          (await repo.invoices(customerActor, BillingFrequency.weekly))
              .valueOrNull;
      final monthly =
          (await repo.invoices(customerActor, BillingFrequency.monthly))
              .valueOrNull;
      return weekly != null &&
          monthly != null &&
          weekly.length == 3 &&
          monthly.length == 2 &&
          weekly.every((i) => i.variant == BillingFrequency.weekly);
    },
  ),
  (
    name: 'billing: a paid instalment is read back as paid with nothing due',
    run: () async {
      final repo = MockBillingRepository(behavior: _instant());
      final r =
          await repo.payInstalment(customerActor, _id(), invoiceId: 'INV-W-45');
      final read = (await repo.invoices(customerActor, BillingFrequency.weekly))
          .valueOrNull
          ?.firstWhere((i) => i.id == 'INV-W-45');
      return r.isOk &&
          read?.status == InvoiceStatus.paid &&
          read?.dueMinor == 0;
    },
  ),
  (
    name:
        'billing: a paid invoice cannot be paid again and an absent one is notAvailable',
    run: () async {
      final repo = MockBillingRepository(behavior: _instant());
      final again =
          await repo.payInstalment(customerActor, _id(), invoiceId: 'INV-M-11');
      final absent =
          await repo.payInstalment(customerActor, _id(), invoiceId: 'INV-404');
      return again.errorOrNull?.kind == RepoErrorKind.businessRuleRejected &&
          absent.errorOrNull?.kind == RepoErrorKind.notAvailable &&
          repo.revision == 0;
    },
  ),
  (
    name:
        'billing: the prepaid liability is not shown as consumed before every meal is done (SC-01)',
    run: () async {
      final p = (await MockBillingRepository(behavior: _instant())
              .prepaidLiability(customerActor))
          .valueOrNull;
      return p != null &&
          p.remainingMinor ==
              p.prepaidMinor - p.fulfilledMinor - p.creditedMinor &&
          p.remainingMinor > 0 &&
          p.obligationsDone < p.obligationsTotal;
    },
  ),
  (
    name:
        'billing: a guest is refused and a failed payment leaves the invoice due',
    run: () async {
      final b = _instant();
      final repo = MockBillingRepository(behavior: b);
      final guest = await repo.invoices(guestCustomer, BillingFrequency.weekly);
      b.failNext(RepoErrorKind.temporarilyUnavailable);
      final failed =
          await repo.payInstalment(customerActor, _id(), invoiceId: 'INV-W-45');
      final read = (await repo.invoices(customerActor, BillingFrequency.weekly))
          .valueOrNull
          ?.firstWhere((i) => i.id == 'INV-W-45');
      return guest.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          failed.errorOrNull?.kind == RepoErrorKind.temporarilyUnavailable &&
          read?.status == InvoiceStatus.due &&
          repo.revision == 0;
    },
  ),
];

MockCheckoutRepository _checkout(MockQuoteRepository quotes) =>
    MockCheckoutRepository(behavior: _instant(), quotes: quotes);

/// MockCheckoutRepository (NC-14): needs a confirmed quote; online payment
/// stays pending (SC-13).
final checkoutChecks = <RepoCheck>[
  (
    name: 'checkout: the summary reads the cart with the server quote',
    run: () async {
      final s = (await _checkout(MockQuoteRepository(behavior: _instant()))
              .summary(customerActor))
          .valueOrNull;
      return s != null &&
          s.lines.length == 1 &&
          s.quote.id == MockQuoteRepository.cartQuoteId &&
          s.quote.totalMinor == 18000;
    },
  ),
  (
    name: 'checkout: an order needs a confirmed quote',
    run: () async {
      final repo = _checkout(MockQuoteRepository(behavior: _instant()));
      final r = await repo.placeOneTimeOrder(customerActor, _id(),
          quoteId: MockQuoteRepository.cartQuoteId, payment: PaymentChoice.cod);
      return r.errorOrNull ==
              const RepoError(RepoErrorKind.businessRuleRejected,
                  field: 'quote') &&
          repo.revision == 0;
    },
  ),
  (
    name:
        'checkout: after confirmation COD places the order and online stays payment-pending',
    run: () async {
      final quotes = MockQuoteRepository(behavior: _instant());
      final repo = _checkout(quotes);
      await quotes.confirmQuote(customerActor, _id(),
          quoteId: MockQuoteRepository.cartQuoteId);
      final cod = (await repo.placeOneTimeOrder(customerActor, _id(),
              quoteId: MockQuoteRepository.cartQuoteId,
              payment: PaymentChoice.cod))
          .valueOrNull;
      final online = (await repo.placeOneTimeOrder(customerActor, _id(),
              quoteId: MockQuoteRepository.cartQuoteId,
              payment: PaymentChoice.online))
          .valueOrNull;
      return cod?.status == OrderStatus.placed &&
          cod?.totalMinor == 18000 &&
          online?.status == OrderStatus.paymentPending;
    },
  ),
  (
    name:
        'checkout: a repeated request id returns the first receipt, not a second order',
    run: () async {
      final quotes = MockQuoteRepository(behavior: _instant());
      final repo = _checkout(quotes);
      await quotes.confirmQuote(customerActor, _id(),
          quoteId: MockQuoteRepository.cartQuoteId);
      final id = _id();
      final a = await repo.placeOneTimeOrder(customerActor, id,
          quoteId: MockQuoteRepository.cartQuoteId, payment: PaymentChoice.cod);
      final b = await repo.placeOneTimeOrder(customerActor, id,
          quoteId: MockQuoteRepository.cartQuoteId, payment: PaymentChoice.cod);
      return a.isOk &&
          a.valueOrNull?.orderId == b.valueOrNull?.orderId &&
          repo.revision == 1;
    },
  ),
  (
    name: 'checkout: COD eligibility comes from the server check',
    run: () async {
      final e = (await _checkout(MockQuoteRepository(behavior: _instant()))
              .codEligibility(customerActor))
          .valueOrNull;
      return e != null && e.eligible && e.sample;
    },
  ),
  (
    name: 'checkout: a guest is refused and an unknown quote is notAvailable',
    run: () async {
      final repo = _checkout(MockQuoteRepository(behavior: _instant()));
      final guest = await repo.summary(guestCustomer);
      final unknown = await repo.placeOneTimeOrder(customerActor, _id(),
          quoteId: 'Q-404', payment: PaymentChoice.cod);
      return guest.errorOrNull?.kind == RepoErrorKind.permissionDenied &&
          unknown.errorOrNull?.kind == RepoErrorKind.notAvailable;
    },
  ),
];

/// MockRefundRepository (NC-17).
final refundChecks = <RepoCheck>[
  (
    name: 'refunds: the list reads refunds and disputes',
    run: () async {
      final page = (await MockRefundRepository(behavior: _instant())
              .refunds(customerActor))
          .valueOrNull;
      return page != null &&
          page.items.length == MockRefundRepository.fixtures.length &&
          page.items.any((r) => r.kind == CustomerRefundKind.dispute);
    },
  ),
  (
    name:
        'refunds: an executed refund carries the provider reference and a requested one does not',
    run: () async {
      final repo = MockRefundRepository(behavior: _instant());
      final done = (await repo.refund(customerActor, 'RF-19')).valueOrNull;
      final pending = (await repo.refund(customerActor, 'RF-21')).valueOrNull;
      return done?.status == CustomerRefundStatus.executed &&
          done?.providerRef != null &&
          pending?.status == CustomerRefundStatus.requested &&
          pending?.providerRef == null;
    },
  ),
  (
    name: 'refunds: an absent case is notAvailable and a guest is refused',
    run: () async {
      final repo = MockRefundRepository(behavior: _instant());
      final absent = await repo.refund(customerActor, 'RF-404');
      final guest = await repo.refunds(guestCustomer);
      return absent.errorOrNull?.kind == RepoErrorKind.notAvailable &&
          guest.errorOrNull?.kind == RepoErrorKind.permissionDenied;
    },
  ),
];
