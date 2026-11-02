# Partner App — Rider workspace: R-01 to R-10 and NR-01 to NR-06

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Purpose | Full contracts for the legacy rider screens and the six proposed rider screens. |
| Applies to | PAR (rider workspace) |
| Depends on | [Partner app rider modules](../../partner-app/RIDER_MODULES.md), [COD collection](../../partner-app/COD_COLLECTION.md), [Legacy prototype digest §7 Rider](../../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md) |
| Status | Legacy status OBSERVED; NR-* are PROPOSED. |

## Legacy screens (R-01…R-10)

| ID | Name · migration | Purpose | Elements → destination/command | Fixes / rules |
|---|---|---|---|---|
| R-01 | Active deliveries (tab) · Extend | Duty, assignment, map | Duty toggle; main CTA→`advanceDelivery`/`confirmPickup`; SOS→R-05 | **Earnings shown separate from COD** (fixes conflict C-07) |
| R-02 | Turn-by-turn · Reuse | Navigation aid | Exit→back | Never a source of authoritative state |
| R-03 | Proof of delivery · Extend | OTP/photo | Confirm→`submitDeliveryProof` | Privacy-safeguarded OTP |
| R-04 | Delivered · Reuse | Post-delivery next step | Start next→queue; Back→R-01 | — |
| R-05 | SOS · Reuse | Safety contact | Send SOS, Call 999 | Real destination PENDING approval |
| R-06 | Queued order · Reuse | Next offer | — | — |
| R-07 | Delivery history · Extend | Filterable history | Today/Week filter now functional (fixes legacy no-op) | — |
| R-08 | Rider earnings · Extend | Expected/confirmed/eligible/settled | Ledger-backed (NR-01) | Fixes "illustrative stats" gap |
| R-09 | Rider profile (tab) · Reuse | Edit, vehicle docs, safety | Edit→SH-08 | — |
| R-10 | Assignment offer · Extend | Accept/decline an offer | Accept→`acceptAssignment` | Conflict-prevented (SC-08) |

## Proposed screens (NR-01…NR-06)

| ID | Name · form | Purpose | Commands | Rules |
|---|---|---|---|---|
| NR-01 | Rider earning ledger · Full screen | Per-delivery expected/confirmed/held/paid/reversed | read `ent.RiderEarning` | BR-011 |
| NR-02 | Rider payout request · Full screen | Withdraw eligible balance only | `requestPayout` | BR-026 (no netting) |
| NR-03 | COD cash collection · Sheet | Record exact cash collected | `recordCodCollection` | glossary: never rider income |
| NR-04 | COD remittance submission · Full screen | Submit deposit evidence | `submitCodRemittance` | INV-12 |
| NR-05 | COD remittance discrepancy · Full screen | Respond to a mismatch case | `flagCodDiscrepancy` (read, respond) | SC-09 |
| NR-06 | Rider delivery dispute · Full screen | Report no-show/accident/failed delivery | `reportDeliveryFailure` | SC-21 |

## F129 reconciliation

Every F129 Rider-section family is mapped in [design/INVENTORY_RECONCILIATION.md](../INVENTORY_RECONCILIATION.md); none left unmapped.
