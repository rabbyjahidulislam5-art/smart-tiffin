# Diagram sources

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (the four `.mmd` files below are retained unchanged as the historical single-app diagrams; new diagrams for the four-application scope are embedded as Mermaid blocks inside Markdown files per the user's "Markdown only" constraint) |
| Owner | Documentation lead |
| Status | Requirements/design diagrams only; no renderer has been run by this effort. |

Status: requirements/design diagrams. They describe proposed components and candidate data, not running infrastructure. Mermaid source is stored separately for maintenance and review.

## Historical `.mmd` files (single-app baseline, unchanged)

| Source | Distinct purpose | Canonical text |
|---|---|---|
| [context.mmd](context.mmd) | Four actors, untrusted mobile client and proposed trusted service boundary | [System architecture](../architecture/SYSTEM_ARCHITECTURE.md) (historical single-app section) |
| [data-model.mmd](data-model.mmd) | Candidate relationship model, subject to BR-001–005 | [Database design](../database/DATABASE_DESIGN.md) (original Firestore entities) |
| [order-sequence.mmd](order-sequence.mmd) | Authorization, atomic order commit and notification failure separation | [Data flow](../architecture/DATA_FLOW.md) (original order flow) |
| [delivery-state.mmd](delivery-state.mmd) | Exactly four confirmed delivery states | [API contracts](../api/API_SPECIFICATION.md) |

## New diagrams (2026-10-30, Mermaid embedded in Markdown — no new `.mmd` files, per the user's Markdown-only constraint)

| File | Content |
|---|---|
| [SYSTEM_CONTEXT.md](SYSTEM_CONTEXT.md) | Actors, four apps, backend, gateway, bank, messaging, maps |
| [APPLICATION_ARCHITECTURE.md](APPLICATION_ARCHITECTURE.md) | Apps, shared-package dependency map, backend modules, two stores |
| [AUTH_AND_ROLE_FLOWS.md](AUTH_AND_ROLE_FLOWS.md) | Customer/partner onboarding, invited staff, admin/accounts MFA, dual-role |
| [SUBSCRIPTION_LIFECYCLE.md](SUBSCRIPTION_LIFECYCLE.md) | Agreement and obligation state diagrams |
| [PAYMENT_AND_COD_WORKFLOW.md](PAYMENT_AND_COD_WORKFLOW.md) | Online payment and COD collection/remittance |
| [ACCOUNTS_AND_SETTLEMENT.md](ACCOUNTS_AND_SETTLEMENT.md) | Earning recognition, payout state machine, reconciliation |
| [DATABASE_RELATIONSHIPS.md](DATABASE_RELATIONSHIPS.md) | High-level ER across FS and PG with ownership (duplicates [database/ENTITY_RELATIONSHIPS.md](../database/ENTITY_RELATIONSHIPS.md)'s diagrams for convenient navigation from this folder) |
| [DELIVERY_STATES.md](DELIVERY_STATES.md) | The four confirmed states plus exception outcomes and reassignment |

Open a source with a Mermaid-capable preview, or use a pinned reviewed Mermaid renderer in future documentation tooling. Syntax uses `flowchart`, `erDiagram`, `sequenceDiagram` and `stateDiagram-v2`. No renderer was executed by this effort; any subsequent rendering result belongs in [TEST_RESULTS](../testing/TEST_RESULTS.md). Source inspection alone is not a rendering pass.

Update diagrams with the canonical document whenever a name, boundary or policy changes. Class and deployment-instance diagrams await actual code and selected hosting.
