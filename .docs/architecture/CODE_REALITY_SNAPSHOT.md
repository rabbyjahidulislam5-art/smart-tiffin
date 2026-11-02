# Code reality snapshot

| Field | Value |
|---|---|
| Revision | 1.1 · 2026-10-30 (refreshed for the four-application documentation rewrite; facts unchanged) |
| Owner | Architecture lead |
| Purpose | Record what actually exists on disk, so no document claims "no application exists" when one does, and so the four-application target is clearly understood as a future state relative to this single-app baseline. |
| Depends on | [File map](FILE_MAP.md), [multi-app architecture](MULTI_APP_ARCHITECTURE.md), [React-to-Flutter migration](REACT_TO_FLUTTER_MIGRATION.md) |
| Status | OBSERVED facts only; recorded 2026-10-30 by direct filesystem inspection. |

**Scope: existence, scale and structure only.** This document does not verify code correctness, test pass/fail status, security posture beyond what [verification/FIREBASE_SECURITY_REVIEW_COPY.md](../verification/FIREBASE_SECURITY_REVIEW_COPY.md) already records, or compliance with BR-001..026 (all still Pending Decision — see [requirements/BUSINESS_RULES.md](../requirements/BUSINESS_RULES.md) and [requirements/POLICY_DECISION_REGISTER.md](../requirements/POLICY_DECISION_REGISTER.md)). It exists because earlier documentation stated flatly that no application had been implemented, which does not match what is actually on disk. **This single combined app is the current baseline, not the four-application target** this documentation set otherwise describes; see [architecture/REACT_TO_FLUTTER_MIGRATION.md](REACT_TO_FLUTTER_MIGRATION.md) and TASK-010 for how one becomes the other.

## `app/` — real Flutter project

- `pubspec.yaml`: package `smart_tiffin`, SDK `^3.13.4`; dependencies `firebase_core 5.1.0`, `firebase_auth 7.0.1`, `cloud_firestore 7.1.0`, `firebase_messaging 17.0.1`, `cupertino_icons`.
- `pubspec.lock` present (real, resolved lockfile).
- `lib/` (~9,600 lines Dart total):
  - `lib/main.dart` (39 ln)
  - `lib/app/` — `app.dart` (461 ln), `session.dart` (334 ln)
  - `lib/data/` — `command_payload.dart`, `design_repository.dart`, `firebase_repository.dart`, `repository.dart`
  - `lib/design/` — `customer_supplier.dart` (2,496 ln), `expanded_views.dart` (731 ln), `identity_operations.dart` (3,375 ln), `screen_library.dart`, `spec.dart`
  - `lib/ui/` — `dashboards.dart` (765 ln), `screen_page.dart` (764 ln), `theme.dart` (175 ln)
- `test/`: 7 files (`command_payload_test.dart`, `customer_supplier_test.dart`, `expanded_views_test.dart`, `identity_operations_test.dart`, `render_inventory_test.dart`, `repository_test.dart`, `screen_coverage_test.dart`, `widget_test.dart`).
- `android/` (Gradle project, `app/src`), `web/` (icons, manifest, `index.html`).
- `assets/fonts/`: NotoSans + NotoSansBengali (Bangla shaping font already present). `assets/images/biryani.png`.
- `app/build/` contains compiled artifacts for `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_messaging`, `firebase_app_check`, `cloud_functions`, `google_sign_in_android`, `url_launcher_android` — the project has actually been built at least once. `.dart_tool/`, `.idea/` also present.

## `backend/` — real Firebase Functions project

- `backend/functions/package.json`: `smart-tiffin-functions`, Node 22, ESM (`"type": "module"`); deps `firebase-admin 14.5.0` + `firebase-functions 7.4.0`; devDeps `firebase 13.1.0` + `firebase-tools 15.34.2` + `@firebase/rules-unit-testing`.
- `node_modules/` fully installed (real `npm install` ran).
- `src/index.js` (19 ln), `src/commands.js` (189 ln) — real function code, not stubs.
- `test/`: 3 files (`commands.test.js`, `firestore.test.js`, `rules.test.js`).
- `emulator-verification.log`, `firestore-debug.log` present — the emulator was actually run. `.env.example` present.

## `firebase/` — rules and config

- `firestore.rules` (56 ln), `firestore.indexes.json` (10 ln), `storage.rules` (7 ln), `SECURITY_REVIEW.md` (see the copy linked above).
- `firebase.json` (repo root) wires functions source to `backend/functions` (codebase `smart-tiffin`, runtime `nodejs22`), Firestore/Storage rules and indexes to `firebase/`, and configures emulators (auth 9099, firestore 8080, functions 5001, ui disabled, `singleProjectMode: true`).

## Git status

**All of `app/`, `backend/`, `firebase/` are untracked (`?? ` in `git status`).** Zero commits touch them. "No commits exist" (stated elsewhere in the docs) is accurate for git history; "no application has been implemented" is not accurate for what exists on disk.

## Known mismatch

[planning/PRODUCT_DELIVERY_PLAN.md](../planning/PRODUCT_DELIVERY_PLAN.md)'s folder-plan section proposes `lib/app, lib/core, lib/l10n, lib/features/*` and states these paths "do not yet exist." The real layout is `lib/app, lib/data, lib/design, lib/ui` and already exists. This mismatch is flagged there and tracked as TASK-010 in [TASKS.md](../TASKS.md) — not resolved by this snapshot.

## What this snapshot does NOT establish

- Whether the Dart/Node code compiles cleanly today or passes its own tests.
- Whether any business rule (BR-001..005) is correctly or incorrectly implemented.
- Whether the code should be committed, rewritten, or discarded.
- Any production-readiness, security certification beyond the Rules/command tests already recorded, or deployment status.
