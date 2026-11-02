# Accounts Web: NF-01 to NF-17

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Purpose | Full contracts for the seventeen Accounts Web screens, entirely new (conflict register C-06). |
| Applies to | ACC |
| Depends on | [accounts-web/* module docs](../../accounts-web/), [api/COMMANDS_LEDGER_AND_GOVERNANCE.md](../../api/COMMANDS_LEDGER_AND_GOVERNANCE.md), [api/COMMANDS_EARNINGS_AND_PAYOUTS.md](../../api/COMMANDS_EARNINGS_AND_PAYOUTS.md) |
| Status | All PROPOSED. None is an observed prototype route (this application did not exist before). |

## Screens

| ID | Name | Purpose | Commands | Module doc |
|---|---|---|---|---|
| NF-01 | Finance executive overview | Verified collections, receivables, payables, revenue, exceptions | reads only | [FINANCE_DASHBOARD](../../accounts-web/FINANCE_DASHBOARD.md) |
| NF-02 | Online payment reconciliation | Match gateway settlements to records | `reconcileGatewayStatement` | [PAYMENT_RECONCILIATION](../../accounts-web/PAYMENT_RECONCILIATION.md) |
| NF-03 | COD collection dashboard | Rider × date custody tracking | reads only | [COD_RECONCILIATION](../../accounts-web/COD_RECONCILIATION.md) |
| NF-04 | COD deposit verification | Confirm a remittance | `verifyCodRemittance` | [COD_RECONCILIATION](../../accounts-web/COD_RECONCILIATION.md) |
| NF-05 | Supplier payable ledger | Recognised earnings, holds, eligible balance | `placeHold`/`releaseHold` | [SUPPLIER_SETTLEMENT](../../accounts-web/SUPPLIER_SETTLEMENT.md) |
| NF-06 | Rider payable ledger | Compensation independent of COD custody | `placeHold`/`releaseHold` | [RIDER_SETTLEMENT](../../accounts-web/RIDER_SETTLEMENT.md) |
| NF-07 | Payout request review | Evaluate requests | `reviewPayout`, `rejectPayout` | [PAYOUT_MANAGEMENT](../../accounts-web/PAYOUT_MANAGEMENT.md) |
| NF-08 | Payout batch execution | Release approved batches | `createPayoutBatch`, `releasePayoutBatch`, `recordPayoutResult` | [PAYOUT_MANAGEMENT](../../accounts-web/PAYOUT_MANAGEMENT.md) |
| NF-09 | Customer credit liability | Credit issuance/redemption/void tracking | `voidCredit` | [REFUNDS_AND_ADJUSTMENTS](../../accounts-web/REFUNDS_AND_ADJUSTMENTS.md) |
| NF-10 | Refund and chargeback management | Refunds vs disputes vs credits | `initiateRefund`, `recordRefundResult` | [REFUNDS_AND_ADJUSTMENTS](../../accounts-web/REFUNDS_AND_ADJUSTMENTS.md) |
| NF-11 | General ledger explorer | Browse journals | reads only; `reverseJournal` | [FINANCIAL_LEDGER](../../accounts-web/FINANCIAL_LEDGER.md) |
| NF-12 | Period close workspace | Close/reopen periods | `closePeriod`, `reopenPeriod` | [FINANCIAL_LEDGER](../../accounts-web/FINANCIAL_LEDGER.md) |
| NF-13 | Reconciliation exceptions | Unmatched/duplicate/invalid items | reads, resolution links | [PAYMENT_RECONCILIATION](../../accounts-web/PAYMENT_RECONCILIATION.md) |
| NF-14 | Financial report export | Secured export with provenance | `exportReport` | [ACCOUNTS_UI_UX](../../accounts-web/ACCOUNTS_UI_UX.md) |
| NF-15 | Finance role permissions | Staff/sub-role grants | `grantStaffRole`, `revokeStaffRole` | [ACCOUNTS_ARCHITECTURE](../../accounts-web/ACCOUNTS_ARCHITECTURE.md) |
| NF-16 | Financial adjustment approval | Manual corrections, maker-checker | `requestAdjustment`, `approveAdjustment` | [REFUNDS_AND_ADJUSTMENTS](../../accounts-web/REFUNDS_AND_ADJUSTMENTS.md) |
| NF-17 | Gateway settlement statement | Reconcile provider statements | `reconcileGatewayStatement` | [PAYMENT_RECONCILIATION](../../accounts-web/PAYMENT_RECONCILIATION.md) |

## Accounts instances of shared screens

AU-13 (Accounts staff sign-in, same screen as Admin's with its own role grant check) and SH-01/05/08 per-app instances are specified in [SHARED_SCREENS.md](SHARED_SCREENS.md) and [ADMIN_SCREENS.md](ADMIN_SCREENS.md); not duplicated here.

## F129 reconciliation

No F129 family maps here directly — this entire application is new (USER-REQ). The only prior-art connection is the legacy A-12/A-13 "Treasury & settlements"/"Payout batch" rows, explicitly re-pointed to NF-08/NF-12 per [design/INVENTORY_RECONCILIATION.md](../INVENTORY_RECONCILIATION.md).
