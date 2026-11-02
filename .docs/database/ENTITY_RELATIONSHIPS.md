# Entity relationships

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Architecture lead |
| Purpose | Mermaid ER diagrams for the operational (Firestore) and financial (PostgreSQL) domains, and how they connect through the outbox. |
| Depends on | [Database design](DATABASE_DESIGN.md), [data dictionary](DATA_DICTIONARY.md), [financial data model](FINANCIAL_DATA_MODEL.md) |
| Status | PROPOSED — NOT APPROVED. |

## Identity and catalogue (Firestore)

```mermaid
erDiagram
  PRINCIPAL ||--o{ ROLE_GRANT : holds
  PRINCIPAL ||--|| USER : profile
  PRINCIPAL ||--o| SUPPLIER : "if approved"
  PRINCIPAL ||--o| RIDER : "if approved"
  SUPPLIER ||--o{ KITCHEN : owns
  KITCHEN ||--o{ MEAL : offers
  MEAL ||--o{ MEAL_VARIANT : has
  MEAL_VARIANT ||--o{ PRICE_VERSION : has
  KITCHEN ||--o{ SLOT_AVAILABILITY : publishes
  APPLICATION ||--o{ APPLICATION_DOCUMENT : includes
```

## Commerce (Firestore, snapshotted financially into PostgreSQL)

```mermaid
erDiagram
  CUSTOMER ||--o{ SUBSCRIPTION : agrees
  SUBSCRIPTION ||--o{ SUBSCRIPTION_VERSION : "has history"
  SUBSCRIPTION ||--|| SUBSCRIPTION_SCHEDULE : defines
  SUBSCRIPTION ||--o{ MEAL_OBLIGATION : generates
  CUSTOMER ||--o{ ORDER : places
  ORDER ||--o{ ORDER_ITEM : contains
  QUOTE ||--o| ORDER : confirms
  QUOTE ||--o| MEAL_OBLIGATION : prices
  MEAL_OBLIGATION ||--o| SUBSTITUTION : "may have"
  ORDER ||--|| DELIVERY_ASSIGNMENT : "has current"
  DELIVERY_ASSIGNMENT ||--o{ DELIVERY_EVENT : logs
```

## Financial (PostgreSQL)

```mermaid
erDiagram
  QUOTE ||--|| PAYMENT_INTENT : funds
  PAYMENT_INTENT ||--o{ PAYMENT_ATTEMPT : has
  PAYMENT_INTENT ||--o| GATEWAY_VERIFICATION : "verified by"
  ORDER_OR_OBLIGATION ||--o| COD_COLLECTION : "collected via"
  COD_COLLECTION }o--|| COD_REMITTANCE : "remitted in"
  CUSTOMER ||--|| CREDIT_ACCOUNT : owns
  CREDIT_ACCOUNT ||--o{ CREDIT_TRANSACTION : records
  SUPPLIER ||--o{ SUPPLIER_EARNING : accrues
  RIDER ||--o{ RIDER_EARNING : accrues
  SUPPLIER_EARNING }o--|| PAYOUT_REQUEST : "eligible for"
  RIDER_EARNING }o--|| PAYOUT_REQUEST : "eligible for"
  PAYOUT_REQUEST ||--|| PAYOUT_APPROVAL : requires
  PAYOUT_REQUEST }o--|| SETTLEMENT_BATCH : "released in"
  SETTLEMENT_BATCH ||--|| PAYOUT_RESULT : confirms
  JOURNAL_ENTRY ||--o{ JOURNAL_LINE : contains
  ACCOUNTING_PERIOD ||--o{ JOURNAL_ENTRY : bounds
```

## Cross-store link

```mermaid
flowchart LR
  FS["Firestore event<br/>(order fulfilled, meal recognised)"] -->|"outbox"| Consumer["Outbox consumer"]
  Consumer --> PG["PostgreSQL journal posting"]
  PG -->|"outbox"| ReadModel["Firestore read-model mirror<br/>(labelled projection, never authoritative)"]
```

## Acceptance and verification

Design-only. Verification requires a schema-level check that every PostgreSQL foreign-key-style reference (e.g. `CodRemittance.riderId`) resolves to an existing Firestore principal id at write time, enforced at the trusted-backend command layer since no native cross-store foreign key exists.
