# System context diagram

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Depends on | [architecture/SYSTEM_ARCHITECTURE.md](../architecture/SYSTEM_ARCHITECTURE.md) |
| Status | PROPOSED — NOT APPROVED. No renderer executed. |

```mermaid
flowchart TB
  Guest["Guest"] --> CUS["Customer App"]
  Customer["Customer"] --> CUS
  Supplier["Supplier"] --> PAR["Partner App"]
  Rider["Rider"] --> PAR
  Admin["Admin staff"] --> ADM["Admin Web"]
  Accounts["Accounts staff"] --> ACC["Accounts Web"]
  CUS --> BE["Trusted backend"]
  PAR --> BE
  ADM --> BE
  ACC --> BE
  BE --> FS["Firestore"]
  BE --> PG["PostgreSQL ledger (proposed)"]
  BE --> GW["SSLCOMMERZ (sandbox, future)"]
  BE --> Bank["Bank / MFS (payouts, remittance)"]
  BE --> Msg["Messaging provider (not selected)"]
  GW -->|"IPN"| BE
```
