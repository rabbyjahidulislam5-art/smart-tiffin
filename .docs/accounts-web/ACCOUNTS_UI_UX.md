# Accounts Web UI/UX

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Accounts Web domain author |
| Purpose | Desktop layout system for Accounts Web: navigation, data tables, filters, detail panels, bulk actions, keyboard shortcuts, export, and the complete list of NF screens with their components and states. |
| Applies to | ACC |
| Depends on | [design/DESIGN_SYSTEM.md](../design/DESIGN_SYSTEM.md), [design/COMPONENT_SPECIFICATIONS.md](../design/COMPONENT_SPECIFICATIONS.md), [design/RESPONSIVE_LAYOUTS.md](../design/RESPONSIVE_LAYOUTS.md) |
| Status | PROPOSED — NOT APPROVED. |

## Layout

Fixed left side navigation (sections listed in [ACCOUNTS_ARCHITECTURE.md](ACCOUNTS_ARCHITECTURE.md) §3); a top bar with role indicator, period selector and export action; a main content area that is a data table for list screens (NF-02, NF-03, NF-05, NF-06, NF-07, NF-11, NF-13) or a dashboard grid for NF-01, with a right-side detail panel that opens without losing the list's scroll position or filter state.

## Data tables

Server-side pagination (cursor-based, per [api/API_SPECIFICATION.md](../api/API_SPECIFICATION.md) §8), column filters, saved filter presets, sortable columns with a stable secondary sort key, and a deliberate strategy for narrow windows (horizontal scroll with pinned identifying columns, never silent clipping — NFR-020).

## Bulk actions

Payout batch creation (NF-08) and reconciliation-exception bulk assignment (NF-13) use an explicit selection + confirmation dialog pattern that states exactly what will happen and to how many items; no bulk action is irreversible without a typed confirmation.

## Keyboard shortcuts

List navigation (arrow keys), quick filter focus, and an approval-screen shortcut that still requires an explicit confirming click for any money-moving action (keyboard convenience never substitutes for the confirmation step).

## Screens summary table

| Screen | Primary components | Key states |
|---|---|---|
| NF-01 Finance overview | KPI tiles, drill-down links | loading, stale (shows `generatedAt`), partial (names the unavailable section) |
| NF-02 Online payment reconciliation | Match table, exception badge | matched, exception, resolving |
| NF-03 COD collection dashboard | Rider × date table | overdue highlight |
| NF-04 COD deposit verification | Detail panel, verify action | pending, verified, rejected |
| NF-05 Supplier payable ledger | Per-supplier table, hold toggle | held, disputed, eligible |
| NF-06 Rider payable ledger | Per-rider table, COD liability column | held, disputed, eligible |
| NF-07 Payout request review | Queue table, approve/reject panel | requested, under review |
| NF-08 Payout batch execution | Batch builder, release action | approved, processing, settled, failed |
| NF-09 Customer credit liability | Transaction ledger table | issued, consumed, voided |
| NF-10 Refund and chargeback management | Case table, decision panel | pending, approved, executed, disputed |
| NF-11 General ledger explorer | Journal table, line detail | posted, reversed |
| NF-12 Period close workspace | Checklist, close action | open, closing, closed, reopened |
| NF-13 Reconciliation exceptions | Exception queue | open, assigned, resolved |
| NF-14 Financial report export | Report builder, export log | generating, ready, failed |
| NF-15 Finance role permissions | Staff table, grant panel | active, revoked |
| NF-16 Financial adjustment approval | Request/approval panel | requested, approved, rejected |
| NF-17 Gateway settlement statement | Statement import, deviation table | matched, deviation |

## Light/dark, Bangla, accessibility

Same token system as the mobile apps (see [design/DESIGN_SYSTEM.md](../design/DESIGN_SYSTEM.md)) adapted for desktop density; Bangla numeral/date formatting throughout; full keyboard operability (NFR-003).

## Acceptance and verification

Design-only. Verification requires a screenshot-based review per screen per [design/SCREEN_VERIFICATION_CHECKLIST.md](../design/SCREEN_VERIFICATION_CHECKLIST.md) once implemented.
