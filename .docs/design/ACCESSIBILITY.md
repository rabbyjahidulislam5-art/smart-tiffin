# Accessibility and bilingual validation plan

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (extends 1.0 with desktop/keyboard requirements for Admin Web and Accounts Web) |
| Owner | Design system author |
| Status | Acceptance design, not an accessibility audit result. |

2026-10-30 · Acceptance design, not an accessibility audit result.

## 2026-10-30 extension — desktop web (Admin Web, Accounts Web)

Full keyboard operability for every action, including financial approvals (no action available only via drag, hover-only menu, or mouse-only interaction); visible focus rings meeting the same contrast requirement as text; a documented tab order for every data table and detail panel; screen-reader announcement of a table's row count and current sort/filter state; no reliance on colour alone for a payout/journal status (icon + text, per the original rule, unchanged for desktop).

Use semantic headings, meaningful labels for all icons, selected/toggled/expanded states, ordered focus traversal and announce committed results and errors. Aim for text contrast at least 4.5:1 for normal text, 3:1 for large text and meaningful UI boundaries, measured on composited surfaces. Use touch targets at least 48 logical pixels; visual icons may be smaller inside them. Color, translucency, animation or position must never be the sole status indicator.

Verify TalkBack reading order and actions on a real/emulated Android target. Check 200% text scaling, keyboard/focus behavior on wide layouts, screen magnification, reduced motion, reduced-transparency fallback, landscape, system bars, safe areas, keyboard occlusion and sufficient scroll to reach primary actions. Financial values, dates, progress and timeline states need meaningful spoken labels.

English and Bangla share feature parity. ARB resources own labels, validation, notifications and accessibility strings. Preserve Bangla shaping and conjuncts; do not split grapheme clusters for avatars/truncation. Provide localized plural/number/date formatting from the approved currency/time policy. Test long names, long addresses, multiline error text and mixed Bangla/Latin references without corrupting provider identifiers. A language change must preserve safe drafts and current route. Native speaker review remains required before claiming translation quality.

Captures must include at least one complete customer, supplier, rider and admin journey in each language, plus every unique screen's translated variant in the design manifest. Automated semantics/overflow/golden checks complement manual checks; neither alone proves accessibility. Record actual results, device, scale, locale and build identity in the final test results.
