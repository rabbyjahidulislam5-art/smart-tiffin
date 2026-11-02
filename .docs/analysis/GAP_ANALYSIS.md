# Gap analysis

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead (primary agent) |
| Purpose | Classify the existing documentation against the two primary requirement sources in the fourteen categories required by the master prompt (Phase 1), before any rewrite. |
| Depends on | [Existing document audit](EXISTING_DOCUMENT_AUDIT.md), [master prompt digest](SOURCE_MASTER_PROMPT_DIGEST.md), [prototype digest](SOURCE_LEGACY_PROTOTYPE_DIGEST.md), [conflict register](CONFLICT_REGISTER.md) |
| Status | Complete for planning. Statements are tagged USER-REQ / OBSERVED / PROPOSED / PENDING per [conventions](CONVENTIONS_AND_ID_REGISTER.md). |

## 1. Existing requirements that remain valid

- FR-001…FR-025 intent (registration, profile, RBAC, plans/menus, subscriptions, orders, pauses, history, delivery tracking, reviews, bills, supplier menus/availability/orders/earnings, delivery worklist and lifecycle, admin user/order/complaint/revenue, notifications). Revised, not discarded.
- BR-001…BR-005 as PENDING with their alternatives; DEC-001…DEC-015.
- Four confirmed delivery states Pending → Picked Up → On The Way → Delivered (ADR-003 content).
- Trusted command boundary (ADR-002) and its OBSERVED implementation: idempotent receipts, canonical request fingerprint, `expectedVersion` stale-write guard, App Check, deny-by-default rules.
- Android-first, Bangla + English, accessibility and privacy principles, integer minor units and Asia/Dhaka (DEC-008, proposed).
- Glass-style design system and role accents (orange customer, green supplier, blue rider, indigo admin) – now corroborated by the 94-screen prototype.
- Evidence honesty: nothing executed is claimed; the rules-emulator and command-core tests the repo reports are OBSERVED claims, not re-run here.

## 2. Existing requirements that need revision

| Item | Revision |
|---|---|
| "One Flutter app with four workspaces" | Four applications (CUS, PAR, ADM, ACC) on one backend (ADR-004) |
| FR-006 monthly subscription | Generalised to flexible daily/weekly/monthly/custom schedule + agreement vs meal obligation (FR-029, FR-031) |
| FR-013 bKash/Nagad reference | Demoted to optional manual-evidence fallback; online payment becomes gateway-validated (FR-033); BR-003 unchanged |
| FR-018 / FR-024 earnings & revenue | Re-based on ledger-backed definitions (FR-036, FR-040, FR-042) |
| FR-021 admin users/providers | Split: partner onboarding (FR-045), staff/finance roles (FR-044), admin operations (FR-043) |
| USER_ROLES (4 roles) | Add Accounts sub-roles; dual-role policy BR-023; segregation of duties |
| ADR-003 | Payment half superseded by ADR-007 (SSLCOMMERZ abstraction + COD); delivery-state half retained |
| Single "documentation-only" scope wording in AGENTS/PROJECT_STATUS | Replaced by the 2026-10-30 scope: documentation refinement now; implementation later; nothing implemented by this effort |
| Statements "no application exists" (SRS, SYSTEM_ARCHITECTURE, FILE_MAP, TEST_RESULTS) | Replace with OBSERVED baseline: `app/` single app, `backend/` callable, `firebase/` rules, untracked, unverified |

## 3. New requirements missing from current documentation (USER-REQ)

Kitchen discovery/profile and kitchen-scoped menus; flexible variants, price versions, slot availability, capacity and stock reservation; one-time ordering; custom schedule builder with per-slot meals; quotation with immutable snapshots and expiry; skip/pause-slot/replace/upgrade/downgrade with adjustment quotes; service credits (non-cash) with history and redemption; billing schedules, invoices, receipts; SSLCOMMERZ abstraction with IPN and server validation; four COD models, rider collection, remittance, verification, discrepancy; supplier and rider earnings with recognition events; payout requests with maker-checker; refunds/disputes/chargebacks/adjustments; double-entry ledger and period close; reconciliation (gateway, COD); finance reporting/export; Admin Web desktop operations; Accounts Web (whole application); Partner App with two workspaces; time-zone/cutoff handling; monorepo/shared packages; React-to-Flutter migration; 25 scenarios and workflows A–J; policy register BR-006…BR-026.

## 4. Incorrect or contradictory business rules / statements

See [conflict register](CONFLICT_REGISTER.md) for the full list with resolutions. Headline contradictions: (C-1) one app vs four apps; (C-2) manual payment references vs SSLCOMMERZ + COD; (C-3) "no application exists" vs real `app/`, `backend/`, `firebase/`; (C-4) registry claim that the 94-screen inventory is "not the same inventory"; (C-5) F129 IDs colliding with legacy IDs; (C-6) admin owns treasury/payout approval in prototype (A-12/A-13) vs Accounts owns settlement; (C-7) prototype "recorded ≠ bank transfer" notes vs earnings shown as sample; (C-8) gateway "later release" vs "future integration prepared now".

## 5. Outdated architecture decisions

ADR-001 one-app Firebase-only; ADR-003 manual references; TECH_STACK relational DB as footnote; SECURITY threat model saying "no payment webhook, CSRF not applicable"; INTEGRATION_DESIGN with FCM only; DATABASE_DESIGN with no financial store; PRODUCT_DELIVERY_PLAN/TECHNICAL_EXECUTION_PLAN with one Flutter app and `ChangeNotifier`/Node as single backend; PDF plan sized to 129 families. Replace through ADR-004…ADR-014, preserving the history in the superseded ADRs.

## 6. Missing modules and dashboards

Accounts Web (financial overview, customer payments, COD dashboard, deposit verification, supplier/rider payable ledgers, payout request review and batch execution, credit liability, refund/chargeback, GL explorer, period close, reconciliation exceptions, reports, role permissions, adjustment approval, gateway statement); Admin desktop command centre, policy configuration, verification queue, incident dispatcher; Partner finance (earnings detail, payout request/history, COD collection/remittance/discrepancy); customer financial surfaces (credit ledger, redemption, refund tracker, weekly/monthly billing).

## 7. Missing screens, interactions and navigation destinations

55 proposed screens (NC 19, NS 7, NR 6, NA 6, NF 17). Dead ends recorded as gaps: P-02 kitchen cards; C-06 kitchen detail UI-only; C-11 loses `meal`/`plan` params; C-12 and C-20/C-21 static; C-15, C-02/C-03, C-19, C-24, S-05, S-12, A-16 saves are toasts; AU-11 admin shortcut to A-07; SH-08 approval chip static; R-07 filter does nothing; S-07/S-08/S-09/R-08 static; deep links absent. Each gets a destination or migration action in the [complete screen inventory](../design/COMPLETE_SCREEN_INVENTORY.md).

## 8. Incomplete database entities and relationships

Existing candidate entities (principals, users, addresses, suppliers, foods, plans, menus, subscriptions, mealPauses, orders, deliveryDetails, deliveryAssignments, orderEvents, bills, billLines, paymentReferences, paymentAllocations, reviews, complaints, requestReceipts, auditEvents, notifications, devices, projections) lack: ledger accounts/journals/periods, credits, quotes/price snapshots, payment intents/attempts/gateway events, COD collections/remittances, earnings, holds, payout requests/approvals/batches/results, refunds/disputes/adjustments, kitchens/zones/capacity/reservations, subscription versions/schedules/obligations, riders/vehicles/staff/role grants, outbox, policy versions. Defined in [entity relationships](../database/ENTITY_RELATIONSHIPS.md) and [financial data model](../database/FINANCIAL_DATA_MODEL.md).

## 9. Missing payment, credit, accounting and settlement workflows

Workflows A–J and scenarios SC-01…SC-25 have no existing counterpart; only the manual `submitPaymentReference` / `verifyPayment` (policy-gated, returning `failed-precondition` in code) exists as OBSERVED.

## 10. Duplicate, obsolete or unnecessary documentation

`docs/` vs FINAL twins (kept as the untouched original; FINAL is the rewritten target); `SCREEN_INVENTORY` + `SCREEN_AND_CONTROL_INVENTORY` overlap (merged into the complete inventory + reconciliation, originals kept as history); `SECURITY_REVIEW` / `SECURITY_REVIEW_PLANNING` / `FIREBASE_SECURITY_REVIEW_COPY` (three views of one review; consolidated pointer in security folder); `PRODUCT_DELIVERY_PLAN` / `TECHNICAL_EXECUTION_PLAN` / `IMPLEMENTATION_PLAN` overlap (responsibilities separated); setup `INSTALLED_SKILL_PATHS_2026-10-30.txt` is non-Markdown (ignored).

## 11. Features shown visually (prototype/screenshots) but not documented

Guest browsing and protect-sheet resume; QuickActions "More" sheets; role-coloured Prototype Hub and device frame as design tool; admin dossier checklist gate and reason sheets; StepForm engine (conditional fields, draft, fix mode); email history with retry; notification settings (essential vs optional); verification report (X-02) with nine checks; design gallery (X-01); SOS; assignment offer; kitchen flow stages. The 129-family inventory and 153 controls covered the screenshots but not these prototype behaviours. All are captured in the [prototype digest](SOURCE_LEGACY_PROTOTYPE_DIGEST.md) and carried into the screen contracts.

## 12. Features documented but absent from the visible frontend

GPS live tracking (prototype is an animated sample); biometric unlock (simulated); bKash/Nagad integration (manual reference only, code policy-gated); payment verification dashboard; refund execution; real notifications; document upload; reviews persistence; multi-kitchen support (later scope in old docs). Marked OBSERVED-absent and carried with explicit status.

## 13. UI-only prototype actions needing backend

Auth (all), OTP, Google, biometric, admin 2FA; catalogue; cart/orders/payments; subscriptions pause/modify/change/cancel; addresses and preferences; tracking; supplier order/stock/menu ops; earnings/payout history; rider offer/pickup/proof/SOS; applications and uploads; admin review decisions and audit insert; users; disputes/tickets; notifications and preferences; email log; profile and re-verification; admin settings (zones, windows, plans, roles, escrow); reports; QA report persistence. Mapped to commands in [API specification](../api/API_SPECIFICATION.md).

## 14. Unresolved business decisions that could affect financial accuracy

BR-001…BR-005 (existing) and BR-006…BR-026 ([policy register](../requirements/POLICY_DECISION_REGISTER.md)). Highest financial risk: BR-006 credit formula, BR-009 commission, BR-010 earning recognition, BR-012/013 COD rules, BR-014 payout thresholds/holds, BR-018 tax, BR-020 approval limits, BR-025 legal status of credits.

## 15. Limitations of this analysis

- The two primary sources are not files in the workspace; their content is preserved in digests written from the supplied text.
- The React prototype code and the supplied screenshots are not in the workspace; prototype behaviour is OBSERVED only as reported in the supplied documentation.
- No code was executed, no test was run, no internet research was performed by the analysis step; official-source verification (Flutter, Firebase, Postgres, SSLCOMMERZ) is scheduled in the references file and must be done before implementation.
