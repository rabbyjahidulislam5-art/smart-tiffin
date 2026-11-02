# ADR-005: Hybrid datastore — Firestore for operations, PostgreSQL for the ledger

| Field | Value |
|---|---|
| Status | PROPOSED — NOT APPROVED |
| Date | 2026-10-30 |

## Context

The master prompt (USER-REQ) explicitly asks to re-evaluate Firebase against a transactional relational database for financial records, considering consistency, transaction guarantees, concurrent modification, auditability, scalability, operational cost and integration complexity, and to recommend one coherent architecture rather than combine technologies without clear responsibilities.

## Options considered

1. **Firestore only.** Keep every entity, including the ledger, in Firestore; implement double-entry balancing in application-level transactions.
2. **PostgreSQL only.** Move all data, including operational/mobile-read-heavy entities, to a relational database.
3. **Hybrid.** Firestore for operational and read-model entities (catalogue, orders, subscriptions, delivery, notifications); a managed PostgreSQL instance for the financial domain (ledger, payments, COD, credits, earnings, payouts, reconciliation), reached only through the trusted backend.

| Criterion | Firestore only | PostgreSQL only | Hybrid |
|---|---|---|---|
| Multi-document ACID transactions for a balanced journal | Possible but limited (bounded transaction scope, no native foreign keys) | Native | Native, scoped to the module that needs it |
| Query/aggregation for reconciliation and reporting | Weak without extra infrastructure | Strong (SQL) | Strong where it matters (ledger), unchanged where it already works (catalogue) |
| Mobile offline-read ergonomics | Strong (OBSERVED, already used) | Requires a separate sync layer | Strong, unchanged for operational data |
| Migration cost from current code | None | High (rewrite everything) | Low (ledger domain is new anyway; nothing existing moves) |
| Operational cost/complexity | One system | One system, but a rewrite | Two systems, one new |

## Decision

Option 3. Firestore keeps the entities it already serves well (OBSERVED baseline, [database/DATABASE_DESIGN.md](../database/DATABASE_DESIGN.md) §FS entities); a managed PostgreSQL instance owns the ledger and financial entities (§PG entities) with native ACID transactions, constraints and SQL aggregation for reconciliation and reporting. An outbox pattern keeps the two stores consistent (see [database/DATA_CONSISTENCY.md](../database/DATA_CONSISTENCY.md)).

## Consequences

Two systems to operate instead of one, and a cross-store consistency mechanism to build and test (NFR-026). In exchange: native relational guarantees for money, far simpler financial reporting SQL, and zero migration cost for the data that already works. This is the architecture change with the highest implementation cost in the whole programme and is explicitly flagged for separate budget/provider approval (DEC-010).

## Risks

Unbudgeted second cloud dependency (RISK-021); reconciliation job complexity; team unfamiliarity with operating two datastores.

## Links

[architecture/TECH_STACK.md](../architecture/TECH_STACK.md), [database/FINANCIAL_DATA_MODEL.md](../database/FINANCIAL_DATA_MODEL.md), [database/DATA_CONSISTENCY.md](../database/DATA_CONSISTENCY.md).
