# Web hosting for Admin Web and Accounts Web

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Release owner — to be identified |
| Purpose | Compare hosting options for the two desktop Flutter Web applications and give a reasoned, PROPOSED recommendation; neither app has been built or hosted. |
| Depends on | [architecture/MULTI_APP_ARCHITECTURE.md](../architecture/MULTI_APP_ARCHITECTURE.md), [security/SECURITY_REQUIREMENTS.md](../security/SECURITY_REQUIREMENTS.md) SEC-018 |
| Status | PROPOSED — NOT APPROVED. No hosting provider selected. |

## Options considered

| Option | Access control fit | Session/CSRF model | Cost/complexity |
|---|---|---|---|
| Firebase Hosting + Cloud Functions auth check | Good — integrates with existing Firebase Auth (OBSERVED dependency) | Needs explicit session/CSRF handling added, not built in | Low incremental cost given existing Firebase usage |
| A general cloud provider's static hosting + signed access (e.g. a CDN with authenticated edge rules) | Good, more configuration work | Depends on provider's session primitives | Moderate; new provider relationship |
| A managed app-hosting platform with built-in auth | Good, but introduces a second identity system to reconcile with Firebase Auth | Built-in, but must be reconciled with the existing role/claim model | Moderate; avoid unless Firebase-based hosting cannot meet a specific need |

## Separate origins, invite-only access

Admin Web and Accounts Web are hosted at **separate origins**, each invite-only (no public signup route, consistent with [requirements/USER_ROLES.md](../requirements/USER_ROLES.md)); neither shares a session or cookie scope with the other or with the two mobile apps.

## Recommendation (PROPOSED)

Firebase Hosting, given the existing OBSERVED Firebase dependency and to avoid introducing a second identity/session system; with an explicit, verified CSRF/session-security layer added on top (SEC-018), since Firebase Hosting alone does not supply this. This recommendation is reviewed and re-confirmed once DEC-010 (budget, operations ownership) is resolved.

## Acceptance and verification

Design-only. Verification requires a security review of the selected hosting's actual session model before any staff account is invited.

## Open decisions

Final provider selection, CSP policy specifics, and the exact session-timeout values for Admin Web vs the stricter Accounts Web are all open.
