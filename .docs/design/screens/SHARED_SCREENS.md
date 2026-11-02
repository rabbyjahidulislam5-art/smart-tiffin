# Shared screens: SH-01, SH-02, SH-04…SH-10 (per-app instances)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Purpose | One contract per shared screen with an instances table showing role-scoped content across all five app contexts. |
| Applies to | CUS, PAR-Supplier, PAR-Rider, ADM, ACC |
| Depends on | [Legacy prototype digest §7 Shared](../../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md), [api/EVENT_AND_NOTIFICATION_DESIGN.md](../../api/EVENT_AND_NOTIFICATION_DESIGN.md) |
| Status | Prototype status (I/U/S) OBSERVED and carried verbatim; server-enforced scoping is PROPOSED. |

## Rule

Every shared screen is **one route per app context**, server-scoped to that context's role; no cross-role data ever appears regardless of navigation path (fixes the legacy "no role guard" gap).

## SH-01 Notifications · Extend
Role-specific list from `ent.Notification` (not a hard-coded "3 per role"); Mark-all-read via the dedicated read-state write ([events §5](../../api/EVENT_AND_NOTIFICATION_DESIGN.md)); tap navigates to the real originating entity. **Instances:** CUS (order/payment/credit events), PAR-Supplier (order/payout events), PAR-Rider (assignment/payout/COD events), ADM (incident/application events), ACC (reconciliation/period/payout events).

## SH-02 Chat · Extend
Audit-safe conversation (fixes "messages are not sent" gap) between a customer and their current rider/supplier contact, or a support agent. **Instances:** same shape across CUS/PAR, scoped to the current order/delivery context only.

## SH-04 Help & support · Reuse
Chat→SH-02, Call, Ticket→SH-06. **Instances:** identical across all five apps; FAQ content is role-specific.

## SH-05 Settings & language · Reuse
Language, theme, notification settings link. **Instances:** ACC/ADM add a session-timeout display given higher privilege.

## SH-06 Report a problem · Reuse
Reason grid, description, photo. **Instances:** CUS/PAR only (ADM/ACC use incident/case screens instead).

## SH-07 Ticket status · Extend
Bound to real `ent.Ticket`/`ent.Complaint` data (fixes legacy static U status).

## SH-08 Edit profile · Extend
Per-role fields plus a Sensitive card for supplier/rider (business/payout/NID details); **approval chip now bound to real `ent.Application`/`ent.StaffAccount` status** (fixes legacy always-"Approved" gap); sensitive-field change triggers re-verification (`reverify`).

## SH-09 Notification settings · Extend
Essential (locked) vs optional (persisted, fixes legacy local-only toggle), per [events §2](../../api/EVENT_AND_NOTIFICATION_DESIGN.md).

## SH-10 Email history · Extend
Real provider delivery status (Queued/Accepted/Delivered/Failed) with Retry; admin-only template preview remains ADM/ACC-only.

## F129 reconciliation

Every F129 Shared-section family (the 20-row planning inventory SH-01…SH-20) is mapped in [design/INVENTORY_RECONCILIATION.md](../INVENTORY_RECONCILIATION.md); none is left unmapped — several F129 shared rows (account closure, data request, reauthentication, device sessions) fold into SH-05/SH-08's extended scope here.
