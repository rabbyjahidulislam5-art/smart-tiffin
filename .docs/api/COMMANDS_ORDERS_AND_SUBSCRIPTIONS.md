# Commands: orders, subscriptions and credits

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Backend and API architect |
| Purpose | Full command contracts for quotes, one-time orders, subscription agreements/schedules/obligations, and service credits — file code **OS** in [API_SPECIFICATION.md](API_SPECIFICATION.md) §12. |
| Status | See status column. |

Format per command: **Purpose · Callers · Request · Response · Errors · Idempotency/transaction · Events · Screens · Refs.**

## `createQuote` (PROP)
Purpose: compute an immutable server price snapshot for a selection. Callers: Cust. Request: `{items[] | obligationChanges[], addressId, deliveryWindow}`. Response: `{quoteId, lines[], totalMinor, expiresAt}`. Errors: `invalid_input`, `out_of_zone`. Idempotency: FS-TX; a repeated identical request returns a fresh quote (quotes are not deduplicated by nature, but the receipt still prevents double-processing of the same `requestId`). Screens: C-07/C-08, NC-08. Refs: FR-030; BR-002, BR-007, BR-008, BR-009, BR-018.

## `confirmQuote` (PROP, SAGA)
Purpose: lock a quote for checkout, reserving stock. Callers: Cust. Request: `{quoteId, expectedTotalMinor}`. Errors: `quote_mismatch` (client's expected total disagrees with server), `cutoff_passed`, `quote_expired`. Idempotency: FS-TX (stock) then outbox to PG payment step. Screens: C-08, NC-08. Refs: FR-030, FR-032.

## `placeOneTimeOrder` (PROP, SAGA)
Purpose: create a one-time order from a confirmed quote. Callers: Cust. Request: `{quoteId, paymentMethod}`. Response: `{orderId, status:"Pending"}`. Errors: `stock_unavailable` (SC-20). Idempotency: FS→PG SAGA; COD invoicing posts `codInvoiced`. Events: order-created (outbox to MOD-NOT, MOD-DLV). Screens: C-08, NC-14. Refs: FR-028, FR-034; BR-002, BR-012.

## `placeOrder` (OBS-G, legacy alias of `placeOneTimeOrder`)
Status today: `failed-precondition` pending BR-002. Successor relationship: §12.2. Screens: C-08 (legacy). Refs: FR-007; BR-002.

## `cancelOrder` (PROP, gated BR-005)
Purpose: cancel an order within policy. Callers: Cust (own), Adm. Request: `{orderId, reason}`. Errors: `cancellation_window_closed`. Idempotency: FS→PG SAGA; posts `journalReversal` of `codInvoiced` where applicable. Screens: C-16/C-17. Refs: FR-007, FR-039; BR-005.

## `requestCancellation` (OBS-G, BR-005)
Purpose: the *request* step preceding a decision via `cancelOrder`/`cancelSubscription`. Callers: Cust, Sup. Screens: C-16. Refs: FR-007, FR-031; BR-005.

## `acceptOrder` / `declineOrder` / `advancePreparation` (OBS-G, DEC-014)
Purpose: supplier-side order lifecycle. Callers: Sup. `declineOrder` (with BR-005) posts to PG SAGA for any COD invoice reversal. Screens: S-01 ReqCard, S-02. Refs: FR-017; BR-005 (decline only).

## `createSubscriptionDraft` (PROP)
Purpose: start a subscription agreement. Callers: Cust. Request: `{kitchenId}`. Response: `{subscriptionId, status:"Draft"}`. Screens: NC-04. Refs: FR-029.

## `saveSubscriptionSchedule` (PROP)
Purpose: define/update the recurrence rule and exceptions for a draft or active agreement, creating a new `ent.SubscriptionVersion`. Callers: Cust. Request: `{subscriptionId, recurrenceRule, exceptions[], startDate, endDate?}`. Errors: `unsupported_combination` (e.g. multi-kitchen before BR-021 approval). Idempotency: FS-TX, versioned. Screens: NC-04, NC-05. Refs: FR-029.

## `quoteScheduleChange` (PROP)
Purpose: price a proposed skip/pause/replace/upgrade/downgrade before confirmation. Callers: Cust. Request: `{obligationId, changeType, replacementMealId?}`. Response: `{adjustmentQuoteId, creditOrChargeMinor, direction}`. Refs: FR-030, FR-031; BR-001, BR-006, BR-017.

## `confirmScheduleChange` (PROP, SAGA)
Purpose: apply a previously quoted schedule change exactly once. Callers: Cust. Request: `{adjustmentQuoteId}`. Idempotency: unique per `adjustmentQuoteId`; posts via `issueCredit` or a new invoice. Screens: NC-09, NC-10. Refs: FR-031; BR-017.

## `skipMeals` (PROP, gated BR-001/BR-006)
Purpose: skip one or more eligible obligations, producing a credit. Callers: Cust. Request: `{obligationIds[]}`. Errors: `cutoff_passed`, `already_dispatched`. Idempotency: unique credit per obligation origin (INV-08); a lost-response retry returns the original receipt (SC-04). Events: `creditIssued` via `issueCredit`. Screens: C-14, NC-09. Refs: FR-031, FR-032; BR-001, BR-006.

## `pauseSlots` (PROP, gated BR-001)
Purpose: exclude dates or a specific slot for a period. Callers: Cust. Request: `{subscriptionId, dateRange, slots[]}`. Screens: C-14, NC-05. Refs: FR-031; BR-001.

## `pauseMeals` (OBS-G, legacy alias)
Status today: `failed-precondition` pending BR-001/BR-002. Successor: `pauseSlots`/`skipMeals`/`resumeSubscription` (§12.2). Screens: C-14. Refs: FR-008; BR-001.

## `subscribe` (OBS-G, legacy alias)
Status today: `failed-precondition` pending BR-002. Successor: the draft→schedule→quote→confirm chain. Screens: C-11, C-12. Refs: FR-006; BR-002.

## `resumeSubscription` (PROP, gated BR-001)
Purpose: resume a paused agreement. Callers: Cust. Screens: C-13 "Unpause day". Refs: FR-031; BR-001.

## `replaceMeal` (PROP, gated BR-017)
Purpose: swap a future obligation's meal. Callers: Cust. Request: `{obligationId, replacementMealId, expectedDifferenceMinor}`. Idempotency: FS→PG SAGA; posts via `issueCredit` or a new invoice; never fulfils both the old and new meal (SC-05/SC-06). Screens: C-15, NC-10. Refs: FR-031; BR-017.

## `cancelSubscription` (PROP, gated BR-005)
Purpose: terminate an agreement. Callers: Cust (own), Adm. Idempotency: FS→PG SAGA. Screens: C-10. Refs: FR-031, FR-039; BR-005.

## `generateMealObligations` (PROP, Scheduled job)
Purpose: materialise `ent.MealObligation` rows from an active schedule. Callers: Sys (daily). Idempotency: per-subscription-per-date key, safe to re-run. Refs: FR-016, FR-029, FR-050.

## `renewSubscription` (PROP, System offer + Customer decision)
Purpose: offer and accept/decline a renewed term. Callers: Sys (offer), Cust (accept/decline). Screens: NC-19. Refs: FR-029, FR-035.

## `issueCredit` (PROP, Internal)
Purpose: post a credit transaction from an approved adjustment source. Callers: internal only (from `skipMeals`, `replaceMeal`, cancellation, or a manual adjustment). Idempotency: unique origin (INV-08). Events: `creditIssued`/`promoCreditIssued`. Refs: FR-032; BR-006.

## `reserveCredit` / `consumeCredit` / `releaseCredit` / `voidCredit` / `expireCredits` (PROP)
Purpose: the credit-account lifecycle (glossary §4 states). `reserveCredit`: Cust, at checkout. `consumeCredit`: internal, on payment completion. `releaseCredit`: Cust (cancel redemption) or Sys (reservation expiry). `voidCredit`: AcMgr, checking an AcOp request — posts `journalReversal` of `creditIssued`. `expireCredits`: Sys, gated on BR-019 approval. Idempotency: balance never negative (INV-07). Screens: NC-11, NC-16. Refs: FR-032; BR-019, BR-025 (void/expire).
