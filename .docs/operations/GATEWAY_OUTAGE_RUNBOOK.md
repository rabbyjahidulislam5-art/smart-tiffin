# Gateway outage and uncertain payment status runbook

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Payments owner with Finance lead |
| Purpose | Procedure for gateway outages, delayed or missing notifications and uncertain payment statuses: preserve pending truth, reconcile, inform users. |
| Applies to | CUS, BE (`initiatePayment`, `handleGatewayNotification`, `validateGatewayTransaction`, `reconcileGatewayStatement`), ACC |
| Depends on | [Runbook](RUNBOOK.md), [incident response](INCIDENT_RESPONSE.md), [settlement runbook](SETTLEMENT_AND_RECONCILIATION_RUNBOOK.md), [payment and COD diagrams](../diagrams/PAYMENT_AND_COD_WORKFLOW.md), [payment architecture](../payments/PAYMENT_ARCHITECTURE.md), [SSLCOMMERZ plan](../payments/SSLCOMMERZ_INTEGRATION_PLAN.md), [sources](../references/SOURCES.md) |
| Authoritative policies | BR-003, BR-012, BR-016 (PENDING); [ADR-007](../adr/007-payment-gateway-abstraction-and-cod.md) |
| Status | **Preparation only.** No gateway is connected; no store credentials exist. Provider behaviour cited here comes from the provider's public documentation and must be rechecked against the actual merchant agreement before implementation. |

## 1. Principles

1. A browser redirect or app callback never marks a payment Verified. Only server-to-server validation of the transaction (identity, amount, currency, status) does.
2. Uncertain means Pending, Awaiting Confirmation or Unknown. The customer sees an honest pending state; orders and subscriptions do not activate and, for existing subscriptions, services follow the approved unpaid handling (BR-016).
3. Every notification and validation attempt is stored (`ent.GatewayEvent`, `ent.GatewayVerification`) and processed idempotently (INV-04, INV-05).
4. Sandbox and live are separate environments with separate configuration; a sandbox result never counts as money.
5. Nothing is retried blindly for money-moving actions. Retries use the same idempotency key.

## 2. Payment states used (from the glossary)

Pending, Initiated, Awaiting Confirmation, Verified, Failed, Cancelled, Expired, Refunded, Partially Refunded, Disputed, Unknown. Unknown is assigned when validation could not be completed after bounded retries.

## 3. Failure modes and responses

| # | Situation | Customer sees | System behaviour | Operator action |
|---|---|---|---|---|
| G1 | Gateway session creation fails | "Payment could not start; nothing was charged" with retry | Intent stays Pending/Failed; no obligation activated; same quote kept until expiry | Check provider status; if prolonged, offer COD only where BR-012 permits |
| G2 | Customer paid but redirect never returned | Order shows "Waiting for payment confirmation" | Awaiting Confirmation; scheduled validation polling by transaction id | Wait for notification or run validation; see G4 |
| G3 | Notification delayed or never sent | Same pending message | Reconciliation job queries provider for unresolved intents | Trigger `validateGatewayTransaction` per intent; escalate if age limit exceeded |
| G4 | Validation endpoint unreachable | Pending | Bounded retries with backoff, then Unknown and alert | Retry later; keep customer informed; raise S2 if many |
| G5 | Notification arrives twice or out of order | No change | Duplicate ignored by event id; state machine rejects regression | Check that no second journal exists |
| G6 | Amount or currency in validation differs from intent | "We are checking your payment" | Reject credit; mark as exception; hold | Contact provider with transaction id; no activation until resolved |
| G7 | Notification fails signature or source checks | Nothing | Rejected, logged as security event | Review for forged callback; S2 if volume |
| G8 | Provider flags a risky transaction | Pending review | Hold service until verification per provider guidance and risk policy | Finance review; decide by evidence |
| G9 | Payment verified after quote or stock expiry | "Payment received, your order needs attention" | Do not oversell; order enters exception; refund or reschedule path (SC-20) | Decide refund or alternative; refund via `initiateRefund` |
| G10 | Customer pays twice | Duplicate noted | Second payment recorded as duplicate; refund obligation | Refund the duplicate; INV-17 |
| G11 | Provider outage during refund | Refund status Pending | `recordRefundResult` only on provider evidence | Retry with same key; reconcile |
| G12 | Settlement statement missing or different | n/a | Exception in weekly close | [Settlement runbook W2](SETTLEMENT_AND_RECONCILIATION_RUNBOOK.md) |

## 4. Procedure for an outage declared by operations

1. Declare an incident (S2, upgrade to S1 if verified-but-unposted money or forged events are suspected) per [incident response](INCIDENT_RESPONSE.md).
2. Confirm scope: provider status page or support, our own egress and TLS, certificate or credential problems, configuration drift between sandbox and live.
3. Contain: if the gateway is unavailable, a reviewed switch hides online payment choices in CUS and shows a neutral notice; COD stays available only where approved (BR-012). Existing pending intents are untouched.
4. Keep the list: query all intents in Initiated, Awaiting Confirmation or Unknown, ordered by age.
5. Recover: once the provider responds, validate each listed intent. For each result: Verified (post once via normal command), Failed or Cancelled (close), Expired (close), still unknown (keep).
6. Reconcile: compare verified count and amount with the provider's records or statement; any unmatched item becomes a reconciliation exception.
7. Inform: customers with pending payments receive a message when their status becomes final; partners are told when their orders were delayed by it.
8. Review: add the cause to the risk register and adjust alerts.

## 5. Customer and staff messaging (PROPOSED wording rules)

- Plain and bilingual, never "payment successful" before verification and never "payment failed" while unknown.
- State what happens next and when to contact support, with a reference id only.
- Support staff may not mark a payment Verified by hand. Manual evidence is a separate flow (BR-003) with its own approval.

## 6. Data to preserve

Intent id, attempt ids, event payload hashes, validation request and response status (not secrets), timestamps, operator actions, correlation ids.

## 7. Acceptance and verification conditions

Mock-gateway tests cover G1 to G12 (planned in `testing/INTEGRATION_TEST_CASES.md`): replay, out-of-order, amount mismatch, validation outage with later recovery, double payment, stock expiry after payment. Run evidence is required before this runbook is considered ready. No claim is made now.

## 8. Open decisions

BR-003 verification authority for manual evidence; BR-012 COD fallback during outage; BR-016 treatment of existing subscriptions with unknown payments; payment age limit parameters; which channels the merchant account actually supports; provider support contact path; messaging templates and provider.
