# Payout management (Accounts Web)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Accounts Web domain author |
| Purpose | Define the payout request review (NF-07) and batch execution (NF-08) screens and the full maker-checker state machine. |
| Applies to | ACC (screens NF-07, NF-08) |
| Depends on | [ADR-010](../adr/010-payout-maker-checker.md), [api/COMMANDS_EARNINGS_AND_PAYOUTS.md](../api/COMMANDS_EARNINGS_AND_PAYOUTS.md) |
| Authoritative policies | BR-014 (thresholds/frequency/holds), BR-020 (approval limits) — PENDING |
| Status | PROPOSED — NOT APPROVED. |

## State machine

Requested → Under Review (AcOp) → Approved (PayAp, ≠ requester) → Processing (batched by AcOp, released by PayAp ≠ batch creator) → Settled (only after independently confirmed external transfer) | Failed | Rejected.

## NF-07 — Payout request review

AcOp inspects the request against the supplier/rider's eligible balance (INV-14), beneficiary verification status, and any exceptions. Reject with a reason, or forward for approval.

## NF-08 — Payout batch execution

AcOp creates a batch of approved requests; PayAp (not the batch's creator) releases it. External transfer execution happens outside this system (bank/MFS); `recordPayoutResult` captures the actual outcome, which alone may mark Settled. A failed external transfer returns the request to review, never silently retried as a new payout.

## Approval limits (BR-020, PENDING)

Thresholds for when a second approver is required are named parameters (`policy.payout.dual_approval_threshold`), not a hard-coded value.

## Acceptance and verification

Design-only. Verification requires: SC-11 (supplier withdrawal) and SC-12 (rider payout while COD owed) scenario tests passing against this state machine; a self-approval attempt rejected (SC-16).
