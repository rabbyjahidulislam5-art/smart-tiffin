# Customer App: proposed new screens NC-01 to NC-19

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Customer-experience design author (E2b); integration by the documentation lead |
| Purpose | Give each of the 19 proposed Customer App screens or subsections a complete, testable contract: identity, purpose, layout, controls, navigation, backend calls, states, validation, responsive and accessibility behaviour, business-rule handling, acceptance cases and traceability. |
| Applies to | CUS (Customer App, Flutter, Android first; guest/public shell where stated) |
| Depends on | [Conventions and ID register](../../analysis/CONVENTIONS_AND_ID_REGISTER.md), [master prompt digest](../../analysis/SOURCE_MASTER_PROMPT_DIGEST.md), [legacy prototype digest](../../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md), [glossary](../../requirements/GLOSSARY_AND_TERMINOLOGY.md), [policy register](../../requirements/POLICY_DECISION_REGISTER.md), [design system](../DESIGN_SYSTEM.md), [UI/UX guidelines](../UI_UX_GUIDELINES.md), [accessibility plan](../ACCESSIBILITY.md), [API authorisation](../../api/AUTHORIZATION.md), [API errors](../../api/ERROR_RESPONSES.md) |
| Module documents | [Customer modules](../../customer-app/CUSTOMER_MODULES.md), [kitchen and meal system](../../customer-app/KITCHEN_AND_MEAL_SYSTEM.md), [order management](../../customer-app/ORDER_MANAGEMENT.md), [custom subscription engine](../../customer-app/CUSTOM_SUBSCRIPTION_ENGINE.md), [meal scheduling](../../customer-app/MEAL_SCHEDULING.md), [customer credits](../../customer-app/CUSTOMER_CREDITS.md), [customer UI/UX](../../customer-app/CUSTOMER_UI_UX.md), [payment architecture](../../payments/PAYMENT_ARCHITECTURE.md), [SSLCOMMERZ plan](../../payments/SSLCOMMERZ_INTEGRATION_PLAN.md), [COD workflow](../../payments/COD_PAYMENT_WORKFLOW.md), [pricing and billing](../../payments/PRICING_AND_BILLING.md), [credit rules](../../payments/CUSTOMER_CREDIT_RULES.md), [API specification](../../api/API_SPECIFICATION.md), [order and subscription commands](../../api/COMMANDS_ORDERS_AND_SUBSCRIPTIONS.md), [payment and COD commands](../../api/COMMANDS_PAYMENTS_AND_COD.md) |
| Sibling screen files | [Public and auth screens](CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md), [legacy customer screens C-01 to C-25](CUSTOMER_SCREENS.md), [shared screens](SHARED_SCREENS.md) |
| Authoritative policies | BR-001, BR-002, BR-005 (detail in [business rules](../../requirements/BUSINESS_RULES.md)); BR-006, BR-007, BR-008, BR-012, BR-016, BR-017, BR-018, BR-019, BR-021, BR-022, BR-025 (in the [policy register](../../requirements/POLICY_DECISION_REGISTER.md)). **All are PENDING.** This file defines no policy value. |
| Status | Draft for review. Every screen here is **PROPOSED**; none is an observed prototype route and none is implemented, approved or tested. All BDT amounts in examples are **HYPOTHETICAL**. |

## 1. Scope and how to read this file

**What this file covers.** The 19 proposed customer screens `NC-01` to `NC-19` named in the user's master prompt (section 3.3 of the [digest](../../analysis/SOURCE_MASTER_PROMPT_DIGEST.md)). The 25 legacy customer screens `C-01` to `C-25` are specified in [CUSTOMER_SCREENS.md](CUSTOMER_SCREENS.md); the guest and authentication shell in [CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md](CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md). Where an NC item extends a legacy screen, both files agree that the legacy ID remains the route owner and this file owns the content contract of the new capability.

**Provenance tags used per contract.** USER-REQ (the master prompt names the screen, its intent, data and primary action), OBSERVED (what the React prototype shows, with its status I/U/S carried verbatim from the [prototype digest](../../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md)), PROPOSED (design decisions by this effort, not approved), PENDING (a policy decision with a register entry). Nothing is described as implemented, tested or approved. An `NC-` identifier is a **documentation identifier, not a confirmed route**.

**Contract layout.** Every contract has the 14 subsections requested by the master prompt, cited as `NC-nn.k` (for example `NC-09.12` is the business-rule section of the skip sheet): 1 Identity and ownership, 2 Purpose and users, 3 Provenance, 4 Layout and visual reference, 5 Elements and behaviour, 6 Navigation, 7 Backend services, 8 States, 9 Validation and permissions, 10 Responsive behaviour, 11 Accessibility and bilingual notes, 12 Business rules and failure handling, 13 Acceptance and tests, 14 Traceability.

**Acceptance wording.** Acceptance cases are written as design obligations (Given/When/Then outcomes). They are **planned, not executed**. A case label such as `S1` is local to its contract; it is not a global identifier. Global identifiers cited are TEST-, SCT-, INV-, SC-, AC-, FR-, BR-, DEC-.

## 2. Form decisions: screen, section, or sheet

The master prompt asks that a screen is added only when an accessible subsection of an existing screen would not be clearer. Each NC identifier is kept stable whichever form is chosen, so traceability never depends on the form.

| ID | Name | Form chosen | Host or route owner | Reasoning |
|---|---|---|---|---|
| NC-01 | Kitchen discovery search | **Full screen** (new route "Kitchens") | Entered from P-02 (Kitchens segment), C-01, C-04 | A searchable, filterable, paginated catalogue with restorable query state is a primary destination. Folding it into C-04 would mix two catalogues (meals and kitchens) under one filter model. |
| NC-02 | Kitchen profile detail | **Section** ("About" segment) | C-06 Kitchen detail (Extend) | Profile, menu and reviews are three views of one entity. A second kitchen route would create competing back stacks and two answers to "open a kitchen card". |
| NC-03 | Kitchen menu by meal slot | **Section** ("Menu" segment) | C-06 (Extend); the slot-menu component is reused by NC-04 and NC-10 | Same entity as NC-02. The component is reused in "pick" modes, so it is a component contract as well as a segment. |
| NC-04 | Custom subscription builder | **Full screen** (guided steps) | Entered from C-11, NC-02, C-01 | A long task with a persisted draft, several validations and preview; it cannot be a sheet. C-11 keeps the template plans and hands over to NC-04. |
| NC-05 | Weekly schedule editor | **Full screen** (editor route, draft mode and change mode) | Opened from NC-04 and from C-10/NC-06 for an existing subscription | Two different parents with different commands share one weekday-by-slot editor. A shared route is clearer than two copies. |
| NC-06 | Monthly schedule calendar | **Section** (body of the calendar) | C-13 Meal calendar (Extend) | C-13 is already the destination of every "Calendar" control (CU-10). A second calendar screen would split entry points. NC-06 adds slots, coverage and lifecycle to it. |
| NC-07 | Delivery price explanation | **Sheet** | Opened from NC-08, NC-14, NC-10, C-12 | Read-only, contextual, no independent flow. |
| NC-08 | Custom plan review | **Full screen**, the quote-review mode of C-12 (Extend) | C-12 Plan review | The review and consent step is one screen for template and custom plans. Two review screens would duplicate the quote and consent logic. |
| NC-09 | Meal skip request | **Sheet** (confirmation) | Opened from NC-06 meal sheet and C-14 | One decision on one server quote; context (the calendar) must stay visible behind it. |
| NC-10 | Meal replacement quotation | **Full screen** (guided steps) | Opened from NC-06 meal sheet and C-15 | It contains a meal picker, a comparison, an optional payment step and a payment-pending state; that exceeds a sheet and must survive leaving the app. |
| NC-11 | Customer service-credit ledger | **Full screen** | Entered from C-23, C-20, NC-16 | Unbounded paginated history with filters and entry detail. |
| NC-12 | Weekly subscription billing | **Section** (weekly variant of the billing view) | C-20 Billing (Extend) | Billing already lives in C-20 (CU-07 area, Billing links). A weekly and a monthly variant of one component under C-20 keeps one billing destination. |
| NC-13 | Monthly subscription billing | **Section** (monthly variant) | C-20 (Extend) | As NC-12. |
| NC-14 | One-time order checkout | **Full screen**, the one-time mode of C-08 (Extend) | C-07 Cart, C-08 Checkout | The checkout screen already exists; NC-14 defines its server-quote, COD-eligibility and payment behaviour for orders without a subscription. |
| NC-15 | Subscription change history | **Full screen** | Opened from a subscription card in C-10 | Unbounded version history with a before/after compare view; embedding it in each card would break the C-10 list. |
| NC-16 | Service credit redemption | **Sheet** | Opened from the payment summary of NC-08, NC-10, NC-13, NC-14 | A bounded choice (how much credit to apply) inside a checkout; not a destination. |
| NC-17 | Refund status tracker | **Full screen** (list and detail) | Entered from C-20, C-17, NC-15, notifications | Refunds are asynchronous and must be addressable by a notification deep link. |
| NC-18 | Kitchen preference favourites | **Section** ("Favourite kitchens" segment) | C-24 Food preferences (Extend) | Favourites and food preferences are both "what I like" settings; a heart toggle on NC-01/NC-02 cards writes to the same list. |
| NC-19 | Subscription renewal offer | **Full screen** | Entered from SH-01 notification and a C-10 banner | A consent decision with its own deep link and accept/decline semantics; reusing NC-08 would blur "confirm a new purchase" with "renew an existing agreement". |

Net effect: 10 full screens (NC-01, 04, 05, 08, 10, 11, 14, 15, 17, 19), 6 sections (NC-02, 03, 06, 12, 13, 18), 3 sheets (NC-07, 09, 16).

## 3. Conventions shared by every contract

### 3.1 Identity and visual language

CUS uses the warm orange customer identity (text and button accent `#C44B00`, decorative warmth `#FF7A18`) from the [design system](../DESIGN_SYSTEM.md). Glass is used only on headers, bottom navigation and bounded summary regions; inputs, money summaries and critical actions sit on opaque surfaces. Status is always icon plus text, never colour alone. Visual references to the prototype and to the screenshot controls (`CU-nn`, see the [control audit](../SCREENSHOT_ACTION_AUDIT.md)) are cited per contract. The prototype is a visual and behavioural reference, never evidence of production behaviour.

### 3.2 Command envelope and idempotency

All writes go through the single trusted boundary (envelope `{command, requestId, expectedVersion?, payload}`, OBSERVED in `executeCommand`; names from register section 6). Rules every contract inherits:

1. The client creates a `requestId` when a consequential intent starts (a sheet opens, a confirm screen appears) and reuses it for every retry of that intent.
2. A tapped primary button is disabled and shows progress until the server answers. A second tap never creates a second request.
3. If the answer is lost, the client looks up the receipt of the original `requestId` (state `outcome_unknown`). It never mints a new `requestId` to resolve ambiguity.
4. `expectedVersion` is sent for edits of versioned records (draft subscription, schedule, preferences). A `conflict` result shows the newer server state and asks the customer to review it.
5. Money-affecting commands also post balanced journals server-side. The client never computes, stores or edits an authoritative amount, balance, eligibility or cutoff.
6. Reads named `read` below are authorised read-model queries, not commands. Their names are not new command names.

### 3.3 Quote pattern (applies to NC-04, 08, 10, 13, 14, 19)

A quote is a server-computed, immutable snapshot (`ent.Quote`) with line items, the policy versions used, a `quoteId` and an expiry (`policy.quote.expiry`, PENDING; see ADR-009 when written). The sequence is `createQuote`, customer review, `confirmQuote` (records consent against the snapshot), then the money-affecting command that references the `quoteId`. If the selection, price version, availability or policy changed, the client receives a new quote and must show the difference before the customer can confirm again. Invariant INV-18: quote total = invoice total = payment amount = journal total. A widget never computes a displayed total.

### 3.4 State rendering rules

Section 8 of each contract lists the screen-specific text and behaviour of the seven mandatory states. The rules below apply everywhere.

- **Loading:** a skeleton with the final structure and a labelled progress region. No fabricated food, price or status.
- **Empty:** says why it is empty (new account, filter, nothing scheduled) and offers one relevant action.
- **Error:** uses the [error categories](../../api/ERROR_RESPONSES.md): `unauthenticated`, `permission_denied`, `invalid_input`, `policy_not_configured`, `business_rule_rejected`, `conflict`, `not_available`, `rate_limited`, `temporarily_unavailable`, `outcome_unknown`, `internal_error`. Messages are localised, never raw exceptions, never another user's data. `policy_not_configured` blocks the dependent action instead of guessing a value.
- **Offline (proposed DEC-012):** reads show cached data with an "as of" time; consequential writes are blocked, not queued. Unsent edits stay as a local draft marker.
- **Denied and unavailable:** the same neutral "no longer available" panel for an absent record and a record the customer may not see, so existence is never leaked.
- **Session expired or revoked:** protected content is cleared; the customer is returned to sign-in (AU-03) and the intent is restored only after authorisation.
- **Success:** shown only after server acknowledgement (or after server-side verification for payments, never from a browser redirect).

### 3.5 Size bands and accessibility baseline

Bands (legacy prototype, mirroring Flutter window size classes): **compact** under 600, **medium** 600 to 839, **expanded** 840 to 1199, **large** 1200 and above (logical pixels). The [responsive layouts](../RESPONSIVE_LAYOUTS.md) document is authoritative once written. Baseline for all contracts: touch targets at least 48 logical pixels; text scalable to 200% without losing a primary action; TalkBack reading order and live-region announcements for committed results; contrast measured on composited surfaces; reduced-motion and reduced-transparency fallbacks; Bangla shaping preserved (no grapheme-splitting truncation); slot identifiers (`slot.breakfast`, `slot.lunch`, `slot.snack`, `slot.dinner`) are never translated or derived from a label; labels, errors and spoken strings live in ARB resources; money and dates use the approved locale and the Asia/Dhaka service-date rule (DEC-008, proposed). Verification is by [accessibility plan](../ACCESSIBILITY.md) and TEST-109, TEST-116 (planned).

### 3.6 Named policy parameters used in this file

No value is defined. Each name is a configuration key whose value comes from an approved, versioned policy.

| Parameter | Meaning | Rule |
|---|---|---|
| `policy.cutoff.change` | Latest moment a skip, pause, replace or schedule change is accepted, per slot, kitchen or category | BR-001, BR-022 |
| `policy.credit.formula` | How a skipped or reduced prepaid obligation becomes a credit or refund | BR-006, BR-005 |
| `policy.credit.expiry` | Credit validity; absent unless approved | BR-019 |
| `policy.delivery_fee.rules` | Delivery fee by purchase type, zone, distance and grouping | BR-007 |
| `policy.discount.rules` | Discounts, stacking, and effect of quote expiry or skip | BR-008 |
| `policy.tax.rules` | Whether and how tax lines apply; off until confirmed | BR-018 |
| `policy.billing.rules` | Basis, coverage, proration, due dates, instalment frequency | BR-002 |
| `policy.unpaid.grace` | Grace period and suspension for unpaid subscriptions | BR-016 |
| `policy.cod.eligibility` | Who and what may use COD, in which of the four COD models | BR-012 |
| `policy.cod.max_order_amount`, `policy.cod.max_outstanding_amount` | Per-order and outstanding COD limits | BR-012 |
| `policy.substitution.rules` | Allowed replacements, price-difference handling | BR-017 |
| `policy.kitchen.multi_kitchen` | Whether one agreement may span kitchens | BR-021 |
| `policy.quote.expiry` | Lifetime of a confirmed-able quote | ADR-009, BR-008 |
| `policy.stock.reservation_expiry` | Lifetime of a stock reservation during checkout | SC-20, FR-046 |
| `policy.renewal.offer_lead` | How long before term end a renewal offer is shown | BR-002, BR-016 |
| `policy.refund.rules` | Refund entitlement, scope and approval | BR-005 |
| `policy.legal.credit_wording` | Approved legal wording for credits | BR-025 |

### 3.7 Acceptance case labels

Each contract section 13 uses local labels: **S** success, **F** failure (domain or third-party), **P** permission, **D** duplicate or lost response, **K** concurrency, **R** recovery after partial failure. They correspond to the scenario test suffixes N, X, P, L, C and R in the [scenario index](../../scenarios/SCENARIO_INDEX.md). Test identifiers cited are planned in [test cases](../../testing/TEST_CASES.md); none has been executed.

---

## 4. Screen contracts

### NC-01 Kitchen discovery search

#### NC-01.1 Identity and ownership

| Item | Value |
|---|---|
| ID, name | NC-01 Kitchen discovery search |
| Application and group | CUS, customer group (guest-readable) |
| Form | Full screen, new route "Kitchens" |
| Entry hosts | P-02 Kitchens segment (guest), C-01 quick action, C-04 header link |
| Module, owner | MOD-CAT; Customer-experience design |
| Migration action | New (replaces the dead-end kitchen cards of P-02; P-02 becomes a thin guest entry into NC-01) |
| Status | PROPOSED |

#### NC-01.2 Purpose and users

Let a guest or customer find legitimate kitchens by cuisine, service area, availability, verification and personal preferences, open one, and come back to the same results. Users: guests (read-only, protected actions prompt sign-in) and signed-in customers.

#### NC-01.3 Provenance

USER-REQ: master prompt NC-01 and phase 3 flow "browse kitchens, search/filter, select, kitchen detail". OBSERVED: P-02 Kitchens segment lists kitchens derived from the meal sample data and **its cards are not clickable** (status I, prototype gap 15). PROPOSED: sort options, filter set, route name, empty-area messaging.

#### NC-01.4 Layout and visual reference

Top: title "Kitchens", search field with clear button, active-address chip (customer) or area selector (guest). Below: horizontally scrolling filter chips (cuisine or category, dietary such as Halal or diet, meal slots offered, open for selected date, verified kitchens, my favourites), a "Filters" button, a sort control, then a result-count line and the kitchen card list. A card shows the kitchen photo, name (English and Bangla), evidence-backed verified badge (only if the verification state supports it), rating summary from permitted reviews, slot chips for slots the kitchen offers, a "Serves your address" or "Does not serve this area" line, and a favourite heart. Visual reference: P-02 kitchens grid and rating badges, CU-27 kitchen name, CU-29 badges, C-04 filter chips, rounded-3xl cards with soft shadows.

#### NC-01.5 Elements and behaviour

| Control | Action | Destination | Command or read | Notes |
|---|---|---|---|---|
| Search field | Type; debounced query; clear | NC-01 (same) | `searchKitchens` (read) with query, filters, zone, cursor | Obsolete in-flight requests are cancelled; only the latest result renders. Matches English and Bangla names. |
| Filter chips and Filters sheet | Toggle filters; apply or reset | NC-01 | `searchKitchens` | Apply commits, Cancel keeps the previous filters. Chip state is announced as selected or not selected. |
| Sort control | Relevance, highest rated, name A to Z | NC-01 | `searchKitchens` | Distance sorting is not offered: no location permission is required. |
| Active-address chip | Change address | C-02 | read of saved addresses | Zone eligibility recomputed server-side for the chosen address. |
| Area selector (guest) | Pick an area | NC-01 | `searchKitchens` by zone | Guests give an area, never a street address. |
| Kitchen card | Open kitchen | C-06 (NC-02 About, NC-03 Menu) | none | Carries kitchen ID and the current query state for return. Always opens a valid destination or the unavailable panel. |
| Favourite heart | Add or remove favourite | NC-18 (list) | `savePreferences` | Guest: opens the sign-in sheet preserving the kitchen ID. Optimistic with revert on failure. |
| Clear filters (empty state) | Reset | NC-01 | `searchKitchens` | Distinct from the "area not served" empty state. |
| Load more | Next page | NC-01 | `searchKitchens` cursor | Explicit end marker; no duplicate rows on retry. |

#### NC-01.6 Navigation

In: P-01 Kitchens quick action, P-02, C-01, C-04, deep link `kitchens` with validated query parameters, return from C-06. Out: C-06 (card), C-02 (address), NC-18 (favourites), AU-03 and AU-12 via the sign-in sheet (guest), SH-01 (bell). Back returns to the previous screen and restores query, filters and scroll position.

#### NC-01.7 Backend services

`searchKitchens` (read). Entities: `ent.Kitchen`, `ent.ServiceZone`, `ent.MealCategory`, `ent.SlotAvailability`, `ent.Review` (aggregates only), `ent.Customer` (preferences, favourites). Authorisation: published, approved kitchens only; guests receive the same public projection; no addresses, document data or contact details. A query is bounded in length and page size; no whole-collection download. Direct reads of unpublished kitchens are denied by rules and by the trusted read.

#### NC-01.8 States

| State | Behaviour |
|---|---|
| Loading | Card skeletons with filter chips already interactive; result count shows a progress label. |
| Empty | Two cases. No match: "No kitchens match" with Clear filters. Area not served: "No kitchens serve this area" with Change address; no "notify me" promise is made. |
| Success | Result count announced once ("12 kitchens"). |
| Error | `temporarily_unavailable`: retained query plus Retry. `invalid_input` (query too long): inline helper, no request. |
| Offline | Last results with an "as of" time; search and filter changes disabled with reason; favourite toggles disabled. |
| Denied | Not applicable to browsing. A suspended customer account can still browse; protected actions show the account-status message. |
| Session expired | Guest browsing continues; a pending favourite or deep link prompts sign-in, then restores intent. |
| Screen-specific | Partial availability: if availability for a card is unknown the card shows "Availability unavailable" rather than a guess. Stale card: a kitchen that stopped accepting orders after the list loaded opens NC-02 in its unavailable state. |

#### NC-01.9 Validation and permissions

Client: query length bound, debounce, chip combinations. Server (authoritative): zone match, publication and verification state, favourites ownership. Guest reads the public projection; only the owner changes favourites. A hidden or suspended kitchen (BR-024, PENDING) is excluded or marked not accepting orders; the reason is not disclosed publicly.

#### NC-01.10 Responsive behaviour

Compact: single-column cards, filters in a bottom sheet. Medium: two-column grid, filter sheet centred. Expanded: persistent filter rail on the left, three-column grid. Large: content width capped, rail plus four-column grid, keyboard-focusable cards. Orientation change keeps query, filters and scroll position.

#### NC-01.11 Accessibility and bilingual notes

The search field has a persistent label. Filter chips are toggle buttons with selected state spoken. The result count is a polite live region. Card order is name, status, rating, area line, actions; the heart has a label naming the kitchen. Bangla and English names are both searchable; long Bangla names wrap rather than truncate. Verified badge text is spoken ("Verified kitchen") and never colour-only.

#### NC-01.12 Business rules and failure handling

Only approved kitchens appear; a verification badge reflects a current document state, not an uploaded file (SC-17, BR-024 PENDING). Multi-kitchen subscription restriction (BR-021, PENDING) is explained on NC-02 and NC-04, not here. If a kitchen is switched off between list load and open, NC-02 shows the unavailable state and no stale menu. If the search backend lags, results may be older than catalogue edits; the checkout quote (NC-08, NC-14) is the final authority.

#### NC-01.13 Acceptance and tests

Planned, not executed.

| Case | Given / When / Then |
|---|---|
| S1 | Given two kitchens, one serving the customer's address: when the customer searches and filters by "serves my address", then only that kitchen is listed and opening it shows its menu. |
| S2 | Given filters set then a kitchen opened: when the customer goes back, then query, filters and scroll position are restored. |
| F1 | Given a kitchen turned off after the list loaded: when its card is tapped, then NC-02 shows "not accepting orders" and no menu items are orderable. |
| P1 | Given a guest: when requesting another user's favourites or an unpublished kitchen, then the request is denied and the response does not reveal whether the record exists. |
| D1 | Given rapid typing: when ten queries are issued, then only the last result set is rendered. |
| K1 | Given a kitchen unpublished during pagination: when the next page loads, then the kitchen disappears without duplicate or missing neighbours. |

Planned tests: TEST-004, TEST-109, TEST-116, TEST-102; scenarios SC-03, SC-17, SC-22 (suffixes N, P, X); AC-004 (browse) for the legacy base; acceptance for FR-026.

#### NC-01.14 Traceability

FR-026, FR-049, FR-050; BR-021, BR-024, DEC-008, DEC-021 no; MOD-CAT; `ent.Kitchen`, `ent.ServiceZone`, `ent.MealCategory`, `ent.SlotAvailability`, `ent.Review`; legacy P-02, C-04, C-06; screenshot CU-27, CU-29; SC-03, SC-17, SC-18, SC-22; F129 families C-04, C-07 (see section 5).

---

### NC-02 Kitchen profile detail

#### NC-02.1 Identity and ownership

| Item | Value |
|---|---|
| ID, name | NC-02 Kitchen profile detail |
| Application and group | CUS, customer group (guest-readable) |
| Form | Section: the "About" segment of the C-06 route |
| Route owner | C-06 Kitchen detail (Extend) |
| Module, owner | MOD-CAT; Customer-experience design |
| Migration action | Extend (C-06 was UI-only in the prototype) |
| Status | PROPOSED |

#### NC-02.2 Purpose and users

Present who a kitchen is and what it can promise today: identity, location in terms of served areas, offered meals, service windows, policies, reviews and verified status. Users: guests and customers deciding whether to order or subscribe.

#### NC-02.3 Provenance

USER-REQ: master prompt NC-02 and the kitchen-profile list (verification status, approved service areas, operating hours, delivery slots, reviews, availability). OBSERVED: C-06 shows verified chips and meals by kitchen (status U); the kitchen card on C-05 links to C-06. PROPOSED: segment structure and the unavailable-kitchen presentation.

#### NC-02.4 Layout and visual reference

Header band: kitchen photo, name in both languages, verification badge (only from an approved verification state), rating summary and count, accepting-orders chip with a reason when not accepting. A segmented control switches About, Menu (NC-03) and Reviews. About sections: description; served areas as zone names with a "Serves your address" result for the active address; operating days and hours; meal slots offered with each slot's window; policy summary (cutoff and cancellation lines read from the active policy version, shown as "see policy", never hard-coded text); recent reviews preview. Sticky footer actions: View menu, Subscribe from this kitchen. Visual reference: C-06 verified chips, C-05 kitchen card, CU-27 and CU-28.

#### NC-02.5 Elements and behaviour

| Control | Action | Destination | Command or read | Notes |
|---|---|---|---|---|
| Segment control | Switch About, Menu, Reviews | C-06 (NC-03 for Menu) | read | The selected segment is part of route state and survives rotation. |
| Accepting-orders chip | Explain status | NC-02 (tooltip or sheet) | read `ent.Kitchen` availability | States "Accepting", "Closed now (opens at ...)", or "Not accepting orders". No internal reason is shown for compliance holds. |
| Serves-your-address line | Change address | C-02 | read of addresses and zone | Server decides; the client never evaluates zone geometry. |
| View menu | Go to Menu segment | C-06 (NC-03) | none | |
| Subscribe from this kitchen | Start a draft | NC-04 | `createSubscriptionDraft` on first step | Guest: sign-in sheet that preserves the kitchen ID (fixes the lost-parameter gap of C-11). Disabled with a reason if the kitchen is not accepting subscriptions. |
| Favourite heart | Toggle | NC-18 | `savePreferences` | Same behaviour as NC-01. |
| Reviews preview and See all | Open the Reviews segment | C-06 | read `ent.Review` | Only permitted, moderated reviews (DEC-013). |
| Report this kitchen | Open problem report | SH-06 with `ref=kitchen:<id>` | `submitComplaint` | Customer only; overflow menu. |

#### NC-02.6 Navigation

In: NC-01 card, C-05 kitchen card, C-04, NC-18, P-01 and P-02 (guest), SH-01 notification about a favourite kitchen (if enabled). Out: NC-03, NC-04, C-02, C-05 via menu items, SH-06, sign-in sheet (guest). Back returns to the origin with its state restored.

#### NC-02.7 Backend services

Reads: `ent.Kitchen`, `ent.ServiceZone`, `ent.SlotAvailability`, `ent.Review`, `ent.PolicyVersion` (display of active cutoff text). No command is needed to view. Authorisation: public projection for guests; no supplier contact details, document images or document numbers are ever returned to customers. Verified status is derived from the approved application and document validity, not stored as a client-visible free-text flag.

#### NC-02.8 States

| State | Behaviour |
|---|---|
| Loading | Header and section skeletons. |
| Empty | Sections with no data are labelled ("No reviews yet"); a missing description is omitted, not shown blank. |
| Success | Content shown; no toast. |
| Error | Retry for the failed section only; the rest stays visible. |
| Offline | Cached profile with "as of" time; actions that start a draft or favourite are disabled with a reason. |
| Denied | An unpublished or non-existent kitchen shows the neutral "no longer available" panel. |
| Session expired | Public content remains; protected actions re-prompt sign-in. |
| Screen-specific | Unavailable kitchen: profile readable, menu orders disabled, Subscribe disabled with reason. Compliance lapse (SC-17, BR-024 PENDING): the kitchen is shown as "not accepting new orders" without stating why. |

#### NC-02.9 Validation and permissions

Read-only apart from favourite and report. Server checks publication and approval state on each load. The favourite and report actions need an authenticated customer. A report requires the kitchen to be one the customer can see.

#### NC-02.10 Responsive behaviour

Compact: single column, segments as tabs, sticky footer actions. Medium: header image beside the summary. Expanded: two columns (About content left, "Order from this kitchen" summary right with the same two actions). Large: capped width, reviews in a third column.

#### NC-02.11 Accessibility and bilingual notes

Each segment is a labelled tab; section headings use heading semantics. The verified badge announces its meaning. The served-area list is plain text, not map-only. Hours are spoken with day and time in the user's locale. Bangla kitchen names and long descriptions reflow; ratings are spoken as "4.5 out of 5, 120 reviews".

#### NC-02.12 Business rules and failure handling

One kitchen per subscription agreement is the PROPOSED launch rule (BR-021, PENDING); the Subscribe action's helper text says that meals from another kitchen need a separate subscription, before any payment (SC-22). A kitchen that stops accepting orders (SC-07) turns the chip to "Not accepting orders"; existing commitments are handled by the continuity process, not on this screen. A rating shown here counts only permitted reviews. A badge never appears from an uploaded file alone.

#### NC-02.13 Acceptance and tests

| Case | Given / When / Then |
|---|---|
| S1 | Given a kitchen serving the active address: when About is opened, then served areas, hours, slots and rating are shown and "Serves your address" is Yes. |
| F1 | Given the kitchen turns off: when About is refreshed, then the chip says "Not accepting orders" and Subscribe is disabled with a reason. |
| P1 | Given a guest: when a customer-only action (favourite, report) is tapped, then the sign-in sheet opens and, after sign-in, the action completes for the same kitchen. |
| D1 | Given a double tap on the favourite heart: then one stored favourite exists. |
| K1 | Given the kitchen is unpublished while open: when the next read happens, then the unavailable panel replaces the content without exposing data. |

Planned tests: TEST-004, TEST-011, TEST-102, TEST-109; SC-07, SC-17, SC-22; acceptance for FR-026.

#### NC-02.14 Traceability

FR-026, FR-046 (availability display), FR-049; BR-021, BR-024; MOD-CAT; `ent.Kitchen`, `ent.ServiceZone`, `ent.Review`, `ent.PolicyVersion`; legacy C-05, C-06; CU-27, CU-28, CU-29; SC-07, SC-17, SC-22; F129/C-07.

---

### NC-03 Kitchen menu by meal slot

#### NC-03.1 Identity and ownership

| Item | Value |
|---|---|
| ID, name | NC-03 Kitchen menu by meal slot |
| Application and group | CUS, customer group (guest-readable) |
| Form | Section: the "Menu" segment of C-06; also a reusable picker component in NC-04 and NC-10 |
| Route owner | C-06 (Extend) |
| Module, owner | MOD-CAT; Customer-experience design |
| Migration action | Extend (C-06 listed meals only in the prototype; C-04 stays the cross-kitchen meal list) |
| Status | PROPOSED |

#### NC-03.2 Purpose and users

Show one kitchen's meals grouped by breakfast, lunch, snack and dinner for a chosen service date, with variants, current prices and honest availability, so the customer can select portions to order or to place into a subscription. Users: guests (browse) and customers (select).

#### NC-03.3 Provenance

USER-REQ: master prompt NC-03; phase 3 (categories, images, descriptions, prices, availability, dietary information). OBSERVED: C-05 meal detail has variants-free quantity stepper and the one-kitchen cart rule; sold-out meals are greyed with a reason ("Restocks tomorrow"); C-06 lists meals by kitchen (status U). PROPOSED: slot tabs, date strip and picker modes.

#### NC-03.4 Layout and visual reference

A slot tab bar (only slots the kitchen offers) above a date strip of the dates the kitchen has published. Under it, meal cards for the selected slot and date: image, name, short description, allergen and dietary tags, price per variant (portion), availability line ("Available", "Sold out", "Not offered on this date", "Cutoff passed"), and a Select control. A variant sheet opens on Select (portion, quantity). A summary bar at the bottom shows the selection count. Visual reference: C-05 image-first layout and quantity footer, C-04 MealCard, CU-26 and CU-30.

#### NC-03.5 Elements and behaviour

| Control | Action | Destination | Command or read | Notes |
|---|---|---|---|---|
| Slot tabs | Choose slot | NC-03 | read `ent.SlotAvailability` | Slot identity is `slot.*`, not the label. |
| Date strip | Choose a service date | NC-03 | read menu for date | Dates come from the server; dates past cutoff are shown disabled with the reason. |
| Meal card | Open detail | C-05 | read `ent.Meal`, `ent.MealVariant` | Meal detail keeps allergens and reviews. |
| Select / variant sheet | Choose variant and quantity | NC-03 (sheet) | read `ent.PriceVersion` | Price shown is the current catalogue version; checkout re-validates. |
| Add to order (browse mode) | Add to cart | C-07 | none until checkout (`createQuote` runs at NC-14) | One-kitchen cart (OBSERVED in C-05) is kept; switching kitchens asks for confirmation before replacing the cart. |
| Add to plan (picker mode) | Return the selection | NC-04 or NC-10 | none | Picker mode is chosen by the caller; returns meal, variant, quantity, date, slot. |
| Dietary and allergen filter | Narrow list | NC-03 | read | Seller claims are labelled as the kitchen's statements, not medical assurance. |
| Sold-out meal | Explain | NC-03 | none | Disabled with a visible reason; restock text only if scheduled. |

#### NC-03.6 Navigation

In: NC-02 (View menu), NC-18 favourite, P-02 guest, NC-04 and NC-10 (picker). Out: C-05 meal detail, C-07 cart, NC-04 or NC-10 (return value), sign-in sheet for protected actions. Back from a pick returns to the caller with the selection.

#### NC-03.7 Backend services

Reads: `ent.Meal`, `ent.MealVariant`, `ent.PriceVersion`, `ent.SlotAvailability`, `ent.KitchenCapacity` (display of remaining count only when a capacity model is approved, FR-046). No stock is reserved while browsing; `reserveStock` is called when a quote is confirmed (NC-08, NC-14, NC-10). Authorisation: public projection; price versions limited to the current effective version.

#### NC-03.8 States

| State | Behaviour |
|---|---|
| Loading | Slot tabs render at once; card skeletons for the active slot. |
| Empty | "No meals for this slot on this date" with the next date that has meals, or "The kitchen does not offer this slot". |
| Success | Selection count updates and is announced. |
| Error | Inline retry in the list; the tab bar and date strip remain usable. |
| Offline | Cached menu with an "as of" time; Add actions disabled. |
| Denied | Unpublished kitchen shows the neutral unavailable panel. |
| Session expired | Browsing continues; Add (protected) prompts sign-in. |
| Screen-specific | Price changed since load: a price-changed marker appears and the next quote shows the difference. Last-portion race: availability may change before checkout; a note says availability is confirmed at checkout. |

#### NC-03.9 Validation and permissions

Quantity bounds and variant validity are checked on the client for usability and re-checked by the server. Only meals offered in the chosen slot, date and kitchen can be selected. The server ignores any client-supplied price.

#### NC-03.10 Responsive behaviour

Compact: slot tabs scroll horizontally, one card per row, variant sheet from the bottom. Medium: two cards per row, variant dialog centred. Expanded: slot tabs as a left rail, three-column cards. Large: four columns with a persistent selection summary panel.

#### NC-03.11 Accessibility and bilingual notes

Slot tabs and the date strip are a labelled tab list and a radio-style list; selected state is spoken. Each card announces name, price basis, availability and tags. Price per portion is spoken with currency. Sold-out is shown by text and icon. Bangla names and tags wrap; the slot name is localised but the identifier is not.

#### NC-03.12 Business rules and failure handling

Cutoff and availability are server-evaluated against Asia/Dhaka service dates (BR-022, PENDING); a cutoff is displayed from the policy, never hard-coded. Two customers choosing the last portion (SC-20): both can add to their selection; only one reservation succeeds at quote confirmation, and the other sees an "no longer available" outcome with alternatives. No hard-coded kitchen, meal, price or duration exists in business logic.

#### NC-03.13 Acceptance and tests

| Case | Given / When / Then |
|---|---|
| S1 | Given a kitchen with lunch and dinner meals: when Dinner and a date are chosen, then only dinner meals offered that date appear with current prices. |
| F1 | Given a meal sold out: when its card is viewed, then Select is disabled and the reason is visible. |
| P1 | Given a guest: when Add is tapped, then the sign-in sheet opens and the selected meal, variant and date are preserved after sign-in. |
| D1 | Given a double tap on Add: then the selection contains the portion once with the intended quantity. |
| K1 | Given two customers and one remaining portion: when both confirm, then one reservation succeeds and the other receives `conflict` with alternatives (SCT-20). |

Planned tests: TEST-005, TEST-015, TEST-114; SC-20 (N, C); acceptance for FR-026 and FR-046.

#### NC-03.14 Traceability

FR-026, FR-027, FR-046; BR-022, BR-021; MOD-CAT; `ent.Meal`, `ent.MealVariant`, `ent.PriceVersion`, `ent.SlotAvailability`, `ent.KitchenCapacity`; legacy C-04, C-05, C-06, P-02; CU-26, CU-30; SC-20; F129/C-05, C-06.

---

### NC-04 Custom subscription builder

#### NC-04.1 Identity and ownership

| Item | Value |
|---|---|
| ID, name | NC-04 Custom subscription builder |
| Application and group | CUS, customer group (authenticated for saving) |
| Form | Full screen with guided steps |
| Entry hosts | C-11 Plan picker ("Customise"), NC-02 Subscribe, C-01 |
| Module, owner | MOD-SUB; Customer-experience design |
| Migration action | Extend (C-11 remains the template list; the prototype ignored the meal and plan parameters) |
| Status | PROPOSED |

#### NC-04.2 Purpose and users

Let a signed-in customer compose a subscription from one kitchen's eligible meals by date, slot, quantity and delivery address, keep it as a draft, preview the whole schedule and total, and send it to the confirmed quote (NC-08). Never a fixed monthly package.

#### NC-04.3 Provenance

USER-REQ: master prompt NC-04 and phase 4 (different meals per day and slot, lunch only, dinner only, weekday meals, repeat weekly, quantities, start date, duration, address, delivery windows, substitutions, schedule preview). OBSERVED: C-11 PlanPicker ignored meal and plan parameters and defaulted to a monthly lunch-and-dinner plan (gap 2). PROPOSED: five steps and draft persistence.

#### NC-04.4 Layout and visual reference

A progress header with five steps: **Kitchen**, **Term**, **Schedule**, **Delivery**, **Preview**. Step bodies: Kitchen (prefilled or chosen via NC-01); Term (start date, duration, billing frequency as two independent controls, taken from the kitchen's published options); Schedule (a calendar or weekday list; each date and slot holds a meal, variant and quantity chosen with the NC-03 picker; "Repeat weekly" opens NC-05); Delivery (address and delivery window); Preview (every scheduled obligation listed by date and slot, count by slot, running total from the latest draft quote, and a link to NC-07). A sticky footer has Save draft and Continue. Visual reference: C-11 plan cards, C-13 date grid, C-12 summary card.

#### NC-04.5 Elements and behaviour

| Control | Action | Destination | Command or read | Notes |
|---|---|---|---|---|
| Kitchen step | Confirm or change kitchen | NC-01 (change) | `createSubscriptionDraft` on first leave | One kitchen per agreement at launch (BR-021, PROPOSED); changing kitchen warns that the schedule is cleared. |
| Start date and duration | Choose | NC-04 | read earliest valid start from server | Server returns the earliest start whose cutoff has not passed (BR-022). |
| Billing frequency | Choose | NC-04 | read options from the kitchen plan | Independent of duration. Options come from the kitchen, never hard-coded. |
| Add or edit meal in a cell | Pick meal, variant, quantity | NC-03 (picker) | `saveSubscriptionSchedule` | Different meals per day and slot are supported; quantities per cell. |
| Repeat weekly | Open the weekly editor | NC-05 (draft mode) | `saveSubscriptionSchedule` | Pattern generates a preview, not obligations. |
| Delivery address | Choose | C-02 (C-03 to add) | read; server validates zone | An address outside the kitchen's zone blocks Continue with an explanation (SC-19). |
| Delivery window | Choose from windows the kitchen offers | NC-04 | read | |
| Delivery fee info | Explain | NC-07 | quote read | Link appears once a draft quote exists. |
| Save draft | Persist and exit | C-10 (Drafts) | `saveSubscriptionSchedule` with `expectedVersion` | Draft is server-side so it survives language change and restart (SC-18). |
| Continue to review | Get quote | NC-08 | `createQuote` | Blocked while any line is flagged invalid. |
| Discard draft | Confirm and delete | C-10 | none authoritative yet; draft marked discarded | Confirmation names the draft; history is not erased. |

#### NC-04.6 Navigation

In: C-11, NC-02, C-01, C-10 draft card, deep link to a draft ID owned by the user. Out: NC-03, NC-05, NC-07, NC-08, C-02, C-03, NC-01. Back moves one step; on step one it asks to keep or discard the draft.

#### NC-04.7 Backend services

`createSubscriptionDraft`, `saveSubscriptionSchedule`, `createQuote` (preview), reads of `ent.Kitchen`, `ent.MealVariant`, `ent.PriceVersion`, `ent.SlotAvailability`, `ent.ServiceZone`. Entities: `ent.Subscription` (Draft), `ent.SubscriptionVersion`, `ent.SubscriptionSchedule`, `ent.Address`. Authorisation: owner only; the draft belongs to the principal; kitchen eligibility and address zone are checked on the server at every save. Commands carry `requestId` and `expectedVersion`.

#### NC-04.8 States

| State | Behaviour |
|---|---|
| Loading | Step skeleton; the draft header shows "Loading draft". |
| Empty | A new draft shows empty cells with guidance for the first step; no pre-filled schedule is invented. |
| Success | "Draft saved" with a time, announced once. |
| Error | Per-field errors on the failing step; a summary at the top; valid input is retained. |
| Offline | Edits stay as an unsent draft marker; Save, quote and Continue are disabled with a reason. |
| Denied | A draft ID not owned by the user shows the neutral unavailable panel. |
| Session expired | Unsent edits are kept locally; after sign-in the draft reloads and the version is checked. |
| Screen-specific | Meal became unavailable: the affected line is flagged "Replace or remove" and Continue is blocked. Version conflict from a second device: the newer draft is shown with a choice to take it or re-apply local edits. Address outside the zone: conditional message with change-address and remove-lines options. |

#### NC-04.9 Validation and permissions

Client checks required fields and obvious ranges. The server validates each line (meal offered in that kitchen, slot and date; quantity bounds; cutoff not passed; no duplicate date, slot and meal line), the start date, the horizon (`policy.cutoff.change`, `policy.billing.rules`), the address zone and the owner. Only the owner may read or save a draft. A draft carries no authority to charge.

#### NC-04.10 Responsive behaviour

Compact: one step at a time, schedule as a date list with a bottom-sheet cell editor. Medium: two-column Schedule step (calendar left, selected-day detail right). Expanded: side-by-side steps with a persistent Preview panel. Large: calendar, day detail and running summary in three panes. Language or orientation change keeps the step and all input.

#### NC-04.11 Accessibility and bilingual notes

Step indicator is a list with "step 3 of 5, Schedule". The calendar offers a linear list alternative. Every cell has a spoken label "Saturday 7 March, breakfast, Egg paratha, quantity 1" (HYPOTHETICAL example). Slot names are localised while identifiers are fixed. Validation errors are associated with their fields and focus moves to the first invalid field. Switching English and Bangla mid-draft preserves all selections (SC-18).

#### NC-04.12 Business rules and failure handling

Subscription agreement is distinct from individual meal obligations: obligations are generated only after confirmation and payment (`generateMealObligations`, scheduled job), never while drafting. Duration and billing frequency are independent. Multi-kitchen is PENDING (BR-021): the builder states the one-kitchen rule before any payment (SC-22). Out-of-zone addresses are never silently accepted (SC-19). Draft totals are previews; the confirmed quote at NC-08 is the only payable amount. If a price version changes, the next quote shows the difference.

#### NC-04.13 Acceptance and tests

| Case | Given / When / Then |
|---|---|
| S1 | Given the prompt example (HYPOTHETICAL): Saturday breakfast A, lunch B, dinner C, Sunday lunch D, Monday breakfast E: when saved, then the draft holds five lines with those distinct meals and the preview lists exactly five obligations. |
| S2 | Given the customer switches to Bangla mid-draft: then all selections and the current step remain. |
| F1 | Given a meal sold out for one date: when Continue is tapped, then only that line is flagged and no quote is created. |
| F2 | Given an address outside the kitchen's zone: then Continue is blocked with options to change address or remove lines. |
| P1 | Given another user's draft ID: when opened or saved, then the response is the neutral unavailable result. |
| D1 | Given a double tap on Save draft: then one new draft version exists. |
| K1 | Given the same draft edited on two devices: when the second saves with a stale `expectedVersion`, then it receives `conflict` and no data is overwritten. |

Planned tests: TEST-006, TEST-007, TEST-109, TEST-113; SC-02, SC-18, SC-19, SC-22 (N, X, C); acceptance for FR-029 and FR-031.

#### NC-04.14 Traceability

FR-029, FR-030, FR-049, FR-050; BR-002, BR-021, BR-022; MOD-SUB, MOD-PRC; `ent.Subscription`, `ent.SubscriptionVersion`, `ent.SubscriptionSchedule`, `ent.Quote`, `ent.Address`; legacy C-11, C-12, C-13, C-02; CU-31; SC-02, SC-18, SC-19, SC-22; F129/C-08, C-09.

### NC-05 Weekly schedule editor

**Identity/purpose.** Full screen (draft mode and change mode); repeats meal choices on selected weekdays without assuming identical food every day; opened from NC-04 and from an existing subscription via C-10/NC-06. **Provenance.** USER-REQ (weekly schedule, uneven quantities, SC-02).
**Elements.** Weekday-by-slot grid; "apply pattern to remaining weeks" action; per-date exception editor; preview totals.
**Backend.** `saveSubscriptionSchedule` with `recurrenceRule` + `exceptions[]`; reads `ent.SubscriptionSchedule`.
**States.** loading/empty/error/offline/denied/session-expired (shared rules §3.4) plus: pattern-conflict (two exceptions on the same date → last-saved-with-version-check wins, never silently merged).
**Validation/permissions.** Owner-only edit; `expectedVersion` on every save.
**Responsive/accessibility.** Compact: one weekday visible at a time with swipe; expanded: full 7-column grid. Each cell has a spoken label matching NC-04.11's example pattern.
**Business rules/failure.** Cutoff evaluated server-side per changed date (BR-022); an edit to an already-generated, dispatched obligation is rejected (DEC-014).
**Tests (planned).** SCT-02-N/P/C/L/X/R (see [scenarios/SC-02](../../scenarios/SC-02-weekly-uneven-quantities.md)).
**Traceability.** FR-029, FR-031; BR-001, BR-022; `ent.SubscriptionSchedule`; legacy C-13 (Extend host); SC-02.

### NC-06 Monthly schedule calendar

**Identity/purpose.** Section (body of the calendar), hosted by legacy C-13 (Extend); reviews every purchased meal within the billing period with real cutoff and lifecycle status per cell, replacing the legacy static 30-day grid. **Provenance.** USER-REQ; OBSERVED legacy C-13 done/today/paused/upcoming states, now server-derived.
**Elements.** Month grid; day → sheet listing that date's obligations; each obligation → NC-09/NC-10 or a disabled state with its cutoff reason.
**Backend.** Reads `ent.MealObligation` for the period; no write from this screen directly (delegates to NC-09/10).
**States.** As §3.4; additionally "no obligations this month" (empty, with a link to NC-04/NC-05).
**Validation/permissions.** Owner-only.
**Responsive/accessibility.** Linear list alternative to the grid on compact/screen-reader use, per §3.4 pattern reused from NC-04.
**Business rules/failure.** Slot identifiers never translated as data (glossary); a dispatched obligation shows read-only.
**Tests (planned).** TEST-029, TEST-050; SC-18 (language switch mid-browse).
**Traceability.** FR-029, FR-050; `ent.MealObligation`; legacy C-13; SC-18.

### NC-07 Delivery price explanation

**Identity/purpose.** Sheet, opened from NC-08/NC-10/NC-14/C-12; read-only, explains why single orders and subscription deliveries use different fee policies. **Provenance.** USER-REQ.
**Elements.** Zone/distance band shown; grouped-delivery vs per-slot comparison; "why this fee" copy sourced from the active `policy.delivery_fee.rules` version, never invented text.
**Backend.** Read-only; reads the quote line and its policy version.
**States.** loading/error only (no write path).
**Business rules/failure.** BR-007 PENDING — every number shown is the actual configured value or, if unconfigured, "fee not yet configured", never a guess.
**Tests (planned).** TEST-030.
**Traceability.** FR-030; BR-007; `ent.Quote`; legacy C-12 (sheet host).

### NC-08 Custom plan review

**Identity/purpose.** Full screen, the quote-review mode of legacy C-12 (Extend); shows kitchen, meal calendar, food total, fees, taxes, discounts, credit and due amount; confirm or return to edit. **Provenance.** USER-REQ; OBSERVED legacy C-12 static breakdown, now itemised from a real quote.
**Elements.** Itemised quote (§3.3 quote pattern); "View price explanation" → NC-07; "Apply credit" → NC-16; Confirm → `confirmQuote` then payment (NC-14) or COD.
**Backend.** `createQuote`/`confirmQuote`; reads `ent.Quote`.
**States.** quote-expired (re-quote required, never honoured stale); payment-pending.
**Business rules/failure.** INV-18 (quote = invoice = payment = journal); never silently charge a different amount than shown here (USER-REQ).
**Tests (planned).** TEST-030, TEST-233 (INV-18); SCT quote-mismatch case.
**Traceability.** FR-030, FR-033; BR-002, BR-006, BR-007, BR-008, BR-018; `ent.Quote`; legacy C-12.

### NC-09 Meal skip request

**Identity/purpose.** Sheet (confirmation), opened from NC-06's meal sheet and legacy C-14; one decision on one server quote, context stays visible behind it. **Provenance.** USER-REQ; fixes legacy double-skip gap (SC-04).
**Elements.** Shows the server-computed credit amount before confirmation; single "Confirm skip" action, disabled after first tap.
**Backend.** `quoteScheduleChange` (preview) → `skipMeals` (confirm); reads/writes `ent.MealObligation`, `ent.CreditTransaction`.
**States.** cutoff-passed (disabled with reason); already-skipped (shows the existing receipt, never a second skip option, SC-04).
**Business rules/failure.** One credit per obligation origin (INV-08); a lost-response retry returns the original receipt.
**Tests (planned).** SCT-04-N/P/C/L/X/R.
**Traceability.** FR-031, FR-032; BR-001, BR-006; `ent.MealObligation`, `ent.CreditTransaction`; legacy C-14; SC-04.

### NC-10 Meal replacement quotation

**Identity/purpose.** Full screen (guided steps: pick replacement → compare → optional payment step → confirm); opened from NC-06's meal sheet and legacy C-15. **Provenance.** USER-REQ; fixes legacy C-15 "not saved" gap (SC-05, SC-06).
**Elements.** Meal picker scoped to the same kitchen/slot; price comparison (old vs new); payment step only if the new meal costs more.
**Backend.** `quoteScheduleChange` → (if charge) payment → `confirmScheduleChange`; (if credit) `confirmScheduleChange` directly.
**States.** payment-pending-for-upgrade (old meal stays valid until the extra amount is confirmed, SC-05); payment-failed (old meal remains, never both fulfilled).
**Business rules/failure.** BR-006, BR-017; supplier capacity shifted atomically with the obligation change (SC-06).
**Tests (planned).** SCT-05-*, SCT-06-*.
**Traceability.** FR-031; BR-006, BR-017; `ent.MealObligation`, `ent.Substitution`; legacy C-15; SC-05, SC-06.

### NC-11 Customer service-credit ledger

**Identity/purpose.** Full screen; entered from C-23, C-20, NC-16; unbounded paginated history with filters and entry detail. **Provenance.** USER-REQ (credit ledger, non-cash).
**Elements.** Available/reserved/consumed/expired balance tiles; transaction list, each row → its source order/obligation; class label (service vs promotional, never merged, SC-23).
**Backend.** Reads `ent.CreditAccount`, `ent.CreditTransaction` (paginated per API spec §8).
**States.** empty ("no credits yet"); as §3.4 otherwise.
**Business rules/failure.** Never shown as withdrawable cash (glossary); balance never negative (INV-07).
**Tests (planned).** TEST-032; SCT-23-*.
**Traceability.** FR-032; BR-006, BR-019, BR-025; `ent.CreditAccount`, `ent.CreditTransaction`; legacy C-23/C-20 (entry points).

### NC-12 Weekly subscription billing

**Identity/purpose.** Section (weekly variant), hosted by legacy C-20 (Extend); shows weekly schedule and due payments clearly separated. **Provenance.** USER-REQ.
**Elements.** Current week's invoice, previous payment, applied credit, remaining balance; "Pay instalment" action when due.
**Backend.** Reads `ent.Invoice`; payment via NC-14's payment flow.
**States.** overdue (per BR-016, PENDING, shown honestly, never a guessed suspension).
**Business rules/failure.** Billing frequency independent of subscription duration (glossary).
**Tests (planned).** TEST-035.
**Traceability.** FR-035; BR-002, BR-016; `ent.Invoice`; legacy C-20.

### NC-13 Monthly subscription billing

**Identity/purpose.** Section (monthly variant), hosted by legacy C-20 (Extend); shows monthly upfront payment, fulfilment calendar and undelivered obligations. **Provenance.** USER-REQ.
**Elements.** Prepaid liability figure (declining as obligations fulfil, SC-01); link to NC-06 calendar; request-modification action.
**Backend.** Reads `ent.Invoice`, `ent.MealObligation` aggregate.
**States.** As §3.4.
**Business rules/failure.** Prepaid obligation never shown as "fully consumed" until every obligation is actually fulfilled or credited (SC-01, INV-06).
**Tests (planned).** TEST-035; SCT-01-*.
**Traceability.** FR-035; BR-002; `ent.Invoice`; legacy C-20; SC-01.

### NC-14 One-time order checkout

**Identity/purpose.** Full screen, the one-time mode of legacy C-08 (Extend); offers standalone meal purchase without forced subscription. **Provenance.** USER-REQ; fixes legacy "outcome simulator" gap (SC-13, SC-20).
**Elements.** Cart summary; address (zone-validated); slot; COD/online payment choice (COD eligibility shown from server check per BR-012, never a static chip); Place Order.
**Backend.** `confirmQuote` → `placeOneTimeOrder` → (COD: `recordCodCollection` chain later) or (online: `initiatePayment` chain, NC-08-style).
**States.** stock-race (SC-20); gateway-pending (SC-13, never a false success from redirect).
**Business rules/failure.** INV-18; INV-05 (gateway dedupe).
**Tests (planned).** SCT-20-*, SCT-13-*.
**Traceability.** FR-028, FR-033, FR-034; BR-002, BR-012; `ent.Order`, `ent.Quote`, `ent.PaymentIntent`; legacy C-07/C-08; SC-13, SC-20.

### NC-15 Subscription change history

**Identity/purpose.** Full screen; opened from a subscription card in C-10; unbounded version history with a before/after compare view. **Provenance.** USER-REQ (preserve original and every approved modification).
**Elements.** Chronological list of confirmed pauses, reschedules, swaps, invoice revisions; each entry's actor and adjustment reference; compare view never edits financial history.
**Backend.** Reads `ent.SubscriptionVersion`, `ent.AuditEvent`.
**States.** empty ("no changes yet"); as §3.4 otherwise.
**Business rules/failure.** Read-only; no command writes from this screen.
**Tests (planned).** TEST-029.
**Traceability.** FR-029; `ent.SubscriptionVersion`; legacy C-10 (entry point).

### NC-16 Service credit redemption

**Identity/purpose.** Sheet, opened from the payment summary of NC-08/NC-10/NC-13/NC-14; a bounded choice of how much credit to apply inside a checkout. **Provenance.** USER-REQ.
**Elements.** Available balance; amount-to-apply slider/input (≤ available); "Apply" confirms atomically.
**Backend.** `reserveCredit` → `consumeCredit` (on payment completion) or `releaseCredit` (if checkout is abandoned).
**States.** insufficient-balance (rejected, shown inline).
**Business rules/failure.** Atomic single consumption; never applied twice to two checkouts in flight (SC-23).
**Tests (planned).** TEST-032; SCT-23-C.
**Traceability.** FR-032; BR-006; `ent.CreditAccount`; legacy none (new interaction).

### NC-17 Refund status tracker

**Identity/purpose.** Full screen (list and detail); entered from C-20, C-17, NC-15, notifications; addressable by a notification deep link. **Provenance.** USER-REQ (distinguish credit from gateway refund).
**Elements.** List of `ent.Refund`/`ent.Dispute` records with status (requested/approved/executed/disputed); detail shows the provider confirmation reference when present.
**Backend.** Reads `ent.Refund`, `ent.Dispute`.
**States.** pending-execution (never shown as completed before `recordRefundResult` confirms, SC-14).
**Business rules/failure.** A refund and an existing credit for the same obligation are mutually exclusive (INV-17).
**Tests (planned).** SCT-14-*.
**Traceability.** FR-039; BR-005, BR-015; `ent.Refund`, `ent.Dispute`; SC-14.

### NC-18 Kitchen preference favourites

**Identity/purpose.** Section ("Favourite kitchens"), hosted by legacy C-24 (Extend); save preferred kitchens without altering kitchen ratings. **Provenance.** USER-REQ.
**Elements.** Heart toggle on NC-01/NC-02 cards writes to the same favourites list shown here.
**Backend.** `savePreferences` (favourites array).
**States.** empty ("no favourites yet, browse kitchens" → NC-01).
**Business rules/failure.** Favouriting never affects the kitchen's public rating or another customer's view.
**Tests (planned).** TEST-026.
**Traceability.** FR-026; `ent.User.preferences`; legacy C-24.

### NC-19 Subscription renewal offer

**Identity/purpose.** Full screen; entered from an SH-01 notification and a C-10 banner; a consent decision with accept/decline semantics, distinct from confirming a new purchase. **Provenance.** USER-REQ.
**Elements.** Renewal term, any schedule changes, new quote, explicit accept/decline; declining never auto-cancels mid-term service.
**Backend.** `renewSubscription` (Sys offer, Cust accept/decline).
**States.** offer-expired (per `policy.renewal.offer_lead`, PENDING).
**Business rules/failure.** Never auto-renews without explicit customer confirmation (USER-REQ: never silently charge a new amount).
**Tests (planned).** TEST-029.
**Traceability.** FR-029, FR-035; BR-002, BR-016; `ent.Subscription`; SH-01 (entry point).

## 5. F129 reconciliation (Customer new-screen coverage)

Every F129 Customer-section family touching subscription building, billing, credits and refunds (`F129/C-08…C-29`, approx. 22 families) is reconciled in full in [design/INVENTORY_RECONCILIATION.md](../INVENTORY_RECONCILIATION.md). NC-01…19 collectively absorb F129's kitchen-discovery, custom-schedule-builder, credit-ledger, refund-tracker and billing-variant families; none is left unmapped.
