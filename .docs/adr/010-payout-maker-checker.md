# ADR-010: Maker-checker segregation of duties for payouts and adjustments

| Field | Value |
|---|---|
| Status | PROPOSED — NOT APPROVED |
| Date | 2026-10-30 |

## Context

USER-REQ: the authority to prepare a payment must be separate from the authority to approve or finalise it; administrative overview must not imply unrestricted ability to transfer money or approve own payouts; "Super Admin" must have explicitly bounded privileges.

## Options considered

1. Single-approver model: any Accounts Operator or above may both prepare and approve a payout/adjustment.
2. Maker-checker: the preparer and the approver must be different principals, enforced at the command layer; thresholds configurable per role.
3. Maker-checker only above a configured monetary threshold; smaller amounts single-approved.

## Decision

Option 2 as the default, with option 3 available as a future refinement once BR-020 supplies an approved threshold (currently none exists, so maker-checker applies to every payout and adjustment in this phase). `approvePayout`/`approveAdjustment` reject a request whose approver identity matches its preparer identity, independent of role.

## Consequences

Every payout/adjustment needs at least two distinct staff accounts in the loop, which is slower than a single-approver model but directly satisfies the USER-REQ segregation-of-duties requirement and closes the SC-16 attack/misuse scenario (an Admin approving their own prepared payout).

## Risks

A two-person Accounts team cannot both prepare and approve without a third party — an operational staffing risk flagged, not solved, by this ADR.

## Links

[accounts-web/PAYOUT_MANAGEMENT.md](../accounts-web/PAYOUT_MANAGEMENT.md), BR-020, NFR-016, SC-16, INV-15.
