# Inventory reconciliation: legacy 94, F129 planning inventory, and proposed 55

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Purpose | Two-way reconciliation ensuring nothing from the 129-family planning inventory (F129) or the 153 screenshot controls is lost when the legacy 94-screen prototype IDs become authoritative. |
| Depends on | [design/SCREEN_INVENTORY.md](SCREEN_INVENTORY.md) (F129, history), [design/SCREEN_AND_CONTROL_INVENTORY.md](SCREEN_AND_CONTROL_INVENTORY.md) (history), [design/COMPLETE_SCREEN_INVENTORY.md](COMPLETE_SCREEN_INVENTORY.md) |
| Status | Authoritative reconciliation. Conflict register item C-05. |

## Why this file exists

Two numbering schemes both use the prefixes `AU-`, `SH-`, `C-`, `S-`, `R-`, `A-`, `X-` but describe **different screens**: the F129 planning inventory (129 families, written before the legacy prototype was supplied) and the legacy 94-screen prototype (now authoritative, per the user's 2026-10-30 instruction and the corrected [source material register](../requirements/SOURCE_MATERIAL_REGISTER.md)). This file maps every F129 family to its legacy or proposed successor so nothing the F129 inventory specified is dropped.

## Mapping method

Each F129 family is mapped by **subject matter**, not by coincidentally shared ID text (an F129 `AU-01` session-resolver screen is NOT the same as legacy `AU-01` Splash — they are cross-referenced as `F129/AU-01` vs `AU-01` throughout this documentation set per [conventions §4](../analysis/CONVENTIONS_AND_ID_REGISTER.md)).

## Reconciliation table (by F129 section)

| F129 section | F129 families (count) | Disposition | Target legacy/proposed IDs |
|---|---|---|---|
| Authentication and onboarding | F129/AU-01…12 (12) | Mapped | AU-01…13 (legacy, richer detail), AU-09/10 application steps extended by F129's document/evidence requirements |
| Shared pages and overlays | F129/SH-01…20 (20) | Mapped | SH-01,02,04…10 (legacy, 9 IDs) absorb the content; F129's extra granularity (reauthentication, device sessions, account closure, search/filter sheet, date/slot chooser) folds into the Extend scope of SH-05/SH-08 and into [design/UI_UX_GUIDELINES.md](UI_UX_GUIDELINES.md) shared-overlay patterns, not lost — see [SHARED_SCREENS.md](screens/SHARED_SCREENS.md) |
| Customer | F129/C-01…29 (29) | Mapped | C-01…25 (legacy) + NC-01…19 (proposed); F129's kitchen-discovery, custom-schedule and credit-ledger content directly motivated NC-01…19 |
| Supplier | F129/S-01…22 (22) | Mapped | S-01…12 (legacy) + NS-01…07 (proposed); F129's capacity/forecast/price-version granularity became NS-04/05/06 |
| Rider | F129/R-01…12 (12) | Mapped | R-01…10 (legacy) + NR-01…06 (proposed); F129's COD-specific granularity became NR-03/04/05 |
| Admin | F129/A-01…27 (27) | Mapped, with a **split** | A-01…19 (legacy) + NA-01…06 (proposed); F129's treasury/payout/escrow content (A-12/A-13 equivalents) is **re-pointed to Accounts Web** (NF-07, NF-08), per conflict register C-06, not dropped |
| System | F129/X-01…07 (7) | Mapped | X-01…02 (legacy, tooling only); F129's additional verification-report granularity folds into [SCREEN_VERIFICATION_CHECKLIST.md](SCREEN_VERIFICATION_CHECKLIST.md) |

**Total F129 families reconciled:** 12+20+29+22+12+27+7 = 129. ✓ None left unmapped.

## Screenshot controls (153, from SCREENSHOT_ACTION_AUDIT.md)

The 153 `CU-`/`SU-`/`RI-`/`AD-`/`LO-` screenshot control IDs are mapped to their owning legacy or proposed screen in the appended mapping table in [design/SCREENSHOT_ACTION_AUDIT.md](SCREENSHOT_ACTION_AUDIT.md) (added 2026-10-30); none is left without a home. Where a control's described behaviour (e.g. a specific button or chip) has no exact legacy equivalent, it is folded into the nearest proposed screen's Elements table in [design/screens/*](screens/).

## Net result

- Legacy 94 IDs: authoritative, unchanged, fully specified in [design/screens/*](screens/).
- F129 129 families: fully reconciled, zero orphans, each pointing to a legacy or proposed ID (or, for the Admin treasury/payout case, explicitly to Accounts Web).
- 153 screenshot controls: fully mapped (see the audit file's appendix).
- Proposed 55 (NC/NS/NR/NA/NF): each one traced back to a specific F129 family or a specific master-prompt instruction, never invented without a source.

See [design/COMPLETE_SCREEN_INVENTORY.md](COMPLETE_SCREEN_INVENTORY.md) for the final 149-screen count across the four applications.
