# Accounts and settlement diagrams

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Depends on | [accounts-web/PAYOUT_MANAGEMENT.md](../accounts-web/PAYOUT_MANAGEMENT.md), [database/FINANCIAL_DATA_MODEL.md](../database/FINANCIAL_DATA_MODEL.md) |
| Status | PROPOSED — NOT APPROVED. |

## Earning recognition

```mermaid
sequenceDiagram
  participant Ev as Recognition event (delivery/milestone)
  participant BE as Backend
  participant PG as Ledger
  Ev->>BE: trigger
  BE->>PG: recognizeSupplierEarning / recognizeRiderEarning
  PG->>PG: post balanced journal
```

## Payout state machine (maker-checker)

```mermaid
stateDiagram-v2
  Requested --> UnderReview
  UnderReview --> Approved: different principal
  UnderReview --> Rejected
  Approved --> Processing
  Processing --> Settled: external confirmation
  Processing --> Failed
```

## Reconciliation

```mermaid
flowchart LR
  Op["Operational event"] --> Cmp["Compare"]
  Ledger["Ledger posting"] --> Cmp
  Cmp -->|"match"| Closed["Matched, closed"]
  Cmp -->|"mismatch"| Exc["ReconciliationException (never auto-corrected)"]
  Exc --> Review["Human review"]
  Review --> Resolve["Resolution journal"]
```
