# Admin Web dashboard

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Admin Web domain author |
| Purpose | Define the executive/operations command centre (NA-01) and its limited finance overview (NA-05), redesigned for real desktop use. |
| Applies to | ADM |
| Depends on | [architecture/MULTI_APP_ARCHITECTURE.md](../architecture/MULTI_APP_ARCHITECTURE.md), [conflict register C-06](../analysis/CONFLICT_REGISTER.md) |
| Status | PROPOSED — NOT APPROVED. This application does not exist. |

## NA-01 — Operations command centre

Desktop side navigation (not a stretched mobile dashboard, USER-REQ); KPI tiles for ongoing orders, kitchen capacity, dispatch risk and incidents; filterable work queues; each KPI drills into authorised detail (A-02/A-03/A-10 equivalents).

## NA-05 — Accounts oversight (limited view)

Approved non-sensitive financial KPIs (e.g. order volume trends, not account balances) and exception counts; opens contextual detail only when the viewing Admin's permission actually extends there — which, by design, excludes ledger, payout and credit detail (owned exclusively by Accounts Web, conflict register C-06).

## What moved to Accounts

Settlement execution, payout approval and journal access (legacy A-12/A-13) are **not** present here; a link to the relevant Accounts Web screen is shown only if the viewing Admin also holds an Accounts grant.

## Acceptance and verification

Design-only. Verification requires confirming an Admin-only session cannot reach a payout or journal command, even via a crafted deep link.
