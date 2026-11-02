# Existing document audit

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead (primary agent) |
| Purpose | File-by-file record of every project-owned Markdown file inspected, what it currently says, what is wrong or missing against the two primary requirement sources, and what happens to it. |
| Applies to | All project-owned `.md` files |
| Depends on | [Conventions](CONVENTIONS_AND_ID_REGISTER.md), [gap analysis](GAP_ANALYSIS.md), [file refinement plan](FILE_REFINEMENT_PLAN.md) |
| Status | Audit complete for structure and scope; each author re-reads their assigned originals in full before rewriting (recorded in the refinement plan). |

## 1. Inspection scope and method

**Inspected (project-owned Markdown):** root `README.md`, `AGENTS.md`, `TASKS.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md`; everything under `docs/` (SRS, README, PROJECT_STATUS, DELIVERABLE_COVERAGE, and requirements/, planning/, architecture/, database/, api/, security/, adr/, design/, testing/, operations/, deployment/, setup/, verification/, references/, diagrams/README); `app/README.md`; `firebase/SECURITY_REVIEW.md`; all 85 Markdown files already under `FINAL_REFINED_DOCS/`.
**Excluded:** `.codex/skills/**` and `graphify-out/**` (tool-generated), `backend/functions/node_modules/**` (generated dependencies), `docs_archive_2026-10-30/` (no Markdown files found), `.mmd`, `.json`, `.png`, `.txt`, PDF/ZIP/DOC and source code. Code was read only to state what exists (see [code reality snapshot](../architecture/CODE_REALITY_SNAPSHOT.md)).
**Method:** three read-only explorers produced per-file inventories (line counts, purpose, identifier ranges, contradictions); the primary agent read the two primary requirement sources (supplied inline, not on disk; preserved as [source digests](SOURCE_MASTER_PROMPT_DIGEST.md) and [prototype digest](SOURCE_LEGACY_PROTOTYPE_DIGEST.md)) and spot-read the register, glossary-bearing and status files. The two primary sources are **not files in the workspace**; this is recorded as a limitation, not a defect.

## 2. Two parallel trees

`docs/` and `FINAL_REFINED_DOCS/` are byte-identical for all requirements, planning (except `PRODUCT_DELIVERY_PLAN`), architecture, database, api, security (except one renamed file), adr and testing files. They differ in: `README.md`, `PROJECT_STATUS.md`, `DELIVERABLE_COVERAGE.md`, `TASKS.md`, `planning/PRODUCT_DELIVERY_PLAN.md` (the FINAL copy corrects the false statement that no application exists), plus five files that exist only in FINAL (`requirements/SOURCE_MATERIAL_REGISTER.md`, `architecture/CODE_REALITY_SNAPSHOT.md`, `design/SCREEN_AND_CONTROL_INVENTORY.md`, `security/SECURITY_REVIEW_PLANNING.md`, `verification/FIREBASE_SECURITY_REVIEW_COPY.md`). `docs/` stays untouched; `FINAL_REFINED_DOCS/` is the target tree. Root `README.md`, `AGENTS.md`, `TASKS.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md` have no counterpart in FINAL except TASKS/README; their content is carried into new FINAL files (see §4).

## 3. Verdicts by group

Legend: **Rewrite** = deep section-by-section rewrite in place (path unchanged); **Extend** = keep and add new sections/IDs; **Supersede** = kept in place with a "SUPERSEDED BY" banner, content mapped; **Carry** = root/docs content re-created inside FINAL_REFINED_DOCS; **History** = kept as dated evidence, banner added; **New** = created.

| File (FINAL_REFINED_DOCS path) | Lines | Today | Defect against target | Verdict |
|---|---|---|---|---|
| `SRS.md` | 59 | Index + glossary; "one Flutter mobile application", bKash/Nagad references | One app, Firebase-only, manual payment | Rewrite |
| `README.md` | 32 | Index with "copy of docs/" banner | Banner obsolete; no 4-app index | Rewrite (+ New `MASTER_INDEX.md`) |
| `PROJECT_STATUS.md` | ~45 | Status and BR table; says no app/redesign pending | Scope outdated | Rewrite |
| `DELIVERABLE_COVERAGE.md` | ~25 | Consolidation map | Single-app layout | Rewrite |
| `TASKS.md` | 63 | Tracker (TASK-001…009, 101…113, 201, +010) | Single Android app tasks | Extend (TASK-114+) |
| `requirements/PROJECT_VISION.md` | 28 | Vision | Single app | Rewrite |
| `requirements/PROJECT_SCOPE.md` | 37 | Scope; gateway/GPS "later" | No Partner/Admin Web/Accounts Web; gateway deferred | Rewrite |
| `requirements/STAKEHOLDER_ANALYSIS.md` | 23 | Stakeholders | No finance team, no riders-as-partners model | Rewrite |
| `requirements/USER_ROLES.md` | 34 | 4 roles, 1 app | No Accounts sub-roles; no dual role policy | Rewrite |
| `requirements/FUNCTIONAL_REQUIREMENTS.md` | 287 | FR-001…025 | No ledger, credits, quotes, COD, payouts, custom schedules | Extend (FR-026…050) + revise 001–025 |
| `requirements/NON_FUNCTIONAL_REQUIREMENTS.md` | 27 | NFR-001…012 | Android-only; no web/desktop, ledger integrity, time zone | Extend (NFR-013+) |
| `requirements/USER_STORIES.md` | 36 | US-001…025 | Customer-centric | Extend |
| `requirements/USE_CASES.md` | 306 | UC-001…025 | No pricing/credit/payout/ledger flows | Extend |
| `requirements/ACCEPTANCE_CRITERIA.md` | 212 | AC-001…025 | Same | Extend |
| `requirements/BUSINESS_RULES.md` | 287 | BR-001…005 pending, DEC-003…007 | Needs links to BR-006+ | Extend (preserve all existing text) |
| `requirements/ASSUMPTIONS_AND_CONSTRAINTS.md` | 49 | DEC-001…015 | DEC-011/015 assume Firebase-only/FCM; documentation-only wording | Rewrite + link DEC-016+ |
| `requirements/REQUIREMENTS_TRACEABILITY_MATRIX.md` | 82 | FR/UC/AC/TEST → screens | Keyed to the 129 families | Rewrite (full chain) |
| `requirements/SCREENSHOT_SCOPE_RECONCILIATION.md` | 38 | Six-screenshot reconciliation | Valid as evidence; maps to F129 IDs | Extend (map to legacy/new IDs) |
| `requirements/SOURCE_MATERIAL_REGISTER.md` | 27 | Says 4-app and 94-screen sources "not adopted" | Reversed by request | Rewrite |
| `requirements/GLOSSARY_AND_TERMINOLOGY.md`, `POLICY_DECISION_REGISTER.md` | — | — | — | New (written) |
| `planning/PRODUCT_DELIVERY_PLAN.md` | 106 | Complete-product plan, one Android app | Headline recommendation obsolete | Rewrite |
| `planning/TECHNICAL_EXECUTION_PLAN.md` | 29 | One Flutter app, ChangeNotifier, Node/Firebase | Superseded | Rewrite |
| `planning/IMPLEMENTATION_PLAN.md` | 40 | Vertical slices | One app | Rewrite |
| `planning/PROJECT_ROADMAP.md` | 23 | M0…M5 | One app | Rewrite (M6+) |
| `planning/RELEASE_PLAN.md` | 33 | CSE-489 baseline | No web release | Rewrite |
| `planning/RISK_REGISTER.md` | 21 | RISK-001…013 | No finance risks | Extend |
| `planning/DEPENDENCY_MAP.md` | 30 | Dependencies | One app | Rewrite |
| `architecture/SYSTEM_ARCHITECTURE.md` | 47 | One Flutter app, four workspaces, "no application exists" | Wrong on both counts | Rewrite |
| `architecture/TECH_STACK.md` | 32 | Flutter + Firebase; relational DB "if needed" | No web, no Postgres decision | Rewrite |
| `architecture/MODULE_DESIGN.md` | 33 | Nine modules | No ledger, credits, quotes, payouts | Rewrite |
| `architecture/DATA_FLOW.md` | 31 | Manual reference flow | No gateway/COD/ledger | Rewrite |
| `architecture/INTEGRATION_DESIGN.md` | 27 | FCM, manual payment | No SSLCOMMERZ | Rewrite |
| `architecture/SECURITY_ARCHITECTURE.md` | 27 | Rules + callable | No webhook/maker-checker/web session | Rewrite |
| `architecture/FILE_MAP.md` | 20 | "No Flutter app/backend" (false) | Wrong | Rewrite |
| `architecture/CODE_REALITY_SNAPSHOT.md` | 46 | Accurate existence snapshot | Needs refresh for 4-app baseline | Extend |
| `architecture/MULTI_APP_ARCHITECTURE.md`, `BACKEND_DOMAIN_DESIGN.md`, `TIME_AND_CUTOFF_POLICY.md`, `REACT_TO_FLUTTER_MIGRATION.md` | — | — | — | New |
| `database/DATABASE_DESIGN.md` | 52 | Conceptual Firestore entities | Missing ledger/credits/quotes/payouts/COD/schedules | Rewrite |
| `database/DATA_DICTIONARY.md` | 64 | Field list | Same | Rewrite |
| `database/DATA_RETENTION.md`, `INDEXING_STRATEGY.md`, `MIGRATION_STRATEGY.md` | 17–23 | Firestore-only | Hybrid datastore, ledger retention | Rewrite |
| `database/ENTITY_RELATIONSHIPS.md`, `FINANCIAL_DATA_MODEL.md`, `DATA_CONSISTENCY.md` | — | — | — | New |
| `api/API_SPECIFICATION.md` | 42 | 14 logical commands | No money/credit/payout/COD/Accounts commands | Rewrite |
| `api/AUTHORIZATION.md` | 28 | 4-role matrix | No Accounts, web, maker-checker | Rewrite |
| `api/ERROR_RESPONSES.md` | 23 | Good taxonomy | Needs financial errors | Extend |
| `api/EVENT_AND_NOTIFICATION_DESIGN.md` | — | — | — | New |
| `security/THREAT_MODEL.md`, `SECURITY_REQUIREMENTS.md`, `SECRETS_MANAGEMENT.md`, `DEPENDENCY_REVIEW.md`, `SECURITY_REVIEW_PLANNING.md` | 17–22 | "No webhook, CSRF n/a" | Wrong for web + gateway + finance | Rewrite |
| `security/FINANCIAL_SECURITY.md`, `AUDIT_AND_COMPLIANCE.md` | — | — | — | New |
| `adr/001-flutter-firebase.md` | 13 | Accepted: Flutter + Firebase, one app | Partially superseded by ADR-004/005 | Supersede (banner) |
| `adr/002-trusted-command-boundary.md` | 13 | Proposed; implemented in code | Revise to accepted-in-code baseline + extend | Rewrite |
| `adr/003-status-and-reference-payments.md` | 13 | Four delivery states; manual payment refs | Payment part superseded by ADR-007; delivery states kept | Supersede (banner, states preserved) |
| `adr/004…014` | — | — | — | New |
| `design/SCREEN_INVENTORY.md` | 177 | 129 families, F129 IDs | Collides with legacy IDs | History + reconciled |
| `design/SCREEN_AND_CONTROL_INVENTORY.md` | 384 | Merged inventory + 153 controls | Same collision | History + reconciled |
| `design/SCREENSHOT_ACTION_AUDIT.md` | 198 | 153 screenshot controls | Valid evidence | Extend (add legacy/new mapping) |
| `design/NAVIGATION_ARCHITECTURE.md` | 106 | Five shells, one app | Four-app navigation | Rewrite |
| `design/DESIGN_SYSTEM.md` | 69 | Glass tokens, role accents | Needs legacy tokens, desktop | Rewrite |
| `design/UI_UX_GUIDELINES.md` | 48 | Shared interaction contracts | Needs desktop/finance tables | Rewrite |
| `design/ACCESSIBILITY.md` | 11 | Notes | Thin | Rewrite |
| `design/PDF_PRODUCTION_PLAN.md` | 43 | Render PDF plan | Scope/counts changed | Rewrite |
| `design/COMPLETE_SCREEN_INVENTORY.md`, `INVENTORY_RECONCILIATION.md`, `NAVIGATION_MAP.md`, `COMPONENT_SPECIFICATIONS.md`, `RESPONSIVE_LAYOUTS.md`, `SCREEN_VERIFICATION_CHECKLIST.md` | — | — | — | New |
| `testing/TEST_STRATEGY.md`, `TEST_CASES.md` | 23, 55 | TEST-001…025, 101…117 | No financial/invariant/scenario tests | Extend |
| `testing/TEST_RESULTS.md`, `BUG_REPORTS.md` | 7, 14 | Honest: nothing executed | Keep honesty | Extend |
| `operations/*` (4), `deployment/*` (4), `setup/*` (4 md + 1 txt) | 7–35 | Firebase/Android only | Web hosting, settlement/reconciliation runbooks | Rewrite / Extend |
| `references/SOURCES.md` | 14 | Source list | Add gateway, ledger, web sources | Extend |
| `verification/*` (3 md) | 5–38 | Old counts 80/129/153 | Stale | History + New reports |
| `diagrams/README.md` + 4 `.mmd` | 14 | Old model | Mermaid `.mmd` untouched; new diagrams in `.md` | Rewrite README; New diagram `.md` files |
| Root docs → FINAL | — | `README`, `AGENTS`, `CHANGELOG`, `CONTRIBUTING`, `SECURITY` | Single-app | Carry (as `PROJECT_AGENT_OPERATING_RULES.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md` inside FINAL) |
| `app/README.md`, `firebase/SECURITY_REVIEW.md` | — | Code-adjacent docs | — | Referenced in code reality snapshot / security review |

New top-level and analysis files: `MASTER_INDEX.md`, `CHANGE_SUMMARY.md`; analysis: this audit, gap analysis, file refinement plan, conflict register, provenance matrix, requirements change log, obsolete document review, conventions, two source digests; verification: coverage, consistency audit, final verification report, open decisions.

## 4. Summary counts (recomputed at final verification)

Inspected project-owned Markdown files (excluding generated/tool files): about 110 (85 in FINAL_REFINED_DOCS, the `docs/` twins and 6 root files already represented, 2 code-adjacent). Files rewritten in place: about 65. Files extended: about 15. Files superseded with banners: 3 ADR/inventory pairs. New files: about 80 (see refinement plan for the exact list).
