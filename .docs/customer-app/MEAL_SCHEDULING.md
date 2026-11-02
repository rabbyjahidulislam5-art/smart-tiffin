# Meal scheduling (Customer App)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Customer App domain author |
| Purpose | Define the calendar UI behaviour, slot identifiers vs labels, time-zone handling, and draft survival across a language switch. |
| Applies to | CUS |
| Depends on | [architecture/TIME_AND_CUTOFF_POLICY.md](../architecture/TIME_AND_CUTOFF_POLICY.md), [design/screens/CUSTOMER_NEW_SCREENS.md](../design/screens/CUSTOMER_NEW_SCREENS.md) (NC-06) |
| Status | PROPOSED — NOT APPROVED. |

## 1. Calendar (NC-06, legacy C-13)

Shows every obligation in the billing period with its real server-derived cutoff and meal-level status (scheduled/skipped/replaced/preparing/delivered); the legacy 30-day grid's static done/today/paused/upcoming states are replaced by the actual `ent.MealObligation.state`.

## 2. Slot identifiers vs labels

Internally, every obligation stores `slot.breakfast`/`slot.lunch`/`slot.snack`/`slot.dinner`; the UI renders the correct localised label at display time. A language switch never changes which slot an obligation belongs to (SC-18).

## 3. Time zone

All dates and cutoffs shown come from the server's Asia/Dhaka derivation of the canonical UTC instant (ADR-013); the device's own time zone never changes which day a meal is scheduled for.

## 4. Draft survival across language switch (SC-18)

A customer mid-draft on the subscription builder who switches English↔Bangla keeps every selection, quantity and date; only the displayed labels change. This is tested explicitly, not assumed from the underlying state management choice.

## Acceptance and verification

Design-only. Verification requires SC-18's acceptance test: switching language mid-draft on a narrow device preserves all selections and clips no text.
