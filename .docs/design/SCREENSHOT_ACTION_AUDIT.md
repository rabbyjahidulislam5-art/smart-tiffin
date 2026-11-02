# Screenshot control audit

2026-10-30 · Visual inspection of all six user attachments. This is a design/behavior mapping, not interaction test evidence. `→` names a planned destination in [the inventory](SCREEN_INVENTORY.md). Display-only information is explicitly identified so decorative icons do not become misleading buttons.

## Source register

| Source | Attachment suffix / content | Findings |
|---|---|---|
| IMG-01 | e43af95e-913c-4b46-9e82-0c5f038acafe.png | Customer Home, long mobile viewport |
| IMG-02 | 71ad4a14-be29-49d3-8ddf-1846eb7e02a2.png | Same visible Customer Home design; no additional unique control observed |
| IMG-03 | b097927b-d5e3-43cb-b71d-7bee9fafbaf3.png | Supplier dashboard |
| IMG-04 | 640ffd0f-c550-4b48-bb6d-c11b6443ff0f.png | Rider active deliveries |
| IMG-05 | 7c9456de-c0fb-48fc-8680-080d08dfc7f3.png | Admin executive console |
| IMG-06 | 873abab5-e40c-42d9-ad28-43ff9d68843a.png | Phone-labelled login with password and role selection |

Attachments were supplied from the local temporary directory. Do not use the depicted names, phone numbers, addresses, payment labels or operational figures as real customers, verification evidence or test fixtures.

## Customer — IMG-01 and IMG-02

| ID | Visible element | Action / destination / data truth |
|---|---|---|
| CU-01 | Brand/home title | Home → C-01; brand mark otherwise decorative |
| CU-02 | Header bell | Notifications → SH-01 |
| CU-03 | Header profile icon | Profile → C-23 |
| CU-04 | Address dropdown and location pin | Address chooser → C-02; pin decorative within labelled control |
| CU-05 | Second bell/unread dot | Same inbox → SH-01; consolidate duplicate visual entry without losing notification access |
| CU-06 | TA avatar/online dot | Profile → C-23; online dot only if its meaning is backed by data |
| CU-07 | Active monthly plan card | Subscription detail → C-13; badge and cycle text derived from accepted obligations |
| CU-08 | “18 days left (12/30 used)” progress | Display with accessible progress; no fixed 30-day business rule inferred |
| CU-09 | Pause Meals | Pause selection/review → C-15; BR-001/002 |
| CU-10 | Plan Calendar | Calendar → C-14 |
| CU-11 | LIVE / ETA / minutes away | Current status and freshness in C-18; live/ETA claim requires evidence; GPS-derived estimate later |
| CU-12 | Delivery meal row and chevron | Order detail → C-17; item-specific food detail available within it |
| CU-13 | Placed/Cooked/On The Way/Drop-off timeline | Separate preparation from delivery; C-18 uses Pending, Picked Up, On The Way, Delivered; stages display-only unless details explicitly offered |
| CU-14 | Rider name/rating/vehicle panel | Authorized contact summary → SH-17; rating/vehicle claims conditional |
| CU-15 | Rider phone icon | User-initiated dialer via SH-17; no automatic call |
| CU-16 | Rider message icon | Approved channel via SH-17; X-04 if in-app messaging selected |
| CU-17 | Track Delivery on Live Map | Preserve live-map design X-01 as later scope; R1 action labelled “View delivery status” → C-18; this release substitution requires scope review |
| CU-18 | Routine Modify | Routine change → C-16; effect on committed orders requires policy |
| CU-19 | Lunch card | Relevant meal/order detail → C-17; in-transit and time backed by data |
| CU-20 | Dinner card | Scheduled meal/order detail → C-17; scheduled status separate from delivery |
| CU-21 | See All (14) and chevron | Catalog → C-04; count from actual matching records |
| CU-22 | All Items chip | Reset category in C-04/C-01 list; selected state announced |
| CU-23 | Bengali Thali chip | Filter catalog by actual category |
| CU-24 | Diet & Keto chip | Filter catalog; seller dietary claims not medical assurances |
| CU-25 | Partially visible Office category | Retain category list/horizontal access; exact clipped wording requires source confirmation |
| CU-26 | Product image/title/description card | Food detail → C-06; full title accessible despite visual truncation |
| CU-27 | Kitchen name | Public kitchen → C-07 |
| CU-28 | Rating/count overlay | Reviews → C-20; count and score from permitted reviews |
| CU-29 | Bestseller/Chef Special/Halal badges | Attributed informational claims; details in C-06/C-07, no invented verification |
| CU-30 | Price label | Display authoritative catalog value/basis; checkout revalidates |
| CU-31 | + Subscribe | Package/configuration → C-08 then C-09; unavailable reason remains visible |
| CU-32 | Horizontal product carousel / partial next card | Swipe/scroll with accessible next item; next card behaves identically |
| CU-33 | Home tab | C-01 |
| CU-34 | Subscriptions tab | C-12 |
| CU-35 | Orders tab | C-17 list |
| CU-36 | Profile tab | C-23 |

## Supplier — IMG-03

| ID | Visible element | Action / destination / data truth |
|---|---|---|
| SU-01 | Kitchen Live / Dashboard brand | S-01; live indicator tied to actual sync/availability |
| SU-02 | Bell | SH-01 |
| SU-03 | Profile icon | S-19 |
| SU-04 | Kitchen name, verification icon, ID, Chef Mode | Kitchen profile → S-19; badge only from approved evidence; role label display-only |
| SU-05 | Accepting Orders toggle | S-16 action; save acknowledged setting; explain current orders unaffected unless policy says otherwise |
| SU-06 | Today's Orders metric and trend | Order list → S-10; values from permitted aggregate |
| SU-07 | Earnings Today / Escrow Cleared | S-17; escrow label requires later finance integration, not manual-reference status |
| SU-08 | Daily Cooking Requirements | S-13; drill-down on portion totals |
| SU-09 | Lunch dispatch countdown | Schedule-derived display; no fabricated deadline |
| SU-10 | Batch total, item quantities and percentage ring | S-13/S-14; percentage denominator documented, not decorative 78% |
| SU-11 | Prepped stage | Preparation history/details → S-14; no backwards mutation by tapping a past stage |
| SU-12 | Preparing stage | S-14 approved next transition with confirmation |
| SU-13 | Packed stage / instruction | S-14 then handoff S-15; only when actual preparation and policy permit |
| SU-14 | Pending count and Auto-Syncing indicator | S-10 filter; freshness/reconnection truth rather than permanent green dot |
| SU-15 | Each request customer/order/items/quantity/notes/price row | Order detail → S-11; only necessary customer information |
| SU-16 | bKash Paid / Nagad Paid badges | Read-only verified summary; pending submission cannot produce badge |
| SU-17 | Decline buttons on all three request cards | S-12 reason/review; no implied cancellation/refund policy |
| SU-18 | Accept Order buttons on all three cards | S-11 review → trusted acceptance; duplicate tap/version protection |
| SU-19 | Edit Full with chevron | Menu/stock → S-02/S-09 |
| SU-20 | Available food thumbnail/name/price/remaining count | S-04/S-09; count conditional on approved capacity model |
| SU-21 | Available-item switches | Acknowledged availability update; optimistic visual state must revert on failure |
| SU-22 | Sold Out / Restock tomorrow / disabled switch | S-09 detail; restock claim only if scheduled; disabled reason accessible |
| SU-23 | Dashboard tab | S-01 |
| SU-24 | Menu tab | S-02 |
| SU-25 | Orders tab | S-10 |
| SU-26 | Earnings tab | S-17 |

## Rider — IMG-04

| ID | Visible element | Action / destination / data truth |
|---|---|---|
| RI-01 | Dispatch title | R-01 |
| RI-02 | SOS | Safety contact sheet → R-08; destination/service must be approved |
| RI-03 | Bell/unread dot | SH-01 |
| RI-04 | Profile icon | R-10 |
| RI-05 | On Duty • Accepting | Availability → R-11; no automatic assignment inference |
| RI-06 | Battery 84% | Display actual platform value only if justified/available; never fabricated operational telemetry |
| RI-07 | GPS HD | L capability X-01; accuracy/staleness/permission design required |
| RI-08 | Avatar/name/vehicle/rating | R-10; truncate visually with accessible full text; verified meaning required |
| RI-09 | Today's earnings | R-12; rider accounting extension needs basis |
| RI-10 | 12 Completed | R-09 current date filter |
| RI-11 | 2 In Progress | R-01 assigned-work filter |
| RI-12 | Map kitchen/customer/rider markers and route | X-01 later; no fake moving position; R1 uses pickup/dropoff addresses |
| RI-13 | 2.4 km • 11 mins bubble | L routing-derived display; no invented ETA |
| RI-14 | Recenter GPS | X-01 permission-aware recenter |
| RI-15 | Turn-by-Turn | X-02 later; external directions alternative only after explicit selection |
| RI-16 | Priority / lunch batch / order ID / delivery window | R-02; priority/window backed by approved service record |
| RI-17 | Dispatch Due 18m | Real schedule-derived timer, not a fixed fixture |
| RI-18 | Meal/quantity and PREPAID panel | R-02 safe summary; paid only from trusted verification |
| RI-19 | Pickup kitchen/address | R-02; details from current assignment |
| RI-20 | Call Kitchen | SH-17 dialer handoff |
| RI-21 | Customer name/subscription badge/verified corporate | Necessary R-02 information only; claims need evidence |
| RI-22 | Customer message | SH-17 / conditional X-04 |
| RI-23 | Customer phone | SH-17 |
| RI-24 | Dropoff address/floor/unit and gate note | R-02; private assignment projection; remove future access after reassignment |
| RI-25 | Paid via bKash (0 due) / OTP not required | Trusted safe collection summary; proof/OTP policy not inferred from screenshot |
| RI-26 | Assigned/Picked Up/On Route/Delivered timeline | Canonical labels Pending/Picked Up/On The Way/Delivered; current state and history, no arbitrary jumps |
| RI-27 | Arrived & Mark Delivered | R-05 confirmation/evidence → server → R-06; “arrived” alone is not completed delivery |
| RI-28 | Report Heavy Traffic / Customer Delay | R-07 reason, submit and case/result |
| RI-29 | Up Next in Queue count, ETA, row/chevron | R-02 for selected permitted assignment; no guaranteed estimate without basis |
| RI-30 | Deliveries tab | R-01 |
| RI-31 | History tab | R-09 |
| RI-32 | Profile tab | R-10 |

## Admin — IMG-05

| ID | Visible element | Action / destination / data truth |
|---|---|---|
| AD-01 | Admin / Super Admin identity | A-01; privilege badge based on actual permission, not a new self-selectable role |
| AD-02 | All systems operational / uptime/latency/sync boxes | A-24 telemetry detail; show unavailable when monitoring absent |
| AD-03 | Bell with count | SH-01 |
| AD-04 | Profile icon | A-27 own profile; account settings via SH-03 |
| AD-05 | Lunch Window Peak chip | Operational window detail → A-24; derived from approved schedule |
| AD-06 | Total subscribers + trend card | A-02 customer/subscription filter; matching aggregate definition |
| AD-07 | Active cooks / cooking now | A-04/A-02 supplier filter |
| AD-08 | Delivery fleet / active route count | A-07 |
| AD-09 | November revenue / daily run-rate | A-16 actual selected-period basis; no fixed month/sample figures |
| AD-10 | Urgent Incident Ticker / 2 Flags | A-12 filtered incident queue |
| AD-11 | Log History chevron | A-12 history |
| AD-12 | Trip delay card / Escalated / description | A-13; no automatic reroute promise |
| AD-13 | Dispatch Backup Rider | A-11, only if BR-004 grants permission |
| AD-14 | View Details | A-13 |
| AD-15 | Dispute card / Reviewing / age / complaint summary | A-15 |
| AD-16 | Issue Replacement Credit (180) | A-19 review; amount and authority depend on BR-002/005; never immediate assumed credit |
| AD-17 | Call Cook | SH-17 |
| AD-18 | Supplier Onboarding / 3 Pending / Batch SLA 4h | A-04; SLA/count must be real and approved |
| AD-19 | Supplier name, owner, area, capacity and tier | A-05 dossier; data sourced from reviewed application |
| AD-20 | NID Verified / Kitchen Checked / Hygiene Cert Pass / Inspection Scheduled | A-06 evidence details; no badge based solely on uploaded files |
| AD-21 | Approve Cook | A-06 decision → confirmation → authorized backend |
| AD-22 | Audit Docs | A-06 document viewer/checklist |
| AD-23 | View Dossier | A-05 |
| AD-24 | Fast-Track Pass | A-06 priority review proposal; never bypass mandatory checks |
| AD-25 | Treasury & Settlement / Live Escrow | X-03 later integration; cannot imply custody of funds |
| AD-26 | Liquidity / settlement window / ready and locked segments | X-03 distinct details, evidence-backed definitions |
| AD-27 | Disburse Scheduled Batch | X-03 review, permission/approval, execution and reconciliation subviews; L scope |
| AD-28 | Audit Ledger (CSV) | A-18 export review; X-03 ledger when treasury exists |
| AD-29 | Escrow Settings | X-03 settings; provider/legal scope required |
| AD-30 | Overview tab | A-01 |
| AD-31 | Users & Cooks tab | A-02 |
| AD-32 | Orders tab | A-09 |
| AD-33 | Settings tab | A-20 |

## Login — IMG-06

| ID | Visible element | Action / destination / data truth |
|---|---|---|
| LO-01 | Back arrow | Previous public entry; deterministic AU-01 fallback |
| LO-02 | “Phone Login” title | Match selected provider; email/password and phone OTP have different forms |
| LO-03 | Translate icon | SH-05 |
| LO-04 | Profile icon | AU-02 authentication entry or authorized own profile if already signed in |
| LO-05 | Service Online • Dhaka Hub | Observed service availability only; absent telemetry means no live claim |
| LO-06 | English / বাংলা toggle | SH-05/apply locale in place; preserve form |
| LO-07 | Brand mark, leaf, LIVE, tagline | Brand elements decorative; LIVE badge only if meaningful measured state |
| LO-08 | Customer role tab | Intent customer; Google eligibility copy; no privilege mutation |
| LO-09 | Supplier role tab | Intent supplier; onboarding/approval enforced |
| LO-10 | Rider role tab | Intent rider; current account grants enforced |
| LO-11 | Admin role tab | Intent admin; invited/authorized accounts only |
| LO-12 | Logging in as / Google sign-in available | Explain selected provider/context; never promise provider not configured |
| LO-13 | Email or Mobile input / @ icon | Validated provider-specific identifier; appropriate keyboard and autofill |
| LO-14 | Clear-input icon | Clear identifier, retain focus; accessible “Clear email/phone” label |
| LO-15 | Verified Safe badge | Replace with truthful security/help text; no unverified assurance |
| LO-16 | Password field / minimum length helper | Password for email flow; OTP separate AU-04; backend/provider validation authoritative |
| LO-17 | Eye icon | Toggle obscuring and announce visibility state; preserve cursor |
| LO-18 | Remember me checkbox | Explicit session persistence preference; never store raw password |
| LO-19 | Forgot Password | AU-05 |
| LO-20 | Login to Smart Tiffin + arrow | Validate → provider → AU-01 authoritative role routing; prevent duplicate submit |
| LO-21 | Fingerprint button | AU-11; unsupported/unconfigured recovery; conditional scope |
| LO-22 | Continue with Google / Customer Only | Provider → role validation; no role overwrite for existing accounts |
| LO-23 | Monthly Plan Offer / 20% savings / chevron | C-24; commercial claim conditional on actual approved offering |
| LO-24 | Sign Up Free | AU-03; “free” only if registration terms support it |
| LO-25 | Terms of Service | SH-09 terms view |
| LO-26 | Meal Hygiene Guidelines | SH-09 hygiene view |

## 2026-10-30 appendix — mapping to the legacy/proposed screen inventory

| Field | Value |
|---|---|
| Added | 2026-10-30, by the documentation lead |
| Purpose | Map all 153 screenshot controls (CU/SU/RI/AD/LO) to their home in the now-authoritative [complete screen inventory](COMPLETE_SCREEN_INVENTORY.md), since every row above was written against the superseded F129 planning inventory. |

**Mapping rule.** Every row above already names a destination (e.g. "→ C-01", "→ S-01", "→ R-01", "→ A-06"). For the Customer (`CU-*`), Supplier (`SU-*`) and Rider (`RI-*`) groups, those destination references coincide in prefix and low numbering with the **legacy prototype IDs** that are now authoritative (CU-01…09 → C-01; SU-01 → S-01; RI-01 → R-01; and so on through each group) — no remapping is needed beyond treating the cited destination as the legacy ID directly.

**Admin (`AD-*`) group — remapped, per conflict register C-06.** The F129 Admin numbering (A-01…A-33 in this file) does **not** match the legacy Admin IDs (A-01…A-19) one-to-one, and several controls describe finance/treasury functions now owned by Accounts Web:

| AD rows | New destination |
|---|---|
| AD-01…04, AD-30…33 (identity, tabs) | Legacy A-01 (tab), A-08 (tab), A-10 (tab), A-15 (tab), NA-01 |
| AD-05…09 (operational metrics) | NA-01, NA-06 |
| AD-10…14 (incidents/dispatch) | A-02, A-03, A-04, NA-04 |
| AD-15…17, AD-19…24 (disputes, onboarding, verification) | A-05, A-06, A-07, NA-03 |
| AD-18 (onboarding SLA/count) | NA-03 |
| **AD-25…29 (Treasury & Settlement, Live Escrow, Liquidity, Disburse Scheduled Batch, Escrow Settings)** | **Accounts Web: NF-01, NF-08, NF-12, NF-07/NF-08, NF-15** — explicitly moved off Admin entirely (conflict register C-06); Admin never gains custody-of-funds controls |

**Login (`LO-*`) group.** Maps to the shared Auth shell: LO-01…02, 04, 12…22, 24 → AU-03; LO-03, 06 → SH-05; LO-08…11 → AU-12; LO-19 → AU-04; LO-21 → AU-11 (biometric, conditional); LO-23 → P-03/C-04 (offer copy, subject to approved pricing); LO-25…26 → SH-09. LO-15's "Verified Safe badge" remains flagged for removal/replacement with truthful text, as the original row already states.

**No control is left without a home.** Every one of the 153 controls above resolves to a legacy or proposed screen ID through the rule above; the Admin financial controls are the only group requiring a different (Accounts Web) destination than their original F129 target.

## Cross-cutting audit criteria

Every icon button has a label and focus state; display-only icons are excluded from keyboard/touch focus. Every active control has a real action, destination or documented inline update. Repeated record cards apply the same contract to the correct record ID, not a shared hard-coded example. A future capability is a labelled design proposal, not an enabled button with a toast claiming success. Scope approval must explicitly accept release substitutions; the audit preserves original intent so functionality is not silently removed.
