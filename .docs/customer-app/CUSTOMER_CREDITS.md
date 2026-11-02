# Customer credits (Customer App, user-facing behaviour)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Customer App domain author |
| Purpose | Define the customer-facing credit balance, history, redemption and skip/replace quotation experience. Formulas and ledger mechanics are defined once in [payments/CUSTOMER_CREDIT_RULES.md](../payments/CUSTOMER_CREDIT_RULES.md); this file does not duplicate them. |
| Applies to | CUS |
| Depends on | [payments/CUSTOMER_CREDIT_RULES.md](../payments/CUSTOMER_CREDIT_RULES.md), [design/screens/CUSTOMER_NEW_SCREENS.md](../design/screens/CUSTOMER_NEW_SCREENS.md) (NC-09, NC-11, NC-16, NC-17) |
| Status | PROPOSED — NOT APPROVED. |

## 1. Balance and history (NC-11)

Shows available/reserved/consumed/expired credit (expiry only if BR-019 approved), each entry referencing its source subscription/obligation and reason — never a bare number with no explanation.

## 2. Skip/replace quotation (NC-09, NC-10)

Before confirming a skip or replacement, the customer sees the proposed credit or charge computed server-side (`quoteScheduleChange`), with the original amount, the adjustment, and the new amount all shown side by side.

## 3. Redemption (NC-16)

Applying available credit to a new order is a single atomic action (`consumeCredit`); the screen shows the remaining due amount immediately and never allows the same credit to be applied twice to two different checkouts in flight.

## 4. Receipt reference on a lost response (SC-04)

If a skip request's response is lost (poor connectivity) and the customer retries, the screen shows the original stable receipt, not a new, possibly duplicated, credit.

## 5. Refund vs credit (NC-17)

A dedicated tracker distinguishes an actual gateway refund (with its provider reference and status) from a service credit; the customer is never left wondering which one they received.

## Acceptance and verification

Design-only. Verification requires SC-04 (double skip) and SC-06 (cheaper replacement credit) to produce exactly one credit each.
