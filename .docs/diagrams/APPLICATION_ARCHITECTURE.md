# Application architecture diagram

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Depends on | [architecture/MULTI_APP_ARCHITECTURE.md](../architecture/MULTI_APP_ARCHITECTURE.md), [setup/MONOREPO_AND_BUILD_OWNERSHIP.md](../setup/MONOREPO_AND_BUILD_OWNERSHIP.md) |
| Status | PROPOSED — NOT APPROVED. |

```mermaid
flowchart LR
  subgraph Apps
    CUS["customer_app"]
    PAR["partner_app"]
    ADM["admin_web"]
    ACC["accounts_web"]
  end
  subgraph Shared packages
    AC["auth_contracts"]
    DM["domain_models"]
    DT["design_tokens_ui"]
    L["localization"]
    API["api_clients"]
    V["validation"]
    EH["error_handling"]
    NI["notification_interfaces"]
    MF["money_format"]
    TU["test_utils"]
  end
  CUS --> AC & DM & DT & L & API & V & EH & NI & MF
  PAR --> AC & DM & DT & L & API & V & EH & NI & MF
  ADM --> AC & DM & DT & L & API & V & EH & NI & MF
  ACC --> AC & DM & DT & L & API & V & EH & NI & MF
  AC --> DM
  API --> DM
  subgraph Backend modules
    direction LR
    MODAUTH["MOD-AUTH"]
    MODCAT["MOD-CAT"]
    MODSUB["MOD-SUB"]
    MODPAY["MOD-PAY"]
    MODLED["MOD-LED"]
    MODSET["MOD-SET"]
  end
  API -.->|"command calls"| MODAUTH & MODCAT & MODSUB & MODPAY & MODLED & MODSET
  MODPAY & MODLED & MODSET --> PG["PostgreSQL"]
  MODAUTH & MODCAT & MODSUB --> FS["Firestore"]
```

No cycle exists: shared packages never depend on an app, and `domain_models` is the only package other shared packages may depend on (NFR-023).
