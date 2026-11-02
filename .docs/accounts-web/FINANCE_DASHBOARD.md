# Finance dashboard

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Accounts Web domain author |
| Purpose | Define every metric on the Accounts Web executive overview (NF-01), its exact definition, qualifier and source. |
| Applies to | ACC (screen NF-01) |
| Depends on | [Glossary §4](../requirements/GLOSSARY_AND_TERMINOLOGY.md), [database/FINANCIAL_DATA_MODEL.md](../database/FINANCIAL_DATA_MODEL.md) |
| Status | PROPOSED — NOT APPROVED. |

## Metrics (each with its qualifier, per glossary §4)

| Metric | Definition | Qualifier | Source |
|---|---|---|---|
| Verified customer collections | Sum of `cash_and_clearing` debits from verified payments, this period | paid | Ledger |
| Outstanding receivables | `customer_prepaid_obligation` balance not yet recognised | pending | Ledger |
| Supplier payables | `supplier_payable` balance | posted, minus held | Ledger |
| Rider payables | `rider_payable` balance | posted, minus held | Ledger |
| Customer credit liabilities | `customer_credit_liability` balance | posted | Ledger |
| COD cash awaiting remittance | `cod_receivable` balance | pending | Ledger |
| Available company funds | `cash_and_clearing` minus `settlement_clearing` in-flight | available | Ledger |
| Pending settlements | Count/sum of `ent.PayoutRequest` in Requested/UnderReview/Approved/Processing | pending | Ledger |
| Completed settlements | Sum of `ent.PayoutResult` this period | settled | Ledger |
| Refund obligations | Sum of approved, unexecuted `ent.Refund` | pending | Ledger |
| Revenue and fee summary | `platform_revenue` and `fees_and_expenses` this period | posted | Ledger |
| Reconciliation exceptions | Count of open `ent.ReconciliationException` | disputed | Ledger |

Every figure states its period, its qualifier, and is drillable to its supporting journal lines (NF-01's primary action: "drill into supporting lines before approving operations"). No figure is a misleading total (for example, "available funds" never includes money already in a pending payout batch).

## Acceptance and verification

Design-only. Verification requires each metric's formula to be checked against a HYPOTHETICAL fixture and shown to equal the sum of its named source journal lines.
