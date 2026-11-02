# Accounts Web architecture

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Accounts Web domain author |
| Purpose | Define the Accounts Web application's boundary against Admin Web, its role model, navigation structure and data sources. |
| Applies to | ACC |
| Depends on | [Multi-app architecture](../architecture/MULTI_APP_ARCHITECTURE.md), [ADR-010](../adr/010-payout-maker-checker.md), [ADR-011](../adr/011-roles-claims-and-sessions.md), [api/AUTHORIZATION.md](../api/AUTHORIZATION.md) |
| Status | PROPOSED — NOT APPROVED. This application does not exist; it is entirely new (conflict register C-06). |

## 1. Boundary against Admin Web

Accounts Web owns reconciliation, collections, settlement execution, payout approval and financial reporting. Admin Web retains only a limited, read-only financial overview (NA-05) and never an implicit ability to transfer money, edit a journal, or approve a payout (USER-REQ, conflict register C-06). The two applications never share a session, origin, or navigation graph (per [architecture/MULTI_APP_ARCHITECTURE.md](../architecture/MULTI_APP_ARCHITECTURE.md) §1).

## 2. Role model and capability matrix

| Role | Can prepare | Can approve | Can view | Cannot |
|---|---|---|---|---|
| Finance Viewer (FinV) | — | — | All finance dashboards, reports | Prepare or approve anything |
| Accounts Operator (AcOp) | Reconciliation items, payout requests, adjustment requests, COD verification | — | Own prepared items | Approve its own preparation (ADR-010) |
| Accounts Manager (AcMgr) | Adjustment requests, period-close initiation | Adjustments, holds release, reconciliation exceptions, period-close finalisation (not self-initiated) | Everything AcOp sees | Approve its own preparation |
| Payout Approver (PayAp) | — | Payout approvals, batch release | Payout queues | Prepare a payout it then approves |
| Financial Auditor (FinAud) | — | — | Everything, plus export | Prepare or approve anything |
| Super Admin (bounded) | Staff role grants, policy publication (financial parameters require AcMgr) | Staff role grants | Administrative views | Any payout or journal action by default |

## 3. Navigation structure (desktop, side navigation)

Dashboard (NF-01) → Payments (NF-02) → COD (NF-03, NF-04) → Supplier Settlement (NF-05) → Rider Settlement (NF-06) → Payouts (NF-07, NF-08) → Credits (NF-09) → Refunds/Adjustments (NF-10, NF-16) → Ledger (NF-11) → Period Close (NF-12) → Exceptions (NF-13) → Reports (NF-14) → Roles (NF-15) → Gateway Statements (NF-17).

## 4. Data sources

Firestore read models for operational context (order/obligation references, principal names); the PostgreSQL ledger for every balance, journal and payout figure (ADR-005). No figure shown in Accounts Web is computed client-side; every dashboard total is derivable from posted journals and immutable events (NFR-030, INV-20).

## 5. Session and security

Invited accounts only, MFA where risk warrants (ADR-011), explicit idle timeout stricter than Admin Web given the higher privilege level, CSRF-appropriate session handling (SEC-018, open pending hosting choice).

## Acceptance and verification

Design-only. Verification requires a role-matrix test confirming each row's "cannot" column is actually rejected at the command layer, not merely hidden in the UI.
