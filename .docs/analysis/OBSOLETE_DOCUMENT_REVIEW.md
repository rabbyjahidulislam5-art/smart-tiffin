# Obsolete document review

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Purpose | Classify every file touched by this rewrite as Keep / Revise / Merge / Supersede / Archive / Remove, per the master prompt's Phase 18 instruction. No file is deleted; "Archive" means a historical banner was added, not removal. |
| Status | Current. |

| File | Classification | Reason |
|---|---|---|
| `requirements/BUSINESS_RULES.md` | Keep (extended) | Still the sole authority for BR-001…005 |
| `requirements/SOURCE_MATERIAL_REGISTER.md` | Revise | Reversed the "not adopted" statement per user instruction |
| `adr/001-flutter-firebase.md` | Supersede (in part) | Single-app framing superseded; technology choice extended |
| `adr/003-status-and-reference-payments.md` | Supersede (in part) | Payment half superseded; delivery-state half kept |
| `design/SCREEN_INVENTORY.md` | Archive (banner added) | Superseded by complete inventory; kept as history, F129 citation preserved |
| `design/SCREEN_AND_CONTROL_INVENTORY.md` | Archive (banner added) | Same |
| `architecture/SYSTEM_ARCHITECTURE.md`, `TECH_STACK.md`, `MODULE_DESIGN.md`, `DATA_FLOW.md`, `INTEGRATION_DESIGN.md`, `SECURITY_ARCHITECTURE.md`, `FILE_MAP.md` | Revise | Single-app/no-ledger framing replaced |
| `database/DATABASE_DESIGN.md`, `DATA_DICTIONARY.md` | Revise (extended) | Firestore entities kept; new entities added; financial entities split to a new file |
| `api/API_SPECIFICATION.md`, `AUTHORIZATION.md`, `ERROR_RESPONSES.md` | Revise/extend | Command set and role matrix expanded |
| `security/*` (6 files) | Revise (extended) | New threats, controls and review items added |
| `planning/*` (7 files) | Revise | Single-app plan superseded by four-app plan |
| `testing/TEST_CASES.md`, `BUG_REPORTS.md` | Extend | New test ranges and documentation defects added |
| `testing/TEST_RESULTS.md` | Revise (status language) | Clarified what "no test run" covers given the OBSERVED code |
| `setup/*` (6 files) | Revise/extend | Four-app/monorepo setup notes added; historical banners where content is session-specific |
| `deployment/*` (5 files) | Revise/extend | Four-app release gates and web hosting added |
| `operations/*` (7 files) | Already extended by the authoring pass (MAINTENANCE_PLAN, INCIDENT_RESPONSE, and the three new runbooks) | No further change needed |
| `references/SOURCES.md` | Extend | New sources and "to verify" markers added |
| `diagrams/*.mmd` (4 files) | Keep unchanged | Historical single-app diagrams, explicitly retained |
| `diagrams/README.md` | Revise | Points to both historical and new diagrams |
| Root `README.md`, `PROJECT_STATUS.md`, `DELIVERABLE_COVERAGE.md`, `TASKS.md`, `SRS.md` | Revise | Four-app scope and corrected code-reality status |

## Backup and manifest

No file in `FINAL_REFINED_DOCS/` was deleted. The "original" versions of every revised/extended file are preserved in `docs/` (the untouched canonical source, per the user's explicit instruction not to modify it) and, for the two explicitly superseded files, as the unedited body text below the added historical banner. This serves as the backup/manifest the master prompt's Phase 18 requires before any removal — no removal occurred.

## Files not reviewed by this classification

`docs/` itself (left untouched, per the user's hard constraint); `app/`, `backend/`, `firebase/` source code (left untouched); `.codex/skills/**` and `graphify-out/**` (tool-generated, out of scope).
