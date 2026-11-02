# File-by-file refinement plan

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead (primary agent) |
| Purpose | The execution plan: for every target file, who writes it, which originals must be read in full first, and what must change. Fixes the exact set of target paths so that cross-links agree before the files exist. |
| Depends on | [Audit](EXISTING_DOCUMENT_AUDIT.md), [gap analysis](GAP_ANALYSIS.md), [conventions](CONVENTIONS_AND_ID_REGISTER.md) |
| Status | Plan executed in two waves of parallel authors plus primary integration; completion is recorded in [final verification](../verification/FINAL_VERIFICATION_REPORT.md). |

## 1. Rewrite protocol

For each assigned file the author (1) reads the original in `FINAL_REFINED_DOCS/` completely, (2) reads the relevant parts of the two source digests, (3) writes a new version section by section, keeping every still-valid fact, control, state, workflow and decision, and recording any removal in the conflict register input, (4) tags provenance, (5) links to authoritative neighbours, (6) states acceptance/verification conditions and open decisions, (7) writes only Markdown inside `FINAL_REFINED_DOCS/`. Originals outside this folder are never touched.

## 2. Author assignments and target paths

| Author | Folder(s) | Target files |
|---|---|---|
| **Primary** (done) | `analysis/`, `requirements/` foundation | `SOURCE_MASTER_PROMPT_DIGEST`, `SOURCE_LEGACY_PROTOTYPE_DIGEST`, `CONVENTIONS_AND_ID_REGISTER`, `EXISTING_DOCUMENT_AUDIT`, `GAP_ANALYSIS`, `FILE_REFINEMENT_PLAN`; `requirements/GLOSSARY_AND_TERMINOLOGY`, `requirements/POLICY_DECISION_REGISTER` |
| **Primary** (integration) | root, `analysis/`, `verification/`, matrix | `README`, `MASTER_INDEX`, `CHANGE_SUMMARY`, `analysis/CONFLICT_REGISTER`, `PROVENANCE_MATRIX`, `REQUIREMENTS_CHANGE_LOG`, `OBSOLETE_DOCUMENT_REVIEW`, `requirements/REQUIREMENTS_TRACEABILITY_MATRIX`, `design/COMPLETE_SCREEN_INVENTORY`, `design/INVENTORY_RECONCILIATION`, `verification/DOCUMENTATION_COVERAGE`, `CONSISTENCY_AUDIT`, `FINAL_VERIFICATION_REPORT`, `OPEN_DECISIONS` |
| **A** | `requirements/`, `planning/`, root files | `requirements/`: PROJECT_VISION, PROJECT_SCOPE, STAKEHOLDER_ANALYSIS, USER_ROLES, FUNCTIONAL_REQUIREMENTS (FR-001…050), NON_FUNCTIONAL_REQUIREMENTS, USER_STORIES, USE_CASES, ACCEPTANCE_CRITERIA, BUSINESS_RULES (extend, preserve text), ASSUMPTIONS_AND_CONSTRAINTS, SCREENSHOT_SCOPE_RECONCILIATION, SOURCE_MATERIAL_REGISTER; `planning/`: PRODUCT_DELIVERY_PLAN, TECHNICAL_EXECUTION_PLAN, IMPLEMENTATION_PLAN, PROJECT_ROADMAP, RELEASE_PLAN, RISK_REGISTER, DEPENDENCY_MAP; root: `SRS`, `PROJECT_STATUS`, `DELIVERABLE_COVERAGE`, `TASKS`, `CHANGELOG`, `CONTRIBUTING`, `SECURITY`, `PROJECT_AGENT_OPERATING_RULES` |
| **B1** | `architecture/`, `adr/`, `database/` | architecture: SYSTEM_ARCHITECTURE, MULTI_APP_ARCHITECTURE, BACKEND_DOMAIN_DESIGN, TECH_STACK, MODULE_DESIGN, DATA_FLOW, INTEGRATION_DESIGN, SECURITY_ARCHITECTURE, TIME_AND_CUTOFF_POLICY, REACT_TO_FLUTTER_MIGRATION, FILE_MAP, CODE_REALITY_SNAPSHOT; adr: 001 (banner), 002 (rewrite), 003 (banner), 004…014 (`004-four-app-monorepo.md`, `005-hybrid-datastore.md`, `006-double-entry-ledger.md`, `007-payment-gateway-abstraction-and-cod.md`, `008-idempotent-command-envelope.md`, `009-quote-and-price-snapshots.md`, `010-payout-maker-checker.md`, `011-roles-claims-and-sessions.md`, `012-notifications-and-scheduled-jobs.md`, `013-time-zone-and-cutoff-evaluation.md`, `014-subscription-agreement-and-meal-obligations.md`); database: DATABASE_DESIGN, DATA_DICTIONARY, ENTITY_RELATIONSHIPS, FINANCIAL_DATA_MODEL, DATA_CONSISTENCY, INDEXING_STRATEGY, MIGRATION_STRATEGY, DATA_RETENTION |
| **B2** | `api/` | API_SPECIFICATION (envelope, conventions, command index with every command in the register), `api/COMMANDS_IDENTITY_AND_CATALOGUE.md`, `COMMANDS_ORDERS_AND_SUBSCRIPTIONS.md`, `COMMANDS_PAYMENTS_AND_COD.md`, `COMMANDS_DELIVERY.md`, `COMMANDS_EARNINGS_AND_PAYOUTS.md`, `COMMANDS_LEDGER_AND_GOVERNANCE.md`, AUTHORIZATION, ERROR_RESPONSES, EVENT_AND_NOTIFICATION_DESIGN |
| **C1** | `payments/`, `security/` | payments: PAYMENT_ARCHITECTURE, SSLCOMMERZ_INTEGRATION_PLAN, COD_PAYMENT_WORKFLOW, PRICING_AND_BILLING, CUSTOMER_CREDIT_RULES; security: THREAT_MODEL, SECURITY_REQUIREMENTS, SECRETS_MANAGEMENT, DEPENDENCY_REVIEW, SECURITY_REVIEW_PLANNING, FINANCIAL_SECURITY, AUDIT_AND_COMPLIANCE |
| **C2** | `accounts-web/` | ACCOUNTS_ARCHITECTURE, FINANCE_DASHBOARD, FINANCIAL_LEDGER, PAYMENT_RECONCILIATION, SUPPLIER_SETTLEMENT, RIDER_SETTLEMENT, PAYOUT_MANAGEMENT, COD_RECONCILIATION, REFUNDS_AND_ADJUSTMENTS, ACCOUNTS_UI_UX |
| **D1** | `customer-app/` | CUSTOMER_MODULES, KITCHEN_AND_MEAL_SYSTEM, ORDER_MANAGEMENT, CUSTOM_SUBSCRIPTION_ENGINE, MEAL_SCHEDULING, CUSTOMER_CREDITS, CUSTOMER_UI_UX |
| **D2** | `partner-app/`, `admin-web/` | partner-app: PARTNER_APP_ARCHITECTURE, SUPPLIER_MODULES, RIDER_MODULES, SUPPLIER_EARNINGS, RIDER_EARNINGS, COD_COLLECTION, PARTNER_UI_UX; admin-web: ADMIN_DASHBOARD, OPERATIONS_MANAGEMENT, APPROVAL_WORKFLOWS, ADMIN_UI_UX |
| **E1** | `design/` system docs | DESIGN_SYSTEM, UI_UX_GUIDELINES, ACCESSIBILITY, NAVIGATION_ARCHITECTURE, NAVIGATION_MAP, COMPONENT_SPECIFICATIONS, RESPONSIVE_LAYOUTS, SCREEN_VERIFICATION_CHECKLIST, PDF_PRODUCTION_PLAN; extend SCREENSHOT_ACTION_AUDIT (mapping column); history banners on SCREEN_INVENTORY and SCREEN_AND_CONTROL_INVENTORY |
| **E2a** | `design/screens/` customer | `CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md` (P-01…04, AU-01…08, AU-12), `CUSTOMER_SCREENS.md` (C-01…25) |
| **E2b** | `design/screens/` new customer + shared | `CUSTOMER_NEW_SCREENS.md` (NC-01…19), `SHARED_SCREENS.md` (SH-01, 02, 04…10 for all five app instances) |
| **E3** | `design/screens/` partner | `PARTNER_APPLICATION_SCREENS.md` (AU-09…11), `SUPPLIER_SCREENS.md` (S-01…12, NS-01…07), `RIDER_SCREENS.md` (R-01…10, NR-01…06) |
| **E4** | `design/screens/` admin, accounts, tooling | `ADMIN_SCREENS.md` (AU-13, A-01…19, NA-01…06), `ACCOUNTS_SCREENS.md` (NF-01…17, Accounts instances of AU-13 and SH), `TOOLING_SCREENS.md` (X-01, X-02) |
| **S1** | `scenarios/` | SC-01…SC-09 as `scenarios/SC-01-…md` … one file each |
| **S2** | `scenarios/` | SC-10…SC-17 one file each |
| **S3** | `scenarios/` | SC-18…SC-25 one file each, plus `scenarios/SCENARIO_INDEX.md` and `scenarios/WORKFLOWS_A_TO_J.md` (WF-A…WF-J) |
| **F1** | `testing/` | TEST_STRATEGY, TEST_CASES (TEST-001…025 revised; 026+ new; 118+ ; INV-linked TEST-201…260), FINANCIAL_TEST_CASES, INTEGRATION_TEST_CASES, UI_UX_TEST_CHECKLIST, TEST_RESULTS, BUG_REPORTS |
| **F2** | `operations/`, `deployment/`, `setup/`, `references/`, `diagrams/` | operations: RUNBOOK, BACKUP_RESTORE, MAINTENANCE_PLAN, INCIDENT_RESPONSE, SETTLEMENT_AND_RECONCILIATION_RUNBOOK, GATEWAY_OUTAGE_RUNBOOK, COD_DISCREPANCY_RUNBOOK; deployment: DEPLOYMENT_GUIDE, CI_CD, RELEASE_CHECKLIST, ROLLBACK_PLAN, WEB_HOSTING_ADMIN_AND_ACCOUNTS; setup: DEVELOPMENT_SETUP, CONFIGURATION, ENVIRONMENT_AUDIT, SKILLS_AND_INTEGRATIONS, CAPABILITY_AUDIT_2026-10-30 (history banner), MONOREPO_AND_BUILD_OWNERSHIP; references: SOURCES; diagrams: README plus `SYSTEM_CONTEXT.md`, `APPLICATION_ARCHITECTURE.md`, `AUTH_AND_ROLE_FLOWS.md`, `SUBSCRIPTION_LIFECYCLE.md`, `PAYMENT_AND_COD_WORKFLOW.md`, `ACCOUNTS_AND_SETTLEMENT.md`, `DATABASE_RELATIONSHIPS.md`, `DELIVERY_STATES.md` (Mermaid blocks inside Markdown; existing `.mmd` files untouched) |

## 3. Cross-link contract

Everyone may link to any path in §2. Mutual references use the identifiers in the [register](CONVENTIONS_AND_ID_REGISTER.md) (FR-, BR-, ent., command names, screen IDs, SC-, INV-). No author may define a new identifier range or rename a command, entity, screen or scenario. A needed addition is reported in the author's hand-off note and merged by the primary agent.

## 4. Integration steps (primary)

1. Collect each author's hand-off note (created files, unresolved cross-reference needs, discrepancies).
2. Write the traceability matrix from the finished FR/UC/AC/TEST/screen/command/entity files.
3. Write the complete screen inventory and reconciliation from the screen files and the F129 mapping.
4. Write the conflict register, provenance matrix, change log, obsolete-document review.
5. Verify (read-only searches): links, identifier uniqueness, counts, forbidden claims, Mermaid fences, git status.
6. Write coverage, consistency audit, open decisions, final verification report, change summary, README and MASTER_INDEX.

## 5. Expected final file count

About 150 Markdown files under `FINAL_REFINED_DOCS/` (the 85 existing, roughly 70 new, some counted twice as rewritten). The verification report states the measured count.
