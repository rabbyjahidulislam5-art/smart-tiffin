# ADR-008: Extend the idempotent command envelope to all four apps and the financial domain

| Field | Value |
|---|---|
| Status | Accepted (OBSERVED base mechanism) and extended, PROPOSED — NOT APPROVED |
| Date | 2026-10-30 |

## Context

OBSERVED: `backend/functions/src/commands.js` already implements `{command, requestId, expectedVersion?, payload}` with a `sha256([uid, requestId])` receipt, a canonical-JSON request fingerprint, `expectedVersion` stale-write detection, and a 16 KB payload cap, in one Firestore transaction. The new scope adds money-moving commands across two stores and four client apps, raising the cost of a duplicate effect (a double credit, a double payout) far above the cost of a duplicate `saveProfile`.

## Options considered

1. Reuse the exact existing mechanism unchanged for every new command.
2. Add a stronger uniqueness constraint specifically for money-moving commands (a unique index on `(principal, command, requestId)` in the owning store, in addition to the receipt).
3. Introduce per-domain idempotency keys unrelated to `requestId` (for example, a COD deposit reference as its own uniqueness key, independent of which client request carried it).

## Decision

Combine options 1, 2 and 3: every command keeps the existing `requestId`-based receipt (option 1) as the baseline duplicate-request protection; every money-moving command additionally enforces a database-level unique constraint on its own natural key (option 2) — for example, one credit per skipped-obligation origin (INV-08), one verified remittance per deposit reference (INV-12); where the natural key comes from outside the system (option 3), such as a bank deposit reference, that external key is the uniqueness constraint, not the `requestId` of whichever staff member happened to submit it.

## Consequences

More constraints to design per financial entity, but a second independent defence against duplication beyond "hope the client sends the same `requestId` on retry" — which the client cannot always guarantee (for example, two different staff members independently keying the same bank deposit).

## Risks

A missed natural-key constraint on a new financial command type, re-opening a duplication path (mitigated by the acceptance checklist in [testing/FINANCIAL_TEST_CASES.md](../testing/FINANCIAL_TEST_CASES.md)).

## Links

[architecture/BACKEND_DOMAIN_DESIGN.md](../architecture/BACKEND_DOMAIN_DESIGN.md) §2, [database/FINANCIAL_DATA_MODEL.md](../database/FINANCIAL_DATA_MODEL.md), INV-04, INV-08, INV-12, NFR-005, NFR-015.
