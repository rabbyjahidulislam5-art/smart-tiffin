# Authorization matrix

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (supersedes 1.0, four-role, single-app matrix; original rows preserved and extended) |
| Owner | Backend and API architect |
| Purpose | Role/sub-role-by-resource and role-by-command authorization, including the five new Accounts sub-roles, maker-checker constraints and session expectations across four apps. |
| Depends on | [API specification](API_SPECIFICATION.md), [requirements/USER_ROLES.md](../requirements/USER_ROLES.md), [ADR-011](../adr/011-roles-claims-and-sessions.md) |
| Status | PROPOSED — NOT APPROVED (role-to-permission mapping); `Trusted` means server-validated, never Admin-SDK-from-device. |

## 1. Original matrix (kept, roles renamed to the legend in API_SPECIFICATION §11)

| Resource/action | Cust | Sup | Rdr | Adm/trusted service |
|---|---|---|---|---|
| Public published catalogue | Read | Read; trusted edit own approved catalogue | Read if product needs it | Moderate/manage under approved policy |
| Private profile/address | Own allowed fields | Own allowed fields | Own allowed fields | Need-based administration; audit sensitive access |
| Canonical role/active/approval | No write | No write | No write | Trusted authorized management only |
| Subscription/pause | Own read/request | Own supplier's necessary service data | No access | Authorized operations; BR-001 controls decisions |
| Order | Own read/place | Own supplier orders; preparation transition | Assignment projection only | Monitor; sensitive mutation requires explicit operation |
| Delivery destination/contact | Own order snapshot | Only approved operational minimum | Current assigned delivery minimum | Authorized assignment workflow |
| Assignment/reassignment | No | Only if BR-004 selects supplier | No self-assignment unless BR-004 approves | Actor unresolved BR-004 |
| Delivery status | Own read | Own order read | Current assignment, legal forward step | Exceptional recovery procedure unresolved DEC-014 |
| Bill/payment reference | Own read/submit | Own earnings/payment summary only | No | Verification actor unresolved BR-003 |
| Revenue report | No | Own earnings, not platform-wide revenue | No | Authorized admin; definition pending BR-002 |
| Review | Eligible own order | Approved public content; no self-rating manipulation | Approved public content if needed | Moderation rules DEC-013 |
| Complaint | Own submission/history | Only if specifically involved/authorized | Only if specifically involved/authorized | Authorized handler; no unrelated disclosure |
| Notification/device token | Own | Own | Own | Trusted send; no user lists of other tokens |
| Audit/request receipts | Own command outcome through safe projection | Own command outcome through safe projection | Own command outcome through safe projection | Restricted operational access; append-only audit |

## 2. Extended matrix — financial and Accounts resources (2026-10-30)

| Resource/action | Cust | Sup | Rdr | FinV | AcOp | AcMgr | PayAp | FinAud | Adm | SupAdm |
|---|---|---|---|---|---|---|---|---|---|---|
| `catalogue.public`, `kitchens.index` | Read | Edit own | Read | — | — | — | — | — | Moderate | — |
| `orders.own`, `obligations.own` | Own | Own supplier's | Assigned | — | — | — | — | — | Monitor | — |
| `quotes.own` | Own | — | — | — | — | — | — | — | — | — |
| `credits.own` | Own | — | — | Read | Read | Read, void (checker) | — | Read | — | — |
| `invoices.own`, `payments.own` | Own | — | — | Read | Prepare | Review/approve | Approve refund | Read | Limited | — |
| `earnings.supplier`, `earnings.rider` | — | Own | Own | Read | Read, hold | Review, release hold | — | Read | — | — |
| `payouts.own` (request) | — | Own | Own | — | — | — | — | — | — | — |
| `payouts` (review/approve/batch/settle) | — | — | — | Read | Review, batch | Approve (≠ preparer) | Approve (≠ preparer) | Read | — | — |
| `ledger.journals`, `ledger.accounts` | — | — | — | Read | Prepare adjustment | Approve adjustment, reverse | — | Read, audit | — | Bounded |
| `reconciliation.items` | — | — | — | Read | Prepare | Resolve exception | — | Read | — | — |
| `cod.collections`, `cod.remittances` | — | — | Own | Read | Verify | Resolve discrepancy | — | Read | — | — |
| `audit.events` | Own command outcome | Own command outcome | Own command outcome | Read | Read | Read | Read | Read, export | Read | Read |
| `staff.roles` (grant/revoke) | — | — | — | — | — | — | — | — | — | Grant (second approver for finance roles) |
| `policy.versions` (publish) | — | — | — | — | — | Financial parameters | — | — | Operational parameters | Operational parameters |
| `accounting.periods` (close/reopen) | — | — | — | — | Begin close | Finalise close (≠ initiator), request reopen | — | Read | — | — |
| `reports` (export) | — | — | — | Read | Generate | Generate | — | Generate, audit | Operational only | — |

## 3. Maker-checker rule (applies to every row marked "approve/review" above)

No principal may approve, release, finalise or settle an item it itself prepared, requested or batched (NFR-016, INV-15, ADR-010). The check is enforced at the command layer by comparing the preparer's and approver's principal ids, never by a UI restriction alone.

## 4. Session and claim rules

Server-managed claims improve route selection but are observed on token refresh; a cached claim never enforces immediate revocation by itself (unchanged OBSERVED limitation). Revoking a staff role immediately invalidates in-flight privileged sessions for Admin Web and Accounts Web (NFR-029, ADR-011). MFA is required for ADM and ACC staff sessions where risk warrants (specific trigger conditions open). Firestore Rules protect client SDK operations for the operational store; the trusted backend has independent authorization obligations for both Firestore and PostgreSQL. Query shape must prove the required ownership restriction; a deep link or push-notification payload undergoes the same checks as a normal screen entry.

## 5. Cross-role and cross-app isolation

A Supplier principal never reads another supplier's private orders, earnings or documents. A Rider principal receives only the minimum delivery projection for a currently assigned delivery; access is revoked immediately on reassignment or completion. An Admin principal has no implicit read or write access to Accounts' ledger, payout or credit resources (conflict register C-06). A dual-role principal (BR-023 PENDING) has independently authorised, non-shared balances and notification scopes per workspace (SC-25). No record is authorised merely because its identifier is hard to guess; cross-role negative tests must cover every row before release (see [testing/TEST_CASES.md](../testing/TEST_CASES.md), [testing/FINANCIAL_TEST_CASES.md](../testing/FINANCIAL_TEST_CASES.md)).
