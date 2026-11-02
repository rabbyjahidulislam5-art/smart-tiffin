# Responsive layouts

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Design system author |
| Purpose | Map the legacy four responsive bands to Flutter window size classes, per-app layout rules, and the adaptive strategy for financial tables on small screens. |
| Depends on | [legacy prototype digest §4, §8](../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md), [design system](DESIGN_SYSTEM.md) |
| Status | PROPOSED — NOT APPROVED. |

## Bands (unchanged from the legacy prototype, OBSERVED)

Compact < 600, medium 600–839, expanded 840–1199, large ≥ 1200 logical pixels. These map directly to Flutter's window size classes.

## Per-app layout rules

| App | Compact/medium (mobile) | Expanded/large (desktop/tablet) |
|---|---|---|
| CUS, PAR | Bottom nav on tab screens; single column; sheets slide from bottom | Icon/labelled nav rail; tab screens in up to 2 CSS-column-equivalent layout |
| ADM, ACC | Not primary targets, but a narrowed-window fallback uses stacked cards with pinned identifying columns | **Primary target.** Side navigation; full data tables; master/detail split panels |

## Financial table adaptive strategy (never silent overflow, NFR-020)

On a compact-band device (unlikely for ADM/ACC but required for any CUS/PAR financial screen such as billing or earnings): switch from a table to a card list, each card showing the row's identifying field, amount and status; a horizontal-scroll fallback with the identifying column pinned is used only where a card list would lose essential comparison ability (e.g. a multi-column reconciliation diff).

## Acceptance and verification

Design-only. Verification requires every financial screen to be checked at the compact band for zero clipped currency figures, per [design/SCREEN_VERIFICATION_CHECKLIST.md](SCREEN_VERIFICATION_CHECKLIST.md).
