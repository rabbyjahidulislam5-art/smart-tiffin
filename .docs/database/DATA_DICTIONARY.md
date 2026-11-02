# Candidate data dictionary

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (the original Firestore entities below are preserved unchanged; §2026-10-30 extension adds the new Firestore entities; PostgreSQL financial entities are in [FINANCIAL_DATA_MODEL.md](FINANCIAL_DATA_MODEL.md)) |
| Owner | Architecture lead |
| Status | Not finalized. Resolve [BR-001…026](../requirements/BUSINESS_RULES.md) before freezing schemas. |

Status: **not finalized**, 2026-10-28, extended 2026-10-30. Names/types below are candidate logical contracts for requirements review. None are implemented. Resolve [BR-001–026](../requirements/BUSINESS_RULES.md) before freezing schemas. `required` denotes a candidate validation need, not an approved migration. `?` means optional/absent; absent values must not be silently interpreted as zero, paid or approved.

## Common types

| Type / field | Candidate representation and validation |
|---|---|
| `id`, `*Id`, `uid` | Opaque nonempty identifier; referenced object verified at trusted boundary |
| `createdAt`, `updatedAt` | Required server timestamp; client time cannot decide deadlines |
| `schemaVersion` | Required integer version for supported decoding; reject unsupported writes |
| `version` | Required integer for mutable operational records; compare atomically |
| `serviceDate` | Valid date-only `YYYY-MM-DD`; timezone resolved under DEC-008 |
| `*Minor` | Integer monetary amount in explicit `currency`; sign/range depends on approved amount versus adjustment semantics |
| `name`, `description` | Unicode strings; required name nonblank; length limits reviewed for Bangla and English |
| `policyVersion` | Immutable identifier of approved rules used for a commitment |

## Identity and catalogue

| Candidate path | Core fields | Access/default/validation |
|---|---|---|
| `principals/{uid}` | `role`, `active`, `authorizationVersion`, timestamps | Server-owned; one of four known roles; elevated roles never self-assigned; bootstrap and signup defaults DEC-009 |
| `users/{uid}` | `name`, `email?`, `phone?`, `preferredLocale`, timestamps | Owner private; `en`/`bn`; provider identity fields reconciled through Auth rather than silently edited |
| `users/{uid}/addresses/{id}` | `recipientName`, `addressText`, `contactPhone`, `label?` | Owner private; no GPS coordinates required; exact required address components decided before delivery UI |
| `suppliers/{uid}` | `displayName`, `approvalStatus`, `published`, timestamps | Public-safe projection only; approval state server-owned; no public private-profile mirror |
| `foods/{id}` | `supplierId`, `name`, `description?`, `priceMinor`, `currency`, `available`, `published`, `version` | Approved supplier owns edits; amounts validated; defaults cannot auto-publish |
| `plans/{id}` | `supplierId`, `name`, `planType`, `offerVersion`, `published`, proposed pricing/schedule specification | `daily`, `weekly`, `monthly`; price/schedule structures depend on BR-002 |
| `menus/{id}` | `supplierId`, `serviceDate`, `mealSlot`, food/plan references, `published`, `version` | Unique supplier/date/slot policy reviewed; referenced items must belong to supplier |

## Meal lifecycle

| Candidate path | Core fields | Access/default/validation |
|---|---|---|
| `subscriptions/{id}` | `customerId`, `supplierId`, `planId`, offer snapshot, `startDate`, `endDate`, `policyVersion`, `status`, `version` | Customer owns read; supplier limited operational read; chronology and eligibility server-validated; lifecycle values pending policy |
| `mealPauses/{id}` | `subscriptionId`, `customerId`, requested service dates/slots, `decision`, `decisionAt?`, policy snapshot | No accepted default; BR-001 defines eligibility/cutoff/effect; duplicate date/slot prevented |
| `orders/{id}` | `customerId`, `supplierId`, `subscriptionId?`, `serviceDate`, `mealSlot`, item snapshots, `totalMinor`, `currency`, `preparationStatus`, `deliveryStatus`, `version` | Server creates authoritative totals; no address or raw payment reference; confirmed delivery enum below |
| `deliveryDetails/{orderId}` | destination snapshot, contact snapshot, `capturedAt` | Customer/admin or trusted service only; courier receives scoped assignment projection |
| `deliveryAssignments/{id}` | `orderId`, `courierId`, delivery destination/contact projection, scheduled window, `active`, `assignmentVersion` | Current courier only; assignment actor/window semantics pending BR-004; revoke stale projection on reassignment |
| `orderEvents/{id}` | `orderId`, `actorId`, event type, previous/new state, `occurredAt`, `requestId` | Immutable audit-facing history; redact unnecessary PII; exceptions separate from successful delivery enum |

The source-confirmed delivery values are `pending`, `picked_up`, `on_the_way`, `delivered`. Display labels are Pending, Picked Up, On The Way, Delivered. Preparation transitions and failed-delivery handling remain DEC-014. An order's payment summary, if introduced, is server-derived and must not become a second independently editable financial truth.

## Financial and feedback records

| Candidate path | Core fields | Access/default/validation |
|---|---|---|
| `bills/{id}` | `customerId`, period, `currency`, totals, `policyVersion`, issue/version fields | Monthly viewing confirmed; exact totals/state fields depend on BR-002; customer read, server write |
| `billLines/{id}` | `billId`, `orderId?`, `subscriptionId?`, `supplierId`, description snapshot, signed amount and adjustment provenance | Immutable issued facts; granularity/formula pending BR-002/005 |
| `paymentReferences/{id}` | `customerId`, `billId`, `provider`, `reference`, claimed amount/currency, submission/verification audit | `bkash` or `nagad`; raw reference private; proposed submission has no verified effect; verifier/evidence/state details BR-003 |
| `paymentAllocations/{id}` | `paymentReferenceId`, `billId`, amount/currency, `allocatedAt`, actor/request provenance | Trusted-only creation after verification; sum cannot exceed verified available funds; partial allocation policy undecided |
| `reviews/{id}` | `orderId`, `customerId`, `supplierId`, rating, `comment?`, moderation/version fields | Rating scale, public identity exposure, edit rules and one-per-order policy DEC-013 |
| `complaints/{id}` | `customerId` or reporting user, related `orderId?`, category, description, handling state, resolution audit | Private to reporter/authorized handlers; actor eligibility, categories and closure rules DEC-013 |

## Supporting records

| Candidate path | Core fields | Constraint |
|---|---|---|
| `requestReceipts/{id}` | actor, operation, payload fingerprint, committed result reference, timestamps | Server-only; scoped idempotency; no raw secret payload |
| `auditEvents/{id}` | actor, action, target, timestamp, reason code, correlation ID | Append-only from trusted service; redacted; retention DEC-010 |
| `notifications/{id}` | recipient, event ID/type, target reference, created/read timestamps | Own read; content redacted; creation server-owned; schedule/recipient policy DEC-015 |
| `users/{uid}/devices/{id}` | private FCM token, platform, update time | Token rotation/sign-out lifecycle; never public or logged |
| Derived report projections | period/date, scope owner, metric-definition version, values, generatedAt | Rebuildable from facts; never a source for altering bill/payment state |

No optional field receives an invented operational default. Exact limits, enum expansion, duplicate normalization, derived projections and subcollection choices are decisions to validate during implementation design, after the business policies are approved.

## 2026-10-30 extension — new Firestore entities (operational, non-financial)

| Candidate path | Core fields | Access/default/validation |
|---|---|---|
| `kitchens/{id}` | `supplierId`, `name`, `verificationStatus`, `serviceZones[]`, `operatingHours`, `deliverySlots[]`, `rating?` | Approved supplier owns edits; `ent.Kitchen` |
| `serviceZones/{id}` | `name`, `boundary`, `active` | Admin-managed; `ent.ServiceZone` |
| `mealVariants/{id}` | `foodId`, `variantName`, `portionSize`, `allergenTags[]` | Supplier owns; `ent.MealVariant` |
| `priceVersions/{id}` | `mealOrVariantId`, `priceMinor`, `currency`, `effectiveFrom`, `authorId` | Immutable once effective; never retroactively alters an existing `ent.Quote`; `ent.PriceVersion` |
| `slotAvailability/{id}` | `kitchenId`, `slot`, `serviceDate`, `capacity`, `reserved` | Server-maintained; `ent.SlotAvailability` |
| `stockReservations/{id}` | `mealOrVariantId`, `quantity`, `expiresAt`, `orderOrQuoteId` | Atomic decrement/release; `ent.StockReservation` |
| `subscriptionVersions/{id}` | `subscriptionId`, `versionNumber`, `scheduleSnapshot`, `createdAt`, `createdBy` | Immutable version history; `ent.SubscriptionVersion` |
| `subscriptionSchedules/{id}` | `subscriptionId`, `recurrenceRule`, `exceptions[]`, `startDate`, `endDate?` | `ent.SubscriptionSchedule` |
| `mealObligations/{id}` | `subscriptionId`, `serviceDate`, `slot`, `mealOrVariantId`, `quantity`, `priceSnapshotId`, `state` | One per dated meal; state per [glossary](../requirements/GLOSSARY_AND_TERMINOLOGY.md) §4; `ent.MealObligation` |
| `substitutions/{id}` | `mealObligationId`, `originalMealId`, `replacementMealId`, `priceDifferenceMinor?`, `decidedAt` | `ent.Substitution` |
| `riders/{uid}` | `vehicleType`, `approvalStatus`, `serviceZones[]`, `onDuty` | `ent.Rider` |
| `vehicles/{id}` | `riderId`, `type`, `registrationNumber?`, `documents[]` | Motorcycle-only fields conditional, per the legacy StepForm rules; `ent.Vehicle` |
| `staffAccounts/{uid}` | `app` (ADM/ACC), `invitedBy`, `status` | Invited only; never self-registered; `ent.StaffAccount` |
| `roleGrants/{id}` | `uid`, `role`, `subRole?`, `grantedBy`, `grantedAt`, `revokedAt?` | Audited; supports multiple grants per BR-023; `ent.RoleGrant` |
| `applications/{id}` | `applicantUid`, `kind` (supplier/rider), `steps{}`, `status`, `reviewerUid?`, `reason?` | `ent.Application` |
| `applicationDocuments/{id}` | `applicationId`, `docType`, `storageRef`, `uploadedAt` | Access-restricted; retention per DEC-010; `ent.ApplicationDocument` |
| `deliveryProofs/{id}` | `assignmentId`, `method` (otp/photo), `capturedAt`, `evidenceRef?` | `ent.DeliveryProof` |
| `riderLocations/{riderId}` | `lat`, `lng`, `updatedAt` | Short retention; visible only to the current assignment's customer; `ent.RiderLocation` |
| `policyVersions/{id}` | `rule` (e.g. `BR-022`), `parameters{}`, `effectiveFrom`, `publishedBy` | `ent.PolicyVersion`; holds every BR-001…026 parameter once approved |
| `outboxEvents/{id}` | `eventType`, `payload`, `createdAt`, `processedAt?` | Server-only; `ent.OutboxEvent` |

See [FINANCIAL_DATA_MODEL.md](FINANCIAL_DATA_MODEL.md) for the PostgreSQL-owned entities: `ent.PaymentIntent`, `ent.PaymentAttempt`, `ent.GatewayEvent`, `ent.GatewayVerification`, `ent.CodCollection`, `ent.CodRemittance`, `ent.CreditAccount`, `ent.CreditTransaction`, `ent.SupplierEarning`, `ent.RiderEarning`, `ent.Hold`, `ent.PayoutRequest`, `ent.PayoutApproval`, `ent.SettlementBatch`, `ent.PayoutResult`, `ent.PayoutDestination`, `ent.LedgerAccount`, `ent.JournalEntry`, `ent.JournalLine`, `ent.AccountingPeriod`, `ent.ReconciliationItem`, `ent.ReconciliationException`, `ent.Refund`, `ent.Dispute`, `ent.Adjustment`, `ent.Quote`.
