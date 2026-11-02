# React prototype to Flutter migration map

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Architecture lead |
| Purpose | Map the legacy React/TypeScript prototype's architecture (navigation, state, components) to Flutter equivalents for the four target applications, without copying its insecure shortcuts. |
| Depends on | [Legacy prototype digest](../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md), [multi-app architecture](MULTI_APP_ARCHITECTURE.md), [design/COMPLETE_SCREEN_INVENTORY.md](../design/COMPLETE_SCREEN_INVENTORY.md) |
| Status | PROPOSED — NOT APPROVED. The prototype is OBSERVED reference material, not code in this repository. |

## Navigation

| Prototype concept | Flutter target |
|---|---|
| In-memory stack navigator (`ProtoProvider`, `go/back/reset`), no URLs | Per-app `Navigator` 2.0 / router package with real route names; Flutter Web apps (ADM, ACC) additionally support browser history and deep links, which the prototype never had |
| `current.p` route params | Typed route arguments per screen, validated at the route boundary |
| Tabs calling `reset()` | Per-app bottom navigation (CUS, PAR) or side navigation (ADM, ACC) with preserved tab state, not a full stack reset, to avoid the prototype's own state-loss gaps |
| Guest protect-and-resume sheet (`afterLogin`) | A typed "pending intent" object carried through the real auth flow for **every** role, fixing the prototype gap where only customer accounts resumed correctly |

## State management

| Prototype concept | Flutter target |
|---|---|
| Global `Store` (in-memory, resets on reload) | Per-app state management (chosen at implementation time, not mandated globally — see [planning/TECHNICAL_EXECUTION_PLAN.md](../planning/TECHNICAL_EXECUTION_PLAN.md)) backed by real commands and read models, never an in-memory sample object |
| `appStatus`, `allApplicants`, `unreadCount` (hard-coded) helpers | Server-computed values from `ent.Application`, `ent.Notification` via real commands/reads, never a hard-coded "3 per role" |
| `touch(id)` resetting variant/sheet on navigation | Equivalent lifecycle hook per route, implemented without a shared global mutable object |

## Design tokens and components

| Prototype concept | Flutter target |
|---|---|
| CSS variables (`--role`, `--background`, …) in `index.css` | Flutter `ThemeExtension` per role/app, defined once in the shared `design_tokens_ui` package (see [design/DESIGN_SYSTEM.md](../design/DESIGN_SYSTEM.md)) |
| `.glass` (backdrop blur + translucent card) | A Flutter `BackdropFilter` + themed container widget, with the same contrast-over-imagery rule enforced in code (NFR-027), not left to chance |
| `Screen`, `NavRail`, `BottomNav`, `StateView`, `IconBtn`, `Card`, `Chip`, `Btn`, `Row`, `List`, `Section`, `Timeline`, `Field`, `Toggle`, `Segmented`, `ChipRow`, `Stat`, `Avatar`, `Note`, `Policy`, `Sample`, `QuickActions` | One Flutter widget each in `design_tokens_ui`, documented in [design/COMPONENT_SPECIFICATIONS.md](../design/COMPONENT_SPECIFICATIONS.md); the `IconBtn` 40px touch target is corrected to the 44px+ rule (NFR-003), not carried over as a defect |
| Four responsive bands (compact/medium/expanded/large) | Flutter's own window size classes, same four-band thresholds, used by `design_tokens_ui` layout helpers |

## Security shortcuts that are explicitly NOT migrated

Demo sign-in accounts and a fixed admin code; any-six-digit OTP acceptance; the AU-11 admin-dossier shortcut; a client-selected role granting any authority; `Store` state surviving sign-out. Each is listed in [analysis/CONFLICT_REGISTER.md](../analysis/CONFLICT_REGISTER.md) items C-13…C-15 with its real-auth replacement.

## Per-screen migration action

The full per-screen mapping (Reuse / Extend / Replace / Split for every one of the 94 legacy screens) is in [design/COMPLETE_SCREEN_INVENTORY.md](../design/COMPLETE_SCREEN_INVENTORY.md) and the per-group contract files in [design/screens/](../design/screens/); this document covers only the underlying architecture, not each screen's content.

## What this document does not establish

No Flutter code has been written under this migration map; it is a design reference only.
