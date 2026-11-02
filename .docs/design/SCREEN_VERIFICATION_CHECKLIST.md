# Screen verification checklist

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Design system author |
| Purpose | The per-screen checklist template, extending the legacy X-02 nine-check model with permission/accessibility/i18n/navigation/evidence rules, and the explicit rule that PASS requires recorded evidence. |
| Depends on | [legacy prototype digest §7 X-02](../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md), [design/screens/TOOLING_SCREENS.md](screens/TOOLING_SCREENS.md) |
| Status | PROPOSED — NOT APPROVED. No screen has been verified by this effort. |

## The nine original checks (OBSERVED, X-02)

Design, Responsive, Overflow, Icons/Buttons, Navigation, Light/Dark, EN/BN, Functional UI, Screenshot.

## Extended checks (2026-10-30)

| # | Check | Pass condition |
|---|---|---|
| 10 | Permission | Every role-restricted action on the screen is verified denied for an unauthorised role at the command layer, not merely hidden |
| 11 | Accessibility | Touch targets ≥ 44px (mobile) or full keyboard operability (desktop); contrast measured on the composited surface |
| 12 | Internationalisation | Every string has an English and Bangla variant; no clipped text at either language's longest form |
| 13 | Navigation | Every control's destination exists and is reachable; no dead end |
| 14 | Evidence | A dated screenshot/recording and the actual command/test run backing the Functional UI check are attached |

## PASS rule (unchanged in spirit from X-02, restated)

A row is **PASS** only if all fourteen checks are ✓ **with recorded evidence**; **FAIL** if any is ✗; otherwise **PENDING**. An empty tracking table is never filled with assumed passes. No screen in this documentation set has been verified; see [verification/FINAL_VERIFICATION_REPORT.md](../verification/FINAL_VERIFICATION_REPORT.md) for what was actually checked (documentation structure only, not rendered screens).

## Acceptance and verification

This checklist itself is a template; it produces evidence only when actually run against implemented, rendered screens.
