# COD reconciliation (Accounts Web)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Accounts Web domain author |
| Purpose | Define the COD collection dashboard (NF-03) and deposit verification (NF-04) screens. |
| Applies to | ACC (screens NF-03, NF-04) |
| Depends on | [payments/COD_PAYMENT_WORKFLOW.md](../payments/COD_PAYMENT_WORKFLOW.md), BR-013 |
| Status | PROPOSED — NOT APPROVED. |

## NF-03 — COD collection dashboard

Tracks every `ent.CodCollection` from order/obligation creation through rider collection to final Accounts verification, by rider and by date, with overdue items prioritised (per the BR-013 deadline parameter once approved).

## NF-04 — COD deposit verification

AcOp confirms a submitted remittance against its deposit reference and amount; a second operator cannot verify the same receipt twice (INV-12, uniqueness enforced at the database level, not merely by UI disabling a button). An image upload alone is never treated as cash confirmation — verification requires the matching deposit-reference record, not just visual evidence.

## Partial and overdue remittances

A partial remittance reduces the outstanding liability but does not close it; the remaining balance stays `DueForRemittance` (see [payments/COD_PAYMENT_WORKFLOW.md](../payments/COD_PAYMENT_WORKFLOW.md) state machine) and continues to age toward `Overdue`.

## Acceptance and verification

Design-only. Verification requires SC-10 (duplicate receipt) to be rejected and SC-09 (cash mismatch) to be correctly routed to a discrepancy case rather than marking the order paid.
