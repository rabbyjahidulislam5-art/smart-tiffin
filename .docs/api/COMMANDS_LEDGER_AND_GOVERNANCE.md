# Commands: ledger and governance

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Backend and API architect |
| Purpose | Full command contracts for journals, adjustments, period close, staff roles, policy versions, application decisions, suspension and exports — file code **LG** in [API_SPECIFICATION.md](API_SPECIFICATION.md) §12. |
| Status | See status column. |

Format per command: **Purpose · Callers · Request · Response · Errors · Idempotency/transaction · Events · Screens · Refs.**

## 1. Journal type labels (referenced across all domain files)

`codInvoiced`, `journalReversal`, `creditIssued`, `promoCreditIssued`, `creditConsumed`, `paymentVerified`, `unmatchedReceipt`, `chargebackReceived`, `gatewaySettled`, `refundApproved`, `refundExecuted`, `codRemittanceVerified`, `codWrittenOff`, `adjustmentPosted`, `supplierEarningRecognized`, `riderEarningRecognized`, `earningReversed`, `payoutReleased`, `payoutSettled`, `payoutFailed`.

## `postJournal` (PROP, Internal only)
Purpose: the only operation that actually writes `ent.JournalEntry`/`ent.JournalLine`; never callable externally. Callers: internal (every financial command above calls this). Idempotency: unique idempotency key per originating command; debits = credits enforced (INV-01). Refs: FR-040.

## `reverseJournal` (PROP)
Purpose: post a reversing entry against a posted journal — the only way to "undo" posted money, never a direct edit. Callers: AcMgr (checking a request above a limit). Events: `journalReversal`. Screens: NF-11. Refs: FR-040; BR-020.

## `requestAdjustment` / `approveAdjustment` (PROP)
Purpose: maker-checker manual correction. Callers: `requestAdjustment`: AcOp, AcMgr. `approveAdjustment`: AcMgr or PayAp, not the requester. Events: `adjustmentPosted`. Screens: NF-16. Refs: FR-039, FR-040; BR-020.

## `recordAdjustment` (OBS-G, legacy alias of `requestAdjustment`)
Status today: `failed-precondition` pending BR-002/BR-005. Screens: A-05 (legacy "Approve credit"). Refs: FR-039; BR-002, BR-005.

## `closePeriod` / `reopenPeriod` (PROP)
Purpose: close an accounting period after reconciliation checks; reopen only under governance. Callers: `closePeriod`: AcOp (begin), AcMgr (finalise, not the initiator). `reopenPeriod`: AcMgr request with an independent approver. Errors: `period_not_reconciled`. Screens: NF-12. Refs: FR-040, FR-041; BR-020 (reopen).

## `grantStaffRole` / `revokeStaffRole` (PROP)
Purpose: invite/grant or revoke a staff/finance role, including Accounts sub-roles. Callers: SupAdm (a second approver for finance-role grants). Idempotency: immediately revokes in-flight privileged sessions (NFR-029). Screens: NF-15. Refs: FR-044; BR-020.

## `changeRole` (OBS-G, legacy alias)
Status today: `failed-precondition` pending DEC-009. Successor: `grantStaffRole`/`revokeStaffRole`; partner role grants go through `decideApplication`. Refs: FR-003, FR-044.

## `approveSupplier` (OBS-G, legacy alias of `decideApplication`)
Status today: gated pending DEC-009. Refs: FR-021, FR-045.

## `decideApplication` (PROP)
Purpose: approve, reject or request information on a partner application. Callers: Adm verifier. Request: `{applicationId, decision, section?, reason?}`. Errors: `checklist_incomplete` (approval requires every check ticked, legacy A-07 pattern preserved). Screens: A-06, A-07, NA-03. Refs: FR-021, FR-045.

## `publishPolicyVersion` (PROP)
Purpose: publish a new `ent.PolicyVersion` for any BR-006…026 parameter. Callers: Adm or SupAdm (operational parameters), AcMgr (financial parameters); the author is never the publisher. Screens: NA-02. Refs: FR-043, FR-050; BR-006…BR-026.

## `saveSettings` (OBS-G, authorization policy)
Purpose: zone and operational settings not yet promoted to a versioned policy. Callers: Adm. Successor for policy-bearing settings: `publishPolicyVersion`. Screens: A-15, A-16. Refs: FR-043.

## `suspendAccount` (PROP)
Purpose: suspend a customer, partner or staff account. Callers: Adm (customers, partners), SupAdm (staff). Idempotency: FS-TX + Auth token revocation. Screens: A-08, A-09. Refs: FR-021, FR-044.

## `exportReport` (PROP)
Purpose: generate a secured, provenance-carrying financial or operational report. Callers: FinV, AcOp, AcMgr, FinAud (finance); Adm (operational, limited). Idempotency: queued, quota-limited, step-up authenticated, fully audited (API spec §10). Screens: A-14, NF-14. Refs: FR-042.

## `exportRecords` (OBS-G, legacy alias)
Status today: gated pending DEC-010. Successors: `exportReport` (staff) and `requestData` (self). Refs: FR-042; DEC-010.
