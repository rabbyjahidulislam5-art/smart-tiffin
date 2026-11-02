# Migration strategy

| Field | Value |
|---|---|
| Revision | 1.1 · 2026-10-30 (adds the PostgreSQL ledger migration and the single-app-to-four-app migration; original Firestore guidance unchanged) |
| Owner | Architecture lead |
| Status | Future implementation/release procedure. No deployed schema, no PostgreSQL instance, and no migration ran. |

## 2026-10-30 extension — two additional migrations

**PostgreSQL ledger schema migration (new):** use a versioned migration tool (not yet selected) with forward-only migrations in normal operation; a "rollback" of a financial schema change is never a silent data rollback — any correction to already-posted data is a new reversing migration plus reversing journal entries, never a destructive `DOWN` migration against real financial history (extends step 4 below, which already requires before/after reconciliation for money).

**Single combined app → four-app monorepo migration (TASK-010):** this is a code-restructuring migration, not a data migration; it is tracked separately and is explicitly out of scope for this documentation-only phase. When undertaken, it follows the same "export/back up, test interruption and restart, validate before removing the old path" discipline as the steps below, applied to the Flutter package structure rather than to data.

Status: future implementation/release procedure. No deployed schema or migration history exists, and no migration ran.

1. Resolve BR-001–005 and approve the candidate dictionary before the first schema version. Record the data owner, supported client versions, validation constraints and access rules.
2. Keep schema version separate from bill/meal policy version. A pricing-policy revision must not reinterpret already accepted financial or meal facts.
3. Prefer additive fields and dual-compatible readers during a mobile rollout. New clients tolerate known optional older fields; server writes reject unsupported payloads safely.
4. For a backfill, prepare a versioned, resumable script with bounded batches, dry-run counts, deterministic identifiers and a checkpoint. Restrict project/environment identifiers explicitly.
5. Export or back up affected data and demonstrate a restore in an isolated destination before risky changes. See [backup/restore](../operations/BACKUP_RESTORE.md).
6. Test empty initialization, supported previous version, malformed legacy documents, interruption/restart, duplicate run, account deletion boundaries and old-client/new-server compatibility.
7. Deploy compatibility support before data transformation; validate totals, referential integrity, authorization and migration counts; only later remove obsolete reads/fields.

Money, reference verification, assignment ownership, role and delivered-state migrations require explicit before/after reconciliation and an audit record. Do not rewrite issued bill facts to match a new rule. Prefer an auditable adjustment or forward correction when reversal would destroy evidence.

Rollback is not assumed safe: classify whether old clients can read new data and whether a reverse transformation loses information. If rollback is impossible, define a forward-fix and temporary write restriction. Record the revision, source/destination project, operator, counts, checksum where appropriate and validation outcome before declaring completion.

Migration tooling/runtime is undecided with DEC-011; no unverified CLI commands or mock success logs are supplied.
