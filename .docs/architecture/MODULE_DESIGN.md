# Module design

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (supersedes 1.0, nine modules, no finance domain) |
| Owner | Architecture lead |
| Purpose | Map every MOD-* backend module to the requirements, apps and entities it serves. |
| Depends on | [Backend domain design](BACKEND_DOMAIN_DESIGN.md), [functional requirements](../requirements/FUNCTIONAL_REQUIREMENTS.md) |
| Status | PROPOSED — NOT APPROVED. |

| Module | Requirements served | Responsibilities and data | Dependencies | Consuming apps |
|---|---|---|---|---|
| MOD-AUTH | FR-001…003, FR-044, FR-045 | Identity, role/claim resolution, staff accounts, partner applications | Firebase Auth | CUS, PAR, ADM, ACC |
| MOD-CAT | FR-004, FR-005, FR-014, FR-015, FR-026, FR-027, FR-046 | Kitchens, meals, variants, price versions, capacity, stock reservation | MOD-AUTH (supplier identity) | CUS, PAR |
| MOD-SUB | FR-006, FR-008, FR-016, FR-029, FR-031 | Subscription agreements, schedules, meal obligations, pause/skip/replace | MOD-CAT, MOD-PRC | CUS, PAR |
| MOD-PRC | FR-030 | Quotes, immutable price snapshots, discount/tax lines | MOD-CAT, MOD-POL | CUS |
| MOD-ORD | FR-007, FR-009, FR-028 | One-time orders, order items, cart | MOD-CAT, MOD-PRC | CUS |
| MOD-PAY | FR-012, FR-013, FR-033, FR-035 | Payment intents/attempts, gateway events/verification, invoices, refunds | MOD-PRC | CUS, ACC |
| MOD-COD | FR-034 | COD collections, remittances, discrepancies | MOD-ORD, MOD-SUB | PAR (rider), ACC |
| MOD-CRD | FR-032 | Credit accounts and transactions | MOD-SUB (adjustment source) | CUS, ACC |
| MOD-LED | FR-040 | Ledger accounts, journals, periods, reconciliation | All financial modules post here | ACC |
| MOD-SET | FR-018, FR-036, FR-037, FR-038 | Supplier/rider earnings, holds, payout requests/approvals/batches | MOD-LED, MOD-DLV | PAR, ACC |
| MOD-DLV | FR-010, FR-019, FR-020, FR-037, FR-047, FR-048 | Delivery assignments, events, proof, rider location | MOD-ORD, MOD-SUB | CUS, PAR, ADM |
| MOD-NOT | FR-025 | Outbox consumption, notification preferences, email log | All modules emit events | CUS, PAR, ADM, ACC |
| MOD-ADM | FR-021, FR-022, FR-023, FR-043 | Zones, incidents, dispatch, complaint handling | MOD-DLV, MOD-AUTH | ADM |
| MOD-AUD | NFR-021 | Immutable audit events | All modules write | ADM, ACC (read) |
| MOD-RPT | FR-024, FR-042 | Derived read models and secured exports | MOD-LED, MOD-SET, MOD-PAY | ADM (limited), ACC |
| MOD-POL | BR-001…026 parameters | Versioned policy configuration | — | BE (all modules read) |

Each module's command list is in [api/API_SPECIFICATION.md](../api/API_SPECIFICATION.md); each module's entities are in [database/DATA_DICTIONARY.md](../database/DATA_DICTIONARY.md).
