# ADR-011: Roles, claims and sessions across five roles and four apps

| Field | Value |
|---|---|
| Status | PROPOSED — NOT APPROVED |
| Date | 2026-10-30 |

## Context

USER-REQ: shared identity infrastructure must not grant shared unrestricted privilege; invited admin/finance accounts; MFA where risk warrants; no self-registration path to finance/dispatch capability; explicit policy for one identity holding more than one legitimate role (BR-023).

## Options considered

1. A single `role` string per account, as OBSERVED today (`principals/{uid}.role` ∈ customer/supplier/delivery/admin, with a new profile starting `null`/inactive).
2. Firebase custom claims carrying one or more role grants plus sub-role detail (for Accounts), refreshed on grant/revoke.
3. A fully external authorization service separate from Firebase Authentication.

## Decision

Option 2. Extend the existing single-role model (option 1, OBSERVED) to custom claims that can carry **multiple independent grants** (for example, a person approved as both Supplier and Rider under BR-023), each with its own workspace and balance, plus Accounts sub-roles (Finance Viewer, Accounts Operator, Accounts Manager, Payout Approver, Financial Auditor) and a bounded Super Admin. Option 3 is rejected as unnecessary infrastructure for this scope.

## Consequences

Claim refresh must happen immediately on grant/revoke (NFR-029), including invalidating in-flight privileged sessions; the client never infers authority from a locally cached claim without server re-verification on each command (unchanged trusted-boundary principle). MFA is required for ADM and ACC staff sessions where risk warrants, not yet specified further (open).

## Risks

Claim propagation delay between revocation and actual session invalidation if implemented naively; dual-role balance isolation implemented incorrectly, leaking one workspace's data into another (SC-25).

## Links

[requirements/USER_ROLES.md](../requirements/USER_ROLES.md), [api/AUTHORIZATION.md](../api/AUTHORIZATION.md), BR-023, NFR-029, SC-25.
