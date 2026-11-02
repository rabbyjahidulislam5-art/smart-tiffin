# Security architecture

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (supersedes 1.0, single-app, no gateway/web/finance) |
| Owner | Architecture lead; security review owner — to be identified |
| Purpose | State the trust boundaries, authentication/authorization model and financial-integrity controls across four applications. |
| Depends on | [Security requirements](../security/SECURITY_REQUIREMENTS.md), [threat model](../security/THREAT_MODEL.md), [financial security](../security/FINANCIAL_SECURITY.md), [authorization](../api/AUTHORIZATION.md) |
| Status | PROPOSED — NOT APPROVED. |

## Trust boundaries

1. **Client (CUS, PAR, ADM, ACC):** untrusted. Never holds a privileged credential, a gateway secret, or an authoritative balance. Enforces nothing by itself — all enforcement happens at the trusted boundary.
2. **Trusted backend (Cloud Functions `executeCommand`, extended):** the only layer that decides role, money and policy outcomes; validates App Check (mobile) and session (web), authorization, idempotency and `expectedVersion` before any write.
3. **Firestore:** deny-by-default rules (OBSERVED, `firestore.rules`); client reads are scoped by ownership/role; all writes happen only through the trusted backend's Admin SDK, never directly from a client SDK write path for any entity introduced by this scope.
4. **PostgreSQL ledger (proposed):** reachable only from the trusted backend; no client driver, no direct query access from any app.
5. **SSLCOMMERZ:** external; inbound IPN is verified (signature/validation per the official contract) before being trusted; outbound calls carry no customer PII beyond what the gateway contract requires.

## Authentication and sessions

Firebase Authentication for CUS and PAR (OBSERVED); web session handling for ADM and ACC adds MFA where risk warrants (ADR-011) and explicit session/idle timeout, since desktop sessions are longer-lived and higher-privilege than mobile sessions.

## Authorization model

Role + claim (from MOD-AUTH) + ownership/relationship check, re-evaluated on every command — never inferred from a UI route (see [api/AUTHORIZATION.md](../api/AUTHORIZATION.md) for the full matrix). Accounts sub-roles (Finance Viewer, Accounts Operator, Accounts Manager, Payout Approver, Financial Auditor) and bounded Super Admin each have an explicit capability matrix; no role is "all-powerful by title".

## Financial-integrity controls (new)

Maker-checker segregation of duties on payouts and adjustments above a configured limit (BR-020); idempotent commands with unique origin constraints for credits, payments and remittances (INV-04, INV-08, INV-12); immutable posted journals with reversal-only correction (INV-02); server-authoritative pricing with no client-supplied total ever trusted (NFR-017). Full threat scenarios are in [security/THREAT_MODEL.md](../security/THREAT_MODEL.md) and [security/FINANCIAL_SECURITY.md](../security/FINANCIAL_SECURITY.md).

## Secrets

Gateway credentials, database connection strings and signing keys live only in the trusted backend's secret manager, never in any client bundle or this documentation (see [security/SECRETS_MANAGEMENT.md](../security/SECRETS_MANAGEMENT.md)).

## What this document does not establish

No security control described here has been implemented or penetration-tested. The existing Firestore rules review in [verification/FIREBASE_SECURITY_REVIEW_COPY.md](../verification/FIREBASE_SECURITY_REVIEW_COPY.md) covers only the current single-app baseline, not the extended entity set this scope introduces.
