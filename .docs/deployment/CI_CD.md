# CI/CD design (planned pipeline)

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 |
| Owner | Release owner and backend maintainer (to be named) |
| Purpose | Specify a planned pipeline per app and package, the checks each stage runs, and permission and route tests per client. |
| Applies to | Monorepo: CUS, PAR, ADM, ACC, shared packages, BE, rules, migrations, documentation |
| Depends on | [Deployment guide](DEPLOYMENT_GUIDE.md), [monorepo and build ownership](../setup/MONOREPO_AND_BUILD_OWNERSHIP.md), [test strategy](../testing/TEST_STRATEGY.md), [security review planning](../security/SECURITY_REVIEW_PLANNING.md), [release checklist](RELEASE_CHECKLIST.md) |
| Authoritative policies | None |
| Status | **Planned, nothing configured, nothing run.** The workspace has no remote repository. No workflow file, runner, secret, branch protection or successful remote run exists or is claimed. |

## 1. OBSERVED baseline

- Documentation verifier: `node scripts/verify_docs.mjs` (repository root, built-in Node modules only). It validates links and structure; it does not validate business approval.
- Backend scripts in `backend/functions/package.json`: `test` (`node --test test/commands.test.js`), `test:rules` (Firebase emulator run of rules tests), `check` (syntax check of source files).
- Flutter app `app/` with `flutter_lints`. Its test and build status is not verified by this documentation effort.
- Only the checks above exist as commands. Everything else in this document is a plan.

## 2. Design rules

1. One pipeline definition per unit, triggered by path filters so a change in `packages/st_core` rebuilds dependent apps and a change in one app does not rebuild others.
2. Minimal workflow permissions; secrets are never exposed to workflows triggered by untrusted contributions.
3. Toolchains and actions pinned by reviewed version; caches keyed to lockfile and SDK version.
4. Release artifacts are built once from a tagged revision and promoted, not rebuilt per environment; environment differences are injected configuration ([deployment guide](DEPLOYMENT_GUIDE.md)).
5. A YAML syntax check, a local build, an uploaded artifact and a live release are different outcomes and are recorded separately with the revision and run URL.

## 3. Stages and gates

| Stage | Applies to | Checks | Evidence |
|---|---|---|---|
| S0 Hygiene | all | Secret scanning of diff, license and dependency inventory change check, forbidden file types (keys, env files with values), documentation verifier | Report |
| S1 Restore and static | each Dart package and app | Pinned Flutter and Dart, `pub get` with lockfile, formatting, analyzer with zero errors, generated-code consistency | Logs |
| S2 Architecture checks | monorepo | Dependency direction lint: no package imports an app; packages form an acyclic graph; apps do not import each other; layering rules from [monorepo ownership](../setup/MONOREPO_AND_BUILD_OWNERSHIP.md) | Lint report |
| S3 Unit and widget tests | packages and apps | Money arithmetic and formatting, validation, state mapping, widgets with localisation (English, Bangla), text scale | Test report |
| S4 Route and permission tests per client | each app | See section 4 | Test report |
| S5 Backend tests | BE | Command tests, idempotency (same key same result), fingerprint mismatch, concurrency, Security Rules tests in emulator, role and ownership denial tests, ledger tests: journal balance, immutability, period lock, idempotent posting, unique constraints | Test report |
| S6 Database | PG | Migrations apply on empty and on previous-version snapshot; constraints and invariant queries; rollback rehearsal of expand/contract; ledger invariant suite (INV-01 to INV-20 where testable) | Report |
| S7 Integration with mock gateway | BE and ACC | Replay, out-of-order, amount mismatch, validation outage; COD flows; payout state machine and maker-checker | Report |
| S8 Build artifacts | apps | Android app bundle signed in a protected job (signing material in secret store); Flutter web release builds for ADM and ACC with environment defines | Checksums, size, revision |
| S9 Security and accessibility | apps | Dependency advisory check, header check on web preview, accessibility checks on key screens (semantics, contrast, touch targets, text scale, Bangla shaping) | Reports |
| S10 Deploy to staging | all | Deploy by explicit environment; post-deploy smoke tests; environment identity assertion | Run URL |
| S11 Promotion | all | Manual approval gate by release owner against the [release checklist](RELEASE_CHECKLIST.md); production deploy from the same artifacts | Approval record |

## 4. Permission and route tests per client

Each client has its own registry of routes and its own tests, so a routing mistake in one app cannot leak screens into another.

| App | Route registration test | Permission tests |
|---|---|---|
| CUS | All routes in the customer and public registry resolve; no route from ADM, ACC or partner registry is registered; guest routes expose no private data; protected-action intent resumes after sign-in | Guest cannot reach protected routes; a customer token cannot call supplier, rider, admin or accounts commands (server test) |
| PAR | Supplier and rider workspaces registered separately; entry chooses workspace by server grant; a user with only one grant cannot open the other workspace | Pending applicant cannot open workspaces (closes legacy gap 20); dual-role user sees separate balances and navigation; switching workspace does not reuse another workspace's cached data |
| ADM | Only admin routes; accounts routes absent from the bundle | Admin role cannot reach payout approval, journal posting or balance change, even by direct deep link; denied commands return the documented error |
| ACC | Only accounts routes; sub-role route gating (Viewer, Operator, Manager, Approver, Auditor) | Maker cannot approve own work (INV-15); Viewer and Auditor have no write actions; Super Admin has no implicit finance override |
| All | Role claims from a refreshed token drive visibility, but every command is also authorised server-side; tests call the server directly with a forged client state | Deep links to unauthorised routes redirect or show a safe denial; session expiry and revocation clear cached data |

Route guards are tested but never counted as the only protection; the server tests are the authority.

## 5. Per-unit pipelines

| Unit | Triggers | Stages |
|---|---|---|
| `st_*` packages | change in package | S0, S1, S2, S3; downstream apps re-run S1 to S4 |
| Customer App | change in app or dependent packages | S0 to S4, S8 (Android), S9, S10, S11 |
| Partner App | same | same |
| Admin Web | same | S0 to S4, S8 (web), S9, S10, S11 |
| Accounts Web | same | same, with stricter header and session checks |
| Backend and ledger | change in BE, rules, migrations | S0, S5, S6, S7, S10, S11 |
| Documentation | change under docs | S0 (documentation verifier) |

## 6. Branch and review policy (PROPOSED)

Protected main; review required; money-affecting code and migrations need a reviewer from the finance data owner group; branches use the `codex/` prefix unless directed otherwise. No forced pushes.

## 7. Acceptance and verification conditions

Each stage has a script or workflow, a recorded successful run on a stated revision, and a recorded failing example showing that the gate blocks (for example a seeded dependency violation or seeded permission regression). Until then no CI claim is made.

## 8. Open decisions

Hosting for source and CI (no remote exists); runner trust and secret handling; signing key custody; test device farm or manual device checks; coverage thresholds (not set); accessibility tooling selection; branch protection policy.
