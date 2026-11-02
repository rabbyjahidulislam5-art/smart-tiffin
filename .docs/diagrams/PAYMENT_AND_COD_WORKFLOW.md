# Payment and COD workflow diagrams

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Depends on | [payments/PAYMENT_ARCHITECTURE.md](../payments/PAYMENT_ARCHITECTURE.md), [payments/COD_PAYMENT_WORKFLOW.md](../payments/COD_PAYMENT_WORKFLOW.md) |
| Status | PROPOSED — NOT APPROVED. |

## Online payment: redirect vs IPN vs validation

```mermaid
sequenceDiagram
  participant C as Customer
  participant GW as Gateway
  participant BE as Backend
  C->>GW: pay
  GW-->>C: browser redirect (cosmetic, not trusted)
  GW->>BE: IPN
  BE->>BE: validateGatewayTransaction
  BE->>C: order activates only now
```

## COD: collection to remittance

```mermaid
stateDiagram-v2
  Recorded --> Confirmed
  Confirmed --> DueForRemittance
  DueForRemittance --> PartiallyRemitted
  DueForRemittance --> RemittedPendingVerification
  PartiallyRemitted --> RemittedPendingVerification
  RemittedPendingVerification --> Verified
  DueForRemittance --> Overdue
  RemittedPendingVerification --> Disputed
  Disputed --> Verified
  Disputed --> WrittenOff
```
