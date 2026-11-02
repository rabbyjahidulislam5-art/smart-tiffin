# COD discrepancy runbook

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Accounts Manager with Admin operations lead for rider matters |
| Purpose | Procedure for cash-on-delivery mismatches, late or partial remittances, duplicate receipts and missing collections, without hiding losses in rider earnings. |
| Applies to | PAR rider workspace (NR-03, NR-04, NR-05), ACC (NF-03, NF-04, NF-13), BE (`recordCodCollection`, `submitCodRemittance`, `verifyCodRemittance`, `flagCodDiscrepancy`, `resolveCodDiscrepancy`) |
| Depends on | [Runbook](RUNBOOK.md), [settlement runbook](SETTLEMENT_AND_RECONCILIATION_RUNBOOK.md), [incident response](INCIDENT_RESPONSE.md), [COD workflow](../payments/COD_PAYMENT_WORKFLOW.md), [COD reconciliation](../accounts-web/COD_RECONCILIATION.md), [diagrams](../diagrams/PAYMENT_AND_COD_WORKFLOW.md) |
| Authoritative policies | BR-012, BR-013, BR-026 (PENDING); INV-10, INV-11, INV-12 |
| Status | **Preparation only.** No COD feature exists. Deadlines, limits, recovery and netting rules are not approved. |

## 1. Principles

1. Customer cash held by a rider belongs to the company. It is never rider income, and rider compensation is independent of it (INV-10).
2. Four amounts stay separate: invoiced, collected (as recorded by the rider), remitted and verified, and still owed. An order is not fully paid until the collection is confirmed and remitted per policy.
3. A deposit receipt image is evidence, not confirmation. Verification needs Accounts review of the deposit reference or bank evidence, once per reference (INV-12).
4. No automatic write-off and no automatic netting against earnings (BR-013, BR-026). Any hold or offset is explicit, approved and reversible.
5. Discrepancies are investigated, never settled by editing earnings or collection history.

## 2. COD states

Recorded, Confirmed, Due for Remittance, Partially Remitted, Remitted (pending verification), Verified, Overdue, Disputed, Written Off. Deadlines use `policy.cod.remittance_deadline_hours` (BR-013, no value approved).

## 3. Discrepancy catalogue

| # | Case | Typical detection | First action | Ledger effect |
|---|---|---|---|---|
| CD1 | Rider reports customer paid less than invoiced | NR-03 submission or support call | Record collected amount as stated, open discrepancy, keep order not fully paid; notify customer support to confirm with the customer | Receivable stays for the difference until resolved (INV-11) |
| CD2 | Delivery completed but no collection recorded | Daily D4 | Contact rider; do not close the receivable | Receivable open; delivery earning rule unchanged |
| CD3 | Remitted amount lower than collected | NF-04 | Verify what was received, flag difference, keep remittance partial | Verified part posts; remainder stays rider liability |
| CD4 | Remitted amount higher than collected | NF-04 | Hold the excess in suspense with reference; investigate | No revenue recognised for excess |
| CD5 | Same deposit reference submitted twice or verified twice | Unique constraint, NF-13 | Keep the first verification; reject or reverse duplicate | Reverse any duplicate journal |
| CD6 | Remittance overdue | Daily D6 | Escalate by stages in the policy; message rider; admin review | Receivable ages |
| CD7 | Rider disputes amount | NR-05 | Collect evidence (order, customer contact log, proof); Accounts Manager decides | Adjustment only after approval |
| CD8 | Cash lost, stolen or robbery claimed | Report | Treat as incident (S2); safety first; police/insurance steps if policy says | Write-off only by approved adjustment (needs BR-013 and BR-020) |
| CD9 | Customer refuses and rider returns food | Delivery exception | Collection not recorded; COD not payable (SC-21) | No receivable beyond policy |
| CD10 | Order reassigned after collection | Reassignment event | Collection stays attached to the rider who holds the cash | Custody tracked per rider |
| CD11 | Rider has earnings and an unremitted amount | Payout review | Show both; payout proceeds on earned balance unless an approved hold exists | No netting without approval (SC-12, BR-026) |
| CD12 | Evidence image altered or suspected fraud | Review | Escalate to security owner; suspend assignments by approved action | Preserve records |

## 4. Procedure

1. Open discrepancy (`flagCodDiscrepancy`) with reason code, amounts, rider id, order ids, evidence references. Audit event written.
2. Notify the rider through NR-05 with the specific question; the rider may respond with evidence.
3. Accounts Operator gathers: order invoice, collection record, customer-confirmation record, delivery proof, remittance attempts, bank or deposit evidence, past history of the rider.
4. Accounts Manager decides category: timing difference, counting error, customer short-pay, rider shortage, fraud suspected, system defect.
5. Resolve (`resolveCodDiscrepancy`) with a proposed resolution: accept explanation, adjust collection to confirmed amount (customer still owes, to be recovered or written off per policy), rider shortage recorded as recovery balance, or escalation. A second approver confirms any adjustment above the configured limit (BR-020).
6. Post any journal produced; it references the discrepancy id and does not alter earlier entries.
7. If the rider owes money and BR-026 allows an approved offset, create an explicit hold or offset record with approver and reason; otherwise recover by remittance.
8. Close with evidence; inform rider and, where relevant, support for the customer.
9. Repeated discrepancies for a rider feed the admin review queue; suspension follows account policy, not an automatic rule.

## 5. Daily and weekly checks

- Daily: new COD collections without confirmation, remittances awaiting verification, overdue items (see [settlement runbook D4 to D6](SETTLEMENT_AND_RECONCILIATION_RUNBOOK.md)).
- Weekly: COD receivable ageing, discrepancies open longer than `ops.cod.discrepancy_age_days`, riders with repeated cases.

## 6. Acceptance and verification conditions

Planned tests: partial remittance, duplicate deposit reference by two operators (SC-10), mismatch (SC-09), payout with outstanding COD (SC-12), reassignment after collection, failed delivery. All planned; none executed.

## 7. Open decisions

BR-012 eligibility and limits; BR-013 deadline, overdue and recovery steps; BR-026 netting; write-off authority and limit (BR-020); legal advice on recovering cash from riders; rider safety and loss reporting procedure.
