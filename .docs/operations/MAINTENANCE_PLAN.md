# Maintenance and retirement plan

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 |
| Owner | Project owner; technical, business-policy and finance owners to be named |
| Purpose | Define recurring maintenance for four apps, the backend and the ledger, and the retirement path. |
| Applies to | CUS, PAR, ADM, ACC, BE, FS, PG, shared packages |
| Depends on | [Runbook](RUNBOOK.md), [backup and restore](BACKUP_RESTORE.md), [monorepo ownership](../setup/MONOREPO_AND_BUILD_OWNERSHIP.md), [dependency review](../security/DEPENDENCY_REVIEW.md), [data retention](../database/DATA_RETENTION.md) |
| Authoritative policies | None; any maintenance that changes commercial behaviour needs the relevant BR approval |
| Status | Future operating plan. No maintainer, cadence or support commitment is assigned. Nothing has been performed. |

## 1. Responsibilities

Name before launch: technical owner (code, releases), business-policy owner (BR approvals), finance owner (ledger, close, reconciliation), security owner, operations owner. Each recurring task below records owner and evidence before any automation is set up.

## 2. Recurring tasks (PROPOSED cadence; frequencies are parameters, not commitments)

| Area | Task | Suggested trigger | Evidence |
|---|---|---|---|
| Dependencies | Review Flutter, Dart, Firebase plugin, Cloud Functions and PostgreSQL driver updates and advisories; regenerate lockfiles through the package manager | Each release and on advisory | Dependency decision record |
| Platform support | Android version support, Flutter web browser support for ADM and ACC, Node runtime support dates for functions | Each release; before runtime end of support | Compatibility note |
| Data | Review indexes and query cost, collection growth, ledger table growth and partitioning need | Quarterly | Capacity note |
| Backups | Verify backup freshness and PITR window; perform a sample restore | Monthly check, annual full exercise | [Restore record](BACKUP_RESTORE.md) |
| Ledger | Trial balance, orphan checks, drift check between subledgers and ledger | Daily automated report after approval, monthly review | Signed check |
| Access | Review staff accounts, finance sub-roles, dormant accounts, admin sessions, service accounts | Monthly | Access review log |
| Secrets | Rotate gateway, messaging and service credentials; verify none in source or client | Per rotation policy (PENDING) | Rotation record, no values |
| Gateway | Compare merchant channel availability and integration against current provider documentation; sandbox smoke test | Quarterly and before live changes | Test record |
| Policy | Review `ent.PolicyVersion` history, expired promotions, tax configuration status | Per policy change | Policy change log |
| Localisation and accessibility | Bangla and English completeness, text scaling and contrast spot checks | Each release | Checklist |
| Notifications | Token lifecycle cleanup, provider failure review | Monthly | Report |
| Cost | Compare Firebase, database, messaging and hosting costs with budget | Monthly | Cost note |
| Security | Rules and IAM review, penetration or abuse test plan items due | Per [security review planning](../security/SECURITY_REVIEW_PLANNING.md) | Review record |

## 3. Compatibility window for installed mobile clients

Backend commands stay backward compatible for the agreed window (`ops.client.min_supported_version`, PENDING). Breaking contract changes need an additive phase, a forced-update mechanism and a rollback plan ([rollback plan](../deployment/ROLLBACK_PLAN.md)).

## 4. Policy and financial maintenance rules

- A policy approval may require migration and regression tests, not only a document update.
- Financial corrections are adjusting entries; they are traceable to a reason code and approver.
- Historical quotes, invoices and journals are never recalculated when prices, fees or tax change.
- Period-end tasks are in the [settlement runbook](SETTLEMENT_AND_RECONCILIATION_RUNBOOK.md).

## 5. Technical debt and later releases

Track unresolved acceptance for the current release separately from later scope (recommendation features, demand prediction, loyalty, extra payment channels, iOS release). Their priority is not decided here.

## 6. Retirement plan

Before ending service decide: authorised data export, retention and deletion obligations (legal advice), final financial reconciliation and period close, settlement of all partner balances and customer credits and prepaid obligations per approved policy, customer and partner communication. Stop new subscriptions and orders only through an approved transition policy; complete or resolve outstanding deliveries and COD remittances. Revoke store, signing, gateway and service credentials, disable web origins, then remove paid resources after retention and recovery needs are met. No deletion schedule or legal obligation is invented here.

## 7. Acceptance and verification conditions

Each task has an owner, a recorded run and evidence; the retirement plan is reviewed by finance and legal advisers before use.

## 8. Open decisions

Owners and cadence approval (DEC-010); secret rotation policy; legal retention periods; credit, prepaid and payable settlement on retirement (BR-025 legal review).
