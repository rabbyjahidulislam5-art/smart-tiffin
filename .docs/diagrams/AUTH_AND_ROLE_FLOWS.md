# Authentication and role flow diagrams

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Depends on | [ADR-011](../adr/011-roles-claims-and-sessions.md), [design/screens/CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md](../design/screens/CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md) |
| Status | PROPOSED — NOT APPROVED. |

## Customer sign-up and OTP

```mermaid
sequenceDiagram
  participant G as Guest
  participant BE as Backend
  G->>BE: register (AU-03)
  BE->>G: OTP (AU-04/05, real rate-limited OTP)
  G->>BE: verify OTP
  BE->>G: onboarding (AU-07/08) -> C-01
```

## Partner application and approval

```mermaid
stateDiagram-v2
  Draft --> Submitted: saveApplication
  Submitted --> InReview
  InReview --> InfoRequested: decideApplication(request_info)
  InfoRequested --> Submitted: resubmit
  InReview --> Approved: decideApplication(approve)
  InReview --> Rejected: decideApplication(reject)
  Approved --> WorkspaceGranted
```

## Invited staff (Admin/Accounts)

```mermaid
sequenceDiagram
  participant SA as Super Admin
  participant S as New staff
  participant BE as Backend
  SA->>BE: grantStaffRole(role, subRole)
  BE->>S: invitation
  S->>BE: AU-13 sign-in + MFA
  BE->>S: session with role claim
```

## Dual-role workspace switch (BR-023, PENDING)

```mermaid
sequenceDiagram
  participant P as Principal
  participant BE as Backend
  P->>BE: command(workspace: supplier)
  BE->>BE: verify active grant = supplier
  P->>BE: switch workspace
  P->>BE: command(workspace: rider)
  BE->>BE: verify active grant = rider
```
