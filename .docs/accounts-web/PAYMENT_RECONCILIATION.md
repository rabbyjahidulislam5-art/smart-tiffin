# Payment reconciliation

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Accounts Web domain author |
| Purpose | Define the online payment reconciliation (NF-02) and gateway settlement statement (NF-17) screens. |
| Applies to | ACC (screens NF-02, NF-17) |
| Depends on | [payments/SSLCOMMERZ_INTEGRATION_PLAN.md](../payments/SSLCOMMERZ_INTEGRATION_PLAN.md), [api/COMMANDS_PAYMENTS_AND_COD.md](../api/COMMANDS_PAYMENTS_AND_COD.md) |
| Status | PROPOSED — NOT APPROVED. |

## NF-02 — Online payment reconciliation

Matches `ent.PaymentIntent` / `ent.GatewayVerification` records against ledger `cash_and_clearing` postings. Three match classes: fully matched (closed automatically); amount or status mismatch (raises `ent.ReconciliationException`, assigned to AcOp); unmatched gateway event with no corresponding intent (possible missed IPN, raised the same way). `reconcileGatewayStatement` is the command; resolution never auto-corrects a balance — it records a non-destructive correction journal if approved.

## NF-17 — Gateway settlement statement

Imports (conceptually; the actual import mechanism is undecided) a periodic SSLCOMMERZ settlement statement and compares it line-by-line against the platform's own transaction records, surfacing processor fees, refund deductions and withholding as distinct lines. Deviations are resolved with financial evidence (the statement itself, a transaction query result), never assumed away.

## Acceptance and verification

Design-only. Verification requires a seeded mismatch (wrong amount, missing event) to be correctly raised as an exception, never silently matched.

## Open decisions

The exact settlement-statement import mechanism and its frequency are undecided, pending the SSLCOMMERZ integration being verified against official documentation.
