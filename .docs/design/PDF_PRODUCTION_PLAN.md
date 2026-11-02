# All-screen frontend PDF production and acceptance

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (updates scope and counts for four apps and the 149-screen inventory; original production workflow unchanged) |
| Owner | Design system author |
| Depends on | [Complete screen inventory](COMPLETE_SCREEN_INVENTORY.md) |
| Status | No final design PDF exists. |

## 2026-10-30 scope update

The PDF now covers **four applications** (Customer, Partner with its two workspaces, Admin Web, Accounts Web) and **149 screens** (94 legacy + 55 proposed), per [COMPLETE_SCREEN_INVENTORY.md](COMPLETE_SCREEN_INVENTORY.md), superseding the original single-app, 129-family count below. Content order gains a tenth section: Accounts Web (finance dashboard → payments/COD → settlement → payouts → ledger/reconciliation → reports). This remains a later deliverable, produced only after the four applications exist and are visually verified; nothing is rendered by this documentation phase.

2026-10-30 · **No final design PDF exists yet.** The requested PDF is produced after actual screen rendering and implementation verification. This plan is not a substitute for that deliverable.

## Content order

1. Cover, build/design revision, release boundaries and evidence legend.
2. Color/material/typography/icon system, responsive rules, accessibility and reusable components.
3. Authentication and onboarding.
4. Customer: Home → discovery → purchase → subscriptions → delivery → finance → feedback/profile.
5. Supplier: dashboard → menus/plans → orders/cooking/handoff → earnings/profile.
6. Rider: current work → pickup/route/completion → incidents/safety → history/profile.
7. Admin: overview → people/approval → orders/assignment/incidents → complaints/finance → settings/audit.
8. Shared settings, notifications, support and all dialogs/sheets, with role-specific variants.
9. Clearly marked later-release designs, including live GPS, gateway and escrow/settlement.
10. Complete route/control coverage and verification/blocker appendix.

## Actual visual output requirements

Every unique screen and expanded child view gets an actual Flutter-rendered image and named PDF destination. No text-only page, screenshot filename, generic placeholder or reused dashboard image counts as a screen design. Full-page compositions include all content: long pages use full-scroll capture plus readable continuation pages where necessary, rather than shrinking 1600px of content into illegible text.

Each screen entry contains stable ID, name, role, route/entry source, release label, locale, viewport, actual preview, controls and destinations, data/permissions, responsive notes and applicable state previews. Include all nested sheets/dialogs/forms and confirmation/result designs. Use separate state pages/contact sheets only when labels and previews remain readable at normal PDF zoom. Bangla must render with embedded licensed fonts. Images must not contain real personal information or unlabelled synthetic “live” metrics.

## Capture manifest contract

Before rendering, expand all inventory families into unique views. Suggested entry fields:

```text
screenId, childView, role, route, release, locale, viewport,
state, requiredControls, sourceRequirements, sourceScreenshotControls,
renderPath, renderHash, buildRevision, captureCommand, pdfPage,
visualReview, interactionTestEvidence, blockers
```

The exact serialization is selected during implementation. State omission requires explicit not-applicable rationale; missing is not equivalent to not applicable. Runtime captures must come from deterministic synthetic scenarios covering empty/normal/error/stale and policy-approved edge cases. Record demo fixture use visibly in the documentation; it is not live integration evidence.

## Production workflow and checks

Use the installed PDF skill and bundled workspace runtime when this phase begins. Capture from tested Flutter UI with fixed viewports/locales; use standard PDF tooling with bookmarks, a linked contents page, page numbers and consistent role dividers. Derive coverage from the same screen/route manifest used for navigation tests. Expand X-03 treasury into overview, ready/locked lists, batch detail/review, approval, outcome/reconciliation and settings before capture.

Render the produced PDF back to page images. Visually inspect **every page**, including clipping, glyph shaping, tiny captions, blank/missing images, long forms, footer collisions, and page order. Check the actual image/page count and set equality against all required screen/state entries. A 100% inventory-row count is insufficient if child views, overlays or translated states are missing. Record command outcomes and visual findings separately from runtime interaction tests.

Final PDF delivery requires a downloadable local file, SHA-256, page count, capture manifest and per-page audit. Links must resolve to packaged assets and source. No claim that the all-in-one PDF is complete until both page audit and coverage checks pass.
