# Commands: delivery

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Backend and API architect |
| Purpose | Full command contracts for assignment, pickup, delivery-state progress, proof, failure and reassignment — file code **DL** in [API_SPECIFICATION.md](API_SPECIFICATION.md) §12. |
| Status | See status column. |

Format per command: **Purpose · Callers · Request · Response · Errors · Idempotency/transaction · Events · Screens · Refs.**

## `assignDelivery` (OBS-G, BR-004)
Purpose: direct dispatch of a delivery to a rider. Callers: Adm dispatcher (actor PENDING BR-004). Status today: gated. Screens: A-04. Refs: FR-019, FR-021; BR-004.

## `advanceDelivery` (OBS-G, BR-004/DEC-014)
Purpose: advance Pending → Picked Up → On The Way (the fourth state, Delivered, uses `submitDeliveryProof`). Callers: Rdr (currently assigned only). Errors: `out_of_order_transition`. Screens: R-01 main CTA. Refs: FR-020; BR-004.

## `reportIncident` (OBS-G, BR-004/DEC-014)
Purpose: report a delivery problem (not yet a formal failure outcome). Callers: Rdr, Sup, Cust, Adm. Screens: SH-06, R-01 "Report delay". Refs: FR-047, FR-022; BR-004.

## `offerAssignment` (PROP)
Purpose: offer a delivery to one or more eligible riders rather than directly assigning. Callers: Adm dispatcher, Sys (if BR-004 permits automatic routing). Request: `{orderOrObligationId, candidateRiderIds[]}`. Screens: R-10. Refs: FR-037; BR-004.

## `acceptAssignment` (PROP)
Purpose: a rider accepts an offered assignment, with conflict prevention so two riders cannot hold the same assignment. Callers: Rdr. Errors: `already_assigned` (race resolved; SC-08 simultaneous-pickup case). Idempotency: unique assignment-acceptance per delivery. Screens: R-10. Refs: FR-037; BR-004, BR-011.

## `confirmPickup` (PROP)
Purpose: rider confirms pickup from the kitchen. Callers: Rdr (assigned). Screens: R-01 (step 0→2), NS-07 handoff. Refs: FR-020, FR-047; DEC-014.

## `submitDeliveryProof` (PROP)
Purpose: complete the delivery with OTP or photo proof, the only path to the Delivered state. Callers: Rdr (assigned). Request: `{assignmentId, method, evidenceRef|otp}`. Errors: `proof_invalid`. Idempotency: one Delivered transition per assignment; triggers `recognizeRiderEarning`. Screens: R-03, R-04. Refs: FR-047, FR-034; BR-012.

## `reportDeliveryFailure` (PROP)
Purpose: record a failed/undeliverable outcome distinct from Delivered. Callers: Rdr (assigned). Request: `{assignmentId, reason, waitedMinutes}`. Effect: does not recognise the rider's completion earning; may place a hold. Screens: NR-06 (SC-21 missing-customer case). Refs: FR-047; BR-011, DEC-014.

## `reassignDelivery` (PROP, SAGA)
Purpose: move an assignment to a replacement rider without double payment. Callers: Adm dispatcher. Idempotency: FS→PG SAGA; posts `earningReversed` if the original rider's earning was already recognised (SC-08, Workflow WF-J). Screens: A-04. Refs: FR-037; BR-004, BR-011.

## `updateRiderLocation` (PROP)
Purpose: update the rider's live location for the current assignment's customer only. Callers: Rdr (assigned, consenting). Request: `{lat, lng}`. Rate-limited and coalesced (API spec §10); location visible only to the current customer, revoked immediately on reassignment/completion (SC-21 privacy rule). Screens: C-18, R-01 MiniMap. Refs: FR-048.

## `recordHandoff` (PROP)
Purpose: kitchen confirms custody transfer to the rider without prematurely completing the delivery. Callers: Sup (owning kitchen). Screens: NS-07. Refs: FR-047; DEC-014.
