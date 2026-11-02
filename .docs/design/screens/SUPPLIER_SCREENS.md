# Partner App — Supplier workspace: S-01 to S-12 and NS-01 to NS-07

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Purpose | Full contracts for the legacy supplier screens and the seven proposed supplier screens. |
| Applies to | PAR (supplier workspace) |
| Depends on | [Partner app modules](../../partner-app/), [Legacy prototype digest §7 Supplier](../../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md), [api/COMMANDS_IDENTITY_AND_CATALOGUE.md](../../api/COMMANDS_IDENTITY_AND_CATALOGUE.md), [api/COMMANDS_EARNINGS_AND_PAYOUTS.md](../../api/COMMANDS_EARNINGS_AND_PAYOUTS.md) |
| Status | Legacy status OBSERVED; NS-* are PROPOSED (not confirmed routes). |

## Legacy screens (S-01…S-12)

| ID | Name · migration | Purpose | Elements → destination/command | Fixes / rules |
|---|---|---|---|---|
| S-01 | Kitchen dashboard (tab) · Extend | Live status, orders, stock, **earned vs available balance shown separately** | Online toggle→`setSlotAvailability`; ReqCard Accept/Decline→`acceptOrder`/`declineOrder`; StockList→`setAvailability` | Fixes conflict C-07 (sample vs ledger-backed earnings) |
| S-02 | Order request detail · Reuse | Accept/decline, stage timeline | Mark packed→`advancePreparation` | — |
| S-03 | Cooking requirements · Extend | Lunch/dinner cooking list | Reads real obligation counts | Fixes "static ingredients" gap |
| S-04 | Menu & stock (tab) · Extend | Manage meals and stock | Meal card→S-05; Toggle→`setAvailability` | — |
| S-05 | Meal form · Extend | Create/edit a meal | Save→`saveFood`/`saveMealVariant` | Price moves to `saveMealVariant`+`schedulePriceChange` (fixes "no price field" gap) |
| S-06 | Supplier orders (tab) · Reuse | New/Cooking/Handed-off queues | Commitments→S-07 | — |
| S-07 | Subscription commitments · Extend | Future obligation counts | Reads real `ent.MealObligation` | Fixes "static" gap |
| S-08 | Earnings (tab) · Extend | Expected/earned/held/eligible/settled | Payout history→S-09 | Ledger-backed (NS-01) |
| S-09 | Payout history · Extend | Past payouts | — | "Recorded" ≠ settled, shown explicitly |
| S-10 | Kitchen profile · Reuse | Edit, docs, operating settings | Docs→S-11 | — |
| S-11 | Verification documents · Extend | Hygiene/trade docs | Upload→`saveEvidence` | Expiry triggers SC-17 |
| S-12 | Operating settings · Extend | Shifts, max portions, payout account | Save→`saveCapacity`/payout destination update | Persisted (fixes "not saved" gap) |

## Proposed screens (NS-01…NS-07)

| ID | Name · form | Purpose | Commands | Rules |
|---|---|---|---|---|
| NS-01 | Supplier earnings detail · Full screen | Break down each recognised earning | read `ent.SupplierEarning` | BR-009, BR-010 |
| NS-02 | Supplier payout request · Full screen | Request a payout | `requestPayout` | INV-14 |
| NS-03 | Supplier payout history · Full screen | Settled/failed/processing transfers | read `ent.PayoutResult` | — |
| NS-04 | Kitchen subscription forecast · Section (S-07 extension) | Future portions by date/recipe | read `ent.MealObligation` | — |
| NS-05 | Kitchen capacity scheduler · Section (S-04 extension) | Daily/slot limits | `saveCapacity`, `setSlotAvailability` | BR-022 |
| NS-06 | Menu price and version manager · Section (S-05 extension) | Price versions with effective dates | `schedulePriceChange` | ADR-009 |
| NS-07 | Kitchen pickup handoff · Sheet | Confirm custody transfer | `recordHandoff` | DEC-014 |

## F129 reconciliation

Every F129 Supplier-section family is mapped in [design/INVENTORY_RECONCILIATION.md](../INVENTORY_RECONCILIATION.md); none left unmapped.
