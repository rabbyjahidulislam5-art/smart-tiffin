# Backup and restore: Firestore and PostgreSQL ledger

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 |
| Owner | Operations owner with Finance data owner (both to be named; DEC-010) |
| Purpose | Define what must be backed up, how recovery would work for each store, and how to prove the ledger is intact after a restore. |
| Applies to | FS (Firestore), PG (PostgreSQL ledger), Cloud Storage documents, identity provider accounts |
| Depends on | [Runbook](RUNBOOK.md), [incident response](INCIDENT_RESPONSE.md), [rollback plan](../deployment/ROLLBACK_PLAN.md), [sources](../references/SOURCES.md), [data retention](../database/DATA_RETENTION.md) |
| Authoritative policies | None. RPO, RTO, retention and region are PENDING under DEC-010 |
| Status | **Not configured, not exercised.** No backup schedule, PITR setting, restore test or recovery environment exists. Product-level statements about managed features are cited in the sources file and carry their own verification status. |

## 1. Data inventory and classes

| Data | Store | Class | Recovery notes |
|---|---|---|---|
| Customers, kitchens, menus, subscriptions, meal obligations, delivery events | FS | Operational, regenerable only in part | Obligations are generated from agreements; verify generation is idempotent before regenerating |
| Request receipts and outbox events | FS and PG | Integrity critical | Losing receipts breaks retry safety; restore with the data they protect |
| Journals, journal lines, payments, gateway events, COD, credits, payouts, periods | PG | Financial record, highest | Never reconstructed from dashboards; immutable (INV-02) |
| Audit events | FS and PG | Evidence | Restore with append-only guarantees |
| Application documents and delivery proofs | Storage | Sensitive | Restore with access rules; do not copy to developer fixtures |
| Identity accounts and custom claims | Identity provider | Access | Provider-supported export and recovery, separate from profile documents; claims are re-derived from grant records |
| Device tokens | FS | Disposable | Not part of the essential backup set |
| Configuration and policy versions | FS and source control | Recoverable | Policy versions are data and must be restored with financial data |

## 2. Controls to establish (PROPOSED)

1. Use managed backup features of the chosen services with restricted, reviewed access and service-provided encryption. Details of what each service offers are summarised in [sources](../references/SOURCES.md): Firestore point-in-time recovery and scheduled backups, and Cloud SQL point-in-time recovery for PostgreSQL. Product limits (windows, retention, billing) must be rechecked before configuration.
2. Backups of FS and PG are taken so that the two can be restored to a consistent logical time. Because the stores are separate, the restore target time is chosen once and both are restored to it, then reconciled (section 5).
3. Access to backups is narrower than application access. Backups are never copied into development environments; fixtures are synthetic.
4. Keep a retained copy of ledger exports (journal headers, lines, period close evidence) in an access-controlled location independent of the live database, per the retention policy (PENDING).
5. A backup that has not been restored in a test is not evidence of recoverability.

## 3. Point-in-time recovery concept

Point-in-time recovery keeps recent versions of data so the system can be returned, or a subset read, at an earlier timestamp. Two uses matter:

| Use | FS approach | PG approach |
|---|---|---|
| Undo a bad bulk write or delete | Read the earlier version of affected documents and write them back through a reviewed procedure, or clone to a new database at a timestamp | Restore to a new instance at a timestamp and extract the affected rows for controlled re-application |
| Full disaster recovery | Restore a backup or clone into a new database, then cut over after verification | Restore to a new instance, verify, then cut over by configuration |

Restores create a new target rather than overwriting the source (per the cited product pages, to be reverified). The cutover decision belongs to the incident lead and the Finance data owner jointly, because it can lose recent financial events.

Financial rule: after any restore that rolls PG back in time, every payment, COD receipt and payout that occurred in the lost window must be rediscovered from external evidence (gateway statement, bank statement, deposit records, provider payout results) and re-posted through normal commands with new idempotency keys and an adjusting reference. Customers and partners are informed through authorised channels.

## 4. Targets (all PENDING)

| Parameter | Meaning | Status |
|---|---|---|
| `ops.rpo.fs_minutes`, `ops.rpo.pg_minutes` | Maximum tolerated data loss | Not approved |
| `ops.rto.fs_hours`, `ops.rto.pg_hours` | Maximum tolerated recovery time | Not approved |
| `ops.backup.retention_days` | Retention of scheduled backups | Not approved, bounded by legal advice |
| Region and residency | Where copies live | Not approved |

No target is promised. Measured results from an exercise replace guesses.

## 5. Restore exercise (to design and run later)

Run in an isolated project with synthetic or access-controlled restored data, never against production without incident authority.

1. Record source project, restore timestamp, schema version and policy version, target project and operator.
2. Restore FS and PG to the same chosen time into isolated targets.
3. Structural checks: document and row counts by collection or table, foreign-key and ownership relationships, identity-to-profile mapping, role grants versus claims.
4. Receipts and idempotency: sample request receipts exist for restored money-affecting records; re-running a sample command with the same key returns the stored result and changes nothing.
5. Disable outbound effects in the restored environment (no gateway calls, no notifications, no payouts, no refunds) before any job runs.
6. Ledger integrity checks (section 6).
7. Cross-store consistency: every PG payment, credit, earning or payout references an FS source record that exists, and conversely every FS record marked paid or settled has a PG counterpart.
8. Measure elapsed time and data loss against targets; record gaps.
9. Record evidence in `testing/TEST_RESULTS.md`. Tear down the isolated restore only under authorisation.

## 6. Ledger integrity check after restore

| Check | Method | Expected |
|---|---|---|
| Journals balance (INV-01) | Per journal, sum of debits equals sum of credits | Zero violations |
| Immutability (INV-02) | Compare journal and line hash chain or row checksums with the last retained export | No changed or missing posted rows |
| Integer amounts (INV-03) | Constraint and sample scan | No fractional or negative-where-prohibited values |
| One journal per money command (INV-04) | Join receipts to journals | At most one per key |
| Gateway receipts equal clearing postings (INV-05) | Compare verified transactions to clearing account postings | Equal by transaction id |
| Credit liability not negative and unique origin (INV-07, INV-08) | Aggregate credit transactions | No negatives, no duplicate origins |
| COD receivable and uniqueness (INV-11, INV-12) | Recompute from invoices, verified remittances and write-offs | Equals ledger balance; no duplicate deposit reference |
| Payables (INV-09, INV-10) | Recompute supplier and rider payables from earnings, holds, settled amounts | Equals ledger balance |
| Closed periods untouched (INV-16) | Compare close evidence totals with current period balances | Equal |
| Trial balance | Sum of all account balances by period | Debits equal credits; closing balances match signed control totals |
| Payout evidence (INV-14) | Each Settled payout has an external confirmation record | None missing |
| Dashboard derivability (INV-20) | Recompute a sample of dashboard totals from journals | Matches |

A restore is accepted only when all checks pass or each deviation has an approved exception recorded by the Finance data owner. Authoritative invariant text is in the [financial data model](../database/FINANCIAL_DATA_MODEL.md).

## 7. Acceptance and verification conditions

- A restore exercise record exists with measured times, integrity check results and sign-off by someone other than the operator.
- Backup schedule, retention and access review are documented with screenshots or exported configuration (no credentials).
- Exercise repeated after any change of store, schema major version or provider.

## 8. Open decisions

DEC-010 (RPO, RTO, retention, region, budget, owner); the PostgreSQL hosting choice; legal retention periods for financial and identity records; handling of identity-provider recovery; whether a cross-region copy is required.
