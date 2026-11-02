# Error and uncertain-outcome contract

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (extends 1.0; original categories unchanged) |
| Owner | Backend and API architect |
| Status | Proposed application-level error taxonomy, not HTTP endpoints or a generated SDK. Codes map to localized Bangla/English messages; internal stack traces and private record existence are never exposed. |

| Application category | Example | User behavior / retry |
|---|---|---|
| `unauthenticated` | Missing/expired session | Reauthenticate; do not silently resubmit a consequential command |
| `permission_denied` | Foreign order, suspended supplier, stale courier assignment | Clear protected view; no retry without changed access |
| `invalid_input` | Missing address, invalid service date, unsupported provider | Preserve safe draft; associate errors with fields |
| `policy_not_configured` | Pending cutoff/billing/verification policy | Do not guess a value; feature cannot commit dependent action |
| `business_rule_rejected` | Pause outside approved window | Explain the applicable rule and alternatives if approved |
| `conflict` | Version changed, duplicate reference or reused request ID | Refresh canonical state; no blind overwrite; avoid identifying another owner's reference |
| `not_available` | Withdrawn meal/plan or inaccessible object | Refresh catalogue; do not substitute another meal automatically |
| `rate_limited` | Excessive requests | Respect validated retry guidance; avoid retry storm |
| `temporarily_unavailable` | Service/transport failure before known result | Keep draft and provide explicit retry |
| `outcome_unknown` | Timeout after command may have committed | Look up original request receipt; never create a new request ID to resolve ambiguity |
| `internal_error` | Unexpected server error | Generic message with safe correlation ID; log redacted details privately |

Candidate result envelope contains category, localized-message key, safe field-error keys, retryability, correlation ID and request ID. Do not include credentials, payment reference, full address, account existence or raw provider exception. Exact transport encoding is decided with DEC-011.

For stale read data, show last update time and disable consequential actions if freshness is required. For partial views, clearly identify unavailable sections instead of replacing balances with zero. A rejected notification permission cannot make a committed order disappear. A notification delivery failure is operational status, not an order failure.

Verification must distinguish rejection before mutation from an unknown network outcome after possible commit. Tests must prove that retrying the same command cannot duplicate payment allocation, meal generation, order creation or transition events.

## 2026-10-30 extension — financial, gateway and maker-checker reasons

| Reason (`category`/`reason`) | Example | User behaviour / retry |
|---|---|---|
| `invalid_input` / `quote_mismatch` | Client's expected total disagrees with the server quote | Re-fetch a fresh quote; never silently accept the client-side figure |
| `business_rule_rejected` / `cutoff_passed` | A skip/pause/replace request arrives at or after the configured cutoff | Explain the cutoff; offer the next eligible date |
| `business_rule_rejected` / `already_dispatched` | A change is requested on a meal already handed to a rider | Explain that only an explicit exception policy can permit this |
| `conflict` / `stock_unavailable` | Two customers raced for the last unit (SC-20) | Offer an alternative or a refund of any payment that completed after the failure |
| `conflict` / `double_compensation` | A refund is requested for an obligation already credited (INV-17) | Show the existing credit; do not issue a second remedy |
| `permission_denied` / `maker_equals_checker` | The approver and preparer of a payout/adjustment are the same principal (INV-15) | Route to a different authorised approver |
| `policy_not_configured` / `policy_pending` | A command depends on an unpublished `policy.*` parameter (BR-006…026) | Feature cannot commit the dependent action; show "awaiting approved policy" |
| `conflict` / `period_not_reconciled` | `closePeriod` attempted with an open `ent.ReconciliationException` | Resolve the exception first; the period stays open |
| `conflict` / `request_in_progress` | A concurrent duplicate request is already being processed (PostgreSQL receipt row locked) | Wait and retry; do not send a new `requestId` |
| `business_rule_rejected` / `client_upgrade_required` | `context.clientApp` is below the minimum supported version | Prompt an app update; no data loss |
| `not_available` / `out_of_zone` | The selected address/kitchen pair is outside the kitchen's service zone (SC-19) | Offer a zone-eligible alternative; never silently reroute |
| `temporarily_unavailable` / `gateway_unverified` | The SSLCOMMERZ gateway has not yet confirmed a transaction | Show "awaiting confirmation", never a guessed success or failure |
| `outcome_unknown` / `financial_posting_pending` | A SAGA's financial step has not yet completed after its operational step committed | Show "processing"; the response's `outcome: accepted_pending` names what is pending |

These reasons extend, and never replace, the original category list above; every new financial command in the [api/COMMANDS_*](API_SPECIFICATION.md) files uses one of the original categories plus, where relevant, one of these reasons.
