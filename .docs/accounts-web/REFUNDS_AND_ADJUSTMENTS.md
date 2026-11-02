# Refunds and adjustments (Accounts Web)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Accounts Web domain author |
| Purpose | Define the customer credit liability (NF-09), refund/chargeback management (NF-10) and financial adjustment approval (NF-16) screens as independent workflows. |
| Applies to | ACC (screens NF-09, NF-10, NF-16) |
| Depends on | [payments/CUSTOMER_CREDIT_RULES.md](../payments/CUSTOMER_CREDIT_RULES.md), BR-005, BR-015, BR-020, BR-025 |
| Status | PROPOSED — NOT APPROVED. |

## NF-09 — Customer credit liability

Tracks `customer_credit_liability` issuances, redemptions, voids and the remaining balance, reconciled against deferred-revenue-style obligations. A credit is never shown as cash available to the customer; the screen's own language distinguishes it explicitly (glossary).

## NF-10 — Refund and chargeback management

Three independent workflows, never merged: (1) service-credit issuance (handled in NF-09, not here); (2) gateway refund (`initiateRefund`/`recordRefundResult`); (3) externally filed chargeback (`ent.Dispute`, evidence review, loss allocation per BR-015 once approved). A refund and a credit are never both granted for the same obligation (INV-17, enforced at the command layer and visible here as a blocking check).

## NF-16 — Financial adjustment approval

Rare manual corrections. AcOp prepares a `requestAdjustment` with old state, proposed journal and supporting evidence; AcMgr or PayAp (never the requester) approves, posting `adjustmentPosted`. No posted balance is ever overwritten directly — the approval produces a new correcting journal (INV-02).

## Acceptance and verification

Design-only. Verification requires SC-14 (partial refund during partial fulfilment) to compute the refundable base from unfulfilled obligations only, and SC-24 (adjustment after an external payout) to never delete or edit the original settled transfer's history.
