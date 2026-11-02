# Order management (Customer App)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Customer App domain author |
| Purpose | Define the one-time order lifecycle: cart, quote, checkout, stock reservation, tracking, cancellation and rating. |
| Applies to | CUS |
| Depends on | [api/COMMANDS_ORDERS_AND_SUBSCRIPTIONS.md](../api/COMMANDS_ORDERS_AND_SUBSCRIPTIONS.md), [payments/PRICING_AND_BILLING.md](../payments/PRICING_AND_BILLING.md) |
| Status | PROPOSED — NOT APPROVED. |

## 1. Lifecycle

Cart (local draft) → `createQuote` → `confirmQuote` (reserves stock, TTL-bounded) → `placeOneTimeOrder` (COD or sandbox online) → Pending → Picked Up → On The Way → Delivered (the four confirmed states, ADR-003 retained) | Failed (distinct exception outcome). Cancellation (`cancelOrder`, BR-005 PENDING) is available only within the approved eligibility window.

## 2. Stock race safety (SC-20)

Two customers racing for the last unit: `reserveStock` is atomic; the losing customer sees an honest sold-out state at `confirmQuote`, never a false success followed by a silent failure. If a payment somehow completes after the stock failure is already known, a refund is triggered automatically rather than fulfilling a non-existent order.

## 3. Tracking

Status-based by default (the four confirmed states); live map (C-18) is an explicit, consent-bound addition clearly distinguished from the legacy prototype's animated sample (NC overlap with [architecture/TIME_AND_CUTOFF_POLICY.md](../architecture/TIME_AND_CUTOFF_POLICY.md) consent note).

## 4. Rating and complaints

`submitReview` (gated on DEC-013) and `submitComplaint` remain available from the order detail screen (legacy C-17 → C-19/C-25), unchanged in intent from the original FR-011/FR-023.

## Acceptance and verification

Design-only. Verification requires the stock-race test (SC-20) and a cancellation-window boundary test once BR-005 is approved.
