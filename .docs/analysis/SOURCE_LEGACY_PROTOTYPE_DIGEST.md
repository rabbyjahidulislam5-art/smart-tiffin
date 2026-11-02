# Source digest — legacy React prototype (94 screens)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead (primary agent) |
| Purpose | Preserve, inside the repository, the facts of the user-supplied `FRONTEND_UI_UX_COMPLETE_SYSTEM_DOCUMENTATION.md` (snapshot 30 Oct 2026) so that every other document and every parallel author can cite it. That source file is **not** present on disk; this digest is the only repository copy of its content. |
| Provenance tag | **OBSERVED (legacy prototype code, as reported by the source author)** unless marked otherwise. Nothing here has been re-verified against the React code, which is not in this workspace (`apps/smart-tiffin-prototype-copy/` is absent). |
| Status | Source digest. Not a design. Statuses I/U/S describe the **prototype**, never a production feature. |
| Related | [Master prompt digest](SOURCE_MASTER_PROMPT_DIGEST.md), [complete screen inventory](../design/COMPLETE_SCREEN_INVENTORY.md), [conventions](CONVENTIONS_AND_ID_REGISTER.md) |

## 1. What the prototype is

A clickable, phone-first React 18 + TypeScript + Vite + Tailwind v3 prototype (`lucide-react` icons, `sonner` toasts, ~3,800 lines) acting as the visual and behavioural reference for the Flutter build. 94 screens registered in `src/proto/registry.tsx`. Custom in-memory stack navigator (no URLs, no deep links). All data hard-coded; no backend; no database. `localStorage` holds only theme (`st-theme`), device preview (`st-device`), application drafts (`st-draft-Cook` / `st-draft-Rider`) and the verification report (`st-qa`). English / বাংলা through `t(en, bn)`. Light / Dark / System theme. Four size bands (compact < 600, medium 600–839, expanded 840–1199, large ≥ 1200) intended to mirror Flutter window size classes. Start screen P-01. Authentication is simulated (Zite auth configured but unused).

## 2. Status legend

**I** interactive (state and logic work in the prototype) · **U** UI-only / static sample · **S** simulated external action (toast or confirm only). "Not saved" / "local" qualifiers mean the action only changes component or in-memory state.

## 3. The 94-screen registry

Counts: Public 4 · Auth 13 · Shared 9 · Customer 25 · Supplier 12 · Rider 10 · Admin 19 · System 2 = **94**. IDs `SH-03` and `C-26+` do not exist; gaps are intentional.

| ID | Name | Source component · file | Group | Prototype status |
|---|---|---|---|---|
| P-01 | Guest home | GuestHome · guest.tsx | Public | I |
| P-02 | Guest menu & kitchens | GuestMenu · guest.tsx | Public | I |
| P-03 | Guest plans | GuestPlans · guest.tsx | Public | I |
| P-04 | Role info (customer/supplier/rider) | RoleInfo · guest.tsx | Public | I |
| AU-01 | Splash | Splash · auth.tsx | Auth | I |
| AU-02 | Language pick | LanguagePick · auth.tsx | Auth | I |
| AU-03 | Universal sign-in | Login · auth.tsx | Auth | I (simulated auth) |
| AU-04 | Forgot password | Forgot · auth.tsx | Auth | I |
| AU-05 | OTP verification | Otp · auth.tsx | Auth | I (any 6 digits except 000000) |
| AU-06 | New password | NewPassword · auth.tsx | Auth | I |
| AU-07 | Customer sign up | SignUp · auth.tsx | Auth | I |
| AU-08 | Customer onboarding | CustomerOnboard · auth.tsx | Auth | I |
| AU-09 | Kitchen application (6 steps) | SupplierApply → StepForm · apply.tsx | Auth | I |
| AU-10 | Rider application (8 steps) | RiderApply → StepForm · apply.tsx | Auth | I |
| AU-11 | Application status | UnderReview · apply.tsx | Auth | I |
| AU-12 | Choose account type | ChooseType · auth.tsx | Auth | I |
| AU-13 | Admin secure sign-in (hidden) | AdminSignIn · auth.tsx | Auth | I |
| SH-01 | Notifications | Notifications · shared.tsx | Shared | I |
| SH-02 | Chat | Chat · shared.tsx | Shared | I (local only) |
| SH-04 | Help & support | Support · shared.tsx | Shared | I/S |
| SH-05 | Settings & language | SettingsScreen · shared.tsx | Shared | I |
| SH-06 | Report a problem | ReportIssue · shared.tsx | Shared | I |
| SH-07 | Ticket status | TicketStatus · shared.tsx | Shared | U |
| SH-08 | Edit profile | EditProfile · shared.tsx | Shared | I |
| SH-09 | Notification settings | NotificationSettings · shared.tsx | Shared | I (local) |
| SH-10 | Email history | EmailHistory · shared.tsx | Shared | I/S |
| C-01 | Customer home | CustomerHome · customer1.tsx | Customer | I |
| C-02 | Saved addresses | Addresses | Customer | I (local) |
| C-03 | Add address | AddAddress | Customer | I (not saved) |
| C-04 | Full menu | MenuScreen | Customer | I |
| C-05 | Meal detail | MealDetail | Customer | I |
| C-06 | Kitchen detail | KitchenDetail | Customer | U |
| C-07 | Cart | Cart | Customer | I |
| C-08 | Checkout | Checkout | Customer | I |
| C-09 | Payment result | PaymentResult | Customer | I |
| C-10 | Subscriptions | Subscriptions · customer2.tsx | Customer | I/S |
| C-11 | Plan picker | PlanPicker | Customer | I |
| C-12 | Plan review | PlanReview | Customer | U |
| C-13 | Meal calendar | MealCalendar | Customer | I/S |
| C-14 | Pause meals | PauseMeals | Customer | I |
| C-15 | Modify today's meals | ModifyRoutine | Customer | I (not saved) |
| C-16 | Orders | Orders | Customer | I |
| C-17 | Order detail | OrderDetail | Customer | I |
| C-18 | Live tracking | LiveTracking | Customer | I (animated sample) |
| C-19 | Rate meal | RateMeal | Customer | I (not saved) |
| C-20 | Billing | Billing | Customer | U |
| C-21 | Invoice | Invoice | Customer | U/S |
| C-22 | Payment methods | PaymentMethods | Customer | S |
| C-23 | Customer profile | CustomerProfile | Customer | I |
| C-24 | Food preferences | FoodPrefs | Customer | I (not saved) |
| C-25 | Complaints | Complaints | Customer | U |
| S-01 | Kitchen dashboard | SupplierDash · supplier.tsx | Supplier | I |
| S-02 | Order request detail | OrderRequest | Supplier | I |
| S-03 | Cooking requirements | CookingReq | Supplier | U |
| S-04 | Menu & stock | MenuManager | Supplier | I |
| S-05 | Meal form | MealForm | Supplier | I (not saved) |
| S-06 | Supplier orders | SupplierOrders | Supplier | I |
| S-07 | Subscription commitments | Commitments | Supplier | U |
| S-08 | Earnings | SupplierEarnings | Supplier | U |
| S-09 | Payout history | PayoutHistory | Supplier | U |
| S-10 | Kitchen profile | KitchenProfile | Supplier | U |
| S-11 | Verification documents | VerificationDocs | Supplier | S |
| S-12 | Operating settings | OperatingSettings | Supplier | I (not saved) |
| R-01 | Active deliveries | RiderHome · rider.tsx | Rider | I |
| R-02 | Turn-by-turn | TurnByTurn | Rider | U |
| R-03 | Proof of delivery | DeliveryProof | Rider | I |
| R-04 | Delivered | Delivered | Rider | I |
| R-05 | SOS | Sos | Rider | S |
| R-06 | Queued order | QueueOrder | Rider | U |
| R-07 | Delivery history | RiderHistory | Rider | U |
| R-08 | Rider earnings | RiderEarnings | Rider | U |
| R-09 | Rider profile | RiderProfile | Rider | U |
| R-10 | Assignment offer | AssignmentOffer | Rider | I |
| A-01 | Executive console | AdminHome · admin.tsx | Admin | I |
| A-02 | Incident detail | IncidentDetail | Admin | U/S |
| A-03 | Incident log | IncidentLog | Admin | I |
| A-04 | Backup rider picker | BackupRider | Admin | I/S |
| A-05 | Dispute detail | DisputeDetail | Admin | S |
| A-06 | Applications queue | OnboardingQueue | Admin | I |
| A-07 | Applicant dossier | Dossier | Admin | I |
| A-08 | Users & cooks | UsersScreen | Admin | I |
| A-09 | User detail | UserDetail | Admin | I (local) |
| A-10 | All orders | AdminOrders | Admin | I |
| A-11 | Order detail (admin) | AdminOrderDetail | Admin | U |
| A-12 | Treasury & settlements | Settlements | Admin | U |
| A-13 | Payout batch | PayoutBatch | Admin | S |
| A-14 | Reports | Reports | Admin | U |
| A-15 | Admin settings | AdminSettings | Admin | U |
| A-16 | Setting detail | SettingDetail | Admin | S |
| A-17 | Audit log | AuditLog | Admin | U |
| A-18 | Security | Security | Admin | I (local) |
| A-19 | Admin profile | AdminProfile | Admin | U |
| X-01 | Design system gallery | Gallery · gallery.tsx | System | I |
| X-02 | Verification report | VerificationReport · report.tsx | System | I (localStorage) |

## 4. Architecture and state (prototype)

- `main.tsx` → `App.tsx` → `ProtoProvider start="P-01"` (`proto/core.tsx`) → Shell. Window ≥ 1024 px shows the **Prototype Hub** (inventory sidebar + toolbar for language, theme, device, state, role context + scaled device frame). Below 1024 px the app runs full-screen with a screen-ID badge and a floating screen-list button. `Toaster` at top-centre.
- `Screen` (ui.tsx) is the single page chrome: glass header, back button (only if `back && stack.length>1`), title/eyebrow, actions, scroll area, optional sticky footer, NavRail (wide) or BottomNav (narrow), and `StateView` swap for non-normal variants.
- Overlays: one global bottom sheet (centred dialog on non-compact bands) and one confirm dialog `{title, body?, ok, danger?, onOk}`.
- Context (`useProto()`): `lang`, `variant` (normal/empty/loading/error/offline/denied; reset on every navigation), `stack/current`, `go/back/reset`, derived `role` (prefix `C-/S-/R-/A-` decides role; otherwise session role), `store/set`, `confirm`, `sheet`, `theme`, `device`, `afterLogin`. `touch(id)` on every navigation updates session role, resets variant, closes sheet.
- `Store` (in memory; reload resets): `paused`, `online`, `onDuty`, `stock{thali,khichuri,roti}`, `accepted/declined`, `riderStep`, `cart/cartMeal`, `stage`, `approved/rejected/info/reasons/history/submitted/myApp`, `readAll/readIds`, `gps`, `reverify`. Helpers `appStatus`, `allApplicants`, `unreadCount` (hard-coded 3 per role), `useCall` (confirm then toast, no real call).
- Navigation: no URLs, no browser back, no deep links. `Screenish` remounts on `id+params` change so local state resets per visit. Tabs call `reset()`.

## 5. Navigation tabs

| Role | Tabs |
|---|---|
| Customer | C-01 Home · C-10 Subscriptions · C-16 Orders · C-23 Profile |
| Supplier | S-01 Dashboard · S-04 Menu · S-06 Orders · S-08 Earnings |
| Rider | R-01 Deliveries · R-07 History · R-09 Profile (3 tabs only) |
| Admin | A-01 Overview · A-08 Users & Cooks · A-10 Orders · A-15 Settings |
| Guest (`GuestNav`) | P-01 Home · P-02 Menu · P-03 Plans · AU-03 Account (push, not reset) |

BottomNav shows only on tab screens in compact/medium bands; NavRail shows on every role screen (`/^[CSRA]-/`) in expanded/large bands. Prefix → role colour: P-/AU-/SH-/X- session role (AU-09/10/11/13 force own colour), C- orange `24 95% 53%`, S- green `158 64% 36%`, R- blue `221 83% 53%`, A- indigo `243 75% 59%`.

## 6. Design system (observed)

Tokens in `index.css`/`tailwind.config.ts`: warm cream background `30 33% 97.5%` (dark `24 12% 8%`), foreground `222 30% 13%`, cards white/dark-charcoal, `--role` set per screen prefix via `roleStyle()`, status colours success/warning/info/destructive, radius scale (`--radius` 1rem; 3xl = +16 px, 2xl = +8 px, xl = +4 px), warm brown-tinted shadows, fonts Plus Jakarta Sans → Hind Siliguri (Bangla) and JetBrains Mono. Visual language: glassmorphism (`.glass` = card 72 % + blur 18 px saturate 1.4) on headers, footers, bottom nav, map pills, rating badges; hero gradient `from-role to-warning`; cards `rounded-3xl`, hero `rounded-[28px]`, sheets `rounded-t-[32px]`; typography eyebrow 10 px bold uppercase tracking 0.12 em, title 17 px, hero 20–24 px extrabold, body 14 px, captions 11–12 px; icons `lucide-react` only; touch targets buttons h-11/h-14, quick tiles min-h 80 px, IconBtn 40 px (below the 44 px rule — known gap).

Reusable components: Screen, NavRail, BottomNav, StateView, IconBtn (unread badge keyed on label `Notifications`), Card, Chip (tones role/success/warning/danger/muted/info), Btn (primary/soft/outline/danger/ghost/success; disabled shows a **reason caption**), Row, List, Section, Timeline, Field, Toggle, Segmented, ChipRow, Stat, Avatar, Note (info/warning/policy), Policy ("Policy pending — final rule not yet approved. Sample only."), Sample chip, QuickActions (3 role tiles + More sheet). Screen-local: MealCard, AddressSheet, GuestMeal, GuestNav, useProtect, LangToggle, ThemeSwitch, LogoutRow, StockList, ReqCard, DeclineSheet, MiniMap, SosBtn, ApplicantCard, ReasonSheet, StepForm, FieldInput.

Responsive: compact → BottomNav, sheets from bottom, single column; medium → centred floating BottomNav, centred dialogs `max-w-lg`; expanded → icon NavRail, tab screens `max-w-5xl` in 2 CSS columns, A-07 checklist right column, X-02 table; large → labelled NavRail (`w-56`), `max-w-6xl`. Hub devices: Small Android 360×740, Phone 390×844, Large phone 430×932, Phone landscape 844×390, Tablet 820×1180, Laptop 1280×800, Desktop 1440×900.

## 7. Per-screen behaviour (observed)

Notation: `→ X` navigates forward; `reset X` replaces the stack; "toast" = sonner toast, no other effect.

### Public / guest
- **P-01** header Sign in → AU-03; hero "See plans" → P-03, "Create account" → AU-12; QuickActions guest (Meals P-02, Plans P-03, Kitchens P-02{tab:kitchens}, More: P-04 customer/supplier/rider, AU-03, AU-12); Today's Special Menu with ChipRow all/thali/diet/office and GuestMeal carousel (tap image → detail sheet with Subscribe; Subscribe → protect C-11{meal}; sold-out greyscale and disabled); See all → P-02; Track my order → protect C-18; Join list: Cook → P-04{r:supplier}, Deliver → P-04{r:rider}, How it works → P-04{r:customer}; GuestNav footer. `states={false}`.
- **useProtect()** opens a "Sign in to continue" sheet: Sign in (`setAfterLogin({id,p})` → AU-03) and Create account (→ AU-12).
- **P-02** Segmented Meals/Kitchens (initial tab from `p.tab`); meals search (en+bn+kitchen) over GuestMeal grid 1→2 (≥ 420 px)→3 (lg) or "No meals match"; kitchens derived from MEALS (count, max rating, image). **Kitchen cards are not clickable (dead end).**
- **P-03** PLANS grid; Subscribe → protect C-11{plan}; info note about pause/cutoff and payment methods.
- **P-04** recoloured by `p.r`; gradient icon, four numbered steps, admin-review note for supplier/rider; CTA: customer → AU-12, supplier → AU-09, rider → AU-10.

### Auth
- **AU-01** logo/tagline; Get started → AU-02; "I already have an account" → AU-03. Reachable only from Hub (start is P-01). **AU-02** English/বাংলা cards, Continue → P-01.
- **AU-03** fields Email/Mobile (default `+880 1712-892401`), Password (default `demo-password`) with eye; validation ID ≥ 11 digits or `@`, password ≥ 8; `wrongpass` → "Wrong password. 2 attempts left"; unknown ID → "No account found" + Create account → AU-12. Demo accounts: +880 1712-892401 customer Tanvir → C-01 (or resume `afterLogin`); rina@kitchen.bd cook → S-01; rokon@rider.bd rider → R-01; nadia@smarttiffin.bd admin → A-01; sultana@kitchen.bd applicant → AU-11{id:sultana}. Remember-me (UI-only), Forgot → AU-04, Sign in, Fingerprint sheet ("Simulate scan"), Continue with Google picker (tanvir@gmail.com → customer; new.user@gmail.com → AU-12{google}), New here? → AU-12, sample-account chips, resume note, LangToggle.
- **AU-04** → AU-05{flow:reset} (≥ 6 chars). **AU-05** 6-digit numeric; `000000` expired; < 6 digits error; verify by flow: reset → AU-06, signup → AU-08, else AU-11; resend toast. **AU-06** ≥ 8 chars + matching confirm → toast → reset AU-03. **AU-07** name ≥ 2, phone ≥ 11 digits, password ≥ 8 → AU-05{flow:signup}. **AU-08** default address, "Pin on map (sample)", plan picker cards; Finish/Skip → setRole(customer) → resume `afterLogin` or C-01.
- **AU-12** three role cards (Customer, Supplier (Cook), Rider), selected border + check, Google email shown when `p.google`; Continue: customer → AU-08 if Google else AU-07; supplier → AU-09; rider → AU-10; note "Admin accounts are invite-only"; "Already have an account? Sign in" → AU-03.
- **AU-13** (hidden) indigo, no back; step 1 email must end `@smarttiffin.bd` + password ≥ 8; step 2 6-digit code, `123456` → setRole(admin) → reset A-01; 3 wrong codes lock ("Locked — try later"); policy note "not linked anywhere"; Hub-only.

### Applications (`StepForm`, AU-09/AU-10/AU-11)
- Field types: text, tel, email, number, date, select, chips (multi), upload (simulated `"<key>.jpg"`), check, area. Conditional display (`show`): bank name only when method = Bank; licence/reg/insurance/licenceDoc/regDoc only when vehicle = Motorcycle. Conditional required (`reqIf`): trade licence when kitchen type Restaurant/Cloud kitchen; fields marked `cond` show "Conditional · policy pending". Validators: phone ≥ 11 digits; capacity 1–500; DOB age ≥ 18.
- Progress bar + step chips; footer Back (step 0 → confirm "Leave application?" → reset AU-12), Save draft (localStorage), Next (validate) / Submit on Review; Review cards with Edit link per step. Submit validates all steps (jumps to first bad step), builds `Applicant` (`id=me-<kind>-<n>`, `ref ST-APP-xxxx`, masked payout) into `store.submitted`, `myApp`, history "Submitted · time", clears draft → reset AU-11{id}.
- Fix mode (`p.id`+`p.fix`): only that step opens; Next goes to Review; warning note quotes admin message; Submit clears `info[id]` and adds history "Updated & resubmitted" → AU-11. Safety notes: payout step "Never share your PIN or password"; rider vehicle step explains bicycle/walker need no licence.
- **KITCHEN_STEPS (6):** Personal (name, phone, email, NID) · Kitchen (name, type HomeChef/Cloud kitchen/Restaurant, address, service-area chips, photo) · Operations & menu (capacity, meal times, working days, sample menu) · Payout (bKash/Nagad/Bank, bank name\*, account, holder) · Documents (NID front/back, kitchen photos, trade licence (cond), hygiene cert (cond)) · Agreement & review (2 checkboxes). **RIDER_STEPS (8):** Personal (+DOB 18+) · Address & zone · Emergency contact · Vehicle (Motorcycle/Bicycle/Walker + motorcycle-only fields) · Availability & phone (shifts, Android/iPhone, GPS checkbox) · Payout · Documents (NID, selfie, + motorcycle docs) · Review (agree).
- **AU-11** applicant from `p.id` → `store.myApp` → `sultana`; states: pending (Clock/warning), info (Alert; **Update application** → AU-09/10{id,fix:section}), rejected (XCircle; reason + Policy; **Start a new application**), approved (Check; **Open my dashboard** → reset HOME[role]). Always: Timeline (Submitted / In review / Decision), History card, Contact support → SH-04, Sign out → reset P-01, policy note linking "Admin › A-07" (**prototype shortcut**, must not exist in a real applicant journey).

### Customer
- **C-01** Bell (unread badge) → SH-01; Avatar → C-23; address pill → AddressSheet (pick toast, Add new → C-03, Manage → C-02); hero plan card → C-10; Active/Paused badge from `store.paused`; Pause Meals/Resume → C-14 / confirm → `paused:false`; Plan Calendar → C-13; QuickActions customer (Order C-04, Plans C-10, Track C-18, More: Cart C-07, Calendar C-13, Pause C-14, Billing C-20, Addresses C-02, Food prefs C-24, Complaints C-25, Support SH-04); Ongoing Delivery item → C-17{TK-911}, rider Call (useCall) / Chat → SH-02{who:Rokon}, Track Delivery on Live Map → C-18; Routine Modify → C-15; Lunch/Dinner cards → C-17{TK-911|TK-930}; special-menu chips + MealCard (card → C-05{id}, Subscribe → C-11{meal}, See All → C-04).
- **C-02** list of 3, Delete → confirm → local removal, +/Add → C-03. **C-03** map placeholder (Sample), Home/Office/Other segmented (non-functional, fixed `h`), address ≥ 6 chars, note → toast → back (not added to C-02). **C-04** search, category chips incl. "Under ৳200", MealCard list, empty state with Clear filters. **C-05** image, chips (badge, Halal, rating, spice), kitchen card → C-06{k}, allergens, static reviews; footer qty ± and Add · BDT x; **one-kitchen-per-cart** confirm when switching; success toast with View cart → C-07; sold-out disabled with reason "Restocks tomorrow". **C-06** verified chips, meals by kitchen. **C-07** empty → Browse menu C-04; one line (`cartMeal`×`cart`), ± (minus to 0 empties), totals with BDT 40 delivery, Checkout → C-08. **C-08** address row → C-02, Lunch/Dinner slot, 4 payment methods (bKash, Nagad, Card, COD), total, **prototype outcome simulator** (✓ ✕ ⦸ ?), Place Order → C-09{outcome}. **C-09** success → View order (cart:0, reset C-01, go C-17{TK-940}) / Back home; failed/cancelled → Try again / Home; unknown → See my orders C-16 / Contact support SH-04.
- **C-10** (tab) gradient summary (used/left/paused), Pause → C-14, Calendar → C-13, Change plan → C-11, Address → C-02, Billing → C-20, Cancel → confirm → toast (S). **C-11** → C-12{plan}; `meal`/`plan` params from guest flows are **ignored** (defaults to `monthly-ld`). **C-12** start date, address → C-02, pay-with → C-22, Policy, **Pay & subscribe** → C-09{success}. **C-13** 30-day grid (done/today/paused/upcoming); day sheet: done/today disabled "Cutoff passed", paused "Unpause day" toast, upcoming "Pause this day" → C-14. **C-14** static date fields, Lunch/Dinner toggles (≥ 1), disabled "Pause today" (cutoff reason), Policy, confirm → `paused:true` + Undo toast → back. **C-15** Lunch locked (warning), Dinner picker, Save toast → back. **C-16** (tab) Active/Upcoming/Past, card → C-17{id}, past Rate → C-19{id}, My complaints → C-25. **C-17** timeline by ID (TK-930=0, TK-8xx delivered, else on the way), Track live → C-18, Call/Chat rider, Invoice → C-21{id}, Rate (delivered) → C-19, Report → SH-06{ref}. **C-18** CSS grid map, SVG route, rider marker animated by `setInterval` 400 ms, Recenter toast, GPS-lost note when `!store.gps`, rider Call/Chat, Report → SH-06. **C-19** three 5-star rows + comment → toast. **C-20** next payment, Pay now → C-09{success}, invoices → C-21{month}, methods → C-22, Policy. **C-21** static breakdown, Download PDF toast. **C-22** bKash default, Nagad; Add → sheet → "not connected yet" toast. **C-23** (tab) Edit → SH-08; rows → C-02, C-24, C-20, C-22, SH-01, C-25, SH-04, SH-05; Apply as a Cook → AU-09, Apply as a Rider → AU-10; LogoutRow (confirm → reset P-01). **C-24** multi-select chips → Save toast. **C-25** two tickets → SH-07{ticket}; New → SH-06{ref:general}.

### Supplier
- **S-01** (tab) eyebrow "● KITCHEN LIVE"/"○ KITCHEN OFFLINE"; Bell → SH-01; Avatar/kitchen name → S-10; online Toggle (off → confirm "Go offline?"); QuickActions supplier (Menu S-04, Orders S-06, Cooking S-03, More: Earnings S-08, Commitments S-07, Payouts S-09, Kitchen profile S-10, Documents S-11, Operating S-12, Alerts SH-09, Support SH-04); Stats Today's orders → S-06, Earnings → S-08; cooking requirements header/batch → S-03; Kitchen flow stage Prepped/Preparing/Packed → `store.stage` (Packed asks confirmation); Live Order Requests (`ReqCard`): card → S-02{id}, Accept → `accepted` + toast, Decline → `DeclineSheet` (reason required) → `declined`; pending count → S-06; Today's Menu & Stock (`StockList`): item → S-05{id}, Toggle → `stock[k]` + toast, Edit Full → S-04.
- **S-02** before acceptance Decline sheet / Accept Order; after: stage Timeline and **Mark packed** (`stage:2`); rows area, window, Call customer (masked), Message rider → SH-02. **S-03** Lunch/Dinner segmented, progress bars, static ingredients. **S-04** (tab) StockList, meal cards → S-05{id}, Add → S-05. **S-05** photo picker toast or image; name EN required, name BN, price > 0, portions > 0; day chips static; Save toast (not persisted); Delete (edit) confirm → toast. **S-06** (tab) New/Cooking/Handed off (static); cards → S-02; Commitments → S-07. **S-07**, **S-08** (tab; Payout history → S-09, Payout account → S-12, Policy), **S-09** (note: "Recorded" ≠ bank transfer) static. **S-10** Edit → SH-08, Docs → S-11, Operating → S-12, Notifications → SH-01, Support → SH-04, Settings → SH-05, Logout. **S-11** three docs (hygiene expiring), Upload renewal toast. **S-12** Lunch/Dinner shift toggles, max tiffins, payout account, Save toast.

### Rider
- **R-01** (tab) SOS (header, red) → R-05; Bell → SH-01; duty Toggle (off → confirm); identity row → R-09; Today's earnings → R-08; "12 Completed" → R-07; GPS text toggles `store.gps` (affects MiniMap overlay and C-18); QuickActions rider (Navigate R-02, Queue R-06, Earnings R-08, More: History R-07, New offer R-10, Proof R-03, Profile R-09, Emails SH-10, Support SH-04); off duty → empty card + Go on duty; `riderStep ≥ 3` → "Waiting for next assignment" → R-10; active: MiniMap, Recenter toast, Turn-by-Turn → R-02, order card, Call Kitchen / Chat / Call customer, Timeline (`riderStep`), main CTA (step 0 → confirm pickup → `riderStep:2`; otherwise → R-03), Report delay → SH-06; Up next → R-06.
- **R-02** static instruction card, tall MiniMap, SOS, Exit. **R-03** photo (tap to capture) or 4-digit OTP; Confirm disabled until proof → R-04. **R-04** "Start next: #TK-912" (`riderStep:0`, reset R-01, go R-06) / "Back to deliveries" (`riderStep:3`, reset R-01). **R-05** Send SOS confirm → error toast (S); Call 999 / dispatch (`useCall`); Share location / Report accident toasts. **R-06** static; Call/Message. **R-07** (tab) Today/This week segmented (does not filter); rows → SH-06{ref}; Earnings → R-08. **R-08** static stats + policy. **R-09** (tab) Edit → SH-08; Vehicle & docs toast; Earnings → R-08; Safety → R-05; Notifications, Support, Settings; Logout. **R-10** Accept → `riderStep:0` + toast → reset R-01; Decline → confirm → reset R-01.

### Admin
- **A-01** (tab) system-health strip; 4 Stats → A-14{k}; QuickActions admin (Applications A-06, Incidents A-03, Payouts A-13, More: Users A-08, Orders A-10, Treasury A-12, Reports A-14, Audit A-17, Security A-18, Emails SH-10, Settings A-15); urgent incidents (Dispatch Backup → A-04, Details → A-02, Review credit → A-05, Call cook via useCall, Log History → A-03); Applications: count link → A-06 and first 2 pending `ApplicantCard`s; Treasury: Open → A-12, Review payout → A-13, Ledger export confirm → toast, Escrow rules → A-16{escrow}, Policy; Bell → SH-01; Avatar → A-19.
- **A-02** timeline; Call rider; Message customers → SH-02{6 customers}; Dispatch → A-04. **A-03** All/Open/Closed; TK-* → A-02, DS-* → A-05. **A-04** pick a rider (required) → confirm → toast. **A-05** calls; Approve credit confirm → toast (pending policy); Reject confirm. **A-06** Segmented Supplier(n)/Rider(n), search (name+owner+area), status chips (pending/info/approved/rejected/all, default pending), `ApplicantCard` (header → A-07{id}, status chip, NID chip, hygiene/docs chip, capacity/vehicle, tier, Review application). **A-07** header status chip; info/rejected notes; Details card (owner, area, capacity/vehicle, type/shift, masked payout, reference) + 3 document tiles ("Document preview (sample)" toast); 4-item checklist (rider's 4th depends on vehicle) local state; History card; wide bands put details in 2 columns and checklist/history in a right column; footer until decided: **Request info** (`ReasonSheet kind=info`: choose section except last, reason ≥ 5 chars → `info[id]="sec|reason"` + history), **Reject** (`ReasonSheet kind=reject` → `rejected`, `reasons`, history), **Approve** (disabled until all checks ticked → confirm → `approved`, clears info, history); then "Decision recorded".
- **A-08** (tab) Customers/Cooks/Riders, search, A→Z/Z→A, rows → A-09{id}, header badge → A-06. **A-09** Orders → A-10, Message → SH-02, Audit → A-17, Suspend/Reactivate confirm (local). **A-10** (tab) Today/Late/Disputed → A-11{id}; Fleet → A-14{fleet}. **A-11** parties → A-09{u2/u3/u5}; Reassign → A-04. **A-12** stats; Payout batch → A-13; Escrow → A-16; Audit → A-17. **A-13** Approve batch confirm ("No money is transferred") → toast. **A-14** title by `p.k`, static bar chart, zones, Export toast. **A-15** (tab) → A-16{zones/windows/plans/roles/escrow}, A-17, A-18, SH-05. **A-16** content per `p.s`; zone toggles no-op; Save toast. **A-17** static audit list. **A-18** 2FA toggle (local), sessions, IP ranges. **A-19** Edit → SH-08; Security; Settings; Support; Logout.

### Shared
- **SH-01** role-specific list of 3 (`NOTIFS`), All/Unread(n), Mark all read; tapping marks read and navigates (customer → C-17/C-21/C-04; supplier → S-02/S-04/S-09; rider → R-10/R-01/R-08; admin → A-02/A-07{sultana}/A-05); header icons → SH-09, SH-10. **SH-02** `p.who` title, Call, local messages, quick replies, Enter/Send; "Messages are not sent". **SH-04** Chat → SH-02, Call, Ticket → SH-06{general}; FAQ rows → toast "content pending review". **SH-05** Language segmented, Appearance Light/Dark/System (persisted), Push/Fingerprint toggles (local), Notification settings → SH-09, Email history → SH-10, Privacy toast, LogoutRow. **SH-06** reference from `p.ref`, reason grid (required), description, Add photo (simulated), Submit → SH-07{ticket:DS-141}. **SH-07** static progress; Done → reset role home. **SH-08** per-role name/email/extra fields + Sensitive card (supplier: business name, payout owner, NID; rider: motorcycle reg, payout owner, NID); validation; dirty-cancel discard confirm; Save disabled until dirty; sensitive change → "Confirm it's you" → `reverify` + toast; read-only Role and Approval chips (approval always "Approved" — known gap); Change password toast. **SH-09** Essential (always on, locked with toast) vs Optional (In-app/Email toggles, local). **SH-10** 4 sample emails EM-2038…2041 with Queued/Accepted/Delivered/Failed, Retry send animates Queued → Accepted (0.9 s) → Delivered (2 s), admin-only Template preview sheet (Approved / Order confirmed, EN/BN).

### System
- **X-01** gallery: role switcher, buttons, chips, timeline, stats, rows, inputs, notes, state icons, Bangla wrapping sample. **X-02** 9 checks per screen (Design, Responsive, Overflow, Icons/Buttons, Navigation, Light/Dark, EN/BN, Functional UI, Screenshot), cell cycles pending → ✓ → ✗; row PASS only if all nine ✓, FAIL if any ✗; Issue/Fix prefilled from `NOTES`; group/status filters; table on wide bands, cards on narrow; ID click → reset(id); CSV export; Clear all; persisted in `st-qa`.

## 8. Sample data (prototype)

`MEALS` biryani, thali, khichuri, roti (sold out), beef · `PLANS` weekly ৳1,800, monthly-l ৳3,900, monthly-ld ৳7,200, office ৳3,400 · `REQUESTS` TK-911/912/913 · `APPLICANTS` sultana (Cook), ctg (Cook), rider-sabbir, rider-mitu · `ACCOUNTS` 5 sign-in identities · `NOTIFS` 3 per role · `EMAILS` EM-2038…2041 · `USERS` u1–u6 · `ORDERS` TK-911/930/887/861. All amounts are **sample** values, never approved prices. Currency is written both `BDT x` and `৳x`.

Privacy rules already visible in the UI and to be preserved: masked phone (`+880 17••`), masked payout (`••••4401`), "Never share your PIN or password", "Emails never contain NID images, codes or passwords".

## 9. Backend touchpoints the source lists (all unimplemented)

Auth (Login/SignUp/Otp/Forgot/NewPassword/Google/biometric); admin auth (allow-list + 2FA); role routing (role on profile table); catalogue (`listMeals/Plans/Kitchens`); cart/orders/payments; subscriptions (`getSubscription`, `pauseMeals`, `modifyRoutine`, `changePlan`, `cancelSubscription`); addresses/prefs; tracking (rider location feed + maps); supplier ops (`listRequests`, `acceptOrder`, `declineOrder(reason)`, `setStage`, `setStock`, menu CRUD); earnings/payouts (`approvePayoutBatch` records only); rider ops (`acceptAssignment`, `confirmPickup`, `submitProof`); SOS/incidents (`raiseSos`, `dispatchBackupRider`); applications (`submitApplication`, uploads, `getMyApplication`); admin review (`listApplications`, `decideApplication` + audit insert); users (`listUsers`, `suspendUser`); disputes/complaints (`createTicket`, `getTicket`, `decideCredit`); notifications (`markRead`, preferences); email log with provider status + retry; profile (`updateProfile`, re-verification queue); admin settings (zones, windows/cutoffs, plans/pricing, roles, escrow); reports (aggregates); chat/calls (third-party, out of scope); QA report persistence (optional). These are **prototype suggestions**, superseded by the contracts in [API specification](../api/API_SPECIFICATION.md) once written.

## 10. Known prototype gaps reported by the source (22)

1. `afterLogin` only consumed for customer accounts; other roles leave it set (stale redirect). 2. PlanPicker ignores `p.meal`/`p.plan` (selection lost). 3. Google identity not carried into AU-09/10 (no prefill). 4. StepForm step-0 exit always goes to AU-12 even for existing customers from C-23. 5. Only `sultana` can sign in as applicant. 6. Sign-out does not clear Store, `myApp` or session role. 7. `unreadCount` hard-coded 3 per role. 8. IconBtn badge keyed on label `Notifications` (translation-fragile). 9. Dossier checklist ticks lost on leave. 10. EditProfile approval chip always "Approved". 11. AddAddress type control fixed and address not added to C-02. 12. SettingDetail zone toggles no-op. 13. MealForm day chips static, not persisted. 14. RiderHistory Today/This week does not filter. 15. **GuestMenu kitchen cards not clickable (no guest kitchen detail).** 16. C-02/C-15/C-19/C-24/S-12/A-16 saves are toasts only. 17. AU-01/AU-02 reachable only from Hub; AU-13 hidden by design. 18. `QUICK_TARGETS` exported but unused. 19. Language not persisted. 20. **No role guard**: pending applicant could open S-01 via Hub; access enforced only by navigation flow. 21. IconBtn 40 px below 44 px target. 22. X-02 every row starts PENDING; no screen marked PASS.

## 11. Journeys (observed)

Guest → protected action → sign-in sheet → AU-03 / AU-12→AU-07→AU-05→AU-08 → resume `afterLogin` (customers only). Single-meal order: C-01 → C-04/C-05 → add (one-kitchen rule) → C-07 → C-08 → C-09 → C-17 | back | C-16. Subscription: C-10/C-01/guest resume → C-11 → C-12 → C-09{success}; pause: C-01/C-10/C-13 → C-14 → confirm → `store.paused`. Application lifecycle: Draft (localStorage) → Pending → Info → Pending → Approved | Rejected → (new application). Supplier daily: online → Accept/Decline → S-02 → Prepped → Preparing → Packed (confirm) → handoff. Rider loop: R-10 accept → R-01 → confirm pickup (step 2) → R-03 proof → R-04 → next (step 0) or wait (step 3) → R-10; SOS R-05. Admin: A-01 incident → A-04 / A-02 / A-05 (credit recorded, no money); treasury → A-13 (recorded only) / A-16 escrow. Sign-out → reset P-01.
