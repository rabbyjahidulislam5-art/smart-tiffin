# Admin Web operations management

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Admin Web domain author |
| Purpose | Define customer/partner management, menu/kitchen oversight, subscription/order monitoring, delivery operations/rider reassignment, zone management, complaints/incidents/disputes, policy configuration and reporting. |
| Applies to | ADM |
| Depends on | [api/COMMANDS_DELIVERY.md](../api/COMMANDS_DELIVERY.md), [api/COMMANDS_LEDGER_AND_GOVERNANCE.md](../api/COMMANDS_LEDGER_AND_GOVERNANCE.md) |
| Status | PROPOSED — NOT APPROVED. |

## Customer and partner management (A-08/A-09 redesigned)

Searchable, sortable desktop tables; user detail with order/message/audit links; suspend/reactivate with a recorded reason.

## Menu and kitchen oversight

Read access to kitchen/menu data for quality monitoring; no direct edit of a supplier's own catalogue (that stays supplier-owned, MOD-CAT).

## Subscription and order monitoring (A-10/A-11 redesigned)

Today/Late/Disputed filters; order detail with party links; reassignment entry point.

## Delivery operations and rider reassignment (NA-04)

Incident dispatcher: delays, unavailable riders, supplier emergencies; `reassignDelivery` with the no-double-payment guarantee (Workflow WF-J) always enforced server-side, never assumed from the UI action alone.

## Service zones (NA-02 scope overlap)

Zone definition and boundary editing (legacy A-16 zone toggles, now functional, fixing the no-op gap).

## Complaints, incidents, disputes (A-02/A-03/A-05 redesigned)

Incident log and detail, dispute review feeding into Accounts' refund/chargeback workflow (never resolved with a direct balance edit by Admin).

## Policy configuration (NA-02)

Propose or approve permitted cutoff, zone, delivery and discount rules via `publishPolicyVersion`; preview consequences before publishing; versioned and effective-dated, never a silent overwrite.

## Reports (NA-06)

Operational reports (meal volume, retention, service failures, late orders, supplier quality) via `exportReport`; financial reports remain Accounts-only.

## Acceptance and verification

Design-only. Verification requires SC-07, SC-08, SC-16, SC-17 to each produce their documented Admin-side behaviour.
