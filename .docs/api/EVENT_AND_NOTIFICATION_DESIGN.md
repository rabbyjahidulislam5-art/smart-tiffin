# Events, notifications and scheduled jobs

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Backend and API architect |
| Purpose | Catalogue the domain events emitted through the outbox, who is notified, preference/essential rules, deduplication, and the scheduled jobs that drive subscription and finance housekeeping. |
| Depends on | [ADR-012](../adr/012-notifications-and-scheduled-jobs.md), [architecture/BACKEND_DOMAIN_DESIGN.md](../architecture/BACKEND_DOMAIN_DESIGN.md) §3, [api/API_SPECIFICATION.md](API_SPECIFICATION.md) |
| Status | PROPOSED — NOT APPROVED. No notification sender or scheduler exists in the OBSERVED code. |

## 1. Domain event catalogue (outbox)

| Event | Emitted by | Notified | Channel |
|---|---|---|---|
| `order.created` | `placeOneTimeOrder` | Supplier (new order) | Push + in-app |
| `order.accepted` / `order.declined` | `acceptOrder`/`declineOrder` | Customer | Push + in-app |
| `obligation.skipped` / `obligation.replaced` | `skipMeals`/`replaceMeal` | Customer (confirmation), Supplier (updated commitment) | In-app |
| `assignment.offered` | `offerAssignment` | Candidate rider(s) | Push |
| `delivery.proof_submitted` | `submitDeliveryProof` | Customer | Push + in-app |
| `delivery.failed` | `reportDeliveryFailure` | Customer, Admin | Push + in-app |
| `payment.verified` | `validateGatewayTransaction`/`verifyPayment` | Customer | Push + email receipt |
| `cod.remittance_overdue` | scheduled job | Rider, Accounts | Push + in-app |
| `credit.issued` | `issueCredit` | Customer | In-app |
| `payout.settled` / `payout.failed` | `recordPayoutResult` | Supplier/Rider | Push + in-app |
| `application.decided` | `decideApplication` | Applicant | Push + email |
| `reconciliation.exception_raised` | reconciliation job | Accounts Operator/Manager | In-app (Accounts Web) |
| `period.closed` | `closePeriod` | Accounts Manager, Financial Auditor | In-app |

Every row is an outbox event (ADR-012); delivery is best-effort and never substitutes for the authoritative read-model state (NFR-009).

## 2. Notification preferences (fixes the legacy hard-coded "3 per role")

Essential categories (account security, payment confirmation, delivery status) are always on and cannot be disabled (legacy SH-09 pattern, kept). Optional categories (marketing-adjacent reminders, menu updates) are togglable per channel (in-app/email/push) and persisted per principal, replacing the legacy prototype's local-only toggle. Unread counts are computed from `ent.Notification` records, never a hard-coded constant.

## 3. Deduplication

A notification carries the originating event's id as its own idempotency key; the consumer that sends it is safe to run twice. A duplicated outbox delivery (at-least-once) must never result in two visible notifications for the same event.

## 4. Email log (extends legacy SH-10)

Each sent email records its state (Queued → Accepted by provider → Delivered → Failed) with a retry action, matching the legacy prototype's behaviour but backed by a real provider status callback instead of a simulated timer. The email/SMS provider itself is not selected (open, see [architecture/INTEGRATION_DESIGN.md](../architecture/INTEGRATION_DESIGN.md)).

## 5. "Mark notification read" (register gap closed here, per API_SPECIFICATION §12.3)

A dedicated read-state write, scoped to the owner's own `ent.Notification` records: `{notificationIds[]}` → marks each read, or all-unread → all-read in one call. Not a full command in the money-moving sense (no idempotency receipt beyond the usual request deduplication); implemented as a narrow, owner-scoped Firestore write path.

## 6. Scheduled jobs

| Job | Frequency | Purpose | Idempotency |
|---|---|---|---|
| `generateMealObligations` | Daily | Materialise future obligations from active schedules | Per subscription per date, safe to re-run |
| `expireQuotes` / `releaseStock` | Short interval (minutes) | Release expired reservations | Per reservation id |
| `flagOverdueCodRemittance` | Daily | Raise `cod.remittance_overdue` per BR-013 parameter (PENDING) | Per rider per period |
| `expireCredits` | Daily, gated on BR-019 approval | Expire aged credits | Per credit transaction |
| Reconciliation sweep | Configurable (e.g. hourly) | Compare operational events to ledger postings | Per reconciliation item |
| Period-close reminder | Per accounting calendar | Prompt Accounts to begin close | Per period |

## Acceptance and verification

Design-only. Verification requires a test that a duplicated outbox delivery produces exactly one visible notification, and that disabling an optional category stops that channel without affecting an essential category.
