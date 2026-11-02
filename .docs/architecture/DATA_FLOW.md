# Data flow

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (supersedes 1.0, manual-reference-only flow) |
| Owner | Architecture lead |
| Purpose | Trace how data moves through the system for the core flows: ordering, subscription scheduling, payment, COD, earnings/settlement. |
| Depends on | [Backend domain design](BACKEND_DOMAIN_DESIGN.md), [database/DATA_CONSISTENCY.md](../database/DATA_CONSISTENCY.md) |
| Status | PROPOSED — NOT APPROVED. |

## Order and preparation (extends the original flow)

```mermaid
sequenceDiagram
  participant C as Customer App
  participant BE as Trusted backend
  participant FS as Firestore
  participant S as Partner App (Supplier)
  C->>BE: createQuote / confirmQuote
  BE->>FS: write Quote
  C->>BE: placeOneTimeOrder
  BE->>FS: reserveStock, write Order
  BE->>S: notify new order (outbox -> MOD-NOT)
  S->>BE: acceptOrder / advancePreparation
  BE->>FS: update Order, OrderEvent
```

## Subscription scheduling

```mermaid
sequenceDiagram
  participant C as Customer App
  participant BE as Trusted backend
  participant FS as Firestore
  participant Job as Scheduled job
  C->>BE: createSubscriptionDraft / saveSubscriptionSchedule
  BE->>FS: write Subscription, SubscriptionVersion, SubscriptionSchedule
  Job->>FS: generateMealObligations (daily)
  FS->>S: read obligations for cooking requirements
```

## Payment (online, sandbox only in this phase)

```mermaid
sequenceDiagram
  participant C as Customer App
  participant BE as Trusted backend
  participant PG as PostgreSQL ledger
  participant GW as SSLCOMMERZ (sandbox)
  C->>BE: initiatePayment
  BE->>PG: write PaymentIntent
  C->>GW: hosted redirect
  GW->>BE: IPN (server-to-server)
  BE->>BE: validateGatewayTransaction
  BE->>PG: write GatewayVerification, post journal
  BE->>C: order/subscription activates
```

## COD collection and remittance

```mermaid
sequenceDiagram
  participant Cu as Customer
  participant R as Partner App (Rider)
  participant BE as Trusted backend
  participant PG as PostgreSQL ledger
  participant Ac as Accounts Web
  Cu->>R: hands over cash on delivery
  R->>BE: recordCodCollection
  BE->>PG: write CodCollection, rider remittance liability
  R->>BE: submitCodRemittance
  Ac->>BE: verifyCodRemittance
  BE->>PG: close liability, post journal
```

## Earnings and settlement

```mermaid
sequenceDiagram
  participant BE as Trusted backend
  participant PG as PostgreSQL ledger
  participant P as Partner App (Supplier/Rider)
  participant Ac as Accounts Web
  BE->>PG: recognizeSupplierEarning / recognizeRiderEarning (on recognition event)
  P->>BE: requestPayout
  Ac->>BE: reviewPayout / approvePayout (different principal)
  BE->>PG: createPayoutBatch / releasePayoutBatch
  BE->>PG: recordPayoutResult (after external confirmation only)
```

## Cross-cutting rule

Every arrow into Firestore or PostgreSQL above happens inside a trusted-backend transaction with an idempotency receipt; no client writes a business-authoritative value directly, in any of the five flows.
