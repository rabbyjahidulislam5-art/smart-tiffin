# Rider settlement (Accounts Web)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Accounts Web domain author |
| Purpose | Define the rider payable ledger screen (NF-06): compensation independent of COD custody, adjustments and remittance differences. |
| Applies to | ACC (screen NF-06) |
| Depends on | [partner-app/RIDER_EARNINGS.md](../partner-app/RIDER_EARNINGS.md), BR-011, BR-026 |
| Status | PROPOSED — NOT APPROVED. |

## Content

Per-rider table: recognised delivery compensation (`ent.RiderEarning`), separate from the rider's outstanding COD liability shown alongside but never merged (glossary: COD cash ≠ rider income). Adjustments (reassignment reversals, SC-08) and remittance differences (SC-09) are shown with their own reference. No automatic netting between the two balances occurs unless BR-026 is approved and an explicit offset is recorded.

## Reviewing eligibility before release

Before releasing a payout, Accounts reviews: recognised compensation minus holds minus any approved offset equals the eligible amount; a rider with an overdue COD remittance may (pending BR-013/BR-026) have payout eligibility restricted — this restriction, if enabled, is an explicit policy-driven hold, never an implicit block.

## Acceptance and verification

Design-only. Verification requires a fixture showing a rider's earned balance and COD liability displayed as two independent, correctly labelled figures that never combine into one number.
