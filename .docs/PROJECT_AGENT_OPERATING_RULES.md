# Operating rules for agents working in this documentation set

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 (carries forward the root `AGENTS.md` rules, updated for the four-application scope) |
| Owner | Documentation lead |
| Status | Current. Applies to any human or AI agent editing `FINAL_REFINED_DOCS/`. |

## Scope and sources

Smart Tiffin connects customers, suppliers, delivery personnel, operations/administration staff and Accounts/finance staff across four applications (Customer App, Partner App, Admin Web, Accounts Web) on one shared backend. The 2026-10-30 user request covers full documentation refinement of the complete four-application, finance-enabled platform: a gap analysis and refinement plan first, then a deep, section-by-section rewrite preserving every still-valid requirement, screen, workflow and decision, fully reconciled against the legacy 94-screen prototype and the prior 129-family planning inventory, with complete traceability and verification. See [analysis/FILE_REFINEMENT_PLAN.md](analysis/FILE_REFINEMENT_PLAN.md).

Read [project status](PROJECT_STATUS.md), [tasks](TASKS.md), [SRS](SRS.md), the [business rules](requirements/BUSINESS_RULES.md) and the [policy decision register](requirements/POLICY_DECISION_REGISTER.md) before changing scope. Inspect actual files before editing; preserve existing work. The two primary sources (master prompt, legacy prototype documentation) are supplied in conversation, not repository files; they are preserved as digests in [analysis/](analysis/) and must be read before any content they govern is rewritten.

## Canonical ownership

Product facts, FR/UC/AC/BR/DEC identifiers and decisions live in `requirements/`. Architecture and candidate contracts live in `architecture/`, `database/`, `api/`, `adr/`. Payment, credit and finance domain specifications live in `payments/` and `accounts-web/`. UX lives in `design/`; test designs and actual results live in `testing/`. Setup, release preparation and operations live in their respective folders. One tracker: `TASKS.md`. Route documents through `README.md` and `DELIVERABLE_COVERAGE.md`.

BR-001…BR-005 (pause, billing, payment verification, assignment, cancellation/refunds) and the extended BR-006…BR-026 are all stable identifiers with their sole policy definition in `requirements/BUSINESS_RULES.md` and `requirements/POLICY_DECISION_REGISTER.md`. All twenty-six remain Pending until specific approval evidence is recorded. No guessed cutoff, formula, verifier, assignment owner, commission rate, payout threshold, tax rate or refund entitlement.

## Boundaries that remain in force

Keep presentation separate from business behaviour and data access, across all four applications. Follow the architecture decisions recorded in `adr/`; current candidate schemas are not final implementation contracts. Use sound null safety, typed boundary parsing, explicit errors, awaited writes, idempotent retry behaviour (this applies equally to Firestore commands and the proposed PostgreSQL ledger). Use server-authoritative money and role changes, integer financial representation (once currency policy is approved), atomic lifecycle changes, minimal PII and fail-closed authorization. Route guards alone are never sufficient; the trusted boundary decides. Preserve the four confirmed delivery states. Never package a service-account key or a gateway secret in any client app, mobile or web.

## Validation and delivery

Documentation is done when required facts and unresolved decisions are explicit, links and identifiers are coherent, deliverable coverage is complete, and actual verification is recorded in `verification/`. Product completion additionally requires implemented acceptance criteria and measured checks; this package is not a production release. Use focused changes; no unrelated cleanup, secret files, real customer fixtures, forced git operations, or automatic licence choice. Review the diff, preserve user edits, and never claim commits, remote CI, integration or release evidence that does not exist.
