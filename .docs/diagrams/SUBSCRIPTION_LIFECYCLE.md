# Subscription lifecycle diagrams

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Depends on | [ADR-014](../adr/014-subscription-agreement-and-meal-obligations.md), [customer-app/CUSTOM_SUBSCRIPTION_ENGINE.md](../customer-app/CUSTOM_SUBSCRIPTION_ENGINE.md) |
| Status | PROPOSED — NOT APPROVED. |

## Agreement states

```mermaid
stateDiagram-v2
  Draft --> PendingPayment
  PendingPayment --> Scheduled
  PendingPayment --> Active
  Scheduled --> Active
  Active --> Paused
  Paused --> Active
  Active --> PartiallyModified
  PartiallyModified --> Active
  Active --> Completed
  Active --> Cancelled
  Scheduled --> Cancelled
  Active --> Expired
```

## Obligation states

```mermaid
stateDiagram-v2
  Scheduled --> Skipped
  Scheduled --> Replaced
  Scheduled --> Preparing
  Preparing --> Ready
  Ready --> HandedOff
  HandedOff --> Delivered
  HandedOff --> Failed
  Scheduled --> Cancelled
```
