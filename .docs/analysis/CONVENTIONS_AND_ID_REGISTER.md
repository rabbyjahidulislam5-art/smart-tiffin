# Documentation conventions and identifier register

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead (primary agent) |
| Purpose | The single contract every author follows so that independently written files agree on identifiers, canonical names, provenance tags, header format and folder ownership. If a file contradicts this register, this register wins and the file is corrected. |
| Status | Working convention. The architecture names below are **PROPOSED**; the identifier scheme itself is a documentation convention. |
| Related | [Master prompt digest](SOURCE_MASTER_PROMPT_DIGEST.md), [legacy prototype digest](SOURCE_LEGACY_PROTOTYPE_DIGEST.md), [glossary](../requirements/GLOSSARY_AND_TERMINOLOGY.md), [policy register](../requirements/POLICY_DECISION_REGISTER.md) |

## 1. Provenance tags (mandatory on every requirement, decision, behaviour and number)

| Tag | Meaning | May be implemented without further approval? |
|---|---|---|
| **USER-REQ** | Explicitly stated by the user (master prompt, prototype document, clarifications on 2026-10-28 and 2026-10-30) | Yes, except where it names a policy value (it names none) |
| **OBSERVED** | Seen in a screenshot, in the legacy React prototype (as reported by its documentation), or in the current `app/`, `backend/`, `firebase/` files. Describes what exists, not what is right | Only as a reference; simulated behaviour is never production behaviour |
| **PROPOSED** | Engineering recommendation by this documentation effort (labelled "PROPOSED — NOT APPROVED" when it touches policy or architecture choice) | No — needs approval; independent modules may proceed |
| **PENDING** | An unresolved business or legal decision with a register entry (BR/DEC) | No — blocks the dependent behaviour only |

Rules: never turn PROPOSED into USER-REQ by repetition; never describe OBSERVED prototype behaviour as implemented product behaviour; a prototype status I/U/S is always carried verbatim next to a screen; all BDT amounts are **HYPOTHETICAL** unless a policy register entry says approved (none do).

## 2. Mandatory header block (every file)

```
# <Title>

| Field | Value |
|---|---|
| Revision | <n.n> · <date> |
| Owner | <role> |
| Purpose | <one sentence> |
| Applies to | <apps / modules> |
| Depends on | <relative links> |
| Authoritative policies | <BR-/DEC- links or "none"> |
| Status | <e.g. Draft for review — nothing implemented, nothing approved> |
```

Plus, where relevant: design reference (screen IDs), APIs/commands, acceptance criteria, unresolved decisions. Relative links only, and every link target must exist.

## 3. Applications and shared backend (PROPOSED structure derived from USER-REQ)

| Code | Application | Platform | Audience | Notes |
|---|---|---|---|---|
| CUS | Customer App | Flutter, Android first (iOS-ready) | Guests and customers | Includes the guest/public shell P-01…P-04 |
| PAR | Partner App | Flutter, Android | Suppliers (kitchen partners) and Riders | Two protected workspaces, one binary; separate navigation, dashboards, balances |
| ADM | Admin Web | Flutter Web, desktop-first | Operations/governance staff | No unrestricted balance/payout authority |
| ACC | Accounts Web | Flutter Web, desktop-first | Accounts & Finance staff | Owns reconciliation, settlement, payouts, ledger views |
| BE | Shared backend | Trusted services | All apps | One domain model, one set of commands |
| DEV | Design/QA tooling | — | Designers, QA | X-01 and X-02 are process/tooling artefacts, not product screens |

Current baseline (OBSERVED): one combined Flutter app `app/` (package `smart_tiffin`), one Cloud Functions callable `executeCommand` (`backend/functions`), Firestore/Storage rules (`firebase/`). All untracked in Git; none verified by this effort. See [code reality snapshot](../architecture/CODE_REALITY_SNAPSHOT.md).

## 4. Screen identifier rules

1. **Legacy 94 are authoritative and unchanged**: `P-01…P-04`, `AU-01…AU-13`, `SH-01, SH-02, SH-04…SH-10`, `C-01…C-25`, `S-01…S-12`, `R-01…R-10`, `A-01…A-19`, `X-01…X-02`. Each is OBSERVED in the React prototype with a prototype status I/U/S. `SH-03` and `C-26+` do not exist.
2. **Proposed new screens** (PROPOSED): `NC-01…NC-19` (Customer), `NS-01…NS-07` (Supplier workspace), `NR-01…NR-06` (Rider workspace), `NA-01…NA-06` (Admin Web), `NF-01…NF-17` (Accounts Web) = 55. A legacy ID is never reused for a different screen. An `N…` ID is not a confirmed route.
3. **Previous planning inventory (129 families, 153 screenshot controls)** keeps its internal IDs only inside archive-style history files and is cited as `F129/<id>` (e.g. `F129/C-17`) to avoid collision with legacy IDs. Screenshot control IDs `CU-`, `SU-`, `RI-`, `AD-`, `LO-` are unchanged and cited as is. The two-way reconciliation lives in [complete screen inventory](../design/COMPLETE_SCREEN_INVENTORY.md) and [inventory reconciliation](../design/INVENTORY_RECONCILIATION.md).
4. Shared screens (`SH-*`) are **instances per app** (`SH-01@CUS`, `SH-01@PAR-S`, `SH-01@PAR-R`, `SH-01@ADM`, `SH-01@ACC`); content is scoped to the server-enforced role.
5. Migration action per legacy screen: **Reuse** (design carried over, backend added), **Extend** (new capability added to the same screen), **Replace** (screen redesigned or moved to another app; legacy ID kept as alias), **Split** (responsibility moved; e.g. A-12/A-13 → Accounts), **Tool** (X-01/X-02).
6. Counts the final report must reproduce: applications 4 (+ shared backend); legacy screens 94; proposed screens 55 (19/7/6/6/17); scenarios 25; workflows 10; policy decisions: BR-001…BR-005 plus BR-006…BR-026.

## 5. Identifier ranges

| Prefix | Existing (keep, revise in place) | New range reserved | Notes |
|---|---|---|---|
| FR | FR-001…FR-025 | **FR-026…FR-050** (list below) | One `## FR-nnn — Title` heading each |
| UC | UC-001…UC-025 | UC-026…UC-075 | One per new FR, plus workflow-level cases |
| AC | AC-001…AC-025, AC-BR001-xx…AC-BR005-xx | AC-026…AC-075, AC-BR006-xx… | `## AC-nnn — Title`; each AC links FR/UC/BR |
| US | US-001…US-025 | US-026…US-075 | Per actor |
| NFR | NFR-001…NFR-012 | NFR-013…NFR-032 | Includes web/desktop, ledger integrity, time zone |
| BR | BR-001…BR-005 (Pending) | **BR-006…BR-026** (PROPOSED — NOT APPROVED, all PENDING) | See policy register |
| DEC | DEC-001…DEC-015 | **DEC-016…DEC-036** (`DEC-(n+10)` ↔ `BR-n`) | |
| ADR | 001–003 | **ADR-004…ADR-014** | 001/003 superseded, 002 revised |
| TEST | TEST-001…025, TEST-101…117 | TEST-026…099 (functional), TEST-118…199 (security/NFR/UI), **TEST-201…260 (financial invariants)** | Planned unless executed |
| SCT | — | `SCT-<scenario nn>-<N|P|C|L|X|R>` | N normal · P insufficient permission · C concurrent update · L lost response with committed server effect · X inconsistent third-party response · R recovery after partial failure. P or X doubles as the abuse test |
| INV | — | INV-01…INV-20 | Financial invariants (see §7) |
| SC | — | SC-01…SC-25 | End-to-end scenarios (see digest §4) |
| WF | — | WF-A…WF-J | Workflows A–J of master prompt phase 11 |
| RISK | RISK-001…013 | RISK-014…RISK-045 | Finance, gateway, COD, multi-app, migration |
| TASK | TASK-001…009, TASK-101…113, 201 | TASK-010 (FINAL copy), TASK-114…199 | TASK-114+ = four-app programme |
| MOD | — | MOD-AUTH, MOD-CAT, MOD-SUB, MOD-PRC, MOD-ORD, MOD-PAY, MOD-COD, MOD-CRD, MOD-LED, MOD-SET, MOD-DLV, MOD-NOT, MOD-ADM, MOD-AUD, MOD-RPT, MOD-POL | Module codes used in traceability (avoids confusion with milestones M0–M5) |
| Entities | — | `ent.<Name>` e.g. `ent.JournalEntry` | See §8 |
| Commands | existing 30 camelCase names | camelCase names in §6 | |
| Milestones | M0…M5 | M6… | |

### New functional requirements (reserved titles; the requirements author writes the bodies)

| ID | Title | Primary module | Apps |
|---|---|---|---|
| FR-026 | Kitchen discovery, search, filters and kitchen profile (verified status, zones, hours, slots, reviews) | MOD-CAT | CUS |
| FR-027 | Flexible meal, variant, price-version, allergen and slot-availability management by suppliers | MOD-CAT | PAR-S |
| FR-028 | One-time ordering and checkout without a subscription | MOD-ORD | CUS |
| FR-029 | Custom daily/weekly/monthly subscription builder, schedule preview and per-slot meal choice | MOD-SUB | CUS |
| FR-030 | Server quotation with immutable pricing snapshot, expiry and customer confirmation | MOD-PRC | CUS, BE |
| FR-031 | Subscription lifecycle and changes: skip, pause slot, resume, replace, upgrade/downgrade, cancel | MOD-SUB | CUS |
| FR-032 | Customer service credits: issue, reserve, consume, void, history (non-cash) | MOD-CRD | CUS, ACC |
| FR-033 | Online payment through the gateway abstraction (SSLCOMMERZ planned): initiate, server-validate, reconcile | MOD-PAY | CUS, BE, ACC |
| FR-034 | COD: eligibility, rider collection, remittance, verification, discrepancy handling | MOD-COD | CUS, PAR-R, ACC |
| FR-035 | Billing schedules, invoices, receipts and payment history | MOD-PAY | CUS, ACC |
| FR-036 | Supplier earnings: recognition events, balances, holds, statements | MOD-SET | PAR-S, ACC |
| FR-037 | Rider assignment, offer acceptance, earnings per delivery, reassignment without double payment | MOD-DLV | PAR-R, ADM |
| FR-038 | Payout requests, review, maker-checker approval, processing and external confirmation | MOD-SET | PAR, ACC |
| FR-039 | Refunds, disputes, chargebacks and adjustments | MOD-LED | CUS, ADM, ACC |
| FR-040 | General ledger (double-entry), journals, reversals and period close | MOD-LED | ACC |
| FR-041 | Reconciliation: gateway settlement, COD deposits, exceptions | MOD-LED | ACC |
| FR-042 | Finance reporting and secured export | MOD-RPT | ACC, ADM (limited) |
| FR-043 | Admin web operations: zones, policy configuration, incidents, dispatch, monitoring | MOD-ADM | ADM |
| FR-044 | Staff accounts, finance roles, segregation of duties, role-grant audit | MOD-AUTH | ADM, ACC |
| FR-045 | Partner onboarding: applications, documents, verification, corrections, expiry (extends FR-021) | MOD-AUTH | PAR, ADM |
| FR-046 | Kitchen capacity, stock reservation and oversell protection | MOD-CAT | PAR-S, BE |
| FR-047 | Delivery proof, missing customer and delivery exceptions | MOD-DLV | PAR-R, CUS |
| FR-048 | Live tracking and location consent, privacy-bounded | MOD-DLV | CUS, PAR-R |
| FR-049 | Localisation (English/Bangla), themes, responsive layouts and accessibility across apps | cross-cutting | all |
| FR-050 | Time zone, delivery date, slot identifiers and cutoff evaluation by trusted services | MOD-POL | BE, all |

Existing FR-001…FR-025 are retained and revised in place: FR-006 (monthly subscription) becomes one billing-cycle case of FR-029; FR-013 (bKash/Nagad reference) is demoted to an optional manual-evidence fallback pending BR-003 and superseded for online payment by FR-033; FR-018/FR-024 (earnings, revenue) are re-based on ledger-backed definitions (FR-036, FR-040/042).

## 6. Canonical command and service names (PROPOSED)

Existing OBSERVED commands in `backend/functions/src/commands.js` (single callable `executeCommand`, envelope `{command, requestId, expectedVersion?, payload}`): working — `saveProfile`, `saveAddress`, `savePreferences`, `saveDevice`, `saveFood`, `savePlan`, `saveMenu`, `setAvailability`, `submitComplaint`; policy-gated (return `failed-precondition`) — `placeOrder`, `subscribe`, `pauseMeals`, `acceptOrder`, `declineOrder`, `advancePreparation`, `requestCancellation`, `advanceDelivery`, `reportIncident`, `assignDelivery`, `approveSupplier`, `changeRole`, `verifyPayment`, `submitPaymentReference`, `recordAdjustment`, `submitReview`, `saveApplication`, `saveEvidence`, `exportRecords`, `requestData`, `saveSettings`.

PROPOSED additions (the API author may refine parameters but not names without updating this register):

| Domain | Commands |
|---|---|
| Catalogue & kitchens | `searchKitchens` (read), `saveKitchenProfile`, `saveMealVariant`, `schedulePriceChange`, `setSlotAvailability`, `saveCapacity`, `reserveStock`, `releaseStock` |
| Quotes & orders | `createQuote`, `confirmQuote`, `placeOneTimeOrder`, `cancelOrder` (policy-gated) |
| Subscriptions | `createSubscriptionDraft`, `saveSubscriptionSchedule`, `quoteScheduleChange`, `confirmScheduleChange`, `skipMeals`, `pauseSlots`, `resumeSubscription`, `replaceMeal`, `cancelSubscription`, `generateMealObligations` (scheduled job), `renewSubscription` |
| Credits | `issueCredit` (system, from adjustment), `reserveCredit`, `consumeCredit`, `releaseCredit`, `voidCredit`, `expireCredits` (only if BR-019 approved) |
| Payments | `initiatePayment`, `handleGatewayNotification` (trusted webhook/IPN), `validateGatewayTransaction`, `reconcileGatewayStatement`, `initiateRefund`, `recordRefundResult` |
| COD | `recordCodCollection`, `submitCodRemittance`, `verifyCodRemittance`, `flagCodDiscrepancy`, `resolveCodDiscrepancy` |
| Delivery | `offerAssignment`, `acceptAssignment`, `confirmPickup`, `submitDeliveryProof`, `reportDeliveryFailure`, `reassignDelivery`, `updateRiderLocation`, `recordHandoff` |
| Earnings & payouts | `recognizeSupplierEarning`, `recognizeRiderEarning`, `requestPayout`, `reviewPayout`, `approvePayout`, `rejectPayout`, `createPayoutBatch`, `releasePayoutBatch`, `recordPayoutResult`, `placeHold`, `releaseHold` |
| Ledger | `postJournal` (internal only), `reverseJournal`, `requestAdjustment`, `approveAdjustment`, `closePeriod`, `reopenPeriod` (governed) |
| Governance | `grantStaffRole`, `revokeStaffRole`, `publishPolicyVersion`, `decideApplication`, `suspendAccount`, `exportReport` |

Every command: authenticated principal + role/claim check + resource ownership/relationship check + idempotency key (`requestId` per principal) + canonical request fingerprint + atomic write of receipt + audit event; money-affecting commands also post balanced journals in the ledger store (ADR-006/008). Clients never write authoritative balances.

## 7. Financial invariants (INV-01…INV-20, PROPOSED; authoritative text in [financial data model](../database/FINANCIAL_DATA_MODEL.md))

INV-01 every posted journal has equal debit and credit totals · INV-02 posted journal lines are immutable; corrections are reversing/adjusting entries · INV-03 amounts are integers in BDT minor units (paisa) · INV-04 each money-moving command has one idempotency key and at most one journal · INV-05 verified gateway receipts = clearing-account postings (by transaction id) · INV-06 customer prepaid obligation = verified prepayments − recognised fulfilled value − credited/refunded amounts · INV-07 customer credit liability = issued − reserved/consumed − voided − expired, never negative · INV-08 one credit per skipped scheduled meal origin (unique origin constraint) · INV-09 supplier payable = recognised supplier earnings − holds − settled − reversals · INV-10 rider compensation payable is independent of rider COD custody · INV-11 COD receivable = invoiced COD − verified remittances − approved write-offs · INV-12 a COD collection is verified at most once per deposit reference · INV-13 platform revenue = recognised commission + fees, never gross customer collections · INV-14 payout total ≤ eligible balance at approval time, and settled only after external confirmation · INV-15 maker ≠ checker for every payout and adjustment above the configured limit · INV-16 no journal posts to a closed period; late events post to the open period with an adjusting reference · INV-17 refund + credit issued for one obligation ≤ the paid refundable base · INV-18 quote snapshot totals = invoice total = payment amount = journal total · INV-19 a delivery earning is recognised at most once per delivery and is reversed on reassignment/failure per policy · INV-20 every dashboard total is derivable from posted journals and immutable events.

## 8. Canonical entity names (PROPOSED; stores: FS = Firestore operational, PG = Postgres ledger/finance)

Identity & partners (FS): `ent.Principal`, `ent.Customer`, `ent.Supplier`, `ent.Kitchen`, `ent.Rider`, `ent.Vehicle`, `ent.StaffAccount`, `ent.RoleGrant`, `ent.Application`, `ent.ApplicationDocument`, `ent.Address`, `ent.ServiceZone`.
Catalogue (FS): `ent.MealCategory`, `ent.Meal`, `ent.MealVariant`, `ent.PriceVersion`, `ent.SlotAvailability`, `ent.KitchenCapacity`, `ent.StockReservation`, `ent.Plan`.
Commerce (FS, financial snapshot copies in PG): `ent.Cart`, `ent.Quote`, `ent.Order`, `ent.OrderItem`, `ent.Subscription` (agreement), `ent.SubscriptionVersion`, `ent.SubscriptionSchedule`, `ent.MealObligation` (individual scheduled meal), `ent.PauseRequest`, `ent.Substitution`, `ent.Invoice`, `ent.Receipt`.
Delivery (FS): `ent.DeliveryAssignment`, `ent.DeliveryEvent`, `ent.DeliveryProof`, `ent.RiderLocation`.
Payments & cash (PG): `ent.PaymentIntent`, `ent.PaymentAttempt`, `ent.GatewayEvent`, `ent.GatewayVerification`, `ent.CodCollection`, `ent.CodRemittance`, `ent.Refund`, `ent.Dispute`, `ent.Adjustment`.
Credits (PG): `ent.CreditAccount`, `ent.CreditTransaction`.
Earnings & payouts (PG): `ent.SupplierEarning`, `ent.RiderEarning`, `ent.Hold`, `ent.PayoutRequest`, `ent.PayoutApproval`, `ent.SettlementBatch`, `ent.PayoutResult`, `ent.PayoutDestination`.
Ledger (PG): `ent.LedgerAccount`, `ent.JournalEntry`, `ent.JournalLine`, `ent.AccountingPeriod`, `ent.ReconciliationItem`, `ent.ReconciliationException`.
Cross-cutting: `ent.RequestReceipt` (idempotency, both stores), `ent.AuditEvent`, `ent.OutboxEvent`, `ent.Notification`, `ent.Device`, `ent.PolicyVersion`, `ent.Setting`, `ent.Ticket`, `ent.Complaint`, `ent.Review`.

## 9. Folder ownership (user-approved layout: existing category folders kept and extended)

| Folder | Content | Authoring owner |
|---|---|---|
| root of `FINAL_REFINED_DOCS/` | README, MASTER_INDEX, CHANGE_SUMMARY, PROJECT_STATUS, TASKS, DELIVERABLE_COVERAGE, CHANGELOG, CONTRIBUTING, SECURITY, AGENT_OPERATING_RULES | Agent A + integration |
| `analysis/` | audit, gap analysis, conflicts, provenance, change log, conventions, source digests | Primary |
| `requirements/`, `planning/` | scope, roles, FR/UC/AC/US/NFR, business rules, policy register, glossary, traceability matrix, roadmap, risk | Agent A |
| `architecture/`, `database/`, `api/`, `adr/` | system/multi-app/backend design, data, contracts, ADRs | Agent B |
| `payments/`, `accounts-web/`, `security/` | payment, pricing, credits, COD, finance apps, threat model | Agent C |
| `customer-app/`, `partner-app/`, scenarios SC-01…SC-12 | module and screen-group specs | Agent D |
| `admin-web/`, `design/`, scenarios SC-13…SC-25 | admin specs, screen inventory/contracts | Agent E |
| `testing/`, `operations/`, `deployment/`, `setup/`, `references/`, `diagrams/` | tests, runbooks, release, sources, Mermaid diagrams | Agent F |
| `verification/` | coverage, consistency audit, final report, open decisions | Primary |

## 10. Authoring rules for all contributors

1. Rewrite section by section from the sources; do not copy-and-trim or summarise old text. Preserve every feature, control, state, workflow and decision the old file carried, unless the [conflict register](CONFLICT_REGISTER.md) records why it changed.
2. Keep the five confirmed delivery states (Pending → Picked Up → On The Way → Delivered, ADR-003 content) as OBSERVED/USER-REQ; failed-delivery handling is an additional exception path (DEC-014), not a fifth state replacement.
3. BR-001…BR-005 text stays PENDING with its existing alternatives; extend, never approve.
4. Do not define a policy value (fee, cutoff, percentage, threshold, tax rate, deadline). Use a named parameter (for example `policy.cod.remittance_deadline_hours`) and cite the BR/DEC.
5. Illustrative arithmetic uses BDT integers in minor units and is labelled HYPOTHETICAL.
6. A statement of testing, verification or implementation is only allowed with executed evidence recorded in `verification/` or `testing/TEST_RESULTS.md`.
7. Mermaid: fenced ```mermaid blocks, plain ASCII identifiers, no HTML in labels, quote labels containing parentheses or colons.
8. Use only Markdown files. Do not create scripts, PDFs, images or archives. Write only inside `FINAL_REFINED_DOCS/`.
9. No placeholder-only files. Every file has the header block, scope, content, acceptance/verification conditions and open decisions.
10. Never write secrets, credentials, real customer data or real SSLCOMMERZ store identifiers.
