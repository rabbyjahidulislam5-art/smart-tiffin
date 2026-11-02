# Data minimization and retention decisions

| Field | Value |
|---|---|
| Revision | 1.1 · 2026-10-30 (adds financial-record and PostgreSQL retention rows; original rows unchanged) |
| Owner | Architecture lead |
| Status | Retention durations and deletion authority are unresolved under DEC-010; no retention job is active. This document does not claim legal compliance or invent a statutory retention period. |

## 2026-10-30 extension

| Data | Purpose / access | Decision and handling requirement |
|---|---|---|
| Posted ledger journals (`ent.JournalEntry`, `ent.JournalLine`) | Financial audit, reconciliation, legal/tax evidence | Never deleted; retention likely exceeds the general operational window above and is subject to BR-018/BR-025 legal review, not a guessed duration |
| Gateway verification and COD remittance evidence | Payment dispute evidence, reconciliation | Retain at least as long as the related journal; raw gateway payloads minimised to what the dispute process needs |
| Application documents (`ent.ApplicationDocument`) | Partner onboarding evidence | Access-restricted; retention after rejection/approval undecided (DEC-010) |
| Rider location history (`riderLocations/{riderId}`) | Live tracking only | Short-lived; not retained as a location history beyond the active delivery (see [architecture/TIME_AND_CUTOFF_POLICY.md](../architecture/TIME_AND_CUTOFF_POLICY.md) consent note) |

Status: retention durations and deletion authority are unresolved under DEC-010; no retention job is active. This document does not claim legal compliance or invent a statutory retention period.

| Data | Purpose / access | Decision and handling requirement |
|---|---|---|
| Profile/contact/address | Identity and meal delivery; owner/authorized operations | Collect only needed fields; define export/deletion workflow and remove obsolete courier projections |
| Orders/subscriptions/pauses | Fulfilment history and dispute evidence | Decide useful history window and de-identification after account closure |
| Bills/verified payment evidence | Reconciliation, customer statement and audit | Owner to determine applicable obligations before any purge; minimize raw reference exposure |
| Reviews | Product feedback | Decide public attribution, edit/removal and moderation rules DEC-013 |
| Complaints | Resolution and dispute handling | Restricted access; decide retention after closure and attachments only if explicitly added |
| Device tokens | Notification routing | Delete/detach on logout, account deletion or invalidation; never use as an analytics identifier |
| Logs/audit/request receipts | Security, diagnostics and retry integrity | Redact content; keep receipts long enough for approved retry window and financial duplicate protection |
| Backups | Recoverability | Align retention, encryption/access and deletion handling with recovery design |

A delete request must be authenticated, checked for unresolved delivery/financial obligations, then executed according to approved policy. Explain retained categories and the basis to the user; do not silently erase financial audit evidence or refuse all deletion indefinitely. Roles and devices must be disabled promptly when account access ends even if restricted records are retained.

Deletion covers source data, projections, caches, search/index-derived exports, logs where applicable and backup expiry. A restore process must reapply deletion/tombstone records so previously removed personal information is not silently reintroduced. Test with synthetic accounts and preserve a minimal deletion audit without reproducing the deleted content.

No location history, provider PIN/OTP, contacts, microphone data or payment-card credentials are needed for current scope. Analytics is not selected. Backup design is canonical in [BACKUP_RESTORE](../operations/BACKUP_RESTORE.md).
