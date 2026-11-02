# Admin Web: AU-13, A-01 to A-19, and NA-01 to NA-06

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Purpose | Full contracts for Admin's secure sign-in, the legacy A-* screens redesigned for desktop, and the six proposed Admin Web screens. |
| Applies to | ADM |
| Depends on | [Admin Web module docs](../../admin-web/), [Legacy prototype digest §7 Admin](../../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md), [api/COMMANDS_LEDGER_AND_GOVERNANCE.md](../../api/COMMANDS_LEDGER_AND_GOVERNANCE.md) |
| Status | Legacy status OBSERVED; NA-* PROPOSED. Desktop layout is PROPOSED for every row. |

## AU-13 Admin secure sign-in (hidden) · Extend
MFA, invited accounts, audit; the legacy fixed-code `123456` is replaced by a real second factor. Never linked from any public page (kept hidden by design, not merely by omission).

## Legacy A-* (redesigned for desktop)

| ID | Name · migration | Purpose | Key change for desktop/finance separation |
|---|---|---|---|
| A-01 | Executive console · Replace (→NA-01) | Operations overview | Desktop command centre; finance detail moved to NA-05/Accounts |
| A-02 | Incident detail · Reuse | Incident detail | Desktop detail panel |
| A-03 | Incident log · Reuse | Incident list | Desktop table |
| A-04 | Backup rider picker · Extend | Dispatch replacement | `reassignDelivery`, no-double-pay guaranteed (SC-08) |
| A-05 | Dispute detail · Extend | Dispute review | Feeds Accounts' refund/chargeback workflow, never a direct balance edit |
| A-06 | Applications queue · Reuse | Application list | Desktop table with filters |
| A-07 | Applicant dossier · Extend | Approve/reject/request-info | Checklist persisted server-side (fixes legacy local-state gap); applicant shortcut removed |
| A-08 | Users & cooks (tab) · Replace | User management | Desktop table |
| A-09 | User detail · Extend | Suspend/reactivate | `suspendAccount` |
| A-10 | All orders (tab) · Replace | Order monitoring | Desktop table, filters |
| A-11 | Order detail (admin) · Reuse | Order detail with party links | — |
| A-12 | Treasury & settlements · **Split** → NA-05 (limited) | Was: broad treasury view | **Settlement execution moves entirely to Accounts Web** (conflict register C-06) |
| A-13 | Payout batch · **Split** → Accounts Web NF-08 | Was: payout approval | **Removed from Admin entirely**; Admin has no payout authority |
| A-14 | Reports · Extend | Operational reports | `exportReport` (operational scope only) |
| A-15 | Admin settings (tab) · Reuse | Settings hub | → A-16, A-17, A-18 |
| A-16 | Setting detail · Extend | Zone/window/plan/role/escrow settings | Zone toggles now functional (fixes legacy no-op) |
| A-17 | Audit log · Extend | Cross-app audit | Real `ent.AuditEvent` (fixes "static list" gap) |
| A-18 | Security · Reuse | 2FA, sessions | — |
| A-19 | Admin profile · Reuse | Profile hub | — |

## Proposed screens (NA-01…NA-06)

| ID | Name · form | Purpose | Commands | Rules |
|---|---|---|---|---|
| NA-01 | Desktop operations command centre · Full screen | KPI/incident overview | reads only | — |
| NA-02 | Business policy configuration · Full screen | Propose/approve policy versions | `publishPolicyVersion` | BR-006…026 |
| NA-03 | Supplier/rider verification queue · Full screen | Application review | `decideApplication` | fixes A-07's applicant-shortcut gap |
| NA-04 | Desktop incident dispatcher · Full screen | Delay/incident resolution | `reassignDelivery` | WF-J |
| NA-05 | Accounts oversight (limited view) · Section | Non-sensitive finance KPIs only | reads (restricted) | conflict register C-06 |
| NA-06 | Operations report explorer · Full screen | Operational reports | `exportReport` | — |

## F129 reconciliation

Every F129 Admin-section family is mapped in [design/INVENTORY_RECONCILIATION.md](../INVENTORY_RECONCILIATION.md); items formerly under Admin's treasury/payout sections (A-12/A-13) are explicitly re-pointed to Accounts Web, not dropped.
