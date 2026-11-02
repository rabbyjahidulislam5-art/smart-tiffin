# Requirements change log

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Purpose | Record every requirement-level change made during the 2026-10-30 rewrite, distinguishing revision from extension from supersession. |
| Status | Current. |

## Revised in place (content changed, same identifier, same file)

FR-001…025, UC-001…025, AC-001…025, US-001…025: text and references updated for the four-application scope; no identifier changed meaning. BUSINESS_RULES.md (BR-001…005): text preserved verbatim; only header, evidence register and a linking section added. SOURCE_MATERIAL_REGISTER.md: fully reversed (was "not adopted", now "primary requirement") per the user's explicit 2026-10-30 instruction.

## Extended (new identifiers added, nothing removed)

FR-026…050, UC-026…050, AC-026…050 (+ AC-BR006…026), US-026…050, NFR-013…032, BR-006…026 (+ DEC-016…036), ADR-004…014, RISK-014…045, TASK-114+ (see [TASKS.md](../TASKS.md)), TEST-026…050, TEST-201…260, SCT-01…25 (×6 case types each), NC-01…19, NS-01…07, NR-01…06, NA-01…06, NF-01…17, INV-01…20, MOD-* codes, `ent.*` entity names, command names (see [conventions §6](CONVENTIONS_AND_ID_REGISTER.md)).

## Superseded (old content kept as history with a banner, new content authoritative)

| Old | Superseded by |
|---|---|
| ADR-001 (single-app Firebase, part) | ADR-004, ADR-005 |
| ADR-003 (manual-payment half) | ADR-007 (delivery-state half retained) |
| design/SCREEN_INVENTORY.md (129 families) | design/COMPLETE_SCREEN_INVENTORY.md |
| design/SCREEN_AND_CONTROL_INVENTORY.md | design/COMPLETE_SCREEN_INVENTORY.md, design/INVENTORY_RECONCILIATION.md |

## New modules/applications (no prior identifier)

Accounts Web (entire application, NF-01…17 and 10 module documents), Partner App's explicit two-workspace architecture document, Admin Web's four module documents, Customer App's six module documents beyond the original single CUSTOMER_MODULES.md-equivalent scope.

## Explicitly not changed

The four confirmed delivery states (Pending → Picked Up → On The Way → Delivered); the trusted-command-boundary principle (ADR-002, extended not reversed); the untrusted-client principle; Android-first and Bangla/English confirmation; the five original business rules' pending status and alternatives.

## Cross-reference

Every entry above is traceable through [analysis/CONFLICT_REGISTER.md](CONFLICT_REGISTER.md) (why) and [analysis/PROVENANCE_MATRIX.md](PROVENANCE_MATRIX.md) (source).
