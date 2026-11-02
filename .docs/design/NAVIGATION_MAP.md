# Navigation map

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Design system author |
| Purpose | Per-app complete route table: every screen reachable, every control's destination verified to exist, dead-end checks, and cross-app handoffs. |
| Depends on | [Navigation architecture](NAVIGATION_ARCHITECTURE.md), [Complete screen inventory](COMPLETE_SCREEN_INVENTORY.md) |
| Status | PROPOSED — NOT APPROVED. |

## Dead-end fixes (carried from the conflict register)

| Legacy gap | Fix |
|---|---|
| P-02 kitchen cards not clickable | → NC-02 (conflict register C-11) |
| C-11 loses `meal`/`plan` params from guest flow | Resume contract carries intent (C-11) |
| AU-11 admin-dossier shortcut | Removed (C-13) |
| SH-08 approval chip always "Approved" | Bound to real status (SH-08 Extend) |
| A-16 zone toggles no-op | Now functional (A-16 Extend) |
| R-07 Today/Week filter no-op | Now functional (R-07 Extend) |

## Cross-app handoffs

Customer → Partner: C-23 "Apply as a Cook/Rider" → AU-09/AU-10 (new application, separate app, same auth identity). Admin → Accounts: NA-05 limited view links to the corresponding NF screen only if the viewing principal also holds an Accounts grant (never a blind link). Accounts/Admin staff sign-in both use AU-13 with a role-grant check distinguishing which workspace opens.

## Per-app route completeness

Every screen ID in [COMPLETE_SCREEN_INVENTORY.md](COMPLETE_SCREEN_INVENTORY.md) has at least one entry route (from a tab, a QuickAction, or a cross-reference documented in its [design/screens/*](screens/) contract) and at least one exit route (back, a tab, or a completion action). This is verified in [verification/CONSISTENCY_AUDIT.md](../verification/CONSISTENCY_AUDIT.md).

## Acceptance and verification

Design-only. Verification requires a link-reachability sweep confirming no screen ID is referenced as a destination without existing in the inventory, and no screen ID exists without at least one documented entry point.
