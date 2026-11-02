# Customer App UI/UX

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Customer App domain author |
| Purpose | Preserve the legacy warm-orange visual identity while extending it to the new subscription, credit and billing screens; define state design and responsive/accessibility behaviour specific to CUS. |
| Applies to | CUS |
| Depends on | [design/DESIGN_SYSTEM.md](../design/DESIGN_SYSTEM.md), [analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md](../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md) §6 |
| Status | PROPOSED — NOT APPROVED. |

## Preserved identity

Warm orange role colour, glass hero cards, rounded-3xl cards, appealing meal photography, QuickActions four-tile pattern with a "More" sheet, the guest-protect-and-resume sign-in sheet — all carried from the legacy prototype (see the design token mapping in [design/DESIGN_SYSTEM.md](../design/DESIGN_SYSTEM.md)).

## New screens follow the same language

NC-01…NC-19 use the same card/glass/orange vocabulary as the legacy C-* screens; a customer should not be able to tell, by look alone, which screen is "new" and which is "legacy".

## State design

Every data screen has loading (skeleton, not spinner-only), empty (with a clear next action), success, error (retry), offline (explicit, not a frozen screen) and denied states, per [design/UI_UX_GUIDELINES.md](../design/UI_UX_GUIDELINES.md). Financial screens (billing, credits) additionally have a "stale data" indicator with a `generatedAt` timestamp.

## Responsive and accessibility

Compact/medium/expanded/large bands per [design/RESPONSIVE_LAYOUTS.md](../design/RESPONSIVE_LAYOUTS.md); the legacy `IconBtn` 40px touch target is corrected to 44px+ (NFR-003); financial tables (billing, credit history) use the small-screen adaptive strategy defined centrally, never silent overflow.

## Acceptance and verification

Design-only. Verification requires a side-by-side visual review confirming NC screens are indistinguishable in style from legacy C screens, and a touch-target audit confirming no control is below 44px.
