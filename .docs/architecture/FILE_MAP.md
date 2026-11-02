# File map

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (corrects 1.0, which wrongly said no Flutter app or backend exists) |
| Owner | Architecture lead |
| Purpose | Map the proposed four-app monorepo areas to their current, OBSERVED on-disk counterparts. |
| Depends on | [Code reality snapshot](CODE_REALITY_SNAPSHOT.md), [multi-app architecture](MULTI_APP_ARCHITECTURE.md) |
| Status | OBSERVED facts plus PROPOSED target layout. |

| Proposed area | Target path (PROPOSED) | Current on-disk reality (OBSERVED) | Ownership |
|---|---|---|---|
| Customer App | `apps/customer_app/` | Not separated; part of the single `app/` package | TASK-010 |
| Partner App | `apps/partner_app/` | Not separated; part of the single `app/` package | TASK-010 |
| Admin Web | `apps/admin_web/` | Does not exist | New |
| Accounts Web | `apps/accounts_web/` | Does not exist | New |
| Shared packages | `packages/*` | Does not exist; closest equivalents are `app/lib/design/`, `app/lib/ui/` inside the single app | TASK-010 |
| Backend | `backend/functions/src/` | Real: `index.js` (19 ln), `commands.js` (189 ln), 3 test files | Extend in place |
| Firebase config | `firebase/` | Real: `firestore.rules` (56 ln), `firestore.indexes.json` (10 ln), `storage.rules` (7 ln) | Extend in place |
| PostgreSQL ledger | Not yet named (PROPOSED, ADR-005) | Does not exist | New |

See [architecture/CODE_REALITY_SNAPSHOT.md](CODE_REALITY_SNAPSHOT.md) for the full on-disk inventory and [architecture/REACT_TO_FLUTTER_MIGRATION.md](REACT_TO_FLUTTER_MIGRATION.md) for how the legacy prototype's files map to this target. This file states existence and target layout only — it does not assess code correctness.
