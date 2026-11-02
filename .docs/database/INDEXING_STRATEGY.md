# Query and indexing strategy

| Field | Value |
|---|---|
| Revision | 1.1 · 2026-10-30 (adds PostgreSQL indexing notes; original Firestore queries unchanged) |
| Owner | Architecture lead |
| Status | Candidate query inventory; no `firestore.indexes.json` extension and no PostgreSQL instance exist. |

## 2026-10-30 extension — PostgreSQL indexing (PROPOSED)

The financial store needs: a unique index on `CodRemittance.depositReference` (INV-12); a unique index on `(uid, requestId)` per money-moving command table (INV-04); a unique index on `CreditTransaction.originId` scoped to issuance type (INV-08); a composite index on `JournalLine(accountCode, journalEntryId)` for ledger balance queries; a composite index on `AccountingPeriod(status, startDate)` for period-close workflows; indexes on every foreign-key-style column (`payeeId`, `riderId`, `supplierId`) used by Accounts Web list views. None of these exists; they are recorded here so the eventual migration script is not designed from scratch.

Status: candidate query inventory; no `firestore.indexes.json` exists. Generate the required index configuration from implemented queries and validate it with the chosen Firestore edition/tooling. Do not treat this table as a deployable index definition.

| Query purpose | Candidate constraints and ordering | Access boundary |
|---|---|---|
| Browse catalogue | Published=true; supplier approval represented safely; plan type/date filter; stable name/id order | Public-safe documents only; browse authentication policy follows SRS |
| Customer order history | customerId=current UID; createdAt descending plus document ID | Customer cannot substitute another UID |
| Supplier cooking list | supplierId=current UID; serviceDate and mealSlot; preparation status | Approved supplier's own obligations |
| Customer subscriptions/pauses | customerId=current UID; relevant status/date | Own documents only |
| Courier queue | courierId=current UID; active=true; schedule order | Current assignment projections only |
| Monthly bills | customerId=current UID; period descending | Own financial records |
| Reference review | Approved verifier scope plus decision/submittedAt | BR-003 must define the scope first |
| Complaints | Reporter scope or authorized handler scope; handling state/time | Private support boundary |
| Notifications | recipient=current UID; createdAt descending | Own notifications |

Use cursor pagination; candidate page size 25, cap 100, must be validated against NFRs and actual response size. Stable secondary ordering prevents missing/duplicated rows when timestamps match. Bound listeners to the active screen and stop them on logout/navigation.

Composite indexes must match actual filters/orderings. Review index exemptions for long free text and private reference fields where they are not queried; no automatic full-text search capability is assumed. Measure query read count, response time and peak-date contention before adding aggregate projections. Supplier/day totals must have a documented rebuild and reconciliation procedure.

Rules evaluate the potential query result, so querying every order and filtering in Flutter is forbidden. A query must include the ownership conditions required by authorization. [Official Rules/query behavior](https://firebase.google.com/docs/firestore/security/rules-conditions), accessed 2026-10-28.

Validation gate: exercise each authorized query and an over-broad/foreign-owner variant against tested Rules, then confirm required indexes in isolated staging. Record index build readiness separately from deployment success.
