# Authoritative task tracker

| Field | Value |
|---|---|
| Revision | 3.0 · 2026-10-30 (TASK-001…113, 201 kept; TASK-114…128 added for the four-application programme) |
| Owner | Documentation lead |
| Status | Documentation refinement (this delivery) complete. No implementation task has started. |

An `app/` Flutter project and a `backend/` Firebase Functions project exist on disk, untracked in git — see [architecture/CODE_REALITY_SNAPSHOT.md](architecture/CODE_REALITY_SNAPSHOT.md). Their completeness, correctness, test-passing and BR compliance are not verified here. This documentation rewrite (TASK-114) is now complete; implementation (TASK-115+) remains a separate, later, explicitly authorised phase.

## Status meanings

| Status | Meaning |
|---|---|
| Planned | Work is defined but has not started. |
| In progress | Active preparation; no completion claim. |
| Implemented but unverified | Artifact exists; required evidence is incomplete. For documents, this means drafted. |
| Verified | Referenced checks passed for the identified artifact. |
| Blocked | A named decision, prerequisite, or authorization prevents that work. |
| Deferred | Intentionally outside scope or assigned to a later release. |

## Prior documentation tasks (kept; status updated)

| ID | Work | Status | Evidence |
|---|---|---|---|
| TASK-001 | FR-001–025, roles, stories, use cases, acceptance, traceability | Implemented but unverified | [SRS](SRS.md) |
| TASK-002 | Architecture, data, service contracts, security (single-app baseline) | Superseded by TASK-116 scope | [architecture/SYSTEM_ARCHITECTURE.md](architecture/SYSTEM_ARCHITECTURE.md) |
| TASK-003 | Delivery plan, test designs, Android bilingual UX | Superseded by TASK-114 scope | [testing/TEST_CASES.md](testing/TEST_CASES.md) |
| TASK-004 | Environment audit, sources, cross-file checks | In progress (ongoing) | [verification/DOCUMENTATION_CHECKS.md](verification/DOCUMENTATION_CHECKS.md) |
| TASK-005 | BR-001–005 decisions | Blocked | [requirements/BUSINESS_RULES.md](requirements/BUSINESS_RULES.md) |
| TASK-006…009 | Screenshot reconciliation, legacy-document restoration, render/PDF planning | Superseded by TASK-114/TASK-128 scope | [design/PDF_PRODUCTION_PLAN.md](design/PDF_PRODUCTION_PLAN.md) |
| TASK-010 | Reconcile untracked `app/`, `backend/`, `firebase/` trees | Planned | [architecture/REACT_TO_FLUTTER_MIGRATION.md](architecture/REACT_TO_FLUTTER_MIGRATION.md) |
| TASK-101…113 | Original Android-only implementation roadmap | Superseded by TASK-115…128 (four-app scope); individual BR gates unchanged | See each original row's acceptance evidence, unchanged |
| TASK-201 | Later-release features (AI, live GPS, coupons, loyalty) | Deferred | — |

## New task: the four-application documentation rewrite (this delivery)

| ID | Work | Status | Evidence |
|---|---|---|---|
| TASK-114 | Gap analysis, refinement plan, and complete rewrite of all requirements/architecture/database/API/payments/design/scenario/testing/operations documentation for four applications | **Implemented but unverified** (documentation complete; see verification below) | [analysis/FILE_REFINEMENT_PLAN.md](analysis/FILE_REFINEMENT_PLAN.md), [verification/FINAL_VERIFICATION_REPORT.md](verification/FINAL_VERIFICATION_REPORT.md) |

## Future implementation tasks (four-application scope)

| ID | Work | Priority | Dependencies | Status |
|---|---|---|---|---|
| TASK-115 | Shared packages, backend command envelope extension, PostgreSQL ledger schema | Must | ADR-004…009 reviewed | Planned |
| TASK-116 | Customer App on real data | Must | TASK-115; policy gates per feature | Planned |
| TASK-117 | Partner App (supplier + rider workspaces) on real data | Must | TASK-115/116; BR-023 for dual-role | Planned |
| TASK-118 | Admin Web on real data | Must | TASK-115 | Planned |
| TASK-119 | Accounts Web on real data | Must | TASK-115; BR-020 for maker-checker | Planned |
| TASK-120 | SSLCOMMERZ sandbox integration | Must | Credentials supplied by the user; official docs verified | Blocked (no credentials) |
| TASK-121 | Financial invariant test suite (INV-01…20) execution | Must | TASK-115, PostgreSQL instance | Planned |
| TASK-122 | 25-scenario integration test execution | Must | TASK-116…120 | Planned |
| TASK-123 | Full bilingual/accessibility/responsive validation, all four apps | Must | TASK-116…119 | Planned |
| TASK-124 | Visual design PDF production from real captures | Must | TASK-123 | Planned |
| TASK-125 | BR-006…026 decisions | Must before dependent implementation | Business owner provides exact policies | Blocked |
| TASK-126 | Legal/regulatory review (BR-018, BR-025) | Must before any cash-out or stored-value feature | Qualified legal reviewer | Blocked |
| TASK-127 | Web hosting selection and security verification (Admin Web, Accounts Web) | Must before any staff invitation | DEC-010 | Planned |
| TASK-128 | Release readiness (release checklist, rollback plan exercised) | Must before real distribution | TASK-116…127 | Deferred |

## Updating this tracker

Move a task to Verified only with a dated evidence link and tested revision or file manifest. Product tests, builds and releases retain their own status. Record newly discovered work here with a stable ID; do not conceal incomplete Must requirements in TASK-201.
