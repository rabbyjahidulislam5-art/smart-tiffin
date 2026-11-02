> **HISTORICAL — superseded 2026-10-30.** This is the original 129-family planning inventory, written before the legacy 94-screen React prototype was supplied as a primary source. Its IDs are cited elsewhere as `F129/<id>` to avoid collision with the now-authoritative legacy prototype IDs. See [design/COMPLETE_SCREEN_INVENTORY.md](COMPLETE_SCREEN_INVENTORY.md) (the current 149-screen authority) and [design/INVENTORY_RECONCILIATION.md](INVENTORY_RECONCILIATION.md) (the full family-by-family reconciliation proving nothing here is lost). Kept unchanged below as the historical record.

# Complete planned screen inventory

2026-10-30 · **Planning inventory, not completed visual designs or implemented routes.** Scope is the available local requirements plus the supplied screenshots; reconciliation with the missing original Markdown remains open.

Each row is a distinct page, sheet or dialog requiring a visual output. IDs are stable. Related record-detail instances share one layout with multiple tested fixtures. R1 = first release, C = conditional screenshot/support extension, L = later-release design. A policy-dependent R1 screen stays required even while implementation is blocked. The controls below plus the [shared interaction contracts](UI_UX_GUIDELINES.md) form the button-to-action-to-destination specification. Dashboard source controls are separately itemized in [the screenshot audit](SCREENSHOT_ACTION_AUDIT.md).

Every page inherits loading, empty, error/retry, success, disabled-with-reason, offline/stale, access-denied and session-expired designs where meaningful; non-data dialogs document non-applicable states. Forms additionally require invalid input, dirty exit, saving, duplicate tap and outcome-unknown. Lists require pagination/end, refresh and no filter matches. No generic blank page can stand in for these states. Role-scoped shared pages must be rendered in each role theme/context.

## Authentication and onboarding

| ID | Screen / layout and required information | Controls → behavior / destination | Scope / gate |
|---|---|---|---|
| AU-01 | Session resolver; brand, real connectivity, access decision | Automatic validated session → own dashboard or AU-02; retry; language → SH-05 | R1 FR-001/003 |
| AU-02 | Sign-in; brand, role intent, provider choices, form, terms, offer | Back → AU-01 entry; role tabs change intent only; email/phone method; clear input; reveal password; remember-session preference; login → AU-01; forgot → AU-05; Google → provider then AU-01; biometric → AU-11; sign up → AU-03; offer → C-24; terms/hygiene → SH-09 | R1 + conditional providers, DEC-009 |
| AU-03 | Registration; Customer/Supplier/Rider intent, identity/contact and consent | Edit inputs; reveal password; terms → SH-09; submit → AU-04 or AU-08; existing account → AU-02; cancel/back | R1; no public Admin grant |
| AU-04 | Identity verification; masked destination, status and expiry | Enter code or check email state; verify → AU-07/AU-08; resend with real limit; change contact → AU-03; cancel | R1, provider-dependent |
| AU-05 | Recovery; chosen account method, anti-enumeration feedback | Submit recovery → AU-06; alternate configured provider → AU-02; back | R1 DEC-009 |
| AU-06 | Recovery confirmation/reset; instructions or secure reset form | Recheck; resend if allowed; new password/confirmation; submit; return → AU-02 | R1; provider owns reset validation |
| AU-07 | Customer setup; name, language, address and preferences | Save → C-01; address → C-02/C-03; language → SH-05; skip optional data | R1 FR-002 |
| AU-08 | Supplier/Rider application; kitchen or vehicle/contact fields | Edit; document requirements → AU-09; save draft; submit → AU-10; back/discard → SH-16 | C details, FR-021/DEC-009 |
| AU-09 | Application evidence; required items, purpose and retention | Add/replace/remove approved file types with confirmation; view; submit → AU-10; errors preserve draft | C, evidence/privacy policy |
| AU-10 | Application pending/rejected/needs-information | Refresh status; correct requested details → AU-08/09; contact → SH-10; sign out → SH-16 | R1 onboarding, DEC-009 |
| AU-11 | Biometric setup/unlock; device support, account binding | Enable/unlock via OS challenge; failure → provider login AU-02; opt out; disable in SH-06 | C UX-02 |
| AU-12 | Wrong-role, disabled account, expired/revoked access | Explain without private details; switch account → AU-02; support → SH-10; retry authorization | R1 FR-001/003 |

## Shared pages and overlays

| ID | Screen / layout and required information | Controls → behavior / destination | Scope / gate |
|---|---|---|---|
| SH-01 | Notification inbox; unread indicators, time and safe preview | Open → SH-02; unread/all filter → SH-19; mark read; preferences → SH-04 | R1 FR-025, DEC-015 |
| SH-02 | Notification detail; message and resource availability | View related authorized entity → originating role detail; missing/revoked destination → SH-15; back | R1 FR-025 |
| SH-03 | Account settings; language, notification, security, privacy, support | Rows → SH-04/05/06/09/10/12/13; sign out → SH-16 | R1 supporting |
| SH-04 | Notification preferences; categories and OS permission status | Toggle permitted categories; save; open OS settings by user action; back | R1 DEC-015 |
| SH-05 | Language chooser; English/বাংলা examples | Select preview; apply to active route; preserve draft and navigation state; cancel | R1 DEC-002 |
| SH-06 | Security; provider, email/phone, password, biometrics and sessions | Reauthenticate → SH-07; update credential via provider; biometric → AU-11; sessions → SH-08 | R1; biometrics C |
| SH-07 | Reauthentication; reason, configured provider challenge | Authenticate → original sensitive action; cancel → source; expired result → AU-02 | R1 FR-001 |
| SH-08 | Session/device access; known sessions if supported | Revoke selected/other sessions → SH-16; refresh; back; unsupported provider capability explained | C DEC-009 |
| SH-09 | Terms/privacy/hygiene/about content; version and language | Tabs/contents; safe external links; back; no fabricated legal/food-safety assurances | R1 supporting; content owner |
| SH-10 | Help and support; categories, contact channels, own cases | FAQ → SH-11; contact → SH-17; own complaints → C-22 or role-scoped SH-14; report → C-21/SH-14 | R1 FR-023; channels C |
| SH-11 | Help article; structured answer and relevant actions | Related article; contact → SH-17; relevant authorized route; back | R1 supporting |
| SH-12 | Privacy and data request; purpose, retained-data explanation | Request export/deletion → SH-13; consent preferences if applicable; policy → SH-09 | C DEC-010 |
| SH-13 | Account closure/data request; impact, identity challenge, status | Reauthenticate → SH-07; confirm → SH-16; submit → SH-18; view request status; no immediate erase assumption | C retention policy |
| SH-14 | Role-scoped support case; subject, context, messages/outcome | Submit/update own case if allowed; contact → SH-17; refresh; back | R1/C DEC-013 |
| SH-15 | Missing/forbidden destination; safe explanation | Return to own role home; sign in if expired; support → SH-10; retry permission check | R1 routing |
| SH-16 | Confirmation / unsaved-exit dialog; action, consequence, reason where required | Confirm invokes authorized originating operation; cancel restores original state; never generic success before acknowledgment | R1 shared overlay |
| SH-17 | Contact sheet; intended party, channel, permitted contact fields | User-initiated phone handoff; approved messaging handoff → X-04 if selected; copy authorized contact; cancel; unavailable channel recovery | C UX-06 |
| SH-18 | Operation outcome; success/rejected/unknown, reference and next step | Reconcile unknown with request ID; retry only safely; view result entity; return; support | R1 shared overlay |
| SH-19 | Search/filter/sort sheet; current applied filters and accessible selections | Search; select; clear/reset; apply → originating collection; cancel preserves prior filters | R1 shared overlay |
| SH-20 | Date/range/meal-slot chooser; service calendar and eligibility | Previous/next period; date/slot select; disabled reason; apply → source; cancel | R1 shared overlay, BR-dependent eligibility |

## Customer

| ID | Screen / layout and required information | Controls → behavior / destination | Scope / gate |
|---|---|---|---|
| C-01 | Home; address, greeting, active plan, progress, delivery, routine, special menu | Address → C-02; bells → SH-01; avatar → C-23; plan/calendar → C-13/14; pause → C-15; delivery → C-18; meal → C-17; modify → C-16; See All/categories → C-04; food → C-06; Subscribe → C-08; bottom tabs → C-01/12/17/23 | R1 dashboard |
| C-02 | Address book/chooser; labelled addresses, current selection, service area | Select → caller; add/edit → C-03; remove → SH-16; back | R1 FR-002/007 |
| C-03 | Address form; recipient, phone, area, street, building/unit, delivery note | Validate required fields; save → C-02; cancel/dirty exit; serviceability error; no GPS permission requirement | R1 FR-002/007 |
| C-04 | Explore plans/meals; daily/weekly/monthly tabs, category chips and search | Search/filter → SH-19; cards → C-06/C-08; supplier → C-07; weekly menu → C-05; load more | R1 FR-004/005 |
| C-05 | Daily/weekly menu calendar; date, supplier, meals and missing-menu state | Date/week → SH-20; meal → C-06; plan → C-08; supplier → C-07 | R1 FR-005 |
| C-06 | Food detail; image, name, supplier, attributed ingredients/allergens, availability, reviews, price | Quantity; eligible date/slot → SH-20; order → C-09; subscribe → C-08; supplier → C-07; reviews → C-20 | R1 FR-004/007/011 |
| C-07 | Public kitchen detail; published identity, supported area, menus, evidence-backed badges and reviews | Menus → C-05; food → C-06; packages → C-08; reviews → C-20; back | R1/C verification claims |
| C-08 | Plan/package detail; daily/weekly/monthly terms, slots, dates, price basis and policy disclosure | Choose eligible date/slots → SH-20; menu → C-05; subscribe/order → C-09; policies → SH-09 | R1 FR-004/006; BR-002 |
| C-09 | Order/subscription configuration; selected items/quantities, start/service dates, slots, notes | Edit/remove item → C-06/SH-16; choose dates → SH-20; address → C-02; continue → C-10 | R1 FR-006/007; BR-002 |
| C-10 | Checkout review; authoritative quote, address snapshot, fees if approved, service and payment terms | Edit sections → C-09/C-02; confirm → SH-18 then C-11; changed quote requires review; payment reference later → C-25 | R1 FR-006/007/012/013; BR-002/003/005 |
| C-11 | Order/subscription confirmation; committed ID, schedule and payment truth | View order → C-17; subscription → C-13; bill → C-26; continue browsing → C-04 | R1; only committed result |
| C-12 | Subscriptions; active/upcoming/past with plan and service interval | Card → C-13; browse → C-04; filter → SH-19; home tab | R1 FR-006 |
| C-13 | Subscription detail; accepted terms, schedule, remaining obligations, pauses and bill | Calendar → C-14; pause → C-15; routine change → C-16; bill → C-26; cancellation request → C-28; contact → SH-17 | R1; BR-001/002/005 |
| C-14 | Plan calendar; date/slot states and scheduled meals | Period navigation; meal → C-17/C-06; select pause dates → C-15; legend/detail; return | R1 FR-006/008 |
| C-15 | Pause form/review/result; eligible dates/slots, reasons and actual financial effect | Select → SH-20; review → SH-16; submit → SH-18; return calendar; reversal only if approved | R1 FR-008, BR-001/002 |
| C-16 | Routine/change request; current lunch/dinner, applicable schedule and limits | Select item/date → C-05/SH-20; review consequence; submit → SH-18; back; no silent historic order edit | C UX-03; policy decision |
| C-17 | Orders and order-detail layout; segmented list, item/address snapshots, preparation/delivery/payment history | Select order/detail; filters → SH-19; track → C-18; bill → C-26; review → C-19; complaint → C-21; cancel → C-28; contact → SH-17 | R1 FR-007/009; list/detail require separate captures |
| C-18 | Delivery tracking; four canonical states, update time, kitchen/rider and schedule | Refresh; order → C-17; call/message → SH-17; issue → C-21; live-map proposal → X-01 in design appendix only | R1 FR-010; GPS L |
| C-19 | Review form/result; eligible order, rating and text, visibility explanation | Rate; edit text; submit → SH-18 then C-20; edit existing only if permitted; cancel | R1 FR-011, DEC-013 |
| C-20 | Review list/detail; supplier/order context and moderation state | Filter → SH-19; own review → C-19; related food → C-06; report → C-21 if allowed | R1 FR-011, DEC-013 |
| C-21 | Complaint form; own service/billing context, category, description | Select related record; submit → C-22 via SH-18; cancel; attachments only if approved | R1 FR-023 |
| C-22 | Complaint list/detail; case ID, updates, decision and next action | Open case; filter; add allowed information; contact → SH-17; related order → C-17; list/detail separate captures | R1 FR-023 |
| C-23 | Profile; personal summary, address, bills, reviews, support and settings | Edit → C-29; addresses → C-02; bills → C-26; reviews → C-20; support → SH-10; settings → SH-03; sign out → SH-16 | R1 FR-002 |
| C-24 | Offer detail; real eligibility, terms, validity and related package | View eligible plan → C-08; terms → SH-09; sign in → AU-02; no invented 20% offer | C UX-16; discounts L |
| C-25 | Payment reference form/detail; bill, bKash/Nagad, independent-verification explanation | Select provider; input reference/approved evidence fields; submit → SH-18; view status/history; resubmit only if allowed; bill → C-26 | R1 FR-013; no gateway or PIN/OTP |
| C-26 | Bill list/detail; period, itemized charges, adjustments, verified paid/outstanding | Period → SH-20; open statement; reference → C-25; payment history → C-27; dispute → C-21; separate list/detail captures | R1 FR-012, BR-002/003/005 |
| C-27 | Payment history/detail; claim/verification/allocation timeline | Filter; record → C-25; related bill → C-26; dispute → C-21; no pending-as-paid | R1 FR-012/013 |
| C-28 | Cancellation/refund request and status; affected obligations, policy and financial consequences | Request/reason; review → SH-16; submit → SH-18; status; complaint → C-21; not automatic refund | R1 dependent behavior, BR-005 |
| C-29 | Profile edit; name/contact and provider-owned identity fields | Save own permitted fields → C-23; credential change → SH-06; dirty exit → SH-16 | R1 FR-002 |

## Supplier / Cook

| ID | Screen / layout and required information | Controls → behavior / destination | Scope / gate |
|---|---|---|---|
| S-01 | Kitchen dashboard; identity, accepting status, order/earnings metrics, demand, preparation, requests and stock | Kitchen → S-19; notifications → SH-01; availability → S-16; orders → S-10; earnings → S-17; cooking → S-13; accept/decline → S-11/12; Edit Full → S-02; bottom tabs S-01/02/10/17 | R1 + UX-07/08 |
| S-02 | Menu/catalog management; foods/menus/plans, availability, draft/published | Add food → S-03; food → S-04; menus → S-05; packages → S-07; stock → S-09; search/filter | R1 FR-014/015 |
| S-03 | Food create/edit; bilingual name/description, image, approved price, dietary info | Upload/remove approved asset; validate; save draft; publish review → SH-16; cancel | R1 FR-014; price BR-002 |
| S-04 | Food management detail; public preview, version and availability | Edit → S-03; toggle availability with acknowledged result; stock → S-09; archive → SH-16; preview → C-06 read-only context | R1 FR-014/015 |
| S-05 | Daily/weekly menu schedule; service dates and publication state | Date → SH-20; create/edit → S-06; preview; publish/unpublish → SH-16 | R1 FR-014 |
| S-06 | Menu editor; date/slot, chosen foods, capacity if approved | Add/remove/reorder food; save draft; review/publish → SH-16; dirty exit | R1 FR-014; capacity C |
| S-07 | Package list/detail; daily/weekly/monthly offerings, accepted version boundary | Create/edit → S-08; archive → SH-16; public preview → C-08; filter | R1 FR-014 |
| S-08 | Package editor; bilingual terms, service coverage, approved pricing | Select menu/dates; save draft; validate/publish; do not rewrite accepted subscriptions | R1 FR-014, BR-002 |
| S-09 | Stock/availability editor; per-item service date, available status, quantity if approved | Toggle; quantity edit with version check; sold-out/restock action; save; conflict refresh | R1 boolean / C quantity |
| S-10 | Orders list; incoming/accepted/preparing/ready/history as approved | Filter/date; detail → S-11; accept → S-11 review; decline → S-12; refresh | R1 FR-017, DEC-014 |
| S-11 | Order detail/acceptance; items, quantities, notes, safe payment summary, readiness and schedule | Accept → SH-16/18; decline → S-12; preparation → S-14; handoff → S-15; contact → SH-17; incident → SH-14 | R1 FR-017 |
| S-12 | Decline/refusal form; reason and explicit operational/financial consequence | Select reason; review; confirm trusted command; return → S-10; no automatic refund | C/FR-017, DEC-014, BR-005 |
| S-13 | Cooking requirements; date/slot totals, portions by item, exclusion/freshness explanation | Date/slot → SH-20; batch → S-14; relevant subscription → S-20; order → S-11 | R1 FR-016 |
| S-14 | Batch preparation; checklist/quantities and approved stage progression | Mark approved transition with confirmation; inspect orders → S-11; packed/handoff → S-15; stale conflict refresh | R1 FR-017, DEC-014 |
| S-15 | Rider handoff; prepared orders, current permitted assignment and evidence | Confirm handoff only under approved contract; call rider → SH-17; report → SH-14; back | R1/C BR-004, DEC-014 |
| S-16 | Accepting orders / schedule settings; service windows and capacity | Duty/availability toggle; edit allowed windows; save; disclose effect on existing orders | C UX-07; not automatic cancellation |
| S-17 | Earnings overview; period, approved basis, verified versus pending, history | Period → SH-20; entry → S-18; payout explanation → X-03 if later design; back | R1 FR-018, BR-002/003 |
| S-18 | Earning/payment entry detail; source obligation, allocations and adjustment audit | Source order → S-11; dispute → SH-14; refresh; no settlement claim without evidence | R1 FR-018 |
| S-19 | Kitchen profile/settings; public details, private application status, service area | Edit own permitted fields; verification → AU-09/10; operating settings → S-16; account → SH-03; reviews → S-22 | R1/C FR-002/021 |
| S-20 | Supplier subscriptions; eligible commitments, service dates and demand links | Filter; detail → S-21; cooking → S-13 | R1 FR-016 |
| S-21 | Subscription service detail; required slots, exclusions and safe customer context | Calendar navigation; affected meal → S-11; cooking → S-13; contact → SH-17; no own billing edits | R1 FR-016 |
| S-22 | Supplier reviews; permitted customer feedback and moderation visibility | Filter; review detail; report → SH-14; response only if policy permits | C/FR-011, DEC-013 |

## Delivery Rider

| ID | Screen / layout and required information | Controls → behavior / destination | Scope / gate |
|---|---|---|---|
| R-01 | Active deliveries dashboard; duty, assignment queue, progress, actual earnings if approved | Duty → R-11; SOS → R-08; bells → SH-01; avatar → R-10; counts → R-01/R-09; job/queue → R-02; earnings → R-12; map controls → X-01/X-02 in later designs | R1 FR-019 + extensions |
| R-02 | Assignment detail; pickup/dropoff, window, items, notes, safe payment summary and state | Call kitchen/customer/message → SH-17; pickup → R-03; start route → R-04; arrived/deliver → R-05; report → R-07; next job → R-02 different record | R1 FR-019/020, BR-004 |
| R-03 | Pickup confirmation; current assignment, kitchen and item handoff | Confirm Picked Up → SH-18; missing food → R-07; contact → SH-17; cancel | R1 FR-020, handoff policy |
| R-04 | En-route status; address, schedule, latest authoritative state | Confirm On The Way; external directions only if approved; delivery → R-05; report → R-07; no fake GPS | R1 FR-020 |
| R-05 | Delivery completion review; correct recipient/order and approved evidence | Confirm Delivered → R-06 via server; evidence fields only if required; cannot deliver wrong/stale assignment; issue → R-07 | R1 FR-020, BR-004 |
| R-06 | Delivery result; confirmed timestamp, job reference, remaining queue | Next → R-02; history → R-09; home → R-01; unknown result → SH-18 instead of success | R1 FR-020 |
| R-07 | Incident/delay form and status; category, affected job, reason | Submit → SH-18; contact → SH-17; view incident updates; no arbitrary state rollback | R1/C DEC-014 |
| R-08 | Safety/SOS sheet; approved emergency/support contacts and user choice | Dial confirmed contact via OS; report → R-07; cancel; cannot claim emergency dispatch | C UX-10; real service required |
| R-09 | Delivery history and detail; own retained minimal records, outcome/date | Filter/date; select record → privacy-reduced R-02; summary; no retained address by default | R1 supporting/retention |
| R-10 | Rider profile/edit; identity, permitted vehicle/contact, application state | Edit permitted fields; save; documents → AU-09/10; settings → SH-03; sign out → SH-16 | R1/C FR-002 |
| R-11 | Duty/availability; status, permitted shift/area fields and effect | Toggle; edit schedule; confirm; explain existing assignment obligations | C UX-09, BR-004 |
| R-12 | Rider earnings/history; approved earning basis and recorded payout distinction | Period; entry detail; dispute → SH-14; no sample income presented as real | C UX-09, BR-002 |

## Administration

| ID | Screen / layout and required information | Controls → behavior / destination | Scope / gate |
|---|---|---|---|
| A-01 | Executive overview; permission-aware metrics, incidents, onboarding and reports | Users → A-02; cooks → A-04; fleet → A-07; revenue → A-16; incidents → A-12; onboarding → A-05; notifications → SH-01; profile → A-27; treasury → X-03; nav → A-01/02/09/20 | R1 + operational/treasury extensions |
| A-02 | Users & Cooks directory; tabs for customer/supplier/rider, status and bounded search | Search/filter → SH-19; person → A-03; supplier → A-05; rider → A-08; add/invite only approved policy | R1 FR-021 |
| A-03 | User detail; permitted account/profile, role/status and audit | Approved role/status action → A-21; service history → A-09; complaints → A-14; contact → SH-17 | R1 FR-021, DEC-009 |
| A-04 | Supplier onboarding queue; age/status and required checks | Filter; application → A-05; prioritize → A-06; no automatic fast-track approval | R1 FR-021 |
| A-05 | Supplier dossier; business profile, submitted documents, check results and reason history | Audit docs → A-06; approve/reject/request info → A-06; contact → SH-17; safe document view | R1/C evidence requirements |
| A-06 | Verification review/decision; check evidence, missing items and audit reason | Inspect document; record permitted check; approve/reject/request info → SH-16/18; priority review cannot skip checks | R1 FR-021 + UX-11 |
| A-07 | Rider directory/fleet; status, assigned load and approved eligibility | Filter; rider → A-08; assignment → A-11 if granted; invite/approval → A-21 | R1 FR-021; dispatch BR-004 |
| A-08 | Rider detail; account, permitted operational profile, assignments and incidents | Account action → A-21; assignment → A-11; job → A-10; incident → A-13; contact → SH-17 | R1 FR-021 |
| A-09 | Order monitoring; bounded date/state/supplier/rider filters | Filter → SH-19/20; detail → A-10; incident → A-13; export only approved permission | R1 FR-022 |
| A-10 | Administrative order detail; preparation/delivery/payment, accepted snapshots and history | Assignment → A-11 if allowed; incident → A-13; bill → A-17; complaint → A-15; no generic edit-state button | R1 FR-022 |
| A-11 | Assignment/reassignment review; eligible riders, current custody and reason | Select; verify conflict/version; confirm → SH-16/18; no eligible rider recovery; old access revoked | R1 dependent FR-019/020; BR-004 authority unresolved |
| A-12 | Incident log; urgency, age, status and relevant job | Filter; details → A-13; bounded refresh; back | R1/C FR-022/023 |
| A-13 | Incident detail/resolution; event timeline, evidence, current assignment | Dispatch backup → A-11 if allowed; contact → SH-17; record approved resolution; complaint/adjustment → A-15/A-19 | R1/C BR-004/005 |
| A-14 | Complaints/disputes queue; category, age, owner and current state | Filter; detail → A-15; allocate handler only if granted | R1 FR-023 |
| A-15 | Complaint detail/resolution; submissions, context, privacy and decision | Request information; record outcome → SH-16/18; replacement-credit review → A-19; call cook → SH-17 | R1 FR-023; BR-002/005 |
| A-16 | Revenue report; chosen period and basis, verified receipts, due and adjustments | Period → SH-20; drill-down → A-17; export → A-18; no fictional uptime/income | R1 FR-024 |
| A-17 | Financial record detail; statement/entry and immutable audit lineage | Payment claims → A-22; order → A-10; adjustment review → A-19; export → A-18 if allowed | R1 FR-012/024 |
| A-18 | Export review/result; date/filter scope, fields, sensitivity and delivery result | Select approved fields; generate; download/share by user action; expiry/error; CSV injection-safe values | C UX-15 |
| A-19 | Adjustment/cancellation/refund decision; request, policy basis and independent approval/evidence | Review; approve/reject only with explicit permission; record external completion separately; confirm → SH-16/18 | R1 dependent BR-002/003/005 |
| A-20 | Administration settings; platform/read-only policy versions and own account | Policy register display; operational settings → A-24; own profile → A-27; account settings → SH-03; audit → A-23; catalog oversight → A-25; review moderation → A-26; escrow → X-03 later | R1/C; no generic policy editor default |
| A-21 | Role/status/invitation decision; target, authority, impact and reason | Review allowed grants/revocation; confirm → SH-16/18; prevent self-escalation; contact → SH-17 | R1 FR-003/021, DEC-009 |
| A-22 | Payment verification queue/detail; claim and independent receiving-account evidence | Filter; review checks; verify/reject/correct only approved verifier; confirm; source bill → A-17 | R1 FR-013; placement does not grant authority |
| A-23 | Audit log/detail; actor, operation, target, safe before/after, timestamp | Filter; event detail; permitted target link; export → A-18; no log mutation | R1 security supporting |
| A-24 | Operational status/configuration; observed service status, schedules, notification settings | Refresh measured status; approved config edits with audit; history → A-23; unavailable telemetry explained | C UX-15; monitoring owner |
| A-25 | Catalog oversight; supplier foods/plans/publication and complaint context | Filter; inspect → read-only S-04/S-07; permitted moderation with reason → SH-16; no assumed pricing overwrite | C admin completeness |
| A-26 | Review moderation; reported feedback, visibility policy and decision history | Filter; detail; permitted hide/restore decision with reason; complaint → A-15 | R1/C FR-011, DEC-013 |
| A-27 | Own Admin profile/view/edit; name, contact, authoritative role and account context | Edit permitted own fields; save; identity changes → SH-06; account settings → SH-03; sign out → SH-16; role display never editable here | R1 FR-002; view/edit separate captures |

## Later-release designs retained from screenshot controls

These are complete design obligations after scope approval, but do not imply enabled R1 routes or integrations. The appendix must visibly say “Later-release proposal”. Do not expose inert production buttons to these pages and call that functional completion.

| ID | Screen / layout and required information | Controls → behavior / destination | Scope / gate |
|---|---|---|---|
| X-01 | Live map; location freshness/accuracy, rider route and privacy | Recenter; zoom; open job; start directions → X-02; permission/offline/stale/no-signal designs | L GPS provider/consent |
| X-02 | Turn-by-turn directions; route, maneuvers and destination | Start/stop navigation; reroute; audio; return; actual navigation provider required | L routing integration |
| X-03 | Treasury/escrow overview plus batch/detail/settings | Ready/locked drill-down; disbursement review, approval and outcome; escrow settings and ledger export; separate visual captures for every subview | L finance/provider/legal contract |
| X-04 | Messaging conversation and permission/availability states | Compose/send/retry; call → SH-17; report; unread/failed/revoked access | C provider/channel decision; not assumed R1 chat |
| X-05 | Gateway checkout and return/reconciliation | Choose provider; redirect; cancel; pending/failed/verified result; requery trusted transaction | L gateway/webhook agreement |
| X-06 | Offer/coupon terms and redemption | Apply/remove validated promotion; eligibility and expiration; checkout quote refresh | L promotions policy |
| X-07 | Biometric management detail where advanced recovery is selected | Enroll/revoke device binding; recover via identity provider; unsupported/lockout | C UX-02; AU-11 covers primary setup |

## Capture expansion rule

Inventory rows group reusable multi-view families for readability; they do not reduce visual coverage. C-17, C-22, C-25, C-26, C-27, S-07, R-09, R-12, A-18, A-22, A-23, A-26, A-27 and X-03 require named child captures for each list/detail/form/result/settings view described in their row. Assign stable suffixes (for example C-26-list and C-26-detail) before visual work. The [PDF production manifest](PDF_PRODUCTION_PLAN.md) must expand these, then count actual captures, states and pages rather than equating a row count with rendered screen count.
