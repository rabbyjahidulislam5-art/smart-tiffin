# Incident response

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 |
| Owner | Incident lead role (to be named; DEC-010) |
| Purpose | Define severity levels, roles, handling steps, financial incident rules and communication for a multi-app, ledger-backed platform. |
| Applies to | CUS, PAR, ADM, ACC, BE, FS, PG, gateway and messaging integrations |
| Depends on | [Runbook](RUNBOOK.md), [backup and restore](BACKUP_RESTORE.md), [gateway outage](GATEWAY_OUTAGE_RUNBOOK.md), [COD discrepancy](COD_DISCREPANCY_RUNBOOK.md), [settlement runbook](SETTLEMENT_AND_RECONCILIATION_RUNBOOK.md), [rollback plan](../deployment/ROLLBACK_PLAN.md), [threat model](../security/THREAT_MODEL.md), [security reporting](../SECURITY.md) |
| Authoritative policies | BR-015, BR-020, BR-024 (PENDING) |
| Status | Preparation only. No incident service, on-call rota, alerting or contact list is running. Severity levels, response times and channels are PROPOSED and not approved. |

## 1. Severity model (PROPOSED)

Response-time targets are parameters (`ops.incident.s1_response_minutes` and so on), not promises.

| Level | Definition | Examples |
|---|---|---|
| S1 Critical | Confirmed financial integrity failure, cross-user data exposure, loss of authorisation control or total outage of the order journey | Unbalanced or altered journal, payout marked Settled without confirmation, forged payment accepted, role escalation, leaked documents |
| S2 High | Significant degradation or risk without confirmed loss | Gateway validation failing, reconciliation mismatch above threshold, COD duplicate verification, scheduler not running |
| S3 Medium | Limited feature or single-role impact | Notification failures, one app version crashing, delayed report |
| S4 Low | Cosmetic or single-user problem | Label error, single support case |

An incident is upgraded when scope grows or evidence of money or personal data impact appears. Privacy and financial integrity candidates start at S2 until triaged.

## 2. Roles

| Role | Responsibility | Must not |
|---|---|---|
| Incident lead | Declares, coordinates, decides containment, keeps the timeline | Perform the financial correction personally if also its approver |
| Technical responder | Diagnoses, applies reviewed containment, prepares fix | Widen permissions broadly |
| Finance lead | Owns financial assessment, correction journals, partner and customer money decisions | Approve own prepared adjustment (INV-15) |
| Security owner | Evidence handling, credential rotation, access review | Alter audit records |
| Communications owner | Drafts messages to customers, partners, staff, regulators | Publish without authority |
| Scribe | Timeline and decisions | Interpret beyond facts |
| Legal and privacy adviser | Notification obligations | Not named yet |

Small teams may combine roles but never combine maker and checker for a financial correction.

## 3. Handling steps

1. Detect and declare: record time, reporter, symptom, first severity.
2. Contain narrowly: restrict the specific failing write path or feature through a reviewed switch; rotate exposed credentials; suspend a session or account if abused. Do not disable authorisation globally.
3. Preserve: redacted evidence, correlation ids, command receipts, journal ids, gateway event ids, deployed artifact and policy version.
4. Assess scope: affected principals, amounts by qualifier (paid, pending, posted, held), time window, whether external money moved.
5. Correct forward: fix in isolation, test, staged rollout ([rollback plan](../deployment/ROLLBACK_PLAN.md)); financial effects corrected by adjusting or reversing entries.
6. Reconcile: run the checks in [backup and restore section 6](BACKUP_RESTORE.md) and the relevant settlement steps; affected obligations, credits, earnings, payouts and COD records must be explainable.
7. Communicate (section 5), close with review within the agreed period.

## 4. Financial incident handling

| Situation | Immediate action | Ledger rule | Runbook |
|---|---|---|---|
| Suspected forged or replayed gateway callback | Pause activation from unverified events; verify with provider validation API; check duplicates | No journal for unverified events; duplicates create no second journal (INV-04, INV-05) | [Gateway outage](GATEWAY_OUTAGE_RUNBOOK.md) |
| Payment status unknown | Keep Pending or Unknown; reconcile later; inform customer | No success posting until verified | same |
| Double credit or double refund | Freeze further credit or refund commands for the origin; identify by origin key | Reverse the extra entry; INV-08, INV-17 | Settlement runbook, exceptions |
| COD cash missing or mismatched | Open discrepancy; hold related rider payout only through an approved hold | No edit of rider earnings to hide it (INV-10) | [COD discrepancy](COD_DISCREPANCY_RUNBOOK.md) |
| Payout error or overpayment | Stop the batch; obtain provider status; do not retry blindly | Adjustment or recoverable balance with evidence; BR-014, BR-015 | Settlement runbook |
| Journal imbalance or tamper evidence | Stop posting jobs; preserve database state; restore comparison from backup | Never edit posted rows; rebuild through reversing journals | Backup and restore |
| Insider misuse (self-approval, bypass) | Suspend actor, preserve audit, security review | Reverse unauthorised effects with approval by another party (SC-16) | Threat model |
| Data exposure | Revoke access, rotate secrets, scope the exposure | n/a | Security reporting |

Rule: preserve pending truth, investigate, reconcile and inform; never invent success to close an incident.

## 5. Communication (PROPOSED)

| Audience | When | Content limits | Authority |
|---|---|---|---|
| Internal staff | At declaration and each status change | Facts, impact, instructions | Incident lead |
| Affected customers | When their money, orders or data are affected | Plain language in English and Bangla, what happened, what they should do, no speculation, no personal data of others | Communications owner with Finance lead |
| Affected partners | When earnings, payouts or assignments are affected | Same, with balances stated by qualifier | Same |
| Gateway, bank, provider | When their records are needed | Transaction ids only | Finance lead |
| Regulators, public | If advised by legal or required | Per advice | Business owner |

Prepare templates in advance; a screenshot SOS button is not an emergency response service, and rider safety incidents follow a separate human procedure to be defined.

## 6. Post-incident review

Record cause, timeline, impact by qualifier, data affected, correction, evidence of recovery, tests added and follow-up tasks in `TASKS.md`. Blameless format; findings update the [risk register](../planning/RISK_REGISTER.md) and runbooks.

## 7. Acceptance and verification conditions

Tabletop exercises for at least: forged callback, double credit, COD mismatch, payout error, data exposure, with timelines recorded. Contact list and escalation path reviewed. No readiness claim until done.

## 8. Open decisions

DEC-010 owners, severity commitments, channels; BR-015 loss allocation; legal notification duties for Bangladesh (to be advised, not assumed); rider safety response procedure; insurance or financial loss handling.
