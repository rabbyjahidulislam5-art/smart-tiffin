# ADR-009: Server quotation with immutable price snapshots

| Field | Value |
|---|---|
| Status | PROPOSED — NOT APPROVED |
| Date | 2026-10-30 |

## Context

USER-REQ (pricing transparency and snapshots governance section): never trust a total calculated solely in a client widget; show a fresh quotation before purchase or a costlier substitution; preserve original paid prices after a supplier changes tomorrow's menu; every financial line needs a clear responsible entity and stable source identifier; totals must agree across the quote, invoice, payment initiation request, ledger posting and customer credit statement.

## Options considered

1. Compute the total client-side from the current catalogue state at checkout time.
2. Compute the total server-side on every checkout call, without persisting an intermediate record.
3. Compute the total server-side and persist it as an immutable `ent.Quote` snapshot with an expiry, referenced by every downstream record (order, invoice, payment, journal).

## Decision

Option 3. A client-computed total (option 1) is explicitly forbidden by NFR-017; a server-computed-but-not-persisted total (option 2) cannot explain, after the fact, why an invoice shows a particular figure if the catalogue changed in between. Persisting the snapshot (option 3) gives every downstream document one shared, immutable source of truth.

## Consequences

An additional entity and expiry-management concern (a stale quote must trigger a re-quote, not a silent re-price), but every total in the system — quote, invoice, payment amount, ledger posting, credit statement — can be traced to exactly one snapshot (INV-18).

## Risks

Quote expiry handling implemented inconsistently across the four apps (mitigated by one shared `api_clients` package helper); a promotion that expires mid-quote-lifetime needs an explicit rule (BR-008).

## Links

[payments/PRICING_AND_BILLING.md](../payments/PRICING_AND_BILLING.md), [database/FINANCIAL_DATA_MODEL.md](../database/FINANCIAL_DATA_MODEL.md), INV-18, NFR-017.
