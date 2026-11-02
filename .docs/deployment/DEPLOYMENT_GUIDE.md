# Deployment guide (preparation)

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 |
| Owner | Release owner (to be named) |
| Purpose | Define environments, deployment units, order of deployment, configuration injection without secrets, gateway sandbox versus live separation and release channels for four apps and a shared backend. |
| Applies to | CUS, PAR, ADM, ACC, BE (Cloud Functions, ledger service, jobs), FS, PG |
| Depends on | [CI/CD](CI_CD.md), [release checklist](RELEASE_CHECKLIST.md), [rollback plan](ROLLBACK_PLAN.md), [web hosting](WEB_HOSTING_ADMIN_AND_ACCOUNTS.md), [monorepo and build ownership](../setup/MONOREPO_AND_BUILD_OWNERSHIP.md), [configuration](../setup/CONFIGURATION.md), [secrets management](../security/SECRETS_MANAGEMENT.md), [multi-app architecture](../architecture/MULTI_APP_ARCHITECTURE.md) |
| Authoritative policies | None. Destination, region, budget and ownership decisions are PENDING (DEC-010); no policy value is deployed |
| Status | **Design only. No environment, Firebase project, application id, signing key, store account, web origin, database or gateway account exists. Nothing has been built or deployed.** All identifiers below are placeholders. |

## 1. Deployment units (PROPOSED)

| Unit | Artifact | Target | Notes |
|---|---|---|---|
| Customer App (CUS) | Signed Android app bundle | Internal test channel first, then store tracks | iOS-ready code, not released at first |
| Partner App (PAR) | Signed Android app bundle (one binary, two role workspaces) | Same | Workspace access by server role grant, never by build flavour |
| Admin Web (ADM) | Flutter web build (static assets) | Own origin, see [web hosting](WEB_HOSTING_ADMIN_AND_ACCOUNTS.md) | Staff only |
| Accounts Web (ACC) | Flutter web build | Separate origin from ADM | Stricter access and session rules |
| Backend commands and jobs (BE) | Cloud Functions codebase (OBSERVED baseline: codebase `smart-tiffin`, Node 22, callable `executeCommand`) | Per environment project | Webhook endpoint for gateway notifications is a separate function with its own authentication checks |
| Ledger store (PG) and ledger module | Managed PostgreSQL plus migration set | Per environment | Hosting choice PROPOSED in [ADR-005](../adr/005-hybrid-datastore.md), not decided |
| Rules and indexes | Firestore rules, indexes, Storage rules (`firebase/`) | Per environment | OBSERVED files exist for the current baseline |

## 2. Environments

| Environment | Purpose | Data | Gateway | Who may deploy |
|---|---|---|---|---|
| Local and emulators | Development | Deterministic synthetic fixtures | Mock gateway only | Developer |
| Dev (shared, optional) | Integration | Synthetic | Mock or sandbox | CI on merge |
| Staging | Release rehearsal, mirrors security rules, config shape and migrations of production | Synthetic or scrubbed-by-construction only; never real customer data | Sandbox | Release owner via approved pipeline |
| Production | Real users | Real | Live (only after financial go-live gates pass) | Release owner with approver, protected pipeline |

Rules:

1. Each environment is a separate Firebase project and a separate PostgreSQL instance. There are no shared databases, buckets, service accounts or gateway credentials across environments.
2. The environment identity is checked before every deployment and at app and server start. Mismatch means stop. Configuration never falls back to production.
3. Names such as `st-dev`, `st-staging`, `st-prod` are illustrative placeholders and are not real project ids. The OBSERVED emulator project id `demo-smart-tiffin` is used in current test scripts only.
4. Production data never enters development or staging. Fixtures are generated and committed as synthetic data.

## 3. Sandbox versus live gateway separation (SSLCOMMERZ, planned)

| Aspect | Rule |
|---|---|
| Endpoints | Sandbox and live use different provider hosts per provider documentation; the active host comes from environment configuration, never from client input |
| Credentials | Separate store identifiers and credentials per environment, held in the secret manager of that environment only; names listed in [configuration](../setup/CONFIGURATION.md), values never in source or builds |
| Accounting | Sandbox transactions never post to the live ledger; staging ledger is disposable and labelled non-financial |
| Notification URL | Each environment registers its own notification endpoint with the provider; live URL is registered only at go-live |
| Client | Apps never contain gateway secrets and never decide success; they open the provider page and then read status from the backend |
| Switch to live | Requires financial go-live gates in the [release checklist](RELEASE_CHECKLIST.md), a recorded approval, a smoke transaction plan with a refund path, and a rollback plan |
| Checks | A startup assertion prevents live gateway credentials from loading in a non-production project and vice versa |

The provider facts in this section are cited in [sources](../references/SOURCES.md) and must be rechecked against the merchant agreement.

## 4. Configuration injection without secrets

- Client apps receive non-secret configuration at build time through compile-time defines or per-flavour configuration files generated by the pipeline: environment name, Firebase client options for that environment, API base identifiers, feature flags, minimum supported version. Firebase client options are identifiers, not authorisation secrets.
- Server configuration is read from environment variables and the platform secret manager at runtime. Variables are listed by name only in [configuration](../setup/CONFIGURATION.md).
- No `.env` file with real values is committed. Example files list names only.
- Builds record configuration version, source revision and checksum so the installed artifact can be matched to its configuration.
- Policy values are data (`ent.PolicyVersion`), not environment variables.

## 5. Release channels

| Channel | Audience | Apps | Purpose |
|---|---|---|---|
| Local | Developers | all | Emulator builds |
| Internal | Team testers | CUS, PAR | Internal test track or direct signed distribution; ADM and ACC preview channel on staging hosting |
| Closed beta | Invited customers and partners (only after approvals) | CUS, PAR | Limited rollout, real partners; only with live gateway gates satisfied or COD-only if so approved |
| Production | Public | CUS, PAR, ADM, ACC | Staged rollout percentage for mobile, versioned releases for web |

Mobile staged rollout, halt and forced-update mechanics are described in the [rollback plan](ROLLBACK_PLAN.md).

## 6. Deployment order for a release (PROPOSED)

1. Confirm the policy baseline and approvals needed by the release; record the tested policy version.
2. Build all affected artifacts from one tagged revision with pinned toolchains and lockfiles.
3. Apply additive database migrations to staging, run migration verification and rollback rehearsal (expand/contract; see [migration strategy](../database/MIGRATION_STRATEGY.md)).
4. Deploy backend to staging; run contract, permission, idempotency and ledger tests.
5. Deploy ADM, ACC to staging hosting; run route-registration and permission tests for each client (CI_CD).
6. Release candidate Android builds to the internal channel; run role journeys including denied access.
7. Go or no-go meeting using the [release checklist](RELEASE_CHECKLIST.md).
8. Production: migrations (additive) first, then backend, then web clients, then mobile staged rollout. Backend stays compatible with old clients for the compatibility window.
9. Post-deploy verification of the actual installed artifact: startup, sign-in, role routing, a synthetic order in a test tenant if approved, job heartbeats, alert silence.
10. Record the evidence. Rollback triggers and owners are in the [rollback plan](ROLLBACK_PLAN.md).

Contract changes that break installed clients are not deployed until the minimum supported version is raised through the forced-update mechanism.

## 7. Required ownership decisions

Release owner, backend owner, finance data owner, region, cost ceiling, provider accounts (Firebase, PostgreSQL host, SSLCOMMERZ merchant, messaging, maps), store or distribution accounts, signing key custody and recovery, web domains, support route. Until decided, no deployment step can be executed.

## 8. Acceptance and verification conditions

| Condition | Evidence |
|---|---|
| Staging reproduces the deployment sequence from a clean checkout | Pipeline run record, revision, artifact checksums |
| Environment guard blocks cross-environment credentials | Test output |
| Config injection produces correct per-environment builds with no secret strings | Secret scan report and build inspection |
| Web origins serve expected headers | Header check record |
| Gateway live switch rehearsed using staging sandbox | Rehearsal record |

## 9. Open decisions

DEC-010 (owners, region, budget); ADR-005 ledger hosting; hosting choice for web ([comparison](WEB_HOSTING_ADMIN_AND_ACCOUNTS.md)); store accounts and application ids; whether a closed beta is COD-only; official Firebase and Flutter setup steps to be rechecked against the pinned toolchain at implementation time ([sources](../references/SOURCES.md)).
