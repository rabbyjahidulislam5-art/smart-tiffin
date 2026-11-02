# Commands: identity, catalogue and onboarding

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Backend and API architect |
| Purpose | Full command contracts for identity, profile, applications, catalogue, kitchens, capacity, stock, reviews and complaints — file code **ID** in [API_SPECIFICATION.md](API_SPECIFICATION.md) §12. |
| Status | See the status column; OBS-W/OBS-G commands are OBSERVED in `backend/functions/src/commands.js`, PROP commands are PROPOSED. |

Format per command: **Purpose · Callers · Request · Response · Errors · Idempotency/transaction · Events · Screens · Refs.**

## `saveProfile` (OBS-W)
Purpose: create or update the caller's own profile; bootstraps `principals/{uid}` on first call. Callers: any authenticated principal, including pending. Request: `{name, email?, phone?, preferredLocale}`. Response: `{id, status: "saved"|"pending", data:{version}}`. Errors: `invalid-argument` (bad field/length), `unauthenticated`. Idempotency: FS-TX, receipt by `(uid, requestId)`. Events: none. Screens: AU-07, AU-08, SH-08, C-23. Refs: FR-001, FR-002.

## `saveAddress` (OBS-W)
Purpose: create/update an owned address. Callers: active principal. Request: `{id, recipientName, addressText, contactPhone, label?}`. Response: `{id, status:"saved", data:{version}}`. Errors: `invalid-argument`, `permission-denied` (foreign address), `aborted` (stale `expectedVersion`). Idempotency: FS-TX. Events: none (zone validation is PROPOSED, see §13 row 7). Screens: C-02, C-03. Refs: FR-002, FR-043.

## `savePreferences` (OBS-W)
Purpose: language, theme, notification category preferences. Callers: active principal. Request: `{locale?, theme?, notificationCategories{}}`. Response: standard saved shape. Errors: `invalid-argument`. Idempotency: FS-TX. Screens: SH-05, SH-09. Refs: FR-025, FR-049.

## `saveDevice` (OBS-W)
Purpose: register/update a push token. Callers: active principal. Request: `{id, token, platform}`. Response: saved shape. Errors: `invalid-argument`. Idempotency: FS-TX; token never returned to another principal; deleted on sign-out. Screens: internal (no dedicated screen). Refs: FR-025.

## `saveApplication` (OBS-G, DEC-009)
Purpose: create/update a draft or submitted supplier/rider application. Callers: pending principal applying as Sup/Rdr. Request: per-step fields from KITCHEN_STEPS/RIDER_STEPS (see [design/screens/PARTNER_APPLICATION_SCREENS.md](../design/screens/PARTNER_APPLICATION_SCREENS.md)). Response: `{id, status:"pending", data:{version}}` today; full accept once DEC-009 is approved. Errors: `failed-precondition` (policy gate) today. Idempotency: FS-TX. Screens: AU-09, AU-10, AU-11. Refs: FR-021, FR-045.

## `saveEvidence` (OBS-G, DEC-009/BR-003)
Purpose: attach a document/evidence reference to an application or a manual payment claim. Callers: applicant, Sup, Rdr; Cust for BR-003 manual evidence. Request: `{evidenceRef, kind, subjectId}`. Response: gated today. Idempotency: FS-TX + Storage upload separately. Screens: AU-09 documents step, C-08 manual-reference upload. Refs: FR-045, FR-013; BR-003.

## `submitReview` (OBS-G, DEC-013)
Purpose: rate a delivered order/meal. Callers: Cust. Request: `{orderId, rating, comment?}`. Errors: gated pending DEC-013 (eligibility, scale, moderation). Screens: C-19. Refs: FR-011.

## `submitComplaint` (OBS-W)
Purpose: file a complaint/support ticket. Callers: any active principal. Request: `{category, description, relatedOrderId?}`. Response: `{id, status:"untriaged", data:{version}}`. Idempotency: FS-TX. Screens: C-25, SH-06. Refs: FR-023. Note: triage/resolution has no dedicated command yet (§12.3 gap; `resolveComplaint` recommended).

## `requestData` (OBS-G, DEC-010)
Purpose: self-service data export/deletion request. Callers: any active principal. Errors: gated pending DEC-010 retention policy. Screens: SH-12, SH-13. Refs: FR-002; DEC-010.

## `searchKitchens` (PROP, Read)
Purpose: public kitchen discovery. Callers: Guest and all roles. Request (query, not a command envelope): `{text?, cuisine?, zone?, availableOnly?, cursor?, limit?}`. Response: paginated list of public `ent.Kitchen` projections. Errors: none (read). Screens: P-02, NC-01. Refs: FR-026.

## `saveKitchenProfile` (PROP)
Purpose: create/update a kitchen's public profile. Callers: Sup (approved). Request: `{name, serviceZones[], operatingHours, deliverySlots[], photos[]}`. Errors: `permission-denied` if the kitchen is not owned by the caller. Idempotency: FS-TX. Screens: S-10, NC-02. Refs: FR-026, FR-027.

## `saveFood` (OBS-W)
Purpose: create/update a meal's base record (name, description, availability flag) — **carries no price** (observed gap, see §13 row 6). Callers: Sup (approved). Request: `{id, name, nameBn?, description?, available}`. Response: saved shape, `published:false` always (observed). Idempotency: FS-TX, full replace on update (no merge). Screens: S-04, S-05. Refs: FR-014, FR-027.

## `savePlan` (OBS-W)
Purpose: create/update a kitchen's plan template (daily/weekly/monthly/custom-eligible). Callers: Sup (approved). Request: `{id, name, planType, mealRefs[]}`. Idempotency: FS-TX, full replace. Screens: S-04. Refs: FR-014, FR-029.

## `saveMenu` (OBS-W)
Purpose: publish a kitchen's menu for a date/slot. Callers: Sup (approved). Request: `{id, serviceDate, mealSlot (observed free text ≤40 chars; migrate to `slot.*`), foodRefs[]}`. Idempotency: FS-TX, full replace. Screens: S-04. Refs: FR-005, FR-014.

## `setAvailability` (OBS-W)
Purpose: toggle a meal's availability flag. Callers: Sup (approved). Request: `{foodId, available}`. Idempotency: FS-TX, **merge** update (observed exception to full-replace). Screens: S-04 StockList. Refs: FR-015.

## `saveMealVariant` (PROP)
Purpose: define a priced, allergen-tagged variant of a meal — carries the price/portion/allergen fields `saveFood` lacks. Callers: Sup (approved). Request: `{id, foodId, variantName, portionSize, allergenTags[]}`. Idempotency: FS-TX. Screens: S-05, NS-06. Refs: FR-027.

## `schedulePriceChange` (PROP)
Purpose: create a new `ent.PriceVersion` with a future effective date, never altering an already-issued quote. Callers: Sup (approved). Request: `{mealOrVariantId, priceMinor, effectiveFrom}`. Errors: `invalid_input` (negative/non-integer amount). Idempotency: FS-TX. Screens: NS-06. Refs: FR-027, FR-030.

## `setSlotAvailability` (PROP)
Purpose: set per-slot availability for a kitchen/date (also folds in the legacy "kitchen online/offline" toggle, §12.3 gap). Callers: Sup (approved). Request: `{kitchenId, serviceDate, slot, capacity}`. Idempotency: FS-TX. Screens: S-01 online toggle, NS-05. Refs: FR-027, FR-046.

## `saveCapacity` (PROP)
Purpose: set daily production/slot limits. Callers: Sup (approved). Request: `{kitchenId, serviceDate, slot, maxPortions}`. Idempotency: FS-TX. Screens: NS-05. Refs: FR-046.

## `reserveStock` (PROP, Internal)
Purpose: atomically decrement available capacity with an expiry. Callers: internal only, invoked inside `confirmQuote`/`replaceMeal`. Request: `{mealOrVariantId, quantity, ttlSeconds}`. Errors: `failed-precondition` `stock_unavailable`. Idempotency: FS-TX, unique reservation id. Refs: FR-046.

## `releaseStock` (PROP, Internal + Scheduled)
Purpose: release an expired or cancelled reservation. Callers: internal, and the scheduled expiry job. Idempotency: FS-TX, safe to call twice. Refs: FR-046.

## Legacy aliases in this file's domain

None directly; `approveSupplier` and `changeRole` (identity-adjacent governance) are documented in [COMMANDS_LEDGER_AND_GOVERNANCE.md](COMMANDS_LEDGER_AND_GOVERNANCE.md).
