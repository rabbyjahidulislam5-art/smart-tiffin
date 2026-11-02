# Data consistency

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Architecture lead |
| Purpose | Define how Firestore and the proposed PostgreSQL ledger stay consistent, how stock/quote reservations expire safely, and how reconciliation detects (never silently fixes) a mismatch. |
| Depends on | [ADR-005](../adr/005-hybrid-datastore.md), [ADR-012](../adr/012-notifications-and-scheduled-jobs.md), [architecture/BACKEND_DOMAIN_DESIGN.md](../architecture/BACKEND_DOMAIN_DESIGN.md) |
| Status | PROPOSED — NOT APPROVED. |

## Outbox pattern (cross-store)

Every command that changes state in its owning store writes a domain event to an outbox row/collection in the **same transaction** as that state change. A separate, idempotent consumer reads unprocessed outbox rows and performs the dependent write in the other store (for example: a Firestore delivery-completion event triggers a PostgreSQL earning-recognition journal; a PostgreSQL payout settlement triggers a Firestore read-model update for the partner app's dashboard). The consumer marks a row processed only after its write succeeds, and is safe to run twice on the same row (NFR-005).

## Reservation and expiry consistency

Stock reservations (`ent.StockReservation`) and quote expiries (`ent.Quote.expiresAt`) are both Firestore-owned, time-bounded holds. A scheduled job releases expired reservations and marks expired quotes unusable; a payment that completes against an already-expired quote is rejected and triggers a refund path (SC-20), never a silent fulfilment against stale pricing.

## Reconciliation (detect, never auto-correct)

A periodic reconciliation job compares: (a) Firestore operational events (order fulfilled, delivery completed, application approved) against their expected PostgreSQL journal postings; (b) PostgreSQL gateway/COD records against external statements (see [accounts-web/PAYMENT_RECONCILIATION.md](../accounts-web/PAYMENT_RECONCILIATION.md)). Any mismatch raises an `ent.ReconciliationException`, assigned for human review — the job never adjusts a balance on its own (NFR-026, INV-16).

## Concurrency

Firestore writes use `expectedVersion` optimistic concurrency (ADR-008, OBSERVED mechanism extended); PostgreSQL writes use native row-level locking within a transaction. A command touching both stores performs its PostgreSQL transaction first (financial system of record) and only then writes the Firestore outbox event, so a PostgreSQL failure never leaves an orphaned Firestore side-effect.

## Acceptance and verification

Design-only. Verification requires: an injected outbox-consumer crash between the two stores' writes does not leave a duplicated or lost event after the consumer resumes; an injected clock skew between the two stores' servers does not change which accounting period a journal posts to (that is governed by `ent.AccountingPeriod`, not wall-clock time at write time).

## Open decisions

The specific outbox implementation (a Firestore collection polled by a Cloud Function versus a message queue) and the reconciliation job's run frequency are both open, pending the PostgreSQL provider decision (DEC-010).
