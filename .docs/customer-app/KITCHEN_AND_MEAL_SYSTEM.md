# Kitchen and meal system (Customer App)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Customer App domain author |
| Purpose | Define kitchen discovery, kitchen profile, menu-by-slot browsing, and the flexible (never hard-coded) meal/variant/price model from the customer's side. |
| Applies to | CUS |
| Depends on | [customer-app/CUSTOMER_MODULES.md](CUSTOMER_MODULES.md), [database/DATA_DICTIONARY.md](../database/DATA_DICTIONARY.md) §extension, [design/screens/CUSTOMER_NEW_SCREENS.md](../design/screens/CUSTOMER_NEW_SCREENS.md) |
| Status | PROPOSED — NOT APPROVED. |

## 1. Discovery (NC-01, fixes legacy P-02 dead end)

`searchKitchens` filters by cuisine tag, service zone, verification status and current availability. Every result card opens a valid kitchen detail destination (NC-02) — the legacy prototype's non-clickable kitchen cards are an explicitly closed gap (conflict register C-11).

## 2. Kitchen profile (NC-02)

Shows verification badge (bound to the real `ent.Kitchen.verificationStatus`, never a static badge — fixes the "badge ≠ verified document state" governance rule), approved service zones, operating hours, delivery slots, aggregate rating, and the live menu. The "verified" badge is read-only client state derived from server data; no client toggle can fabricate it.

## 3. Menu by slot (NC-03, legacy C-04/C-06)

Meals are grouped by `slot.breakfast`/`slot.lunch`/`slot.snack`/`slot.dinner` identifiers (never a hard-coded "today's special" list). Each meal shows its current `ent.PriceVersion`, portion/variant options, and allergen tags. Selecting a sold-out or unavailable item is disabled with an honest reason ("Restocks tomorrow"-style message, legacy pattern kept).

## 4. No hard-coded kitchen, meal, price or duration

Every screen reads the kitchen/meal/price/plan structure from the catalogue (MOD-CAT); nothing in the Customer App names a specific kitchen, meal or price in code or configuration (USER-REQ, explicit anti-hard-coding rule).

## 5. One-kitchen-per-order constraint (BR-021, PENDING)

The legacy one-kitchen-per-cart behaviour is preserved as the default for a single subscription agreement; a customer may still hold several independent agreements with different kitchens. Multi-kitchen-per-agreement remains BR-021/PENDING (SC-22): until approved, attempting it is explained before payment, not silently discarded.

## Acceptance and verification

Design-only. Verification requires: every kitchen card in the discovery list to open a working detail screen; a sold-out meal to be visibly and functionally disabled; a price shown to match the active `ent.PriceVersion` at view time.
