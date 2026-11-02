# Operations runbook: four apps, shared backend and ledger

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (rewrites the single-app monitoring note of 2026-10-28) |
| Owner | Operations owner (to be named; DEC-010) with Finance operations lead for financial sections |
| Purpose | Define what to monitor, how to diagnose symptoms and which procedure to follow once the four applications, the trusted backend and the ledger exist. |
| Applies to | CUS, PAR (supplier and rider workspaces), ADM, ACC, BE, Firestore (FS) and the PostgreSQL ledger store (PG) |
| Depends on | [Incident response](INCIDENT_RESPONSE.md), [backup and restore](BACKUP_RESTORE.md), [maintenance plan](MAINTENANCE_PLAN.md), [settlement and reconciliation runbook](SETTLEMENT_AND_RECONCILIATION_RUNBOOK.md), [gateway outage runbook](GATEWAY_OUTAGE_RUNBOOK.md), [COD discrepancy runbook](COD_DISCREPANCY_RUNBOOK.md), [rollback plan](../deployment/ROLLBACK_PLAN.md), [conventions](../analysis/CONVENTIONS_AND_ID_REGISTER.md) |
| Authoritative policies | BR-013, BR-014, BR-020 (all PENDING); parameter names only, no values |
| Status | **Preparation document. Nothing described here has been run, deployed, monitored or tested.** No monitor, alert, scheduled job, on-call rota or support channel exists. |

## 1. Scope and ground rules

1. This runbook is PROPOSED. It becomes operational only after the owners, channels and thresholds in section 9 are approved and each procedure has been rehearsed with recorded evidence in [test results](../testing/TEST_RESULTS.md).
2. OBSERVED baseline: one combined Flutter app (`app/`, package `smart_tiffin`), one Cloud Functions callable `executeCommand` (`backend/functions`, Node 22 runtime declared in `firebase.json`), Firestore and Storage rules in `firebase/`. No PostgreSQL ledger, no gateway, no Accounts or Admin web build exists yet. Sections below describe the target state and are marked PROPOSED.
3. Money is never repaired by editing history. Corrections are reversing or adjusting journals with a reason code and an approver who is not the preparer (INV-02, INV-15).
4. Uncertain external status (gateway, bank, rider claim) is shown as pending. Success is never invented to clear a queue.
5. Access during an incident follows least privilege. Do not widen Security Rules or IAM to "get unstuck".
6. Personal data in logs is minimised: correlation id, principal id hash and error category only. No tokens, card or wallet data, store credentials, document images or full addresses.

## 2. System map for operators (PROPOSED)

| Component | Store or service | Operated by | Notes |
|---|---|---|---|
| Customer App (CUS), Partner App (PAR) | Android release channel | Release owner | Installed clients cannot be replaced instantly; backend stays backward compatible for the agreed window |
| Admin Web (ADM), Accounts Web (ACC) | Separate web origins, see [web hosting](../deployment/WEB_HOSTING_ADMIN_AND_ACCOUNTS.md) | Release owner | Staff only; MFA required (PROPOSED) |
| Command service (BE) | Cloud Functions callable and scheduled jobs | Backend maintainer | Idempotency receipts and audit events written with each command |
| Operational store (FS) | Firestore | Backend maintainer | Catalogue, subscriptions, obligations, delivery |
| Ledger store (PG) | Managed PostgreSQL (hosting choice PROPOSED in [ADR-005](../adr/005-hybrid-datastore.md)) | Finance data owner | Journals, payments, COD, payouts, periods |
| Payment gateway | SSLCOMMERZ (planned, not connected) | Payments owner | Sandbox and live strictly separated |
| Messaging | FCM and a transactional message provider (not selected) | Backend maintainer | Notification failure never undoes a committed command |

## 3. Monitoring catalogue (PROPOSED, none active)

Each signal needs an owner, threshold parameter, alert channel and a verified test alert before it counts as active.

| Signal | Why | Threshold parameter (no value approved) | First responder | Restriction on data in the alert |
|---|---|---|---|---|
| Command error rate and latency per command name | Broken order, payment or assignment path | `ops.alert.command_error_rate`, `ops.alert.command_p95_ms` | Backend maintainer | Command name, correlation id, error category |
| Authorization denials and forbidden writes | Misconfiguration or probing | `ops.alert.denied_rate` | Security owner | Counts per role; no tokens |
| Idempotency replays and fingerprint mismatches | Client retry storms or tampering | `ops.alert.replay_rate` | Backend maintainer | requestId hash |
| Gateway notifications received, validated, rejected | Forged or lost IPN, validation failures | `ops.alert.gateway_validation_failures` | Payments owner | Transaction id only |
| Payments in Awaiting Confirmation or Unknown older than the age limit | Lost callbacks, outage | `ops.alert.payment_pending_age_minutes` | Finance operations | Count and oldest age |
| Journal imbalance check (INV-01) and ledger-to-subledger drift | Integrity failure | zero tolerance | Finance data owner | Journal id |
| Daily reconciliation exceptions open and ageing | Unmatched money | `ops.alert.recon_exception_age_hours` | Accounts Manager | Counts by type |
| COD remittance overdue count and amount band | Cash exposure | from BR-013 deadline parameter | Accounts Operator | Rider id, amount band |
| Payout batches stuck in Processing | Unconfirmed transfers | `ops.alert.payout_processing_age_hours` | Accounts Manager | Batch id |
| Scheduled job success (obligation generation, earning recognition, outbox) | Missed daily work | job heartbeat | Backend maintainer | Job name, run id |
| Outbox backlog and notification failure rate | Delivery of messages | `ops.alert.outbox_backlog` | Backend maintainer | Counts only |
| Unassigned or stalled deliveries near slot cutoff | Fulfilment risk | from BR-004 and BR-022 | Admin operations | Zone, slot id |
| Backup age, PITR window, restore test age | Recoverability | see [backup and restore](BACKUP_RESTORE.md) | Operations owner | Timestamps |
| Firebase and database cost against budget | Runaway reads or writes | approved budget | Operations owner | Aggregates |
| Admin and Accounts privileged actions (role grants, period close, payout approval) | Misconduct detection | every event reviewed | Security owner | Actor id, action, reason code |

## 4. Diagnostic procedures

### 4.1 Customer and operational symptoms

| Symptom | Checks | Safe response |
|---|---|---|
| Customer cannot sign in or receive OTP | Identity provider status, OTP provider status, rate limit state, account disabled flag | Show a safe error, never log credentials; do not bypass OTP |
| Payment shows pending after the customer paid | Payment state, gateway events received, validation attempts | Follow [gateway outage runbook](GATEWAY_OUTAGE_RUNBOOK.md); never mark Verified from a redirect |
| Quote rejected as stale or amount mismatch | Quote expiry, price version, policy version | Ask the customer to re-confirm a fresh quote; never charge a new amount silently |
| Obligation count differs from kitchen forecast | Obligation generation job run, pauses and skips, price and slot ids | Re-run generation idempotently from source records; never overwrite totals by hand |
| Credit appears twice or not at all | Credit origin unique key (INV-08), request receipts | Escalate to Accounts; correct only through a reversing credit transaction |
| Rider cannot see an assignment | Assignment revision, role grant, query filter, token claims freshness | Correct the assignment through the command; refresh the token; do not widen reads |
| Delivery transition rejected | Expected current state and version | Refresh and retry if still authorised; keep the event trail |
| Dispatch looks stuck | Offer expiry, rider duty status, zone | Admin reassigns using `reassignDelivery`; see INV-19 for earning reversal |
| Notification not received | Outbox event, token validity, provider response | Resend through the outbox; notification state is not business state |
| Role change does not apply | Claim refresh, grant record, session revocation | Force token refresh; confirm the grant in the staff audit trail |

### 4.2 Financial symptoms

| Symptom | Checks | Safe response |
|---|---|---|
| Dashboard total disagrees with journals | Period, qualifier (paid, pending, posted, held, reserved, disputed, available), source query | Treat the journals as truth (INV-20); open a defect; do not patch the dashboard figure |
| Journal does not balance or posts to a closed period | Command receipt, journal lines, period state | Stop the producing job, preserve evidence, follow [incident response](INCIDENT_RESPONSE.md) severity S1 |
| Gateway statement mismatch | Settlement statement vs clearing postings by transaction id | Reconciliation exception and the [settlement runbook](SETTLEMENT_AND_RECONCILIATION_RUNBOOK.md) |
| COD deposit counted twice | Unique deposit reference constraint (INV-12) | [COD discrepancy runbook](COD_DISCREPANCY_RUNBOOK.md); reverse the duplicate verification |
| Payout shows Settled without external evidence | Payout result record, bank or MFS confirmation | Revert state by reversing entry; this is an S1 incident |
| Supplier or rider balance appears wrong | Earning recognition events, holds, reversals, settled payouts | Rebuild the explanation from journals; correct only by adjustment with approval |

## 5. Routine operating cadence (PROPOSED)

| Cadence | Task | Owner | Reference |
|---|---|---|---|
| Daily | Check job heartbeats, outbox backlog, pending payments, open exceptions, COD overdue list | Operations and Accounts Operator | sections 3 and 4 |
| Daily | Daily close steps | Accounts Operator and Accounts Manager | [settlement runbook](SETTLEMENT_AND_RECONCILIATION_RUNBOOK.md) |
| Weekly | Weekly close, access review of privileged sessions, dependency alerts review | Accounts Manager, Security owner | same, [maintenance plan](MAINTENANCE_PLAN.md) |
| Monthly | Period close, backup restore sample test, role grant review, cost review | Finance lead, Operations owner | same, [backup and restore](BACKUP_RESTORE.md) |
| Per release | Release checklist and rollback readiness | Release owner | [release checklist](../deployment/RELEASE_CHECKLIST.md) |

## 6. Change control in operation

- Policy parameters change only through `publishPolicyVersion` with an approval record; historical quotes and invoices are never recalculated.
- Production configuration changes follow the same review as code. Environment identity is checked before every write; configuration fails closed and never falls back to production.
- Emergency restriction of a failing write path is allowed only through a reviewed switch (for example a feature flag held in configuration); disabling authorization globally is prohibited.

## 7. Evidence to keep

Alert test results, backup and restore exercise records, close checklists with sign-offs, incident reports, reconciliation exception resolutions and rollback rehearsals. Store them outside customer-facing systems with restricted access; link them from `verification/`.

## 8. Acceptance and verification conditions

| Condition | Evidence required |
|---|---|
| Each monitored signal fires a test alert to the named owner | Recorded test alert per signal |
| Every runbook step has been walked through in staging by someone other than its author | Dated walkthrough record |
| Financial procedures reproduce expected journals using synthetic data | Test results linked to TEST-201 to TEST-260 once executed |
| Owners, channels, thresholds approved | Approval record under DEC-010 |

Until then the correct statement is "runbook drafted, not exercised".

## 9. Open decisions

- DEC-010: operations owner, support route, alert channels, severity commitments, RPO and RTO.
- BR-013 and BR-014: the deadlines and frequencies the daily and weekly steps depend on.
- Messaging provider selection and its privacy review.
- Ledger hosting choice and its operations burden ([ADR-005](../adr/005-hybrid-datastore.md)).
