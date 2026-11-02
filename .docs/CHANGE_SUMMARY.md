# Change summary — four-application documentation rewrite

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Status | Documentation complete per this summary; nothing implemented. |

## What changed

Smart Tiffin's documentation is rewritten from a single combined Android/Firebase application into **four applications on one shared backend**: Customer App, Partner App (supplier and rider workspaces), Admin Web, Accounts Web. This follows the user's two primary requirement sources: an expanded master prompt (now preserved as [analysis/SOURCE_MASTER_PROMPT_DIGEST.md](analysis/SOURCE_MASTER_PROMPT_DIGEST.md)) and the 94-screen legacy prototype documentation (now [analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md](analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md)).

## New capability documented

Flexible daily/weekly/monthly/custom subscriptions with an agreement/obligation model; non-cash service credits; SSLCOMMERZ gateway abstraction (sandbox-ready, not connected) plus four distinct COD models; supplier and rider earnings independent of each other and of COD custody; a dedicated Accounts department with a double-entry ledger, reconciliation, and maker-checker payouts; 55 proposed screens (NC-19/NS-7/NR-6/NA-6/NF-17) fully specified alongside the 94 legacy screens; 25 cross-system scenarios and 10 workflows; 21 new business rules (BR-006…026); 11 new architecture decision records.

## Files

~150 new files, ~65 files revised in place, 2 files archived with a historical banner (nothing deleted), 212 Markdown files total in `FINAL_REFINED_DOCS/`. Full lists: [analysis/EXISTING_DOCUMENT_AUDIT.md](analysis/EXISTING_DOCUMENT_AUDIT.md), [analysis/OBSOLETE_DOCUMENT_REVIEW.md](analysis/OBSOLETE_DOCUMENT_REVIEW.md).

## Unresolved decisions

26 business rules (BR-001…005 original, BR-006…026 new), all **Pending Decision**, owner "business owner/authorised stakeholder — to be identified." Full register: [requirements/POLICY_DECISION_REGISTER.md](requirements/POLICY_DECISION_REGISTER.md). Legal/regulatory questions for Bangladesh (stored value, credits, tax, payout handling) are listed, not answered, in [security/AUDIT_AND_COMPLIANCE.md](security/AUDIT_AND_COMPLIANCE.md).

## Tests not executed

Every TEST-*, SCT-*, and INV-* check in [testing/](testing/) and [scenarios/](scenarios/) is planned, none executed. The repository's own backend/app test claims (OBSERVED, not re-run by this effort) are recorded honestly in [testing/TEST_RESULTS.md](testing/TEST_RESULTS.md).

## What this delivery is not

Not an implemented application. Not a legal compliance determination. Not a rendered visual design or PDF (a later deliverable). Not a connected payment gateway. `docs/` (the original tree) and the repository root files remain untouched and unchanged, per the user's instruction; they are stale relative to this package until a separately approved cutover.

## Where to go next

[verification/OPEN_DECISIONS.md](verification/OPEN_DECISIONS.md) lists every open item; [TASKS.md](TASKS.md) TASK-115…128 lists the implementation sequence once BR-006…026 and the remaining BR-001…005 are approved.
