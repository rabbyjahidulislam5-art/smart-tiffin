# Settlement and reconciliation runbook (daily, weekly, monthly close)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Finance lead; executed by Accounts Operator and Accounts Manager |
| Purpose | Step-by-step procedure and checklists for reconciliation, settlement and period close, including exceptions. |
| Applies to | ACC (Accounts Web), BE ledger commands, PG ledger store |
| Depends on | [Runbook](RUNBOOK.md), [gateway outage](GATEWAY_OUTAGE_RUNBOOK.md), [COD discrepancy](COD_DISCREPANCY_RUNBOOK.md), [incident response](INCIDENT_RESPONSE.md), [financial data model](../database/FINANCIAL_DATA_MODEL.md), [accounts architecture](../accounts-web/ACCOUNTS_ARCHITECTURE.md), [payment reconciliation](../accounts-web/PAYMENT_RECONCILIATION.md), [payout management](../accounts-web/PAYOUT_MANAGEMENT.md), [accounting diagrams](../diagrams/ACCOUNTS_AND_SETTLEMENT.md) |
| Authoritative policies | BR-009, BR-010, BR-011, BR-013, BR-014, BR-020, BR-026 (PENDING). Frequencies and deadlines are parameters (`policy.settlement.*`), none approved |
| Status | **Preparation document. Never executed.** Screens referenced (NF-01 to NF-17) are proposed designs, not built. |

## 1. Principles

1. Reconciliation compares independent sources: ledger, operational records, gateway statements, bank statements, COD deposit evidence, payout provider results. Matching is by stable identifiers (transaction id, deposit reference, payout reference).
2. Posted history is immutable. Differences produce a reconciliation exception, then a reversing or adjusting journal after approval.
3. Maker and checker differ for every adjustment and payout above the configured limit (INV-15).
4. A payout is Settled only after external confirmation (INV-14). Submitted, approved, processing and settled are distinct.
5. No journal is posted into a closed period; late events post to the open period with an adjusting reference (INV-16).
6. Every figure in a checklist names its qualifier: paid, pending, posted, held, reserved, disputed, available.

## 2. Roles

| Role | Does | Does not |
|---|---|---|
| Accounts Operator | Prepares matches, drafts adjustments and payout batches, records COD verification | Approve own drafts |
| Accounts Manager | Reviews exceptions, signs daily and weekly close, approves within limit | Approve own preparation |
| Payout Approver | Checker for payout requests and batches | Prepare the same batch |
| Financial Auditor | Read-only verification of closes and samples | Post or edit |
| Finance Viewer | Reads | Everything else |
| Admin staff | Operational context only | Any settlement authority |

## 3. Daily close checklist (PROPOSED)

Target: end of each business day or the next morning, per `policy.settlement.daily_close_time` (PENDING).

| # | Step | Evidence | Done by |
|---|---|---|---|
| D1 | Confirm job heartbeats (obligation generation, earning recognition, outbox) ran | Heartbeat view | Operator |
| D2 | List payments in Awaiting Confirmation or Unknown older than the age limit; trigger validation per [gateway outage](GATEWAY_OUTAGE_RUNBOOK.md) | Count before and after | Operator |
| D3 | Match verified gateway transactions with clearing postings by transaction id (INV-05); list unmatched | NF-02 report | Operator |
| D4 | Match COD collections recorded today with delivery completion; list collections without confirmation | NF-03 report | Operator |
| D5 | Process COD remittances received: verify deposit reference uniqueness, verified amount, differences flagged (INV-12) | NF-04 | Operator, second person confirms bank evidence |
| D6 | Review overdue COD against the BR-013 deadline parameter; escalate per [COD runbook](COD_DISCREPANCY_RUNBOOK.md) | Overdue list | Operator |
| D7 | Review new credits, refunds and adjustments requests; confirm unique origins (INV-08, INV-17) | NF-09, NF-10 | Operator |
| D8 | Review payout requests received; check balances, holds and beneficiary status | NF-07 | Operator drafts, Approver decides |
| D9 | Journal balance check and trial balance for the day (INV-01) | Report | Operator |
| D10 | Open exceptions: assign, age, escalate | NF-13 | Manager |
| D11 | Sign daily close: counts of exceptions open, differences by type | Sign-off | Manager |

## 4. Weekly close checklist

| # | Step | Evidence |
|---|---|---|
| W1 | All daily closes signed; unresolved items listed with owner and age | Close log |
| W2 | Gateway settlement statement received and reconciled for the covered days (NF-17): transactions, provider fees, refunds, withholding, bank credit | Statement match report |
| W3 | Supplier payable ledger review: recognised earnings, holds, reversals; eligible balances (NF-05) | Report |
| W4 | Rider payable ledger review independent of COD custody (NF-06; INV-10) | Report |
| W5 | Payout batch preparation: select approved requests, verify destination ownership checks, total ≤ eligible balances (INV-14), batch created by maker | NF-08 |
| W6 | Batch review by a different approver; release only after approval | Approval record |
| W7 | Record payout results from provider; update only on external confirmation; failed items return to review | Result records |
| W8 | Credit liability movement review (NF-09) | Report |
| W9 | Access and sensitive-action review: role grants, overrides attempts | Security report |
| W10 | Manager signs weekly close | Sign-off |

Frequency of payout batches follows `policy.payout.frequency` (BR-014, PENDING).

## 5. Monthly close and period close checklist

| # | Step | Evidence |
|---|---|---|
| M1 | All weekly closes signed and exceptions older than the period resolved or carried with approval | Close log |
| M2 | Bank statement reconciliation for settlement and COD deposit accounts | Signed reconciliation |
| M3 | Gateway clearing account balance is explained fully by in-transit settlements | Schedule |
| M4 | COD receivable equals invoiced COD minus verified remittances minus approved write-offs (INV-11); ageing report | Report |
| M5 | Customer prepaid obligation roll-forward (INV-06); customer credit liability roll-forward (INV-07) | Roll-forwards |
| M6 | Supplier and rider payable roll-forward; settled amounts match payout confirmations (INV-09, INV-14) | Roll-forwards |
| M7 | Revenue recognition check: platform revenue equals recognised commission and fees, not collections (INV-13) | Report |
| M8 | Refund and dispute status review (BR-015); provisions only if policy approves | Report |
| M9 | Trial balance; integrity checks from [backup and restore section 6](BACKUP_RESTORE.md) | Report |
| M10 | Control totals signed by preparer and reviewer; period moves Open to Closing | NF-12 |
| M11 | `closePeriod` executed by authorised role; period state Closed; close evidence stored immutably | Close record |
| M12 | Late events after close: post to open period with adjusting reference; reopen only by governed `reopenPeriod` with approval and reason (SC-15) | Approval |
| M13 | Reports exported with scope and timestamp, export logged (NF-14) | Export log |

## 6. Exception handling

| Exception | Detection | Action | Closure condition |
|---|---|---|---|
| Gateway transaction without ledger posting | D3 | Validate with provider; if valid, post through normal command with original idempotency key | Posting exists, evidence attached |
| Ledger posting without gateway transaction | D3 | Treat as high risk; investigate; reverse with approval | Reversal approved |
| Amount or currency mismatch with validation | D3 | Do not credit the order; hold; contact provider | Provider answer recorded |
| Duplicate notification or duplicate receipt | D3, D5 | Confirm no second journal; remove duplicate effect by reversal if one exists | Counts agree |
| Unmatched bank credit | M2 | Park in suspense with reference, never allocate by guess | Match found or approved write-back |
| Provider fee differs from expectation | W2 | Record fee adjustment after provider statement evidence | Approved adjustment |
| Payout failed or returned | W7 | Return amount to eligible balance by entry; review destination; do not retry blindly | Retry approved or request rejected |
| Payout overpaid | W7 or later | Recovery balance or adjustment per BR-014, BR-015 (see SC-24); never delete history | Approved recovery path |
| Period closed but late event | M12 | Adjusting entry in open period | Linked reference |
| Disagreement between operational and ledger totals | any | Journals are truth for money; fix the producing process | Defect recorded |

Each exception has an id, owner, age, evidence and reason code; resolution requires a second person where an adjustment is posted.

## 7. Acceptance and verification conditions

- Each checklist run in staging with synthetic data produces the expected journals and reports, recorded against TEST-201 to TEST-260 once executed.
- A walkthrough shows that an operator cannot approve own work and an Admin account cannot post or approve.
- Not verified now: nothing in this document has been run.

## 8. Open decisions

BR-013 deadlines; BR-014 thresholds, frequency, holds; BR-020 approval limits; BR-009 commission base for revenue recognition; BR-026 netting; provider settlement statement format; bank statement import method; period calendar and close deadline.
