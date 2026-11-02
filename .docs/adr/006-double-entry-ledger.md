# ADR-006: Double-entry ledger for all financial movement

| Field | Value |
|---|---|
| Status | PROPOSED — NOT APPROVED |
| Date | 2026-10-30 |

## Context

USER-REQ: the Accounts department needs a finance ledger using "a double-entry accounting model or another justified and rigorously reconciled financial design", with every monetary movement having an identifiable source and balanced accounting treatment, and recognition policy kept separate from cash movement.

## Options considered

1. Double-entry ledger with a fixed chart of accounts (cash/payment clearing, COD receivables, customer prepaid obligations, customer service-credit liabilities, supplier payables, rider payables, platform revenue, fees/expenses, refunds/adjustments, settlement clearing).
2. Single-entry transaction log per domain (payments table, payouts table, credits table) with manually reconciled totals.
3. Event-sourced ledger with derived balances recomputed from the full event history on every read.

## Decision

Option 1. A double-entry ledger gives a built-in self-check (debits always equal credits, INV-01) that a single-entry log does not, and is the standard, well-understood model for the reconciliation and audit requirements in Phase 10 of the master prompt. Option 3 is rejected as unnecessary complexity for this scope; option 2 is rejected because it has no structural guarantee against an unbalanced or lost entry.

## Consequences

Every money-moving command must identify its correct debit and credit accounts (see [database/FINANCIAL_DATA_MODEL.md](../database/FINANCIAL_DATA_MODEL.md) for the posting-rule table); a posted journal line is immutable — corrections are reversing or adjusting entries only (INV-02, NFR-014). This is a stricter discipline than the current OBSERVED backend, which has no money handling at all.

## Risks

Incorrect account mapping for a new command type; period-close discipline not followed in practice (mitigated by `closePeriod` validation, NF-12).

## Links

[database/FINANCIAL_DATA_MODEL.md](../database/FINANCIAL_DATA_MODEL.md), [accounts-web/FINANCIAL_LEDGER.md](../accounts-web/FINANCIAL_LEDGER.md), INV-01, INV-02, INV-16.
