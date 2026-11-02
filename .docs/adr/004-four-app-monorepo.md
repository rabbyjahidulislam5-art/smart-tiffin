# ADR-004: Four applications in one monorepo with shared packages

| Field | Value |
|---|---|
| Status | PROPOSED — NOT APPROVED |
| Date | 2026-10-30 |

## Context

USER-REQ: Customer App and Partner App must be separate mobile applications; Supplier and Rider must be distinct protected workspaces inside the Partner App; Admin and Accounts must be separate desktop-first web applications; all four must share one coherent backend and must not duplicate or disconnect their databases.

## Options considered

1. Four independent repositories with published shared packages.
2. One monorepo with `apps/*` and `packages/*`, using Dart/Flutter workspaces or Melos.
3. One combined Flutter app with role-based routing (the superseded 2026-10-28 approach).

## Decision

Option 2: one monorepo, four `apps/*` packages (`customer_app`, `partner_app`, `admin_web`, `accounts_web`), shared `packages/*` (auth contracts, identity/roles, domain models, design tokens/UI, localization, API clients, validation, error handling, notification interfaces, money formatting, test utilities), with an enforced acyclic dependency graph (NFR-023). Option 3 is rejected: it cannot give suppliers and riders independent dashboards/balances/release cadences, and it is the design this request explicitly supersedes.

## Consequences

Faster shared-code changes and one coordinated backend contract version, at the cost of coordinated versioning across four apps and careful route/permission isolation per app (see [architecture/MULTI_APP_ARCHITECTURE.md](../architecture/MULTI_APP_ARCHITECTURE.md)). Migrating the existing single `app/` package into this layout is tracked separately as TASK-010 and is not performed by this ADR.

## Risks

Package name/version drift between apps; a shared package accidentally depending on an app-specific one (circular import) — mitigated by a dependency-graph check in CI (not yet configured).

## Links

[architecture/MULTI_APP_ARCHITECTURE.md](../architecture/MULTI_APP_ARCHITECTURE.md), [setup/MONOREPO_AND_BUILD_OWNERSHIP.md](../setup/MONOREPO_AND_BUILD_OWNERSHIP.md), RISK-022.
