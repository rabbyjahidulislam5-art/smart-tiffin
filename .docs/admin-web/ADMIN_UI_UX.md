# Admin Web UI/UX

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Admin Web domain author |
| Purpose | Desktop layout system for Admin Web, migrating the legacy indigo mobile admin screens into a real desktop experience. |
| Applies to | ADM |
| Depends on | [design/DESIGN_SYSTEM.md](../design/DESIGN_SYSTEM.md), [design/COMPONENT_SPECIFICATIONS.md](../design/COMPONENT_SPECIFICATIONS.md) |
| Status | PROPOSED — NOT APPROVED. |

## Layout

Side navigation, data tables with filters, dashboards with charts, approval panels, detail views — the same desktop pattern family as Accounts Web (shared components from `design_tokens_ui`), with the indigo admin accent preserved from the legacy prototype.

## Migration of mobile admin screens

Each legacy A-xx screen's content is retained; its layout is redesigned for desktop (wider tables instead of stacked cards, side-by-side detail panels instead of full-screen navigation) per the migration action recorded in [design/screens/ADMIN_SCREENS.md](../design/screens/ADMIN_SCREENS.md).

## Keyboard shortcuts and bulk actions

List navigation shortcuts; bulk actions (e.g. bulk complaint triage) use an explicit confirmation dialog stating the affected count.

## Light/dark, Bangla, accessibility

Same token system as the other three apps; full keyboard operability for every action (NFR-003).

## Acceptance and verification

Design-only. Verification requires a screenshot-based review per screen per [design/SCREEN_VERIFICATION_CHECKLIST.md](../design/SCREEN_VERIFICATION_CHECKLIST.md) once implemented.
