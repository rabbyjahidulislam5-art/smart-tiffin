# ADR-014: Separate the subscription agreement from its individual meal obligations

| Field | Value |
|---|---|
| Status | PROPOSED — NOT APPROVED |
| Date | 2026-10-30 |

## Context

USER-REQ: distinguish a subscription agreement from the individual scheduled meal orders generated under it; support flexible per-date, per-slot customisation instead of one fixed monthly package; maintain historical records of the original subscription and every approved modification.

## Options considered

1. Model a subscription as a single document whose "meals" are an embedded, mutable list.
2. Model a subscription as a versioned **agreement** (kitchen, schedule rules, term, billing terms) that generates separate, individually addressable **meal obligation** records (one per date+slot+meal), each with its own lifecycle, price snapshot and credit/adjustment trail.

## Decision

Option 2. Option 1 cannot cleanly support "skip this one lunch without touching the rest of the plan", cannot hold a stable per-meal price snapshot (ADR-009) independent of later menu changes, and makes the agreement-vs-obligation distinction the master prompt explicitly requires impossible to express. The legacy prototype's own `Subscriptions` screen defaulting to one hard-coded `monthly-ld` plan (ignoring guest-selected `meal`/`plan` parameters) is the kind of defect this model is designed to prevent.

## Consequences

Two entities instead of one (`ent.Subscription`/`ent.SubscriptionVersion`/`ent.SubscriptionSchedule` and `ent.MealObligation`), and a scheduled job (`generateMealObligations`) that must run reliably and idempotently to turn a schedule into obligations. In exchange: a skip, pause, replacement, upgrade or downgrade touches exactly the affected obligation(s), never the whole agreement, and the agreement's version history remains intact.

## Risks

Obligation-generation job failure or duplication (mitigated by idempotent job design, ADR-008); a schedule change needing to regenerate only future, not past, obligations — an explicit rule, not a default.

## Links

[customer-app/CUSTOM_SUBSCRIPTION_ENGINE.md](../customer-app/CUSTOM_SUBSCRIPTION_ENGINE.md), [database/ENTITY_RELATIONSHIPS.md](../database/ENTITY_RELATIONSHIPS.md), BR-001, BR-021.
