# Integration design

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (supersedes 1.0, FCM-only) |
| Owner | Architecture lead |
| Purpose | External integrations: the SSLCOMMERZ gateway abstraction, messaging/notifications, maps/GPS consent, and resilience rules for all of them. |
| Depends on | [Payment architecture](../payments/PAYMENT_ARCHITECTURE.md), [SSLCOMMERZ integration plan](../payments/SSLCOMMERZ_INTEGRATION_PLAN.md), [ADR-012](../adr/012-notifications-and-scheduled-jobs.md) |
| Status | PROPOSED — NOT APPROVED. No external integration is connected. |

| Integration | Purpose | Access and failure contract | Release evidence required |
|---|---|---|---|
| SSLCOMMERZ (sandbox only) | Online payment initiation, hosted redirect, IPN, transaction validation, refund | Trusted backend holds credentials, never a client; bounded retry on transient failure; IPN processing is idempotent; unknown status preserved as pending, never guessed | Sandbox transaction log, IPN replay test, signature/validation check |
| Firebase Cloud Messaging | Push notifications across CUS and PAR | Delivery is best-effort; a missed push never substitutes for the authoritative in-app/read-model state (NFR-009) | Delivery/failure counters, deduplication test |
| Email/SMS provider (not selected) | Accounts/Admin alerts, customer receipts | Provider-agnostic interface behind MOD-NOT; bounded retry; delivery status logged (legacy SH-10 pattern) | Provider selection record, retry test |
| Maps/location provider (not selected) | Live tracking display, zone boundaries | Rider location only visible to the current assignment's customer; explicit consent required; retention bounded | Consent flow test, access-scoping test |
| Managed PostgreSQL (proposed) | Ledger, payments, COD, credits, earnings, payouts | Connection pooling and timeout bounded; migrations versioned separately from Firestore schema version | Migration dry run, connection-failure fallback test |

## Resilience rules (apply to every row above)

Bounded retries with backoff; a circuit-breaker-style short-circuit after repeated failures, surfaced to the operator (not silently retried forever); explicit timeout per call; every external failure is reconciled, never guessed into a false success (NFR-009); a secret for any of the above is never present in a client bundle, log, or this documentation (NFR-008).

## What is explicitly out of scope for this phase

Real SSLCOMMERZ credentials or transactions; any production messaging provider contract; any production maps/location provider contract; any production PostgreSQL instance. All are design-only until a separately authorised implementation phase supplies them.
