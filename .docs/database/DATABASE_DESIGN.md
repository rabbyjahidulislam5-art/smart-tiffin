# Candidate database design

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (extends 1.0; the original Firestore entities below are preserved unchanged) |
| Owner | Architecture lead |
| Purpose | Describe the operational (Firestore) data design and its boundary with the financial (PostgreSQL) design in [FINANCIAL_DATA_MODEL.md](FINANCIAL_DATA_MODEL.md). |
| Depends on | [ADR-005](../adr/005-hybrid-datastore.md), [data dictionary](DATA_DICTIONARY.md), [entity relationships](ENTITY_RELATIONSHIPS.md) |
| Status | Conceptual requirements design, not an approved or implemented schema. BR-001 through BR-026 remain Pending Decision. No collections, rules, indexes, migrations or seed data have been deployed. |

**Status: conceptual requirements design, not an approved or implemented schema.** BR-001 through BR-026 remain Pending Decision (original BR-001…005 in [business rules](../requirements/BUSINESS_RULES.md); extended BR-006…026 in [policy decision register](../requirements/POLICY_DECISION_REGISTER.md)). No collections, rules, indexes, migrations or seed data have been deployed.

## 2026-10-30 extension: two stores, one domain model

The entities below (`principals`, `users`, `suppliers`, `foods`, `plans`, `menus`, `subscriptions`, `mealPauses`, `orders`, `deliveryDetails`, `deliveryAssignments`, `orderEvents`, `reviews`, `complaints`, `requestReceipts`, `auditEvents`, `notifications`, `devices`) remain in **Cloud Firestore** and are **extended**, not replaced, for the four-application scope (kitchens/zones/capacity, rider/vehicle records, staff accounts, applications/documents, subscription versions/schedules/obligations, substitutions — see [data dictionary §2026-10-30 extension](DATA_DICTIONARY.md)). The financial domain introduced on 2026-10-30 — the ledger, payments, COD, credits, earnings and payouts — moves to a **PROPOSED managed PostgreSQL** store under [ADR-005](../adr/005-hybrid-datastore.md); its entities, posting rules and invariants are defined in full in [FINANCIAL_DATA_MODEL.md](FINANCIAL_DATA_MODEL.md), not here, to keep store ownership unambiguous (conventions §8). `bills`, `billLines`, `paymentReferences` and `paymentAllocations` below are retained as the manual-reference evidentiary path (BR-003) alongside, not instead of, the new PostgreSQL payment entities.

## Storage and ownership

Cloud Firestore follows the source preference for operational data. Firebase Authentication owns credentials and UID identity. Firestore holds application profiles and operational records; it must never store plaintext passwords, provider PINs or OTPs. Candidate names in the [data dictionary](DATA_DICTIONARY.md) provide a shared vocabulary, not generated models.

Use separate public catalogue and private operational documents. An authorized Firestore read exposes its document, so a supplier or courier must not receive a customer/payment document and rely on the UI hiding fields. Proposed courier assignment projections contain only information needed for that delivery. Public supplier data excludes private contact/account information.

## Relationships and ER model

| Relationship | Candidate cardinality | Required invariant |
|---|---|---|
| User → principal | One identity to one canonical access record | Client cannot write role/active state |
| Supplier → food / plan / menu | One supplier to many owned records | Supplier identifier immutable on ordinary update |
| Customer → subscription | One to many | Customer and plan exist; accepted offer snapshot retained |
| Subscription → pause | One to many requested dates | No duplicate accepted pause for the same service obligation |
| Customer → order | One to many | Owner immutable; price and meal selection snapshotted |
| Subscription → order | Optional origin for many dated meal obligations | Generation is idempotent by subscription/date/slot |
| Order → delivery details | One private destination snapshot | Later profile edits do not silently reroute accepted delivery |
| Order → assignment | One current assignment with retained change events | Only currently authorized courier receives current projection |
| Customer → bill → bill lines | One to many statements/lines | Issued statement facts and policy version auditable |
| Payment reference → allocations | One to zero or more allocations after verification | Same verified funds cannot be applied twice |
| Delivered order → review | Eligibility/cardinality unresolved DEC-013 | No review of a foreign or ineligible order |
| User → complaint | One to many | Only complainant and authorized handlers see private content |

See [entity diagram source](../diagrams/data-model.mmd). Firestore does not automatically enforce these relationships as SQL foreign keys; trusted validation, transactions and tested Rules must enforce the chosen invariants.

## Atomicity, uniqueness and concurrency

Use a transaction for each authoritative state change and its audit/request receipt. Candidate unique keys include actor+operation+request ID, subscription+service date+slot, and payment provider+normalized reference. Reference normalization must be verified against real provider formats before implementation; never casually change case or strip meaningful characters. Reserve uniqueness within the trusted boundary without revealing another user's record. No database-wide query-then-write uniqueness check is sufficient under concurrency.

Commands that modify existing state carry an expected version. Repeated identical requests return the same committed result; conflicting reuse is rejected. Retry-safe generation prevents duplicate subscriptions/meals/bill lines. Notification intent is recorded with commit and sent afterwards. Firestore transaction functions may repeat, so external actions cannot occur inside them. [Transaction documentation](https://firebase.google.com/docs/firestore/manage-data/transactions).

## Policy-sensitive boundaries

| Pending rule | Data implications that must be decided before schema approval |
|---|---|
| BR-001 meal pauses | Deadline/timezone, allowed dates, accepted/rejected representation, demand freeze and billing linkage |
| BR-002 billing | Statement period, line formula, rounding, fees/commission, partial payment, credits, earnings/revenue definitions |
| BR-003 manual payment verification | Who verifies, acceptable evidence, reference scope, rejection/resubmission and allocation model |
| BR-004 delivery assignment | Who assigns, reassignment timing, courier capacity, address visibility and exception recovery |
| BR-005 cancellation/refunds | Eligibility, state effects, financial adjustments, approval and refund evidence |
| BR-006…026 (extended) | Credit formula, delivery fee, discount/commission, earning recognition, COD limits/deadlines, payout thresholds, disputes, tax, approval limits, multi-kitchen, cutoff, dual-role, kitchen discontinuity, legal status of credits, COD netting — see [FINANCIAL_DATA_MODEL.md](FINANCIAL_DATA_MODEL.md) for which of these govern a PostgreSQL field |

These decisions may change field names, cardinalities and transitions. Do not finalize models, serializers, security rules or financial calculations from this document until they are resolved and traced to acceptance cases.

## Monetary, temporal and deletion conventions

Proposed DEC-008: BDT with integer minor units and Asia/Dhaka for service-date calculations. Store timestamps as server-generated instants and service dates separately as validated date-only values. No floating-point financial arithmetic. Rounding and recognition rules belong to BR-002, not a guessed serializer default. Schema versions and policy versions are distinct.

Archive catalogue entries referenced by accepted transactions instead of deleting their history. Account deletion requires the approved retention policy, de-identification and lawful handling of retained financial records; no cascading erase is assumed. [Retention](DATA_RETENTION.md), [migration strategy](MIGRATION_STRATEGY.md) and [backup/restore](../operations/BACKUP_RESTORE.md) define remaining gates.
