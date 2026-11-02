# Rollback and disaster recovery plan

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (adds ledger-safe rollback rules; original sequence unchanged) |
| Owner | Release owner — to be identified |
| Status | Proposed operational requirements; no deployed artifact or recovery environment exists. |

Status: proposed operational requirements; no deployed artifact or recovery environment exists.

## 2026-10-30 extension — ledger-safe rollback

A rollback **never** reverses a posted ledger journal directly (INV-02); any correction needed after a bad deploy is a new reversing/adjusting journal, applied forward, never a destructive edit of financial history. A rollback of Admin Web or Accounts Web code never implies rolling back the PostgreSQL schema independently of its own versioned migration path (see [database/MIGRATION_STRATEGY.md](../database/MIGRATION_STRATEGY.md)). If a bad deploy caused incorrect payouts to be released, the recovery is [security/FINANCIAL_SECURITY.md](../security/FINANCIAL_SECURITY.md)'s incident path (SC-24 pattern: adjustment, never deletion), not a code rollback pretending the payout never happened.

## Rollback triggers

Consider stopping rollout for confirmed cross-user access, incorrect financial records, repeated duplicate writes, failed sign-in across supported devices, or loss of the critical order-to-delivery journey. Actual alert thresholds, decision authority and communication route require an operations decision.

## Safe recovery sequence

1. Identify the affected artifact, configuration, rule/policy version and time window; preserve redacted evidence.
2. Restrict the specific failing write path if necessary through an authorized, reviewed control. Do not disable all authorization as a workaround.
3. Compare the previously validated compatible artifact and backend contracts. A mobile rollback cannot instantly replace already installed clients.
4. Prefer a forward correction where data has changed irreversibly. Never delete payment/billing history to imitate a code rollback.
5. Test the corrective version in isolation, then use an authorized staged rollout.
6. Reconcile orders, bill allocations, assignment history and notification attempts. Test ownership and state-transition invariants.
7. Record restoration evidence and unresolved affected records; communicate only through authorized channels.

## Disaster recovery

Use the separate [backup/restore requirements](../operations/BACKUP_RESTORE.md) for data recovery. Restore into an isolated target first; test identity mappings, ownership, policy versions and financial totals before considering cutover. RPO, RTO, export permissions, retention, responsible operator and cost are pending DEC-010. No recovery-time promise is made.

Rollback is complete only when the corrected system and affected user journeys are verified, not when a deployment command returns.
