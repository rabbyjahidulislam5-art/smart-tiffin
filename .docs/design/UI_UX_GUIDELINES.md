# Screen behavior and state contracts

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (extends 1.0; applies now to the 149-screen [complete inventory](COMPLETE_SCREEN_INVENTORY.md) rather than the superseded 129-family inventory) |
| Owner | Design system author |
| Depends on | [Complete screen inventory](COMPLETE_SCREEN_INVENTORY.md), [component specifications](COMPONENT_SPECIFICATIONS.md) |
| Status | Planned, not executed. |

2026-10-30 · Planned, not executed. Applies to every row and child view in [the complete inventory](COMPLETE_SCREEN_INVENTORY.md) (superseding the original reference to the historical [SCREEN_INVENTORY.md](SCREEN_INVENTORY.md)).

## 2026-10-30 extension — desktop and financial controls

Desktop tables (Admin Web, Accounts Web) add: sortable column headers, bulk-selection with an explicit confirmation dialog naming the affected count, keyboard row navigation, and a deliberate narrow-window strategy (horizontal scroll with pinned identifying columns) rather than silent clipping (NFR-020). Financial amounts never animate a changing number without a settled final value shown; a "stale" financial figure always shows its `generatedAt` timestamp. Maker-checker screens disable the approve action entirely (not merely show it disabled) when the viewing principal is the item's own preparer.

## Universal controls

| Control | Required behavior |
|---|---|
| Back / close | Close top sheet then pop page; retain safe draft; SH-16 for unsaved edits; deterministic own-shell fallback |
| Primary tab | Select authorized tab and restore safe stack/scroll; announce selection; never grants another role |
| Search | Bounded query, cancel obsolete requests, clear input, no matches and error distinct; no whole-database download |
| Filter/sort/date | SH-19/20; Apply commits selection; Cancel preserves old selection; Reset clears visible filters |
| Card/row/chevron | Open exactly that record and role-appropriate detail; no competing overlapping tap targets |
| Switch | Define real setting/effect; busy/disabled and failure recovery; no “success” until persisted |
| Add/edit/delete/archive | Open specified form; validate boundary; preserve draft; destructive review; referenced history archived rather than silently erased |
| Submit/save/confirm | Validate, disable duplicate tap, use request identity, show acknowledged result; reconcile unknown outcomes |
| Refresh/load more | Preserve existing data, disclose freshness, no duplicate rows; explicit end and retry |
| Phone/message/export | Explicit user handoff; check actual capability, permission and allowed data; show missing-app/provider recovery |
| Help/info | Explanatory sheet or SH-11 article; can receive keyboard focus if actionable |
| Logout | SH-16; end session/listeners and remove protected view state; return AU-02; do not flash prior user's cached content |

## State design contract

| State | Visual and behavioral requirement |
|---|---|
| Initial loading | Stable skeleton matching structure, labelled progress; do not show fabricated food/amount/status |
| Empty | Explain absence; one relevant action (browse/create/clear filter); distinguish new account from permission failure |
| Error | Safe, specific message; retry only where safe; retained context; support reference without raw exceptions/PII |
| Success | Committed result and identifier/time where relevant; clear next destination; announce once |
| Disabled | Explain why adjacent to action; accessible text, not just low contrast; unresolved policy is not functional completion |
| Offline | Banner, cached timestamp if permitted, accessible retry; critical writes blocked under proposed DEC-012; no queued success |
| Stale/conflict | Explain newer server state; refresh/review changes before retry; never overwrite silently |
| Permission denied | Remove sensitive content; SH-15; no private entity details in error |
| Session expired/revoked | AU-02/AU-12; safe intent restoration only after authorization |
| Partial/unknown | SH-18; distinguish committed subresults where approved; reconcile by original operation ID |
| Invalid form | Persistent per-field explanation and summary; focus first invalid field; retain valid inputs |
| Long/large text | Wrap/reflow; primary actions accessible without clipping; full accessible labels |
| Image/file failure | Meaningful fallback; retry where useful; no broken icon affecting action reachability |

## Domain-specific interaction safeguards

Checkout shows the latest trusted quote and all approved components before confirmation. If price/availability changes, return to review with differences. Payment reference submission always says pending verification. Reviews require the permitted own-order context. Supplier accepting-orders and availability changes must explain their effects without inventing cancellation policy. Preparation and delivery timelines are separate. Delivery completion must validate the current assignment and approved evidence. Admin approvals require an explicit permission and auditable decision; dashboard visibility is insufficient.

All confirmations identify the exact object and consequence. Never put arbitrary “Are you sure?” on every harmless navigation action. Sensitive changes, irreversible operations and lost edits deserve confirmation; filtering and opening details do not.

## Per-screen visual checklist

For each inventory ID and expanded child: draw normal content, every applicable state above, all contained menus/dialogs/sheets, validation and completion variants. Specify entry/exit, required data, permitted actions, locale, responsive behavior and source controls. Mark inapplicable states with a reason in the capture manifest. Render EN and BN examples with long content and large text. Record unresolved policy-dependent copy separately rather than inventing final terms.
