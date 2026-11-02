# Proposed restrained glass design system

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (extends 1.0 for four apps and the Accounts identity; original tokens unchanged) |
| Owner | Design system author |
| Depends on | [legacy prototype digest §6](../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md), [component specifications](COMPONENT_SPECIFICATIONS.md) |
| Status | Design specification for approval. Tokens are proposals, not measured contrast/performance results or rendered outputs. |

2026-10-30 · Design specification for approval. Tokens are proposals, not measured contrast/performance results or rendered outputs.

## 2026-10-30 extension — fifth accent and desktop density

A fifth, deliberately restrained **Accounts accent** (`#2B5A6B`, a muted slate-teal, chosen to read as distinct from both Admin's indigo and Supplier's green at a glance) is added for Accounts Web, alongside the four original role accents (customer orange, supplier green, rider blue, admin indigo — all carried unchanged from the legacy prototype, see [source digest §6](../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md)). Admin Web and Accounts Web both add a **desktop density** variant: tighter vertical rhythm (spacing scale 4/8/12/16/24 instead of up to 48), real data tables with sortable headers, and side navigation instead of a bottom nav/rail. Money display uses integer BDT minor units formatted to two decimals in both English and Bangla numerals per locale (NFR-006, NFR-019).

## Visual direction

Preserve the tiffin mark and warm orange customer identity. Use a warm near-white canvas with quiet tinted layers, generous spacing, dark readable text and translucent navigation/summary surfaces. Glass is a small material accent; long lists, forms, money summaries and critical actions use opaque surfaces. Food photography provides warmth without becoming background behind text. Supplier green, rider blue and admin indigo identify workspace context while shared component geometry stays consistent.

| Token | Proposed value / use |
|---|---|
| Canvas | `#FAF8F5` warm white |
| Surface | `#FFFFFF`, opaque for inputs and critical content |
| Primary text | `#17212B` |
| Secondary text | `#52616D`; validate contrast on actual surface |
| Customer accent | `#C44B00` for text/buttons; `#FF7A18` decorative warmth |
| Supplier accent | `#08664B` |
| Rider accent | `#124DB7` |
| Admin accent | `#4330A8` |
| Error | `#B42318` with icon, text and recovery |
| Success | `#08744F` with explicit state text |
| Warning | `#854A0E`; pale warm background |
| Glass | White 88–94% opacity, thin neutral border; blur 8–12 logical pixels only behind bounded navigation/summary regions |
| Radii | Inputs 12; cards 20; sheets 24; chips fully rounded |
| Spacing | 4/8/12/16/24/32/48 logical pixels; screen gutters 20 narrow, 24 medium, 32 wide |
| Shadow | One soft low-opacity layer, no stacked bright glows |
| Motion | 120–180ms state feedback, 200–260ms page/sheet transition; reduced-motion alternative |

Never depend on alpha alone for contrast. Measure final composited text/background combinations, including imagery behind glass. Offer opaque/reduced-transparency rendering when blur/contrast or device performance requires it. Do not blur scrolling list items independently or stack large offscreen filters.

## Typography, icons and content

Use an approved, locally bundled Latin/Bangla font pair with license files; candidate Noto Sans and Noto Sans Bengali require source/license verification at asset selection. Avoid synthetic condensed headings. Proposed scale: hero 28/36, page title 24/32, section 20/28, card title 18/26, body 16/24, supporting 14/22, compact label 12/18. Bangla may need greater line height; verify shaping and wrapping in real Flutter renders.

Use one coherent Material icon family initially. Icons supplement text, especially status and bottom navigation. No emoji as the sole functional icon. Full labels remain available to semantics when visibly truncated. Format currency/dates via approved locale/timezone rules; do not concatenate translated fragments or use hard-coded English plural forms. বাংলা and English labels remain readable in the language selector.

## Component specification

| Component | Anatomy and behavior | Required variants |
|---|---|---|
| Role shell | Title, one notification entry, account entry, bottom nav/rail/sidebar | Four accents; active/inactive; unread; offline; large text |
| Glass summary card | Eyebrow, main value, context, optional single action | Read-only/clickable; skeleton; absent data; no fake stats |
| Primary/secondary/destructive button | Label, optional leading icon, full hit target | Default/focus/pressed/disabled(reason)/busy; no layout jump |
| Food card | Photo, full accessible title, kitchen, attributed badges, price basis, CTA | Available/sold out; image failure; no rating; long Bangla title |
| Plan card | Accepted name, interval/slots, cycle progress, policy-dependent actions | Active/upcoming/paused/ended; no plan; unavailable action |
| State timeline | Ordered canonical labels, timestamp, actor where permitted | Pending/complete/current; stale; no color-only meaning |
| Order/job row | Identifier, service window, quantity, separate preparation/payment/delivery labels | New/accepted/history; loading; conflict; long address |
| Input field | Persistent label, value, helper/error, optional affordance | Empty/filled/focus/error/read-only/disabled; secure reveal |
| Selection group | Tabs/chips/radio/check; clear selected semantics | Keyboard/focus; translated wrapping; disabled explanation |
| Status badge | Icon + short textual status | Pending/verified/rejected/stale; no unverified seals |
| Amount summary | Itemized signed lines, basis, due, verified amount | Pending reference; adjustments; unavailable policy/data |
| Calendar | Month/week, service slots, legend and eligible selections | Paused/unavailable/selected/today; accessible linear alternative |
| Confirmation sheet | Action, target, consequence, reason if needed | Normal/destructive/financial; cancel; busy; unknown outcome |
| Feedback panel | Human-readable problem and exact next action | Empty/loading/offline/error/denied/success; retry preserves context |
| Admin table | Bounded result count, filters, row actions, detail pane | Narrow stacked cards; pagination; keyboard; sensitive-field masking |
| File/evidence item | Name/type/size, purpose, review status | Upload progress/failure; rejected type; protected view; remove confirmation |

## Layout recipes

- **Customer:** greeting and active service first; prominent plan and delivery; two meal cards; simple category browsing. Keep Subscribe attached to price/terms; remove repeated bells by consolidating to the same inbox entry.
- **Supplier:** kitchen availability and time-critical order queue above secondary revenue. Cooking quantities and stage actions stay visible without giant charts. Present accept/decline consequences clearly.
- **Rider:** current assignment, pickup/dropoff and next legal action dominate. Contact targets are large; keep scrolling and typing minimal. Safety action remains visually distinct. Map imagery cannot replace usable address information.
- **Admin:** actionable incidents and applications first, real aggregate metrics second. On wide layouts, combine list and detail; on mobile, use clean stacked records. Distinguish monitoring from permission to mutate.
- **Authentication:** one focused provider form, explicit role intent, visible recovery/registration, unobtrusive legal links. Avoid the screenshot's mixed phone/password semantics and unsupported “Verified Safe” badge.

Proposed adaptive breakpoints: below 600 logical pixels use a single column; 600–1023 use rail and optional two columns; 1024+ use sidebar/master-detail where appropriate. Content width, not device name, drives layout. Validate at 360, 390, 600 and 1024 widths plus selected real Android devices. These are test proposals, not evidence.

## Legacy prototype token mapping (OBSERVED, now the primary visual reference)

The legacy React prototype's actual tokens are now the primary reference rather than an independent proposal: warm cream background `30 33% 97.5%` (dark `24 12% 8%`), customer `24 95% 53%`, supplier `158 64% 36%`, rider `221 83% 53%`, admin `243 75% 59%`, glass = card 72% opacity + 18px blur + 1.4 saturate. The restrained palette above is reconciled toward these legacy HSL values at implementation time rather than treated as a competing system; both describe the same warm, card-based, glass-accented identity.

## Visual approval gate

After planning approval, render each role dashboard and auth screen to establish composition, then all inventory destinations and states using the same tokens. Compare against the control audit before approving the design set. Do not treat a single attractive dashboard as approval of the whole frontend. [PDF requirements](PDF_PRODUCTION_PLAN.md) define the final visual evidence.
