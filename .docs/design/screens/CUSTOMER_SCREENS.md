# Customer App: legacy screens C-01 to C-25

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Purpose | Full contracts for the 25 legacy customer screens, each OBSERVED in the prototype and now specified for real backend integration. |
| Applies to | CUS |
| Depends on | [Conventions](../../analysis/CONVENTIONS_AND_ID_REGISTER.md), [legacy prototype digest §7](../../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md), [customer-app/*](../../customer-app/), [api/COMMANDS_ORDERS_AND_SUBSCRIPTIONS.md](../../api/COMMANDS_ORDERS_AND_SUBSCRIPTIONS.md), [api/COMMANDS_PAYMENTS_AND_COD.md](../../api/COMMANDS_PAYMENTS_AND_COD.md) |
| Sibling files | [Public/auth screens](CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md), [new screens NC-01…19](CUSTOMER_NEW_SCREENS.md), [shared screens](SHARED_SCREENS.md) |
| Status | Each screen's prototype status (I/U/S) is OBSERVED and carried verbatim; the backend contract and migration action are PROPOSED. |

## Shared rules (apply to every contract below)

Command envelope, idempotency, quote pattern and state-rendering rules are identical to [CUSTOMER_NEW_SCREENS.md §3](CUSTOMER_NEW_SCREENS.md). Every screen inherits loading/empty/error/offline/denied/session-expired/success states; only screen-specific deviations are called out. Migration actions: **Reuse** (design kept, backend added), **Extend** (new capability added), **Replace** (redesigned/moved).

## Contracts

| ID | Name · migration | Purpose and users | Elements → destination/command | Backend / entities | Business rules and failure handling | Tests (planned) |
|---|---|---|---|---|---|---|
| C-01 | Customer home · Extend | Home hub: active plan, delivery tracking, quick actions | Bell→SH-01; Avatar→C-23; hero plan→C-10; Pause/Resume→`pauseSlots`/`resumeSubscription`; Calendar→NC-06; special menu→C-04/C-05 | `ent.Subscription` (own read), `ent.MealObligation` | `paused` badge reflects real server state, not local toggle | SCT per UC-029/031 |
| C-02 | Saved addresses · Extend | Manage delivery addresses | List→edit; Add→C-03; Delete→confirm | `ent.Address` via `saveAddress` (delete variant) | Zone validation added (fixes legacy gap, SC-19) | AC-saveAddress |
| C-03 | Add address · Extend | Create an address | Form→`saveAddress`; segmented type now functional (fixes legacy no-op) | `ent.Address` | Server-side zone check before save | SCT-19 |
| C-04 | Full menu · Reuse | Browse all meals with filters | Search/category chips; card→C-05 | `searchKitchens`-adjacent meal read model | None hard-coded; filters query live catalogue | — |
| C-05 | Meal detail · Extend | View one meal, add to cart | Kitchen card→C-06; qty±; Add→cart (local) then `confirmQuote` | `ent.Meal`, `ent.MealVariant`, `ent.PriceVersion` | One-kitchen-per-cart enforced unless BR-021 approves otherwise | SC-22 |
| C-06 | Kitchen detail · Extend | Kitchen profile and its menu (fixes legacy UI-only gap) | Verified badge (real); meal list→C-05 | `ent.Kitchen` | Every kitchen card now opens this working destination | SCT per conflict register C-11 |
| C-07 | Cart · Reuse | Review selected items before checkout | ±, Checkout→C-08 | Local draft until `createQuote` | Empty state→Browse (C-04) | — |
| C-08 | Checkout · Extend | Choose address/slot/payment, confirm quote | Address→C-02; payment method (COD or sandbox online); Place Order→`confirmQuote`→`placeOneTimeOrder`/`initiatePayment` | `ent.Quote`, `ent.Order`, `ent.PaymentIntent` | Server quote is authoritative (NFR-017); legacy "outcome simulator" removed, replaced by real gateway/COD flow | SC-13, SC-20 |
| C-09 | Payment result · Extend | Show the outcome of a payment | success→C-17; failed→retry; unknown→C-16/SH-04 | `ent.PaymentIntent` read | Never shown as success before server verification (fixes legacy simulator) | SC-13 |
| C-10 | Subscriptions (tab) · Extend | List every active agreement independently | Pause→`pauseSlots`; Calendar→NC-06; Change plan→C-11; Cancel→`cancelSubscription` | `ent.Subscription` (list, not a single hard-coded plan) | Fixes legacy single-`monthly-ld`-default gap (conflict register C-09) | UC-029 |
| C-11 | Plan picker · Extend | Choose a template or start custom | →C-12 or NC-04 | `ent.Plan` read | Carries `meal`/`plan` params from guest flow (fixes legacy param-loss gap) | — |
| C-12 | Plan review · Extend (quote-review mode of NC-08) | Review and confirm a plan quote | Start date; Address→C-02; Pay→`confirmQuote` | `ent.Quote` | Every line itemised (fee, discount, tax, credit) | SCT-30 |
| C-13 | Meal calendar · Extend (hosts NC-06) | Calendar of obligations | Day sheet→pause/skip | `ent.MealObligation` | Real server cutoff per obligation, not a static 30-day grid | SCT per BR-022 |
| C-14 | Pause meals · Extend | Pause selected dates/slots | Confirm→`pauseSlots` | `ent.MealObligation` | Cutoff enforced server-side | SC-04-adjacent |
| C-15 | Modify today's meals · Extend | Change today's obligation where permitted | Save→`replaceMeal`/`quoteScheduleChange` | `ent.MealObligation` | Persisted (fixes legacy "not saved" gap); dispatched meals blocked | SC-05 |
| C-16 | Orders (tab) · Reuse | Active/Upcoming/Past orders | Card→C-17; Rate→C-19 | `ent.Order` | — | — |
| C-17 | Order detail · Extend | Timeline and actions for one order | Track→C-18; Invoice→C-21; Rate→C-19; Report→SH-06 | `ent.Order`, `ent.DeliveryEvent` | Timeline from real state, not an ID-based guess | — |
| C-18 | Live tracking · Extend | Live map for an active delivery | Recenter; Call/Chat | `ent.RiderLocation` (consent-scoped) | Explicitly distinguished from a simulated animation (fixes legacy gap); GPS-lost honest state | SC-21-adjacent |
| C-19 | Rate meal · Reuse | Submit a rating | Stars+comment→`submitReview` | `ent.Review` (DEC-013 gated) | — | — |
| C-20 | Billing · Extend (hosts NC-12/13) | Billing schedule and payment history | Pay now→payment flow; Invoices→C-21 | `ent.Invoice` | Accounts for COD obligations and credits, not just online payments | — |
| C-21 | Invoice · Extend | One invoice/receipt | Download | `ent.Invoice`, `ent.Receipt` | PDF only when a receipt actually exists (fixes legacy always-available download) | — |
| C-22 | Payment methods · Extend | Manage payment methods | Add→gateway-specific flow | n/a (gateway-managed) | Methods shown reflect the actually configured merchant account, not static chips | — |
| C-23 | Customer profile (tab) · Reuse | Profile hub | Edit→SH-08; rows→C-02/C-24/C-20/C-22; Apply as Cook/Rider→AU-09/10 | `ent.User` | — | — |
| C-24 | Food preferences · Extend (hosts NC-18) | Dietary preferences + favourite kitchens | Multi-select→Save | `ent.User.preferences`, favourites list | Persisted (fixes legacy "not saved" gap) | — |
| C-25 | Complaints · Reuse | List and file complaints | New→SH-06 | `ent.Complaint` | — | — |

## F129 reconciliation

Every F129 planning-inventory family touching Customer screens is mapped in [design/INVENTORY_RECONCILIATION.md](../INVENTORY_RECONCILIATION.md); no family is left unmapped. This file's 25 legacy IDs are additionally cross-referenced to the master prompt's per-screen instruction table (digest §3.2).
