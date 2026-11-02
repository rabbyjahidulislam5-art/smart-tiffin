# ADR-012: Outbox-based notifications and scheduled jobs

| Field | Value |
|---|---|
| Status | PROPOSED — NOT APPROVED |
| Date | 2026-10-30 |

## Context

The platform needs reliable, deduplicated notifications across four apps (fixing the legacy prototype's hard-coded "3 notifications per role") and recurring jobs: generating meal obligations from a subscription schedule, expiring stale quotes/stock reservations, flagging overdue COD remittances, and closing accounting periods.

## Options considered

1. Send notifications synchronously inside the command that triggers them.
2. Write a domain event to an outbox in the same transaction as the state change; a separate consumer sends notifications and runs scheduled jobs asynchronously.

## Decision

Option 2. Synchronous sending (option 1) couples notification-provider latency/failure to the user-facing command's success and risks losing an event if the notification step fails after the state change already committed. The outbox pattern keeps the state change and the event record atomic, and lets the consumer retry delivery independently and idempotently.

## Consequences

An additional moving part (the outbox table/collection and its consumer) and an eventual-consistency window for notifications (never for authoritative state, which commits synchronously). Scheduled jobs (`generateMealObligations`, `expireQuotes`, `flagOverdueCodRemittance`, `expireCredits`, period-close reminders) are also outbox/cron-driven, not embedded in request-handling code paths.

## Risks

A stuck or slow consumer delaying user-visible notifications (monitored, not solved, by this ADR); a scheduled job running twice if not made idempotent itself.

## Links

[architecture/BACKEND_DOMAIN_DESIGN.md](../architecture/BACKEND_DOMAIN_DESIGN.md) §3, [api/EVENT_AND_NOTIFICATION_DESIGN.md](../api/EVENT_AND_NOTIFICATION_DESIGN.md), DEC-015.
