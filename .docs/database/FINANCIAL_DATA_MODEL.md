# Financial data model

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Architecture lead |
| Purpose | Define the PostgreSQL-owned financial entities, the double-entry chart of accounts, posting rules per business event, and the twenty financial invariants (INV-01…20). |
| Depends on | [ADR-005](../adr/005-hybrid-datastore.md), [ADR-006](../adr/006-double-entry-ledger.md), [conventions §7–8](../analysis/CONVENTIONS_AND_ID_REGISTER.md), [glossary](../requirements/GLOSSARY_AND_TERMINOLOGY.md) |
| Authoritative policies | BR-006…026 (all PENDING) supply every numeric parameter referenced below |
| Status | PROPOSED — NOT APPROVED. No PostgreSQL instance exists. |

## 1. Store boundary

Everything in this file lives in the **PROPOSED managed PostgreSQL** instance (ADR-005), reached only from the trusted backend (ADR-002). Firestore never holds an authoritative balance; it may hold a read-model mirror updated via the outbox, always labelled as a projection, never as the source of truth.

## 2. Chart of accounts (double-entry, ADR-006)

| Account | Type | Meaning |
|---|---|---|
| `cash_and_clearing` | Asset | Money in transit through the gateway or bank before settlement |
| `cod_receivable` | Asset | COD amounts invoiced but not yet remitted/verified |
| `customer_prepaid_obligation` | Liability | Verified prepayment for service not yet delivered |
| `customer_credit_liability` | Liability | Outstanding non-cash service credit balance |
| `supplier_payable` | Liability | Recognised, unsettled supplier earnings |
| `rider_payable` | Liability | Recognised, unsettled rider compensation |
| `platform_revenue` | Revenue | Recognised commission and service fees |
| `fees_and_expenses` | Expense | Gateway fees, processing costs |
| `refunds_and_adjustments` | Contra-revenue/Expense | Reversals and corrections |
| `settlement_clearing` | Asset/Liability (clearing) | In-flight payout funds between approval and external confirmation |

## 3. Entities (PostgreSQL)

| Entity | Key fields | Notes |
|---|---|---|
| `ent.Quote` | id, customerId, lines[], totalMinor, currency, expiresAt | Immutable snapshot (ADR-009); every downstream amount traces here |
| `ent.PaymentIntent` | id, quoteId, amountMinor, status | 11-state model (glossary §4) |
| `ent.PaymentAttempt` | id, paymentIntentId, channel, attemptedAt | |
| `ent.GatewayEvent` | id, provider, rawPayloadRef, receivedAt, processed | Inbound IPN/webhook record |
| `ent.GatewayVerification` | id, paymentIntentId, verifiedAmountMinor, verifiedAt, result | Only this (or Accounts' COD verification) may set a payment Verified |
| `ent.CodCollection` | id, orderOrObligationId, riderId, collectedAmountMinor, collectedAt | |
| `ent.CodRemittance` | id, riderId, depositReference (unique), amountMinor, submittedAt, verifiedAt? | Unique constraint on `depositReference` (INV-12) |
| `ent.CreditAccount` | customerId, availableMinor | Never negative (INV-07) |
| `ent.CreditTransaction` | id, creditAccountId, type (issue/reserve/consume/release/void/expire), amountMinor, originId (unique per issuance, INV-08) | |
| `ent.SupplierEarning` | id, supplierId, sourceObligationOrOrderId, amountMinor, recognizedAt | One per source (INV-19-equivalent for suppliers) |
| `ent.RiderEarning` | id, riderId, deliveryAssignmentId (unique), amountMinor, recognizedAt | Unique per delivery (INV-19) |
| `ent.Hold` | id, subjectType, subjectId, amountMinor, reason, placedAt, releasedAt? | |
| `ent.PayoutRequest` | id, payeeType (supplier/rider), payeeId, amountMinor, requestedBy | amountMinor ≤ eligible balance at request time (INV-14) |
| `ent.PayoutApproval` | id, payoutRequestId, approverId (≠ requestedBy, INV-15), decidedAt | |
| `ent.SettlementBatch` | id, payoutRequestIds[], releasedAt | |
| `ent.PayoutResult` | id, settlementBatchId, externalReference, confirmedAt | Only this sets Settled (INV-14) |
| `ent.PayoutDestination` | id, payeeId, type (bank/MFS), verifiedAt | No PIN/OTP ever stored |
| `ent.LedgerAccount` | code, type | The chart above |
| `ent.JournalEntry` | id, postedAt, sourceCommand, status (Posted/Reversed) | Immutable once Posted (INV-02) |
| `ent.JournalLine` | id, journalEntryId, accountCode, debitMinor, creditMinor | Sum(debit) = sum(credit) per entry (INV-01) |
| `ent.AccountingPeriod` | id, startDate, endDate, status (Open/Closing/Closed/Reopened) | No posting to a Closed period (INV-16) |
| `ent.ReconciliationItem` | id, source, matchedJournalLineId? | |
| `ent.ReconciliationException` | id, reconciliationItemId, raisedAt, resolvedAt?, resolverId? | Never auto-resolved |
| `ent.Refund` | id, originalPaymentIntentId, amountMinor, status | |
| `ent.Dispute` | id, subjectId, evidenceRef, decidedBy?, decidedAt? | |
| `ent.Adjustment` | id, subjectId, amountMinor, reason, preparedBy, approvedBy? (≠ preparedBy if above threshold, BR-020) | |

## 4. Posting rules (illustrative; parameters PENDING)

| Event | Debit | Credit | Trigger command |
|---|---|---|---|
| Verified online payment | `cash_and_clearing` | `customer_prepaid_obligation` | `handleGatewayNotification` → `validateGatewayTransaction` |
| Verified COD remittance | `cash_and_clearing` | `cod_receivable` | `verifyCodRemittance` |
| Supplier earning recognised | `customer_prepaid_obligation` (service rendered) | `supplier_payable` | `recognizeSupplierEarning` |
| Platform commission recognised | `supplier_payable` (deduction) | `platform_revenue` | same, commission split (BR-009 PENDING) |
| Rider earning recognised | `customer_prepaid_obligation` or a delivery-fee account | `rider_payable` | `recognizeRiderEarning` |
| Credit issued (skip) | `customer_prepaid_obligation` | `customer_credit_liability` | `issueCredit` |
| Credit consumed | `customer_credit_liability` | `customer_prepaid_obligation` (new order) | `consumeCredit` |
| Refund issued | `refunds_and_adjustments` | `cash_and_clearing` | `recordRefundResult` |
| Payout settled | `settlement_clearing` | `supplier_payable` or `rider_payable` | `recordPayoutResult` |

All amounts are HYPOTHETICAL examples in these rows; the actual accounts touched by a given BR-006…026 outcome are finalised only once that rule is approved.

## 5. Financial invariants (INV-01…INV-20)

See [conventions §7](../analysis/CONVENTIONS_AND_ID_REGISTER.md) for the full authoritative text of INV-01 through INV-20. They are not repeated here to avoid two sources of truth; every posting rule above is designed to satisfy them, in particular INV-01 (balanced journals), INV-02 (immutability), INV-04/08/12 (idempotency/uniqueness), INV-13 (revenue ≠ gross collections), INV-14/15 (payout eligibility and maker-checker), INV-16 (period close), INV-17 (no double compensation) and INV-18 (quote-to-journal total equality).

## 6. Worked example (HYPOTHETICAL)

A customer's monthly subscription quote totals 7,200.00 BDT (720,000 minor units). A verified online payment posts `cash_and_clearing` 720,000 / `customer_prepaid_obligation` 720,000. After the first week, obligations worth 180,000 minor units are fulfilled; recognition posts `customer_prepaid_obligation` 180,000 / `supplier_payable` 162,000 and `supplier_payable` 162,000 (reduction) / `platform_revenue` 18,000 (illustrative 10% commission — **not an approved rate**). The customer skips one remaining meal worth 25,000 minor units; a credit posts `customer_prepaid_obligation` 25,000 / `customer_credit_liability` 25,000. At every step, debits equal credits (INV-01) and the sum of all postings traces back to the original 720,000 quote (INV-18). All figures are illustrative only.

## Acceptance and verification

Design-only; no instance exists. Verification requires an automated test asserting INV-01…INV-20 hold after a simulated sequence of the workflows in [scenarios/WORKFLOWS_A_TO_J.md](../scenarios/WORKFLOWS_A_TO_J.md).

## Open decisions

Every numeric parameter in every posting rule above (commission rate, credit formula, delivery fee, tax rate, payout threshold) is PENDING under BR-006…026.
