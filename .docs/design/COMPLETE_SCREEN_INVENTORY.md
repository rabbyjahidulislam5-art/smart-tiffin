# Complete screen inventory

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Purpose | The single authoritative count and index of every screen across all four applications: 94 legacy (OBSERVED) + 55 proposed (PROPOSED) = 149. |
| Depends on | [Conventions §4](../analysis/CONVENTIONS_AND_ID_REGISTER.md), [design/screens/*](screens/), [design/INVENTORY_RECONCILIATION.md](INVENTORY_RECONCILIATION.md) |
| Status | Authoritative. Legacy IDs are unchanged; proposed IDs are documentation identifiers, not confirmed routes. |

## Counts by application

| App | Legacy | Proposed | Total |
|---|---|---|---|
| CUS (Customer App) | P-01…04 (4), AU-01…08,12 (9), SH-01,02,04…10 (9, shared instance), C-01…25 (25) = 47 | NC-01…19 (19) | 66 |
| PAR-Supplier | AU-09 (1), S-01…12 (12) = 13 | NS-01…07 (7) | 20 |
| PAR-Rider | AU-10 (1), R-01…10 (10) = 11 | NR-01…06 (6) | 17 |
| ADM | AU-13 (1), A-01…19 (19) = 20 | NA-01…06 (6) | 26 |
| ACC | — (0) | NF-01…17 (17) | 17 |
| System tooling | X-01…02 (2) | — | 2 |
| Shared (AU-11 applicant status) | 1 | — | 1 |
| **Total** | **94** (incl. SH shared counted once per app = 9×5 would double count; see note) | **55** | **149** |

**Counting note:** SH-01/02/04…10 (9 IDs) are shared screens instantiated per app (5 instances each, see [SHARED_SCREENS.md](screens/SHARED_SCREENS.md)); they are counted **once** (9 IDs) in the 94-legacy total, not once per instance, matching the legacy prototype's own registry count. AU-11 (Application status) is shared between the Supplier and Rider application flows and is counted once.

## Full index

| ID range | Count | File |
|---|---|---|
| P-01…04 | 4 | [CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md](screens/CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md) |
| AU-01…08, AU-12 | 9 | [CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md](screens/CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md) |
| AU-09, AU-10, AU-11 | 3 | [PARTNER_APPLICATION_SCREENS.md](screens/PARTNER_APPLICATION_SCREENS.md) |
| AU-13 | 1 | [ADMIN_SCREENS.md](screens/ADMIN_SCREENS.md) |
| SH-01, 02, 04…10 | 9 | [SHARED_SCREENS.md](screens/SHARED_SCREENS.md) |
| C-01…25 | 25 | [CUSTOMER_SCREENS.md](screens/CUSTOMER_SCREENS.md) |
| NC-01…19 | 19 | [CUSTOMER_NEW_SCREENS.md](screens/CUSTOMER_NEW_SCREENS.md) |
| S-01…12 | 12 | [SUPPLIER_SCREENS.md](screens/SUPPLIER_SCREENS.md) |
| NS-01…07 | 7 | [SUPPLIER_SCREENS.md](screens/SUPPLIER_SCREENS.md) |
| R-01…10 | 10 | [RIDER_SCREENS.md](screens/RIDER_SCREENS.md) |
| NR-01…06 | 6 | [RIDER_SCREENS.md](screens/RIDER_SCREENS.md) |
| A-01…19 | 19 | [ADMIN_SCREENS.md](screens/ADMIN_SCREENS.md) |
| NA-01…06 | 6 | [ADMIN_SCREENS.md](screens/ADMIN_SCREENS.md) |
| NF-01…17 | 17 | [ACCOUNTS_SCREENS.md](screens/ACCOUNTS_SCREENS.md) |
| X-01…02 | 2 | [TOOLING_SCREENS.md](screens/TOOLING_SCREENS.md) |

**Sum check:** 4+9+3+1+9+25+19+12+7+10+6+19+6+17+2 = 149. ✓

## Migration action summary

| Action | Count (approx.) | Meaning |
|---|---|---|
| Reuse | ~45 | Design carried over unchanged, backend added |
| Extend | ~50 | New capability added to the same screen |
| Replace | ~6 | Redesigned or moved to another app |
| Split | 2 (A-12, A-13) | Responsibility moved to Accounts Web |
| New (PROPOSED) | 55 | No legacy equivalent |

Exact per-screen action is recorded in each [design/screens/*](screens/) file's contract table, not duplicated here.
