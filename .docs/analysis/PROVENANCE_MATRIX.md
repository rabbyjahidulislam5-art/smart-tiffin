# Provenance matrix

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Purpose | Source-of-truth table distinguishing user-expressed requirements, screenshot appearances, verified source (prototype/code) behaviour, earlier architecture assumptions, and external recommendations, for every substantive requirement area. |
| Depends on | [Conventions §1](CONVENTIONS_AND_ID_REGISTER.md), [conflict register](CONFLICT_REGISTER.md) |
| Status | Current. |

| Requirement area | USER-REQ (user-expressed) | OBSERVED (screenshot/prototype/code) | PROPOSED (this effort's recommendation) | Earliest date |
|---|---|---|---|---|
| Four applications | Master prompt Phase 2 | — | Monorepo layout, package names | 2026-10-30 |
| 94 legacy screens | Legacy prototype digest (user-supplied) | React prototype code (as reported) | Migration action per screen | 2026-10-30 |
| 55 proposed screens | Master prompt §3.3 | — | Form decision (screen/section/sheet), exact layout | 2026-10-30 |
| Flexible subscriptions | Master prompt Phase 4 | Prototype's hard-coded `monthly-ld` default (the opposite behaviour, a defect) | Agreement/obligation model (ADR-014) | 2026-10-30 |
| Service credits | Master prompt Phase 5 | — | Credit formula shape, class separation | 2026-10-30 |
| SSLCOMMERZ | Master prompt Phase 7 (gateway choice) | — | Abstraction interface, IPN contract (to verify) | 2026-10-30 |
| COD four models | Master prompt Phase 7 | Prototype's single COD checkbox (superseded) | Four distinct state machines | 2026-10-30 |
| Double-entry ledger | Master prompt Phase 10 (model choice: "double-entry or justified equivalent") | — | Full chart of accounts, posting rules (ADR-006) | 2026-10-30 |
| Hybrid datastore (Firestore + PostgreSQL) | Master prompt Phase 12 (re-evaluation instruction) | Firestore already in use (OBSERVED) | ADR-005 recommendation | 2026-10-30 |
| BR-001…005 | 2026-10-28 source brief | — | Alternatives and recommendations (unchanged) | 2026-10-28 |
| BR-006…026 | Master prompt Phase 15 (extension instruction) | — | 21 new rules, all PENDING | 2026-10-30 |
| 25 scenarios | Master prompt §4 | — | Decision tables, sequence diagrams, tests | 2026-10-30 |
| Accounts Web (whole app) | Master prompt Phase 10 | — | Entire domain, new (no OBSERVED equivalent) | 2026-10-30 |
| Admin/Accounts separation | Master prompt Phase 2, 10 | Legacy A-12/A-13 (now split, conflict C-06) | NA-05 limited view | 2026-10-30 |
| Code reality ("no app exists" correction) | — | `app/`, `backend/functions`, `firebase/` on disk | Corrected status language | 2026-10-30 (FINAL copy), reaffirmed this pass |

## Discrepancy: screenshot card with no working route

P-02 (legacy guest menu/kitchens screen) shows kitchen cards that are **not clickable** (OBSERVED prototype defect). The master prompt explicitly requires every kitchen card to resolve to a working destination. Resolution: NC-02 (Kitchen profile detail) is designed as the destination; recorded in [design/screens/CUSTOMER_NEW_SCREENS.md](../design/screens/CUSTOMER_NEW_SCREENS.md) and [conflict register C-11](CONFLICT_REGISTER.md).

## Discrepancy: documented but not visible

Live GPS tracking (C-18) is documented as a future, consent-bound feature; the prototype shows only an animated sample. This is recorded, not silently merged, per [architecture/TIME_AND_CUTOFF_POLICY.md](../architecture/TIME_AND_CUTOFF_POLICY.md) and the legacy prototype digest's own "animated sample" note.

## Traceability rule

Every changed requirement traces to exactly one authoritative file (named in the "PROPOSED" column above or in the relevant module document) and to every dependent specification through that file's own links — never duplicated into a second authoritative copy.
