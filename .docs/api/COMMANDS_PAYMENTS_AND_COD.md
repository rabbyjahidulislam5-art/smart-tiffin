# Commands: payments and COD

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Backend and API architect |
| Purpose | Full command contracts for manual payment references, SSLCOMMERZ sandbox payment, gateway reconciliation, refunds, and the four COD models — file code **PC** in [API_SPECIFICATION.md](API_SPECIFICATION.md) §12. |
| Status | See status column. No gateway credential is used; sandbox only. |

Format per command: **Purpose · Callers · Request · Response · Errors · Idempotency/transaction · Events · Screens · Refs.**

## `submitPaymentReference` (OBS-G, BR-002/BR-003)
Purpose: submit a bKash/Nagad manual reference as evidence of a claimed payment. Callers: Cust. Request: `{billId, provider, reference, claimedAmountMinor}`. Status today: gated pending BR-002/BR-003. Never, by itself, marks a bill paid. Screens: C-08 (legacy manual path). Refs: FR-013; BR-003.

## `verifyPayment` (OBS-G, BR-003)
Purpose: independently verify a submitted reference. Callers: the BR-003-approved verifier (PROPOSED: AcOp, checked by AcMgr). Status today: gated. Events (once live): `paymentVerified`. Screens: NF-02 (manual evidence lane). Refs: FR-012, FR-013; BR-003.

## `initiatePayment` (PROP)
Purpose: start an SSLCOMMERZ sandbox payment against a confirmed quote. Callers: Cust. Request: `{quoteId}`. Response: `{paymentIntentId, redirectUrl}`. Idempotency: PG-TX for the intent, SAGA with the FS invoice state. Screens: C-08, NC-14. Refs: FR-033, FR-035.

## `handleGatewayNotification` (PROP, Webhook)
Purpose: the only trusted inbound contract from the gateway (IPN). Callers: gateway (untrusted until validated). Request: raw gateway payload, persisted durably before any processing. Errors: signature/validation failure → event stored but not applied. Idempotency: `gwevt:{gateway}:{eventKey}`, deduplicated (INV-05, SC-13). Events: `paymentVerified`, `unmatchedReceipt`, `chargebackReceived`. Refs: FR-033, FR-041; BR-003.

## `validateGatewayTransaction` (PROP)
Purpose: server-to-server validation of a transaction (identity, amount, currency, status). Callers: Sys (from the webhook flow); AcOp for a manual re-validation. Errors: `amount_mismatch`, `unknown_status` (never guessed into success). Events: `paymentVerified`. Refs: FR-033, FR-041.

## `reconcileGatewayStatement` (PROP)
Purpose: match a gateway settlement statement against ledger clearing entries. Callers: AcOp (prepare), AcMgr (approve exceptions). Events: `gatewaySettled`; mismatches raise `ent.ReconciliationException`, never auto-corrected. Screens: NF-02, NF-17. Refs: FR-041.

## `initiateRefund` (PROP, gated BR-005)
Purpose: request/approve a refund distinct from a credit. Callers: AcOp (request), AcMgr or PayAp (approve). Request: `{paymentIntentId, amountMinor, reason}`. Errors: `double_compensation` if a credit already covers the same obligation (INV-17). Events: `refundApproved`. Screens: NF-10. Refs: FR-039; BR-005, BR-015.

## `recordRefundResult` (PROP)
Purpose: record the gateway's or a manual refund execution result. Callers: Sys (gateway result), AcOp (manual evidence). Errors on failure post `journalReversal`. Events: `refundExecuted`. Refs: FR-039; BR-005.

## `recordCodCollection` (PROP)
Purpose: record the exact cash a rider collected on delivery. Callers: Rdr. Request: `{orderOrObligationId, collectedAmountMinor}`. Idempotency: PG-TX; never credited as rider income (glossary). Screens: NR-03. Refs: FR-034; BR-012.

## `submitCodRemittance` (PROP)
Purpose: a rider submits cash/transfer evidence against their collected obligation. Callers: Rdr. Request: `{depositReference, amountMinor, method}`. Idempotency: unique `depositReference` (INV-12). Screens: NR-04. Refs: FR-034; BR-013.

## `verifyCodRemittance` (PROP)
Purpose: Accounts verifies a submitted remittance, closing the liability. Callers: AcOp (verify), AcMgr (check above a limit). Events: `codRemittanceVerified`. Screens: NF-04. Refs: FR-034; BR-013, BR-020.

## `flagCodDiscrepancy` / `resolveCodDiscrepancy` (PROP)
Purpose: raise and resolve a mismatch between invoiced and collected/remitted COD. Callers: Rdr, AcOp, AcMgr (flag); AcMgr checking an AcOp request (resolve). Events on resolution: `codWrittenOff` or `adjustmentPosted`. Screens: NR-05, NF-13. Refs: FR-034, FR-039; BR-013, BR-020, BR-026 (SC-09).

## The four COD models (BR-012, all PENDING)

| Model | Commands used | Distinguishing rule |
|---|---|---|
| Individual order | `recordCodCollection` → `submitCodRemittance` → `verifyCodRemittance` | One collection per order |
| Per scheduled meal | Same chain, keyed per `mealObligationId` | One collection per obligation, not per subscription |
| Approved weekly collection | Batched `recordCodCollection` across a week, one remittance | Requires BR-012 approval of the batching window |
| Approved monthly settlement/postpaid | Deferred collection against an approved credit limit | Requires BR-016 (unpaid subscription handling) in addition to BR-012 |

None of these four models is interchangeable with another; a command's behaviour (limits, deadlines) is selected by the order/obligation's declared model, never inferred.
