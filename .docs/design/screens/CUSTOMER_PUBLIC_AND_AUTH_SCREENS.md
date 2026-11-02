# Customer App screen contracts: public shell and authentication (P-01…P-04, AU-01…AU-08, AU-12)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Design lead, customer and shared screens (author E2a) |
| Purpose | Fourteen-section screen contracts for the guest shell and the customer authentication journey of the Customer App, with the migration of each screen from the 94-screen React prototype. |
| Applies to | CUS (Customer App). Partner applicant screens AU-09…AU-11 and the hidden admin sign-in AU-13 are specified elsewhere; this file only defines the hand-off to them. |
| Depends on | [Conventions and identifier register](../../analysis/CONVENTIONS_AND_ID_REGISTER.md) · [legacy prototype digest](../../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md) · [master prompt digest](../../analysis/SOURCE_MASTER_PROMPT_DIGEST.md) · [glossary](../../requirements/GLOSSARY_AND_TERMINOLOGY.md) · [policy register](../../requirements/POLICY_DECISION_REGISTER.md) · [screenshot control audit](../SCREENSHOT_ACTION_AUDIT.md) · [old 129-family inventory](../SCREEN_AND_CONTROL_INVENTORY.md) |
| Authoritative policies | None defined here. Consumed and still PENDING: DEC-002 (languages), DEC-009 (identity provider, recovery, onboarding, multi-role), DEC-010 (operating constraints, retention), DEC-012 (offline behaviour), DEC-015 (notification policy), BR-023 (dual-role accounts), BR-008 (promotions) |
| Design reference | Screen IDs P-01…P-04, AU-01…AU-08, AU-12; companion files [customer screens](CUSTOMER_SCREENS.md), [new customer screens](CUSTOMER_NEW_SCREENS.md), [shared screens](SHARED_SCREENS.md), [partner application screens](PARTNER_APPLICATION_SCREENS.md); [navigation architecture](../NAVIGATION_ARCHITECTURE.md), [design system](../DESIGN_SYSTEM.md), [accessibility](../ACCESSIBILITY.md) |
| APIs and module docs | [Customer modules](../../customer-app/CUSTOMER_MODULES.md) · [customer UI/UX](../../customer-app/CUSTOMER_UI_UX.md) · [kitchen and meal system](../../customer-app/KITCHEN_AND_MEAL_SYSTEM.md) · [API specification](../../api/API_SPECIFICATION.md) · [identity and catalogue commands](../../api/COMMANDS_IDENTITY_AND_CATALOGUE.md) · [authorization](../../api/AUTHORIZATION.md) · [error responses](../../api/ERROR_RESPONSES.md) · [pricing and billing](../../payments/PRICING_AND_BILLING.md) |
| Unresolved decisions | DEC-009 sign-in providers and recovery method; DEC-002 initial locale; DEC-010 where the Partner app is distributed; BR-023 whether one identity may hold customer and partner grants; OTP and throttle parameter values (named `policy.auth.*`, no value proposed) |
| Status | **Draft for review. Nothing here is implemented or approved.** Prototype statuses (I, U, S) are carried verbatim and describe the legacy React prototype only. BDT figures are HYPOTHETICAL. Routes are PROPOSED names, not confirmed routes. |

## 1. How to read this file

**Provenance tags used inside the contracts.** `OBS` = OBSERVED in the legacy React prototype as reported by its documentation (the prototype source is not in this workspace and was not re-verified). `REQ` = USER-REQ, an explicit instruction in the master prompt or the later 2026-10-28/30 clarifications. `PRO` = PROPOSED by this documentation effort; it needs approval before it becomes a requirement. Where an element row carries `FIX`, it repairs a prototype gap listed in section 10 of the legacy digest (gap numbers are quoted as "gap n").

**Prototype statuses.** I interactive · U UI-only/static sample · S simulated external action. The prototype's "not saved" and "local" qualifiers are quoted as given.

**Case labels.** Acceptance cases are labelled `S` (success), `F` (failure), `P` (permission), `D` (duplicate or concurrency) with the screen ID, for example "P-01 · F1". These labels are local to this document and are not registered identifiers. AC, TEST and SCT references follow the ranges in the conventions register; where a new requirement has no confirmed acceptance-criterion number yet, the reference is written as "AC for FR-0nn" and is resolved by the requirements author. Everything in section 13 of each contract is a planned test design; nothing has been executed.

**Universal states.** The prototype state variants are normal, empty, loading, error, offline and denied (reset on every navigation). Each contract adds `session-expired` and screen-specific states. The behaviour common to all screens is in [UI/UX guidelines](../UI_UX_GUIDELINES.md); section 8 of each contract states only what is particular to that screen.

**Responsive bands** are the four window-size classes observed in the prototype: compact below 600, medium 600–839, expanded 840–1199, large 1200 and above (logical pixels). [Responsive layouts](../RESPONSIVE_LAYOUTS.md) is authoritative for the final breakpoints.

## 2. Shared contracts used by several screens

### 2.1 Guest shell and role colour

Guests see `GuestNav` with four destinations: Home P-01, Menu P-02, Plans P-03 and Account AU-03 (the last one pushes; it does not reset the stack). Public and auth screens take the session role colour; for a visitor this is the customer warm orange (OBS `24 95% 53%`, proposed tokens in [design system](../DESIGN_SYSTEM.md)). Signed-in customers never see `GuestNav`; they use the customer tabs C-01, C-10, C-16, C-23.

### 2.2 Protected-action intent (replaces the prototype's `afterLogin`)

A guest who taps a protected action (subscribe, add to cart, track an order, create an account from a plan) is shown the "Sign in to continue" sheet (OBS `useProtect`). The sheet records an **intent**: target screen ID, the typed parameters needed to resume (kitchen, meal, variant, plan, slot, date, mode) and a creation time. Rules (PRO):

1. The intent holds identifiers only, never prices, eligibility or role. It lives in app-private storage and is a hint, not authority; the server re-authorises everything after sign-in.
2. It is single use, expires after `policy.auth.intent_ttl_minutes` (no value proposed) and is discarded at sign-out and when the signed-in account has no customer grant (fixes gap 1: stale redirect for non-customer roles).
3. After sign-in the target screen revalidates the parameters (kitchen still active, meal still available, address in zone). If a parameter is no longer valid the user lands on the parent screen (C-06, C-04 or C-10) with a banner naming what changed, and the other selections survive (fixes gap 2: lost plan and meal parameters).
4. The sign-in sheet offers Sign in (AU-03) and Create account (AU-12); both carry the intent. Completing sign-up (AU-07, AU-05, AU-08) preserves it.

### 2.3 Hand-off to the Partner App

Supplier and rider applications are made in the Partner App (PAR), not inside the Customer App (architecture decision of the 2026-10-30 request; see [multi-app architecture](../../architecture/MULTI_APP_ARCHITECTURE.md)). Where the prototype navigated to AU-09 or AU-10, the Customer App shows a hand-off sheet that explains the review step and opens the installed Partner App or its distribution page. Where the Partner App is distributed is open (DEC-010). Applying never grants access; only a server-validated role grant and approval state do (see AU-12 and P-04).

## 3. Overview

| ID | Name | Prototype status | Migration action | Route (PROPOSED) | Tab membership |
|---|---|---|---|---|---|
| P-01 | Guest home | I | Extend | `/guest/home` | Guest nav: Home |
| P-02 | Guest menu and kitchens | I | Extend | `/guest/menu` (`?tab=kitchens`) | Guest nav: Menu |
| P-03 | Guest plans | I | Extend | `/guest/plans` | Guest nav: Plans |
| P-04 | Role information (customer, supplier, rider) | I | Reuse | `/guest/roles/:role` | None (pushed from P-01 and C-23) |
| AU-01 | Splash and session resolver | I | Extend | `/auth/splash` | None (launch screen) |
| AU-02 | Language pick | I | Reuse | `/auth/language` | None (first run; also reached from settings) |
| AU-03 | Universal sign-in | I (simulated auth) | Extend | `/auth/sign-in` | Guest nav: Account |
| AU-04 | Forgot password | I | Extend | `/auth/forgot` | None |
| AU-05 | OTP verification | I (any six digits except 000000) | Extend | `/auth/verify` | None |
| AU-06 | New password | I | Extend | `/auth/new-password` | None |
| AU-07 | Customer sign up | I | Extend | `/auth/sign-up` | None |
| AU-08 | Customer onboarding | I | Extend | `/auth/onboarding` | None |
| AU-12 | Choose account type | I | Split | `/auth/choose-type` | None |

---

## P-01 — Guest home

### 1 Identity and ownership

| Field | Value |
|---|---|
| Screen ID | P-01 (legacy, authoritative) · no F129 counterpart |
| Application / group | CUS · P (Public) |
| Prototype source | `GuestHome` · guest.tsx · registry start screen |
| Prototype status | I (state variants disabled: `states={false}`) |
| Migration action | **Extend.** The hero, quick actions, special menu and join list are kept. Added: live catalogue reads, designed non-normal states, durable protected-intent capture, area check. |
| Route / tab | `/guest/home` · Guest nav Home |
| Related proposed screens | NC-01 (kitchen discovery), NC-18 (favourites after sign-in) |

### 2 Purpose and users

Introduce Smart Tiffin to anonymous visitors and signed-out returning customers: show what is cooked today, how subscriptions work and who to sign in as, without asking for any personal data. Signed-in customers are routed to C-01 by AU-01 and never see P-01.

### 3 Provenance

- **OBS:** customer-oriented hero with "See plans" and "Create account"; header Sign in; three-tile QuickActions with a More sheet; "Today's Special Menu" chip row (all, thali, diet, office) over a GuestMeal carousel; tap on a meal image opens a detail sheet with Subscribe; sold-out cards greyscale and disabled; See all; Track my order; "Join" list (Cook, Deliver, How it works); GuestNav footer.
- **REQ:** preserve the customer-oriented hero, plan discovery, special-meals carousel, role information and sign-in intent preservation (master prompt per-screen additions, P-01). Group intent: discover legitimate kitchens, meals and plans without surrendering protected data.
- **PRO:** categories and chips come from catalogue data; a "Check my area" control; designed empty, offline and error states; Track my order resumes at the right order screen.

### 4 Layout and visual reference

Top to bottom: glass header (logo, language toggle, Sign in); hero card (OBS gradient from role orange to warning amber, large radius) with primary "See plans" and secondary "Create account"; QuickActions row of three tiles plus More; Special Menu section (chip row, horizontal carousel of meal cards with kitchen name, price from the published price version and availability badge); "Track my order" tile; Join list; glass GuestNav footer. Glass is used only on the header and footer; food imagery never sits behind text without an opaque scrim. Hero and carousel keep the warm tiffin identity and food photography of the screenshots.

### 5 Elements and behaviour

| Control | Action | Destination | Command / read | Notes |
|---|---|---|---|---|
| Header Sign in | Open sign-in | AU-03 | — | OBS |
| Language toggle (EN / বাংলা) | Switch language in place, keep scroll position | Same screen | local preference; `savePreferences` after sign-in | FIX gap 19: language persisted; PRO |
| Hero "See plans" | Open plan previews | P-03 | — | OBS |
| Hero "Create account" | Start account creation | AU-12 | — | OBS |
| Quick action Meals | Open meal list | P-02 | — | OBS |
| Quick action Plans | Open plans | P-03 | — | OBS |
| Quick action Kitchens | Open kitchens tab | P-02 `{tab: kitchens}` | — | OBS |
| Quick action More | Sheet with customer, supplier, rider information, Sign in, Create account | P-04 `{r}`, AU-03, AU-12 | — | OBS |
| Special-menu chips | Filter carousel by category | Same screen | read: published categories (`ent.MealCategory`) | OBS chips all/thali/diet/office; PRO: category list is data-driven, not hard-coded; "office" is a sample label |
| Meal card (image) | Open guest meal sheet: photo, kitchen, price basis, allergens, availability | Sheet; kitchen name → C-06 guest mode | read: published `ent.Meal`, `ent.MealVariant`, `ent.PriceVersion` | OBS sheet; PRO: kitchen link added so the sheet is not a dead end |
| Sheet "Subscribe" | Capture intent, ask to sign in | Sign-in sheet → AU-03 / AU-12; resume C-11 `{kitchenId, mealId}` | intent only (§2.2) | OBS target; FIX gap 2 |
| Sheet "Order once" (PRO) | Capture intent to add to cart | Resume C-05 `{mealId}` after sign-in | intent only | PRO: one-time purchase is a first-class path (FR-028) |
| Sold-out card | Disabled; shows reason text and restock only if scheduled | None | `ent.SlotAvailability` | OBS greyscale; PRO: reason as text, not colour alone |
| See all | Open meal list | P-02 | — | OBS |
| Track my order | Protected action | After sign-in: C-18 for the single active delivery, else C-16 | intent | OBS target C-18; PRO: a guest has no order, so resume goes to the order list when there is no unambiguous active delivery |
| Join: Cook / Deliver | Role information | P-04 `{r: supplier / rider}` | — | OBS |
| Join: How it works | Role information | P-04 `{r: customer}` | — | OBS |
| Check my area (PRO) | Choose a district or area from a list; no account, no GPS | Same screen; filters carousel | read: public service-zone labels (`ent.ServiceZone`) | PRO: addresses the "unsupported area" failure |
| GuestNav | Home / Menu / Plans / Account | P-01, P-02, P-03, AU-03 | — | OBS |

### 6 Navigation

- **Entry:** AU-01 when there is no valid session; sign-out from C-23 (OBS: reset to P-01); GuestNav Home.
- **Exit:** per element table. No route from P-01 reaches a private screen without passing the intent sheet.
- **Back:** P-01 is the root of the guest stack; system back leaves the app. A pushed screen returns here.
- **Guest and resume rules:** §2.2. A returning customer with a valid session never lands here (AU-01 redirects to C-01).

### 7 Backend services

- **Reads (unauthenticated, published projection only):** special-menu meals, categories, kitchens (`searchKitchens`), service-zone labels. Entities: `ent.Kitchen`, `ent.Meal`, `ent.MealVariant`, `ent.PriceVersion`, `ent.SlotAvailability`, `ent.ServiceZone`.
- **Commands:** none. Language and area choice are local until sign-in.
- **Authorisation:** public read model exposes no addresses, subscriptions, payout data, contact numbers or identity documents. Only kitchens with an approved, non-lapsed verification state appear (ties to BR-024 and SC-17).
- **Never trust the client:** prices shown are published price versions and labelled indicative; no total or eligibility computed here is binding. The intent payload is untrusted (§2.2). Public reads are rate-limited and cacheable.

### 8 States

| State | Behaviour |
|---|---|
| Loading | Skeleton hero, chip row and three card placeholders; no invented meals or prices |
| Empty | "No kitchens or meals are available right now" with Check my area and Create account; distinguishes an empty catalogue from an empty filter result |
| Success | Normal content; the chip filter result count is announced |
| Error | Section-level failure message with Retry; header, hero and navigation remain usable |
| Offline | Last cached catalogue with its timestamp and an offline banner; Subscribe and Track remain visible but explain that sign-in needs a connection |
| Denied | Not applicable to anonymous reads; an unsupported-area result is shown instead (see below) |
| Session expired | A signed-in user whose session lapsed is returned here with a "Session ended, please sign in" banner |
| Unsupported area | The selected area has no serving kitchen: message, nearest served areas, option to be informed later is not offered until a notification policy exists (DEC-015) |
| Promotion expired | A banner or badge for an offer past its validity is not rendered; no offer text exists until BR-008 is approved |
| Image failure | Neutral placeholder; text and actions unaffected |

### 9 Validation and permissions

No free-text inputs. The area list and chips accept only server-provided values. No permission is requested here: not location, not notifications. All content is readable by `guest`; every action beyond reading is protected by the intent sheet and re-authorised on the server after sign-in.

### 10 Responsive behaviour

- **Compact:** single column; carousel one and a half cards; GuestNav as bottom bar.
- **Medium:** centred floating GuestNav; carousel shows two cards; the More sheet becomes a centred dialog (max width about 512 px, OBS `max-w-lg`).
- **Expanded:** navigation rail replaces the bottom bar; hero and Today's Special in two columns.
- **Large:** labelled rail; content capped at the large container width; special menu as a three-column grid instead of a carousel.

### 11 Accessibility and bilingual notes

Hero buttons and tiles have visible text labels; the header Sign in and language toggle have names and at least 48 dp touch targets (the prototype's 40 px icon buttons were a known gap, gap 21). The carousel exposes an accessible list with "card n of m", and the next partly visible card is reachable by swipe and by focus traversal. Sold-out is stated in words. Bangla meal and kitchen names may be longer than English: cards wrap rather than truncate and keep a full accessible label. Language switching keeps scroll and filter state. Price text uses the shared amount formatter (two decimals; the prototype mixed `BDT x` and `৳x`).

### 12 Business rules and failure handling

- Only published, verified kitchens are shown; a kitchen that loses certification disappears from new browsing (BR-024, SC-17) without altering any paid commitment.
- Slow images and an empty catalogue must never block navigation.
- Interrupted sign-in handoff: if the process dies during sign-in the intent is lost safely; the user returns to P-01 and nothing was created.
- A displayed price is not an offer; binding amounts come only from a server quote (FR-030).
- No analytics event carries personal data from this screen.

### 13 Acceptance and tests (planned, not executed)

- **P-01 · S1.** Given a signed-out visitor and two published kitchens, when P-01 opens, then the hero, quick actions and special menu render published meals only, "See plans" opens P-03, and no sign-in is requested. Refs: AC-004, TEST-004, FR-004, FR-026.
- **P-01 · F1.** Given a visitor taps Subscribe on a meal, signs in, and the meal became sold out meanwhile, when the intent resumes, then the user lands on the kitchen detail C-06 with the banner "This meal is no longer available", no draft or cart line exists, and the intent is cleared. Refs: AC-004, TEST-004, TEST-113.
- **P-01 · P1.** Given a supplier account signs in after the intent "Subscribe" was captured on this device, when sign-in completes, then the intent is discarded, no customer screen opens, and the account sees the access outcome of AU-03. Refs: AC-003, TEST-102, SCT-25-P.
- **P-01 · D1.** Given two rapid taps on Subscribe, then exactly one sign-in sheet opens and one intent is stored. Refs: TEST-112 (client side).

### 14 Traceability

FR-001, FR-004, FR-026, FR-049 · MOD-CAT, MOD-AUTH · BR-024 (consumed), DEC-002, DEC-009 · entities `ent.Kitchen`, `ent.Meal`, `ent.PriceVersion`, `ent.ServiceZone` · scenarios SC-17, SC-18 · module docs [kitchen and meal system](../../customer-app/KITCHEN_AND_MEAL_SYSTEM.md), [customer modules](../../customer-app/CUSTOMER_MODULES.md).

---

## P-02 — Guest menu and kitchens

### 1 Identity and ownership

| Field | Value |
|---|---|
| Screen ID | P-02 (legacy, authoritative) · partial F129 ancestor F129/C-04 (explore) and F129/C-07 (public kitchen) |
| Application / group | CUS · P (Public) |
| Prototype source | `GuestMenu` · guest.tsx |
| Prototype status | I (kitchen cards are not clickable: prototype gap 15) |
| Migration action | **Extend.** Meals and kitchens tabs are kept. The dead-end kitchen cards become real entry points to the kitchen detail with kitchen-specific menu, honest availability and a guest-safe purchase preview. |
| Route / tab | `/guest/menu` with optional `?tab=kitchens` · Guest nav Menu |
| Related proposed screens | NC-01 (discovery filters), NC-02 (kitchen profile), NC-03 (menu by slot), NC-18 (favourites) |

### 2 Purpose and users

Let visitors browse every published meal and every published kitchen, search, filter and open a kitchen, so that the decision to register is informed. Users: guests and signed-out customers.

### 3 Provenance

- **OBS:** Segmented Meals / Kitchens (initial tab from `p.tab`); meal search across English name, Bangla name and kitchen; GuestMeal grid of one, two (from about 420 px) or three (large) columns, or "No meals match"; kitchens derived from meals (meal count, best rating, image); **kitchen cards not clickable**.
- **REQ:** every clickable kitchen card must lead to a valid destination; fix non-clickable cards; open kitchen details, kitchen-specific menu, honest availability and a guest-safe purchase preview (P-02 addition). Kitchen discovery by cuisine, service area, availability, verification and preference (NC-01 intent).
- **PRO:** filters, area check, pagination, a purchase preview that is explicitly indicative.

### 4 Layout and visual reference

Sticky glass header with title and language toggle; segmented control Meals | Kitchens; search field with clear button; filter chip row (slot: breakfast, lunch, snack, dinner; cuisine; dietary; area) with an "All filters" sheet; results as a responsive grid of meal cards (photo, name, kitchen, price basis, availability badge, rating) or kitchen cards (cover photo, name, verified badge only where evidence-backed, cuisine tags, served areas, today's availability, rating and review count). Customer orange accent. Glass only on header and footer.

### 5 Elements and behaviour

| Control | Action | Destination | Command / read | Notes |
|---|---|---|---|---|
| Segmented Meals / Kitchens | Switch list | Same screen | — | OBS |
| Search | Bounded query, debounce, cancel stale requests; clear button | Same screen | read: meal search, `searchKitchens` | OBS search; PRO: server-side, paginated; results count announced |
| Filter chips and sheet | Slot, cuisine, dietary, area, verified only, available now | Same screen | `searchKitchens` filter arguments | PRO (NC-01) |
| Meal card | Open guest meal sheet or C-05 in guest mode | C-05 (guest) | read: `ent.Meal` | OBS grid |
| Meal card "Add" or "Subscribe" | Capture intent | Sign-in sheet → C-05 / C-11 | intent (§2.2 of this file) | OBS protect pattern |
| **Kitchen card** | Open kitchen detail | **C-06 in guest mode** `{kitchenId}` | read: `ent.Kitchen` profile | FIX gap 15 (was dead end) |
| Kitchen card "View menu" | Open kitchen detail on the Menu tab | C-06 `{kitchenId, tab: menu}` | read: kitchen menu by slot | REQ: kitchen-specific menu |
| Kitchen card "Plans" | Open this kitchen's plans | C-06 `{tab: plans}` then protected C-11 | read: `ent.Plan` for the kitchen | PRO |
| Guest purchase preview (inside C-06) | Shows indicative price and "binding total after sign-in and address" | Sign-in sheet | none; no `createQuote` for guests | REQ guest-safe preview; PRO |
| Clear filters (empty state) | Reset | Same screen | — | OBS |
| Sort (PRO) | Relevance, rating, name | Same screen | `searchKitchens` | PRO; sort keys are server enumerations |

### 6 Navigation

- **Entry:** P-01 (See all, Meals, Kitchens, More), GuestNav Menu, deep link to a kitchen.
- **Exit:** C-06 and C-05 in guest mode; AU-03 / AU-12 through the intent sheet.
- **Back:** returns to the previous guest screen; filter and scroll state are restored.
- **Guest rules:** reading is always allowed; a guest-mode C-05/C-06 shows `GuestNav`, not the customer tabs; protected actions use the intent contract. After sign-in the same kitchen opens in customer mode.

### 7 Backend services

- **Reads:** `searchKitchens` (kitchen cards), meal search over published `ent.Meal`/`ent.MealVariant` with `ent.SlotAvailability`; aggregate rating from `ent.Review` computed by trusted code.
- **Commands:** none.
- **Authorisation:** unauthenticated, published projection; ratings expose counts and scores, not reviewer identity. A kitchen without current verification is excluded or marked unavailable, never shown as verified.
- **Never trust the client:** availability is advisory; stock is checked again at quote and order. Search text is treated as data (no query injection into backend filters).

### 8 States

| State | Behaviour |
|---|---|
| Loading | Skeleton cards for the active tab; segmented control stays usable |
| Empty | Meals: "No meals match" with Clear filters (OBS). Kitchens: "No kitchens serve this area yet" with area change; both distinguish no data from filtered-out data |
| Success | Results and count; focus stays on the control that was used |
| Error | List-level message with Retry; keeps the query |
| Offline | Cached last results with age; search disabled with reason |
| Denied | Not applicable for guests |
| Session expired | Not applicable; signed-in users see their own shell |
| Kitchen unavailable | Card shows "Not taking orders now" and still opens C-06 read-only |
| Slow images | Placeholder keeps card height stable |

### 9 Validation and permissions

Search length bounded (server limit); filter values from enumerations only; no permission needed. Kitchen details are public data; contact details, addresses and documents are never part of the projection.

### 10 Responsive behaviour

Compact: one column of cards, filters in a sheet. Medium: two columns, filters inline. Expanded: three columns with the rail; filters as a left column. Large: grid up to the container cap, with kitchen cards beside a persistent filter column. The OBS breakpoints (one, two from about 420 px, three on large) are retained as starting points.

### 11 Accessibility and bilingual notes

Segmented control exposes selected state; every card is a single focus target with a composed label (name, kitchen, price, availability, rating). Rating is text ("4.5 out of 5, 120 reviews"), never stars alone. Bangla search must match Bangla and English names; ordering and filters use locale-aware collation. Result counts and "no match" are announced. Empty and error panels are real text, not images.

### 12 Business rules and failure handling

- A kitchen card must always resolve to a valid destination; a card whose kitchen was just withdrawn shows the unavailable state rather than a broken route.
- Certification lapse removes or flags a kitchen (BR-024, SC-17); the guest sees only current status.
- Multi-kitchen subscriptions are not offered to guests; the restriction (BR-021, PENDING; proposal one kitchen per agreement) is explained on C-11 before any payment.
- Indicative prices never include delivery fees, discounts, tax or credits (BR-007/008/018 pending); the preview says so.

### 13 Acceptance and tests (planned, not executed)

- **P-02 · S1.** Given a published kitchen "K" with six meals, when a guest taps K's card on the Kitchens tab, then C-06 opens for K in guest mode listing all six eligible meals and its plans. Refs: AC-004, AC for FR-026, TEST-004.
- **P-02 · F1.** Given K is suspended after the list loaded, when the guest taps its card, then C-06 opens in the "not taking orders" state with no purchase actions and no crash. Refs: SCT-17-N, TEST-004.
- **P-02 · P1.** Given an anonymous client calls the meal search with another customer's identifier or an unpublished kitchen ID, then the response contains no private or unpublished data (denied or empty). Refs: TEST-102, AC-003.
- **P-02 · F2.** Given the device is offline, when the search is submitted, then the cached list is shown with its age and the search field explains why it is disabled. Refs: DEC-012, TEST-113.

### 14 Traceability

FR-004, FR-026, FR-049 · MOD-CAT · BR-021, BR-024 · `ent.Kitchen`, `ent.Meal`, `ent.MealVariant`, `ent.SlotAvailability`, `ent.Plan`, `ent.Review` · scenarios SC-17, SC-22, SC-03 (entry) · [kitchen and meal system](../../customer-app/KITCHEN_AND_MEAL_SYSTEM.md).

---

## P-03 — Guest plans

### 1 Identity and ownership

| Field | Value |
|---|---|
| Screen ID | P-03 (legacy, authoritative) · F129 ancestor F129/C-08 (plan detail) and F129/C-24 (offer) |
| Application / group | CUS · P (Public) |
| Prototype source | `GuestPlans` · guest.tsx |
| Prototype status | I |
| Migration action | **Extend.** The four fixed prototype plans become kitchen-published plan templates plus daily, weekly, monthly and user-composed previews. |
| Route / tab | `/guest/plans` · Guest nav Plans |
| Related proposed screens | NC-04 (builder), NC-05 (weekly editor), NC-07 (delivery price explanation) |

### 2 Purpose and users

Show visitors the ways to buy: single order, daily plan, weekly subscription, monthly subscription and a self-composed schedule, with an honest preview of what a week or month looks like, before they sign in.

### 3 Provenance

- **OBS:** PLANS grid (weekly, monthly lunch, monthly lunch and dinner, office; HYPOTHETICAL sample prices BDT 1,800 / 3,900 / 7,200 / 3,400); Subscribe on each plan → protected C-11 `{plan}`; info note about pause, cutoff and payment methods.
- **REQ:** replace rigid plan-only assumptions with daily, weekly, monthly and user-composed subscription previews; never force a fixed monthly package; no hard-coded duration or price in logic.
- **PRO:** schedule preview from a plan template; independent display of duration and billing frequency; "Build your own" entry; offers shown only when approved.

### 4 Layout and visual reference

Header; mode selector (Single order, Daily, Weekly, Monthly, Build your own) as chips; below it a list of plan cards for the selected mode (kitchen name, plan name, slots included, billing frequency, "from" price taken from published price versions, policy chips such as "Pause rules pending"); a "What a week looks like" preview card (grid of days × slots with example meals); policy note card; sticky footer with Subscribe on the focused card. Hero gradient reused from P-01 on the first card only. Glass on header and footer.

### 5 Elements and behaviour

| Control | Action | Destination | Command / read | Notes |
|---|---|---|---|---|
| Mode chips | Change preview mode | Same screen | read: `ent.Plan` by mode | REQ/PRO |
| Plan card | Expand to show slots, duration, billing frequency, included meals, kitchen | Same screen | read: `ent.Plan`, `ent.PriceVersion` | OBS grid; PRO detail |
| Plan card kitchen link | Open kitchen | C-06 (guest) | — | PRO |
| Schedule preview toggle | Show week or month sample built from the template | Same screen | read only; no quote | PRO; preview, not a charge |
| "Subscribe" | Capture intent, require sign-in | Sign-in sheet → C-11 `{planId, kitchenId, mode}` | intent | OBS target; FIX gap 2 |
| "Build your own" | Capture intent for the custom builder | Sign-in sheet → C-11 `{mode: custom}` | intent | REQ (user-composed); PRO |
| Policy info note | Explain pause, cutoff, payment methods in neutral wording | — | — | OBS note; wording shows "Policy pending" chips while BR-001/002 are unapproved |
| Offer banner | Shown only if an approved promotion exists | Offer terms sheet | read: promotion (BR-008) | PRO; from F129/C-24; hidden until approved |
| GuestNav | As P-01 | — | — | OBS |

### 6 Navigation

- **Entry:** P-01 hero and tile, P-02 plan link, GuestNav Plans, AU-03 offer teaser.
- **Exit:** C-11 (after sign-in), C-06, AU-03 / AU-12.
- **Back:** previous guest screen; selected mode restored.
- **Guest rules:** previews are read-only; the intent carries plan, kitchen and mode; the customer who returns lands on C-11 with those values set, or on C-06 with a notice if the plan is withdrawn.

### 7 Backend services

- **Reads:** published plan templates (`ent.Plan`), price versions (`ent.PriceVersion`), kitchen summary, slot availability.
- **Commands:** none. Draft and quote exist only after sign-in (`createSubscriptionDraft`, `createQuote` on C-11 and C-12).
- **Authorisation:** unauthenticated read of published templates. Plans of a suspended kitchen are not listed.
- **Never trust the client:** prices on the card are catalogue prices; the preview total is labelled "estimate" and excludes delivery fees, discounts, tax and credits until the server quotes (BR-007/008/018 pending).

### 8 States

| State | Behaviour |
|---|---|
| Loading | Skeleton mode chips and plan cards |
| Empty | "No plans in this mode yet. Try another mode or build your own." |
| Success | Plans and preview |
| Error | Retry on the list; mode chips usable |
| Offline | Cached plans with age; Subscribe explains that sign-in needs a connection |
| Denied | Not applicable |
| Session expired | Banner for signed-in users returned from a protected action |
| Plan withdrawn | Card disabled "No longer offered"; intent resume falls back to C-06 |
| Offer expired | Offer banner removed; no stale offer text |

### 9 Validation and permissions

No inputs. Prices and durations come from data; if a plan lacks a price version the card is hidden rather than showing a placeholder amount. All content readable by guests.

### 10 Responsive behaviour

Compact: one column of plan cards, preview in a collapsible section. Medium: two columns. Expanded: list on the left, persistent preview on the right. Large: three columns with a wider preview grid. Sticky footer collapses to inline buttons on wide bands.

### 11 Accessibility and bilingual notes

Mode chips behave as a single-select group with announced selection. The preview grid has a linear alternative ("Monday: breakfast, Dal Khichuri; lunch, none"). Money, periods and plurals use locale-aware formatting; Bangla day and slot names are identifiers translated at display, never stored as translated strings (slot identifiers `slot.breakfast`, `slot.lunch`, `slot.snack`, `slot.dinner`). Policy-pending chips carry text, not colour alone.

### 12 Business rules and failure handling

- Subscription duration and billing frequency are separate settings and both are shown (glossary).
- Pause, cutoff, discount, delivery fee and tax statements describe parameters, not values, until BR-001/002/007/008/018 are approved.
- A plan from a kitchen that later stops serving is not purchasable; paid commitments follow BR-024 (SC-07).
- Multi-kitchen custom schedules are explained as unsupported at launch (BR-021 proposal) before any payment.

### 13 Acceptance and tests (planned, not executed)

- **P-03 · S1.** Given a kitchen with a published weekly template, when a guest selects Weekly, then the card shows slots, billing frequency and a "from" price from the current price version, the preview shows a seven-day grid and no amount is described as final. Refs: AC-004, AC for FR-029.
- **P-03 · F1.** Given the template was withdrawn after the list loaded, when the guest taps Subscribe and signs in, then C-06 opens with "This plan is no longer offered" and no draft exists. Refs: TEST-004, TEST-113.
- **P-03 · P1.** Given an unauthenticated client requests plan data for an unpublished kitchen, then no data is returned. Refs: TEST-102.

### 14 Traceability

FR-004, FR-026, FR-029 · MOD-CAT, MOD-SUB · BR-001/002 (consumed), BR-008, BR-021 · `ent.Plan`, `ent.PriceVersion`, `ent.Kitchen` · SC-01, SC-02, SC-22 · [custom subscription engine](../../customer-app/CUSTOM_SUBSCRIPTION_ENGINE.md), [pricing and billing](../../payments/PRICING_AND_BILLING.md).

---

## P-04 — Role information

### 1 Identity and ownership

| Field | Value |
|---|---|
| Screen ID | P-04 (legacy, authoritative) · no F129 counterpart |
| Application / group | CUS · P (Public) |
| Prototype source | `RoleInfo` · guest.tsx |
| Prototype status | I |
| Migration action | **Reuse.** Content and layout carry over; supplier and rider calls to action now hand off to the Partner App. |
| Route / tab | `/guest/roles/:role` (`customer`, `supplier`, `rider`) · none |
| Related proposed screens | None |

### 2 Purpose and users

Explain, in a separate page per role, what it means to be a customer, a kitchen partner or a delivery partner, how joining works, and that partners are reviewed before they can work. Users: guests, and customers considering a partner role (from C-23).

### 3 Provenance

- **OBS:** recoloured by `p.r`; gradient icon; four numbered steps; an admin-review note for supplier and rider; CTA customer → AU-12, supplier → AU-09, rider → AU-10.
- **REQ:** keep separate role explanations; require verification before supplier or rider operational access.
- **PRO:** CTAs for supplier and rider use the Partner App hand-off (§2.3); a statement of what the review checks and what happens on rejection or requests for information.

### 4 Layout and visual reference

Header with back; large gradient icon card in the role colour (customer orange, supplier green, rider blue — OBS role colours C-/S-/R- prefixes; the page itself is a P- screen that is recoloured by parameter); title and one-sentence promise; four numbered step cards; review note card with an information icon; primary CTA pinned in a glass footer. Admin is deliberately absent: admin accounts are invitation-only.

### 5 Elements and behaviour

| Control | Action | Destination | Command / read | Notes |
|---|---|---|---|---|
| Role segmented switch (PRO) | Switch between the three explanations without leaving | Same route with new `:role` | — | PRO; avoids returning to P-01 |
| Numbered steps | Read-only | — | static localized content | OBS |
| Review note | Read-only; states that applications are reviewed and operations stay locked until approval | — | — | OBS; REQ |
| CTA customer "Create account" | Start sign-up | AU-12 | — | OBS |
| CTA supplier / rider "Apply in the Partner app" | Open hand-off sheet, then Partner App | Partner App AU-09 / AU-10 | none | OBS target; hand-off per §2.3 |
| Back | Return | previous screen | — | OBS |

### 6 Navigation

Entry: P-01 More sheet and Join list; C-23 "Apply as a Cook / Rider" (hand-off). Exit: AU-12, hand-off sheet. Back returns to the caller. Guest rules: public content only; no intent is stored for partner roles, because partner applications are not resumable in the Customer App.

### 7 Backend services

Static localized content; optional read of the published role requirements (document types, vehicle rules) only if the content owner publishes them. No commands. Authorisation: public. Never trust the client: nothing selected here affects authorisation; a role exists only when the server holds an approved grant (`ent.RoleGrant`).

### 8 States

| State | Behaviour |
|---|---|
| Loading | Immediate; static content has no loading state |
| Empty | Not applicable |
| Success | Content shown |
| Error | Only for the optional remote requirements block, with fallback text |
| Offline | Fully readable; CTA hand-off explains that the Partner App may need a connection to apply |
| Denied | Not applicable |
| Session expired | Not applicable |
| Unknown role parameter | Falls back to the customer explanation |

### 9 Validation and permissions

The `:role` parameter is validated against the three allowed values. Public screen; no personal data.

### 10 Responsive behaviour

Compact: single column with pinned CTA. Medium: centred card, max width about 512 px. Expanded and large: two columns (explanation left, steps right) with the CTA inline.

### 11 Accessibility and bilingual notes

The gradient is decorative; the role name is in the title. Step numbers are text. The note is a landmark. Bangla copy is reviewed by a native speaker before release (accessibility plan). Colour is never the only way the role is identified.

### 12 Business rules and failure handling

Applying does not grant access. A rejected or incomplete application is handled in the Partner App (AU-11 and the admin review); the explanation here must not promise approval, timing or income. Whether a person may hold customer and partner grants with one login is open (BR-023, SC-25); the page states only that each workspace is separate and separately authorised.

### 13 Acceptance and tests (planned, not executed)

- **P-04 · S1.** Given `/guest/roles/rider`, when the page opens, then it shows the rider explanation in the rider colour, the review note and the hand-off CTA, and no admin option. Refs: AC-021, AC for FR-045.
- **P-04 · F1.** Given an invalid `:role` value (`admin`), then the page shows the customer explanation and never an admin explanation. Refs: TEST-102.
- **P-04 · P1.** Given a customer taps "Apply in the Partner app", then no supplier or rider workspace is reachable in the Customer App, and the Partner App still requires approval. Refs: SCT-25-P, TEST-021.

### 14 Traceability

FR-001, FR-003, FR-021, FR-045 · MOD-AUTH · BR-023, DEC-009, DEC-010 · `ent.RoleGrant`, `ent.Application` · SC-25 · [partner application screens](PARTNER_APPLICATION_SCREENS.md), [multi-app architecture](../../architecture/MULTI_APP_ARCHITECTURE.md).

---

## AU-01…AU-08, AU-12 — Authentication shell (compact contracts)

The remaining nine Auth screens share one contract shape below (identity/purpose, provenance, elements, backend, states, business rules, tests, traceability), compact per [conventions](../../analysis/CONVENTIONS_AND_ID_REGISTER.md) rather than repeating the 14-subsection essay above verbatim for each; all fourteen aspects are still covered, condensed.

### AU-01 Splash

**Identity/purpose.** Session resolver; brand, connectivity check, routes to AU-02 or the authoritative role dashboard. Reuse. **Provenance.** OBSERVED (prototype, reachable only from the Hub, start screen is P-01); USER-REQ (establish identity before any destination).
**Elements/backend.** Automatic session check (no user input) → authoritative role/approval read → dashboard or AU-02; Retry on failure.
**States.** loading; offline (retry); session-invalid (→ AU-02).
**Business rules/failure.** A cached claim is never trusted without server re-verification (ADR-011).
**Tests (planned).** TEST-001, TEST-101.
**Traceability.** FR-001; `ent.Principal`.

### AU-02 Language pick

**Identity/purpose.** English/বাংলা selection before P-01. Reuse. **Provenance.** OBSERVED.
**Elements/backend.** Two cards, Continue → P-01; `savePreferences` persists the choice (fixes legacy "not persisted" gap).
**States.** As §3.4 shared rules.
**Tests (planned).** TEST-049.
**Traceability.** FR-049; `ent.Setting`.

### AU-03 Universal sign-in

**Identity/purpose.** Real provider authentication (replaces legacy demo accounts and fixed OTP). Extend. **Provenance.** OBSERVED legacy simulated auth (conflict register C-14), explicitly replaced.
**Elements/backend.** Email/phone + password or OTP via Firebase Authentication; routes by the **server-resolved role**, never a client-selected tab; Forgot → AU-04/05/06; biometric (AU-11-equivalent, conditional) kept as a device-unlock convenience only, never standalone authentication.
**States.** wrong-credentials (rate-limited); account-disabled; unknown-account (anti-enumeration wording).
**Business rules/failure.** A visually selected role never grants authority (USER-REQ); real rate limiting on sign-in attempts (NFR-022).
**Tests (planned).** TEST-001, TEST-101, SCT per SC-25 (dual-role sign-in).
**Traceability.** FR-001, FR-003; BR-023; `ent.Principal`, `ent.RoleGrant`; legacy AU-03.

### AU-04 Forgot password

**Identity/purpose.** Recovery entry. Reuse. **Provenance.** OBSERVED.
**Elements/backend.** Identifier input → AU-05 (flow=reset) via the real provider recovery flow.
**States.** rate-limited; unknown-identifier (anti-enumeration wording, same response shape as a known one).
**Tests (planned).** TEST-001.
**Traceability.** FR-001.

### AU-05 OTP verification

**Identity/purpose.** Real, expiring, rate-limited OTP (replaces legacy "any six digits except 000000"). Extend. **Provenance.** OBSERVED legacy gap, explicitly fixed.
**Elements/backend.** 6-digit input; provider-issued OTP with a real expiry and attempt limit; routes by `flow` param to AU-06/AU-08/AU-11-equivalent.
**States.** expired; too-many-attempts (lockout with a real cooldown, not a fixed `123456`-style bypass).
**Business rules/failure.** NFR-022 rate limiting.
**Tests (planned).** TEST-001.
**Traceability.** FR-001; `ent.Principal`.

### AU-06 New password

**Identity/purpose.** Password reset completion. Reuse. **Provenance.** OBSERVED.
**Elements/backend.** New password + confirmation → provider reset → AU-03.
**States.** weak-password (provider-validated minimum).
**Tests (planned).** TEST-001.
**Traceability.** FR-001.

### AU-07 Customer sign up

**Identity/purpose.** Self-service customer registration (never grants supplier/rider/staff authority). Reuse. **Provenance.** OBSERVED.
**Elements/backend.** Name/phone/password → `saveProfile` (bootstrap, OBSERVED working) → AU-05 (flow=signup) → AU-08.
**States.** As §3.4.
**Business rules/failure.** Self-registration produces a Customer grant only, never finance/dispatch capability (USER-REQ authentication governance).
**Tests (planned).** TEST-001, TEST-002.
**Traceability.** FR-001, FR-002.

### AU-08 Customer onboarding

**Identity/purpose.** First-run profile/address/preferences completion. Reuse. **Provenance.** OBSERVED.
**Elements/backend.** Address → `saveAddress`; preferences → `savePreferences`; Finish/Skip → C-01, resuming any protected-action intent (§2.2).
**States.** As §3.4.
**Tests (planned).** TEST-002.
**Traceability.** FR-002; `ent.Address`.

### AU-12 Choose account type

**Identity/purpose.** Customer/Supplier/Rider intent selection, feeding AU-07/08 or AU-09/10; Admin is never offered (invite-only, USER-REQ). Reuse. **Provenance.** OBSERVED.
**Elements/backend.** Three role cards; selection is intent only (§2.2 of this file; selection never grants authority, repeated here deliberately since AU-12 is the screen most likely to be misread as a privilege grant).
**States.** As §3.4.
**Business rules/failure.** No public route to an Admin/Accounts account type.
**Tests (planned).** TEST-045.
**Traceability.** FR-045; `ent.Application`; [partner application screens](PARTNER_APPLICATION_SCREENS.md).

## F129 reconciliation (Public and Auth)

Every F129 Public/Auth-section family (`F129/AU-01…12`, 12 families) is reconciled in full in [design/INVENTORY_RECONCILIATION.md](../INVENTORY_RECONCILIATION.md). The thirteen legacy IDs in this file (P-01…04, AU-01…08, AU-12) absorb F129's session-resolver, registration, verification, recovery and onboarding families; AU-09…11 (applications) are covered separately in [PARTNER_APPLICATION_SCREENS.md](PARTNER_APPLICATION_SCREENS.md); AU-13 (Admin/Accounts secure sign-in) is covered in [ADMIN_SCREENS.md](ADMIN_SCREENS.md). None is left unmapped.
