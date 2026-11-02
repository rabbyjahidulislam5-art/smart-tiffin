# Supplier settlement (Accounts Web)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Accounts Web domain author |
| Purpose | Define the supplier payable ledger screen (NF-05): recognised earnings, adjustments, holds and unpaid claims. |
| Applies to | ACC (screen NF-05) |
| Depends on | [partner-app/SUPPLIER_EARNINGS.md](../partner-app/SUPPLIER_EARNINGS.md), BR-009, BR-010 |
| Status | PROPOSED — NOT APPROVED. |

## Content

Per-supplier table: recognised earnings (sum of `ent.SupplierEarning`), platform deductions (commission per BR-009), active holds (`ent.Hold`), disputes affecting the balance, and the resulting eligible-for-payout figure. Every line is traceable to its source order/obligation and recognition event (BR-010). Accounts can place or release a hold here (`placeHold`/`releaseHold`) with a reason; it cannot directly edit a recognised-earning figure — only a reversing adjustment can change it.

## Explaining an available payout amount

The screen's primary purpose (per the master prompt's NS-01/NF-05 contracts): explain, to an auditor's satisfaction, exactly why a given amount is available for payout — every contributing recognised earning, every deduction, every hold, with links to each source.

## Acceptance and verification

Design-only. Verification requires: a held amount excluded from the eligible-for-payout figure; a disputed obligation excluded until resolved.
