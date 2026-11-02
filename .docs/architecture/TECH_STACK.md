# Technology stack

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (supersedes 1.0, single-app Firestore-only) |
| Owner | Architecture lead |
| Purpose | Record the chosen and candidate technologies for all four applications and the shared backend, with the reasoning for each. |
| Depends on | [System architecture](SYSTEM_ARCHITECTURE.md), [ADR-005](../adr/005-hybrid-datastore.md) |
| Status | PROPOSED — NOT APPROVED except where OBSERVED in the existing code. |

| Area | Direction | Status / reason |
|---|---|---|
| Client framework | Flutter/Dart for all four applications (CUS, PAR Android; ADM, ACC Web) | USER-REQ; OBSERVED Flutter SDK `^3.13.4` already in use for the single combined app |
| Mobile auth | Firebase Authentication | OBSERVED (`firebase_auth 7.0.1` already a dependency) |
| Mobile/web data (operational) | Cloud Firestore | OBSERVED (`cloud_firestore 7.1.0`); kept for operational and read-model data under the hybrid datastore decision |
| Push/notifications | Firebase Cloud Messaging, extended with an email/SMS provider for Accounts/Admin alerts | OBSERVED FCM dependency; email/SMS provider PROPOSED, not selected |
| Trusted backend | Cloud Functions (Node 22, ESM), one callable `executeCommand`, extended | OBSERVED; extension is PROPOSED |
| Financial store | Managed PostgreSQL (ledger, payments, COD, credits, earnings, payouts, reconciliation) | PROPOSED — NOT APPROVED ([ADR-005](../adr/005-hybrid-datastore.md)); provider not selected |
| App integrity | Firebase App Check | OBSERVED (already enforced on the existing callable) |
| Payment gateway | SSLCOMMERZ, behind a gateway abstraction; not connected | USER-REQ (gateway choice); abstraction PROPOSED |
| Web hosting (ADM, ACC) | Not yet selected; compare Firebase Hosting, a managed static host with signed access, or a general cloud provider | PROPOSED, comparison pending — see [deployment/WEB_HOSTING_ADMIN_AND_ACCOUNTS.md](../deployment/WEB_HOSTING_ADMIN_AND_ACCOUNTS.md) |
| Shared package manager | Dart/Flutter workspaces (pub workspaces) or Melos for the monorepo | PROPOSED, not configured |
| Testing | `flutter_test`, `mocktail`/`mockito` equivalents for Dart; existing Node test runner for backend; Firestore emulator; a future PostgreSQL test container | OBSERVED Node test runner and Firestore emulator already in use; PostgreSQL test tooling PROPOSED |
| Diagrams | Mermaid, embedded in Markdown | USER-REQ constraint (Markdown only) |
| CI | Not yet configured | PROPOSED — see [deployment/CI_CD.md](../deployment/CI_CD.md) |

## Why PostgreSQL alongside Firestore (summary; full comparison in ADR-005)

Firestore's transaction model, query limitations (no server-side aggregation across documents without additional infrastructure) and eventual consistency across collections make a double-entry ledger, period close and cross-entity financial reconciliation harder to build with the same integrity guarantees a relational database gives natively through ACID transactions, foreign-key constraints and SQL aggregation. Firestore remains well suited to operational, per-document, mobile-read-heavy data. The hybrid split follows the master prompt's own instruction to "recommend one coherent final architecture with documented tradeoffs" rather than combining technologies without clear responsibilities — ownership is the module map in [BACKEND_DOMAIN_DESIGN.md](BACKEND_DOMAIN_DESIGN.md) §1.

## Rejected-for-now alternatives

- **Firestore only, with application-level ledger logic:** simpler operationally, but weaker transactional guarantees for multi-account journal postings and harder financial reporting; rejected as the sole store for the ledger domain, PROPOSED.
- **Relational database for everything:** would require migrating the existing OBSERVED Firestore-based mobile data layer; rejected as unnecessary churn for data that is already working operationally, PROPOSED.

## Open decisions

PostgreSQL provider/region/budget, email/SMS provider, web hosting provider, and CI platform are all open (DEC-010).
