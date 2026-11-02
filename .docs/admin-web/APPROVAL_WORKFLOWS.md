# Admin Web approval workflows

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Admin Web domain author |
| Purpose | Define the supplier/rider application review workflow (NA-03) and staff account lifecycle, fixing the legacy prototype's unpersisted checklist and admin-shortcut gaps. |
| Applies to | ADM |
| Depends on | [design/screens/PARTNER_APPLICATION_SCREENS.md](../design/screens/PARTNER_APPLICATION_SCREENS.md), [api/COMMANDS_LEDGER_AND_GOVERNANCE.md](../api/COMMANDS_LEDGER_AND_GOVERNANCE.md) |
| Status | PROPOSED — NOT APPROVED. |

## Application review (NA-03, legacy A-06/A-07)

Checklist gate (persisted server-side via `ent.Application`, fixing the legacy local-state-only checklist); **Approve** disabled until every check is ticked; **Request info** reopens a named section with a reason (≥ a minimum length); **Reject** requires a reason; every decision is server-authorised and recorded in `ent.AuditEvent`. The legacy AU-11→A-07 applicant shortcut is removed — an applicant has no path to see or influence the admin review screen.

## Document handling

Documents are previewed from their `evidenceRef`, access-restricted, never embedded inline; retention follows [database/DATA_RETENTION.md](../database/DATA_RETENTION.md) (open).

## Staff account lifecycle

Invited → Active → Suspended → Removed, via `grantStaffRole`/`revokeStaffRole`/`suspendAccount`; every transition audited with actor, target, reason and timestamp (NFR-021).

## No self-approval for Admin's own payout authority

Admin never holds payout-approval authority at all (conflict register C-06); this is enforced structurally, not merely by convention.

## Acceptance and verification

Design-only. Verification requires: a checklist state surviving navigation away and back; an applicant account unable to reach A-07/NA-03 by any route.
