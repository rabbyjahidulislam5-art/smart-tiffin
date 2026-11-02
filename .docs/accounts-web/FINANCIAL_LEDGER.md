# Financial ledger (Accounts Web)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Accounts Web domain author |
| Purpose | Define the ledger journal explorer (NF-11) and period close workspace (NF-12) screens' behaviour, building on the chart of accounts and posting rules in [database/FINANCIAL_DATA_MODEL.md](../database/FINANCIAL_DATA_MODEL.md). |
| Applies to | ACC (screens NF-11, NF-12) |
| Depends on | [ADR-006](../adr/006-double-entry-ledger.md), [database/FINANCIAL_DATA_MODEL.md](../database/FINANCIAL_DATA_MODEL.md) |
| Status | PROPOSED — NOT APPROVED. |

## General ledger explorer (NF-11)

Browse balanced journal entries with consistent account hierarchy; filter by account, period, source command, or originating entity. Each `ent.JournalEntry` shows its lines, source command, policy version used, and timestamp. No edit action exists on a Posted entry; the only actions are `reverseJournal` (AcMgr, checking an above-limit case) and navigating to a linked reversing entry.

## Period close workspace (NF-12)

Checklist-driven close: (1) all gateway settlements reconciled (NF-02); (2) all COD remittances verified (NF-04); (3) all open reconciliation exceptions resolved or explicitly carried forward with a reason (NF-13); (4) credit and payable balances agree with their supporting transaction sums. `closePeriod` is disabled until the checklist is satisfied. A late event arriving after close posts to the next open period with an adjusting reference, never backdated (SC-15, INV-16). `reopenPeriod` requires AcMgr request plus an independent approver — governed, not routine.

## Recognition vs cash movement

The screen always labels whether a figure reflects recognised (accrual) value or actual cash movement; these are never merged into one number (USER-REQ: "recognition policy separate from cash movement").

## Acceptance and verification

Design-only. Verification requires: an attempted edit of a Posted line rejected; a period close blocked while an exception is open; a late event correctly routed to the next open period.
