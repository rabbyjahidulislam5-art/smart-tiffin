# ADR-013: Canonical UTC storage with Asia/Dhaka service dates, server-evaluated cutoffs

| Field | Value |
|---|---|
| Status | PROPOSED — NOT APPROVED |
| Date | 2026-10-30 |

## Context

USER-REQ (delivery time and cutoff policy governance section): a subscription purchased today for tomorrow's meal must never be misread as a different day because of a device's time zone; a lunch must never become a dinner after translation or a device change; no arbitrary national deadline without recorded approval.

## Options considered

1. Store and compare times in the client's local time zone.
2. Store a canonical UTC instant everywhere; derive the Asia/Dhaka service date and evaluate every cutoff only at the trusted backend.
3. Store a canonical UTC instant, but allow the client to perform a provisional cutoff check for responsiveness, with the server as a final re-check.

## Decision

Option 2. Option 1 is explicitly what the governance section warns against. Option 3 is rejected as unnecessary complexity and a potential source of a misleading client-side "allowed" state that the server then rejects; a single authoritative evaluation point is simpler to reason about and test.

## Consequences

Every client must send and receive canonical timestamps and slot identifiers, never a pre-formatted local string, for anything cutoff-relevant; all user-facing date/time formatting happens at render time from the canonical value, in the viewer's language.

## Risks

A client that formats a date incorrectly for display (a UI bug) is distinct from a wrong cutoff decision (a logic bug) under this design, which is the intended separation — but it must be tested as such, not conflated.

## Links

[architecture/TIME_AND_CUTOFF_POLICY.md](../architecture/TIME_AND_CUTOFF_POLICY.md), BR-022, DEC-008, SC-18.
