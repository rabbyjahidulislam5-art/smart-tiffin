# COD collection (Partner App, rider workflow)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Partner App domain author |
| Purpose | Define the rider-side COD collection, remittance submission and discrepancy-response workflow. |
| Applies to | PAR (rider workspace) |
| Depends on | [payments/COD_PAYMENT_WORKFLOW.md](../payments/COD_PAYMENT_WORKFLOW.md), [api/COMMANDS_PAYMENTS_AND_COD.md](../api/COMMANDS_PAYMENTS_AND_COD.md) |
| Status | PROPOSED — NOT APPROVED. |

## 1. Collection (NR-03)

On delivery, the rider records the exact amount tendered (`recordCodCollection`) with a customer acknowledgement step; this amount is immediately a company liability the rider owes, never personal income (glossary).

## 2. Remittance submission (NR-04)

The rider submits cash/transfer evidence (`submitCodRemittance`) with a unique deposit reference; the obligation stays `DueForRemittance` until Accounts verifies it (NF-04). Partial remittance is supported and shown as a reduced, not closed, liability.

## 3. Discrepancy response (NR-05, SC-09)

If Accounts flags a mismatch, the rider responds with evidence through a dedicated case, never by having their personal earnings record silently adjusted to hide the shortfall.

## 4. Independence from the four COD models

Which of the four models ([payments/COD_PAYMENT_WORKFLOW.md](../payments/COD_PAYMENT_WORKFLOW.md)) applies to a given delivery determines the cadence (per-delivery vs weekly batch vs monthly), but the rider-side screen flow (collect → submit → verify) is the same shape for all four.

## Acceptance and verification

Design-only. Verification requires SC-09 and SC-10 to be handled exactly as specified in the payments workflow document, with no duplicate-receipt or earnings-hiding path available to the rider UI.
