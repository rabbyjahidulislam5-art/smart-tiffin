# Release checklist

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (extends to four applications and the financial domain; original rows unchanged) |
| Owner | Release owner — to be identified |
| Status | Entirely unrun. Future gate, not a record of completed release work. |

This checklist is entirely **unrun** for the application. It is a future gate, not a record of completed release work.

## 2026-10-30 extension

| Gate | Required evidence / reason it is open |
|---|---|
| Four-application scope | All four apps (Customer, Partner, Admin Web, Accounts Web) meet the gates below independently; no app is released on another's evidence |
| Ledger correctness | INV-01…INV-20 pass against a real PostgreSQL instance; period-close checklist exercised at least once |
| Maker-checker | Self-approval rejection verified for every payout and adjustment path (ADR-010) |
| Gateway integration | Sandbox flow verified end to end per [payments/SSLCOMMERZ_INTEGRATION_PLAN.md](../payments/SSLCOMMERZ_INTEGRATION_PLAN.md); no live credential introduced before a separate go-live decision |
| COD models | All four COD models (M1…M4, per [payments/COD_PAYMENT_WORKFLOW.md](../payments/COD_PAYMENT_WORKFLOW.md)) exercised in test, even if only M1 is enabled at launch |
| Web hosting | Admin Web and Accounts Web hosting/session security selected and verified (SEC-018) |
| Desktop accessibility | Full keyboard operability verified for every financial approval action |
| Screen coverage | Every one of the 149 screens in [design/COMPLETE_SCREEN_INVENTORY.md](../design/COMPLETE_SCREEN_INVENTORY.md) has recorded PASS evidence per [design/SCREEN_VERIFICATION_CHECKLIST.md](../design/SCREEN_VERIFICATION_CHECKLIST.md) |

Before publication, review [test results](../testing/TEST_RESULTS.md), [financial test cases](../testing/FINANCIAL_TEST_CASES.md), [security review](../security/SECURITY_REVIEW_PLANNING.md), [financial security](../security/FINANCIAL_SECURITY.md), [risk register](../planning/RISK_REGISTER.md) and [rollback plan](ROLLBACK_PLAN.md).

| Gate | Required evidence / reason it is open |
|---|---|
| Policy baseline | Approved BR-001 through BR-005 and relevant additional decisions; all five remain pending |
| Scope | All current-release FRs satisfied; none moved to later release merely to pass |
| Identity | Chosen auth method, role provisioning, denial tests, session revocation |
| Financial correctness | Approved formula, immutable bill history, duplicate/correction tests, manual verification audit |
| Delivery | Approved assignment authority, least-PII projection, transition/reassignment concurrency tests |
| Android package | Real generated project, identifiers, signing, reproducible release build and artifact checksum |
| Languages and accessibility | Bangla/English journeys, TalkBack, text scaling, contrast and touch targets on devices |
| Data | Rules/indexes tested; migration compatibility and approved retention/recovery procedure |
| Configuration | Separate verified environment/project IDs; no privileged client secrets |
| Notifications | Foreground/background permission and token lifecycle verified; no PII on lock screens |
| Runtime failures | Offline, timeout, retry, duplicate and partial-commit behavior checked |
| Performance | Approved workload and thresholds measured in appropriate build mode |
| Operations | Named owner, support route, alert routing and recovery exercise |
| Publication | Explicit destination/cost/scope approval and actual distribution evidence |

Before publication, review [test results](../testing/TEST_RESULTS.md), [security review](../security/SECURITY_REVIEW_PLANNING.md), [risk register](../planning/RISK_REGISTER.md) and [rollback plan](ROLLBACK_PLAN.md). Required failures or unrun checks prevent a production-ready claim.
