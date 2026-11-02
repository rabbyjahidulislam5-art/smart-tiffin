# Component specifications

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Design system author |
| Purpose | Specify every reusable component (legacy-derived and new financial/desktop components), its props, states, Flutter widget mapping and tests. |
| Depends on | [Design system](DESIGN_SYSTEM.md), [legacy prototype digest §6](../analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md), [architecture/REACT_TO_FLUTTER_MIGRATION.md](../architecture/REACT_TO_FLUTTER_MIGRATION.md) |
| Status | PROPOSED — NOT APPROVED. |

## Legacy-derived components (Flutter widget per prototype component)

| Component | Props | States | Flutter mapping |
|---|---|---|---|
| Screen shell | title, eyebrow, actions, footer | normal/loading/empty/error/offline/denied | `Scaffold` + themed `AppBar`/footer |
| Glass card | child, clickable | default/pressed/skeleton | `BackdropFilter` + themed `Container` |
| Chip | tone, icon | — | `Chip`-derived widget with themed colours |
| Btn | variant, size, disabled+reason | default/pressed/disabled/busy | `ElevatedButton`/`OutlinedButton`/`TextButton` wrapper |
| Row/List | icon, label, sub, destination | clickable/non-clickable | `ListTile`-derived widget |
| Timeline | steps, current | — | custom `Row`/`Column` of step widgets |
| Field | label, error, hint | empty/filled/focus/error/disabled | `TextFormField` wrapper |
| Toggle | on, label | — | `Switch` wrapper, `role="switch"` semantics |
| QuickActions | kind (role) | — | `GridView` of tiles + "More" sheet |

## New financial/desktop components

| Component | Props | States | Notes |
|---|---|---|---|
| Money field | amountMinor, currency | read-only/editable (editable never for an authoritative balance) | Always BDT, two-decimal display, integer minor units internally |
| Quote breakdown | lines[], total | loading/ready/expired | Shows every line itemised per [payments/PRICING_AND_BILLING.md](../payments/PRICING_AND_BILLING.md) |
| Schedule grid / calendar cell | date, slot, obligationState | scheduled/skipped/replaced/preparing/delivered/failed | Slot identifiers never translated as data |
| Credit ledger row | type, amount, origin, date | — | Class (service/promotional) always labelled |
| Status chip taxonomy | one shared enum across payment/COD/payout/delivery states | — | Icon + text, never colour alone |
| Approval panel | preparer, item, approve/reject actions | self-approval-blocked (absent, not disabled) | Enforces maker-checker visually and functionally |
| Data table (desktop) | columns, rows, filters, pagination | loading/empty/error/partial | Server-side cursor pagination |
| Reconciliation diff view | expected, actual, delta | matched/exception | Used by NF-02, NF-13, NF-17 |
| Timeline/state tracker | states[], current | stale (shows `generatedAt`) | Shared by delivery and financial state machines |

## Acceptance and verification

Design-only. Verification requires each component's state set to be exercised in [design/SCREEN_VERIFICATION_CHECKLIST.md](SCREEN_VERIFICATION_CHECKLIST.md) once implemented.
