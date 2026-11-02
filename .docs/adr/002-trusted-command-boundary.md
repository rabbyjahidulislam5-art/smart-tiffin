# ADR-002: Introduce a trusted command boundary

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (supersedes 1.0 "proposed"; the boundary is now OBSERVED in code, and this ADR extends it to four apps and the financial domain) |
| Status | **Accepted and OBSERVED** for the existing single callable; **extended, PROPOSED — NOT APPROVED** for the four-application, financial-command scope below |

## Context

Role changes, verified payment allocation, authoritative billing, assignment access, credit issuance, payout approval and notification sending all require a boundary that no client — mobile or web — can forge. The 2026-10-28 version of this ADR left the server runtime as "proposed". It is no longer proposed: `backend/functions/src/index.js` and `commands.js` implement exactly this boundary today as one Cloud Functions callable `executeCommand`, with Firebase App Check enforcement, a `{command, requestId, expectedVersion?, payload}` envelope, a `sha256([uid, requestId])` idempotency receipt, and `expectedVersion`-based stale-write rejection (OBSERVED).

The 2026-10-30 scope adds three apps (Partner, Admin Web, Accounts Web) and a financial domain (ledger, payouts, COD) that must cross this same boundary, plus an inbound trust problem the original ADR did not need to consider: a gateway webhook/IPN arriving from outside the system, which must be verified before being trusted at all.

## Options considered

1. **Extend the existing single callable** with more `command` cases, keeping one envelope and one receipt mechanism. 
2. **Split into several callables/HTTP functions by domain** (catalogue, payments, ledger, admin) for clearer IAM scoping and independent deploys. 
3. **Introduce a separate server for the financial domain** (for example, a small dedicated service in front of the proposed PostgreSQL ledger), while keeping the existing callable for Firestore-backed operational commands.

## Decision (PROPOSED — NOT APPROVED for the extension; the base mechanism is already OBSERVED and accepted)

Keep the existing envelope, idempotency and `expectedVersion` mechanism as the shared contract across all four applications (extends [ADR-008](008-idempotent-command-envelope.md)). Lean toward **option 3** for the financial domain: Firestore-backed operational commands continue through the existing `executeCommand`-style boundary; ledger-owning commands (MOD-PAY, MOD-COD, MOD-CRD, MOD-LED, MOD-SET) are handled by functions that write to the proposed PostgreSQL store inside their own transaction, still reached through the same authenticated, App-Checked, idempotency-checked entry path — not a separately secured surface. A new category of input — the SSLCOMMERZ IPN/webhook — is handled by a dedicated, signature-verified inbound handler that is **not** reachable by any client command path and never trusts a browser redirect as confirmation (see [ADR-007](007-payment-gateway-abstraction-and-cod.md)).

## Consequences

The existing command-core and emulator rules tests (OBSERVED, claimed by the repository's own README, not re-run by this effort) remain a useful baseline to extend rather than replace. Extending the command set means every new `command` string in [api/API_SPECIFICATION.md](../api/API_SPECIFICATION.md) needs its own authorization and validation branch; a growing single callable eventually becomes an argument for revisiting option 2. This revisit is deferred, PROPOSED, not decided now.

## What remains true regardless of hosting choice

Privileged Firestore/PostgreSQL client libraries bypass declarative rules, so server code must independently re-check authorization on every command (unchanged from the original ADR). No temporary client-side payment verification, role elevation, or balance write is ever implemented while BR-001…BR-026 remain open. [FCM server requirements](https://firebase.google.com/docs/cloud-messaging/server-environment) (external reference, not verified by this effort — see [references/SOURCES.md](../references/SOURCES.md)).

## Links

[ADR-005](005-hybrid-datastore.md), [ADR-007](007-payment-gateway-abstraction-and-cod.md), [ADR-008](008-idempotent-command-envelope.md), [api/API_SPECIFICATION.md](../api/API_SPECIFICATION.md), [architecture/BACKEND_DOMAIN_DESIGN.md](../architecture/BACKEND_DOMAIN_DESIGN.md).
