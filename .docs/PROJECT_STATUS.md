# Project status

| Field | Value |
|---|---|
| Revision | 3.0 · 2026-10-30 (supersedes 2.0, which predated the four-application documentation rewrite) |
| Owner | Documentation lead (primary agent) |
| Purpose | State exactly what exists, what this documentation effort did, and what remains open, without over- or under-claiming. |
| Status | Documentation refinement phase. No application implementation performed by this effort. |

## What this effort did

Following the user's two primary requirement sources (an expanded master prompt specifying four Flutter applications, a flexible subscription/credit/payment/ledger domain, 25 cross-system scenarios and 55 proposed screens; and a 94-screen legacy React prototype documentation), this effort produced a complete, deeply rewritten documentation set inside `FINAL_REFINED_DOCS/`: a gap analysis and file-by-file refinement plan; extended requirements (FR-026…050, UC/AC/US to match, BR-006…026); a four-application architecture with eleven new ADRs; an extended database/financial data model; a full API command specification; payment, credit, COD and Accounts Web domain specifications; customer/partner/admin module specifications; a reconciled screen inventory covering all 94 legacy screens plus 55 proposed screens with full per-screen contracts; 25 end-to-end scenarios and 10 workflows; extended testing, security, operations, deployment, setup and diagram documentation; and a final verification pass. See [DELIVERABLE_COVERAGE.md](DELIVERABLE_COVERAGE.md) for the complete mapping and [verification/FINAL_VERIFICATION_REPORT.md](verification/FINAL_VERIFICATION_REPORT.md) for what was actually checked.

## What exists on disk (OBSERVED, unchanged by this effort)

`app/` is a real single combined Flutter project (~9,600 lines of Dart; package `smart_tiffin`); `backend/functions` is a real Cloud Functions project with one callable (`executeCommand`), idempotent receipts and 9 working plus 21 policy-gated commands; `firebase/` holds deny-by-default Firestore/Storage rules. All three are **untracked in git** and **not independently verified by this effort**. See [architecture/CODE_REALITY_SNAPSHOT.md](architecture/CODE_REALITY_SNAPSHOT.md). None of this constitutes the four-application target architecture described in this documentation set; it is the current single-app baseline the eventual migration starts from (see [architecture/REACT_TO_FLUTTER_MIGRATION.md](architecture/REACT_TO_FLUTTER_MIGRATION.md) and TASK-010 in [TASKS.md](TASKS.md)).

## What does not exist

No Admin Web, no Accounts Web, no Partner App with separated supplier/rider workspaces, no PostgreSQL ledger, no SSLCOMMERZ integration (sandbox or otherwise), no rendered design PDF, no executed test of any kind beyond what the repository's own README files claim (and those claims are recorded as OBSERVED, not re-run — see [testing/TEST_RESULTS.md](testing/TEST_RESULTS.md)).

## Decisions and blockers

All twenty-six business rules remain **Pending Decision**. Decision owner for every one: **business owner/authorised stakeholder — to be identified**.

| Rule group | Decision state | Blocked implementation |
|---|---|---|
| BR-001…BR-005 (original: pauses, billing, payment verification, assignment, cancellation/refunds) | Pending Decision | Exactly as recorded in [BUSINESS_RULES.md](requirements/BUSINESS_RULES.md) |
| BR-006…BR-026 (extended: credits, fees, commission, earning recognition, COD, payouts, disputes, tax, approval limits, multi-kitchen, cutoff, dual-role, kitchen discontinuity, legal status of credits, COD netting) | Pending Decision | Exactly as recorded in [POLICY_DECISION_REGISTER.md](requirements/POLICY_DECISION_REGISTER.md) |

## Independent next work

Within documentation: stakeholder review of this package, and the remaining open items listed in [verification/OPEN_DECISIONS.md](verification/OPEN_DECISIONS.md). On an explicit, separately authorised later implementation request: establish the four-application monorepo, implement policy-neutral foundations (auth, catalogue, non-financial schema) and test authorization boundaries with synthetic data, before any policy-dependent financial behaviour is finalised.

## Next concrete action

The authorised stakeholder records decisions for BR-001 through BR-026 in the canonical registers, with exact chosen policies and approval evidence. Implementation follows as a separate, later phase.
