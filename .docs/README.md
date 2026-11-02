# Smart Tiffin documentation (FINAL_REFINED_DOCS)

| Field | Value |
|---|---|
| Revision | 3.0 · 2026-10-30 (four-application rewrite) |
| Owner | Documentation lead |
| Status | Documentation refinement complete. `docs/` (the original tree) remains untouched and canonical only until a separately approved cutover; this folder is now the more advanced, four-application baseline. |

## What this is

The complete, rewritten documentation for Smart Tiffin as **four applications on one shared backend**: Customer App, Partner App (supplier and rider workspaces), Admin Web, Accounts Web. It follows the user's two primary requirement sources — an expanded master prompt and the 94-screen legacy prototype documentation — both preserved in [analysis/](analysis/). See [CHANGE_SUMMARY.md](CHANGE_SUMMARY.md) for what changed and [MASTER_INDEX.md](MASTER_INDEX.md) for where to find anything.

## Start here

1. [PROJECT_STATUS.md](PROJECT_STATUS.md) — what exists, what doesn't, what's blocked.
2. [SRS.md](SRS.md) — the organised entry point into the full requirements catalogue.
3. [requirements/BUSINESS_RULES.md](requirements/BUSINESS_RULES.md) and [requirements/POLICY_DECISION_REGISTER.md](requirements/POLICY_DECISION_REGISTER.md) — the 26 business rules, all Pending Decision.
4. [MASTER_INDEX.md](MASTER_INDEX.md) — question-to-file index.
5. [verification/FINAL_VERIFICATION_REPORT.md](verification/FINAL_VERIFICATION_REPORT.md) — what was actually checked.

## Hard constraints this package follows

Markdown only, inside this folder. No application code was modified. No test was executed. No business policy was approved. No real SSLCOMMERZ or PostgreSQL credential was used. See [requirements/SOURCE_MATERIAL_REGISTER.md](requirements/SOURCE_MATERIAL_REGISTER.md) for the provenance of the two primary sources, and [analysis/CONVENTIONS_AND_ID_REGISTER.md](analysis/CONVENTIONS_AND_ID_REGISTER.md) for the authoring rules every file follows.

## Folder guide

| Folder | Content |
|---|---|
| `analysis/` | How this rewrite was planned and reconciled |
| `requirements/`, `planning/` | Product facts, FR/UC/AC/BR/DEC identifiers, roadmap |
| `architecture/`, `database/`, `api/`, `adr/` | Technical design and candidate contracts |
| `payments/`, `accounts-web/` | Payment, pricing, credit and finance domain |
| `customer-app/`, `partner-app/`, `admin-web/` | Per-application module specifications |
| `design/` (+ `design/screens/`) | UX, design system, and full screen contracts for all 149 screens |
| `scenarios/` | 25 end-to-end business/financial scenarios and 10 workflows |
| `security/` | Threat model, controls, financial security, audit/compliance questions |
| `testing/` | Test strategy and planned cases (none executed) |
| `operations/`, `deployment/`, `setup/`, `references/`, `diagrams/` | Running, releasing and sourcing the system |
| `verification/` | Coverage, consistency and final verification evidence |
