# Software requirements specification

| Field | Value |
|---|---|
| Revision | 2.0 · 2026-10-30 (supersedes 0.1 · 2026-10-28) |
| Owner | Requirements and planning author |
| Purpose | Organised entry point into the complete requirements catalogue for the four-application Smart Tiffin platform. |
| Status | Documentation refinement delivered; no application exists under this specification yet. See [code reality snapshot](architecture/CODE_REALITY_SNAPSHOT.md) for what is actually on disk (a single combined prototype app, untracked, unverified). |

## Purpose and system boundary

Smart Tiffin connects customers, kitchen suppliers, delivery riders, operations/administration staff and Accounts/finance staff around flexible meal ordering, custom subscriptions, delivery, payments and financial settlement. The product is **four separate applications on one shared backend**:

- **Customer App** (Flutter, Android first) — guests and customers.
- **Partner App** (Flutter, Android) — suppliers and riders, in two protected workspaces.
- **Admin Web** (Flutter Web, desktop-first) — operations and governance staff.
- **Accounts Web** (Flutter Web, desktop-first) — Accounts and Finance staff.

The shared backend uses Firebase Authentication, Cloud Firestore and Cloud Functions as a trusted command boundary (OBSERVED, extending the existing single callable `executeCommand`), plus a PROPOSED managed PostgreSQL store for the double-entry ledger, payouts and reconciliation. Delivery tracking remains status-based with a consent-bound live-location option; payment is COD plus a sandboxed SSLCOMMERZ gateway abstraction (future, not connected).

This SRS is an organised entry point into canonical documents; it intentionally avoids duplicating the complete catalogue.

| Specification concern | Canonical document |
|---|---|
| Problem, objectives and success | [Project vision](requirements/PROJECT_VISION.md) |
| Current documentation task and product scope | [Project scope](requirements/PROJECT_SCOPE.md) |
| Stakeholders and decision authority | [Stakeholder analysis](requirements/STAKEHOLDER_ANALYSIS.md) |
| Roles, ownership and access boundaries | [User roles](requirements/USER_ROLES.md) |
| Functional behaviour FR-001–FR-050 | [Functional requirements](requirements/FUNCTIONAL_REQUIREMENTS.md) |
| Quality attributes NFR-001–NFR-032 | [Non-functional requirements](requirements/NON_FUNCTIONAL_REQUIREMENTS.md) |
| Actor outcomes | [User stories](requirements/USER_STORIES.md) |
| Inputs, normal and exceptional paths, persistence and audit | [Use cases](requirements/USE_CASES.md) |
| Given/When/Then acceptance designs | [Acceptance criteria](requirements/ACCEPTANCE_CRITERIA.md) |
| BR-001–BR-026, decision questions/options and policy approval | [Business rules](requirements/BUSINESS_RULES.md), [policy decision register](requirements/POLICY_DECISION_REGISTER.md) |
| Confirmed facts, proposed assumptions and remaining decisions | [Assumptions and constraints](requirements/ASSUMPTIONS_AND_CONSTRAINTS.md) |
| Requirements-to-design/test/evidence links | [Traceability matrix](requirements/REQUIREMENTS_TRACEABILITY_MATRIX.md) |
| Four-application architecture and trust boundaries | [Multi-app architecture](architecture/MULTI_APP_ARCHITECTURE.md), [system architecture](architecture/SYSTEM_ARCHITECTURE.md) |
| Candidate data and financial model | [Database design](database/DATABASE_DESIGN.md), [financial data model](database/FINANCIAL_DATA_MODEL.md) |
| Planned service contracts | [API specification](api/API_SPECIFICATION.md), [authorization](api/AUTHORIZATION.md) |
| Screens and interaction contracts (legacy 94 + proposed 55) | [Complete screen inventory](design/COMPLETE_SCREEN_INVENTORY.md), [screen contracts](design/screens/) |
| Payments, pricing and credits | [Payment architecture](payments/PAYMENT_ARCHITECTURE.md), [pricing and billing](payments/PRICING_AND_BILLING.md), [customer credit rules](payments/CUSTOMER_CREDIT_RULES.md) |
| Accounts Web domain | [accounts-web/](accounts-web/) |
| Cross-system scenarios | [scenarios/](scenarios/) |
| Implementation sequence and risks | [Implementation plan](planning/IMPLEMENTATION_PLAN.md), [risk register](planning/RISK_REGISTER.md) |
| Planned verification and actual evidence | [Test strategy](testing/TEST_STRATEGY.md), [test results](testing/TEST_RESULTS.md) |

## Terminology

See [requirements/GLOSSARY_AND_TERMINOLOGY.md](requirements/GLOSSARY_AND_TERMINOLOGY.md) for the full, authoritative glossary (money terms, subscription terms, roles, state vocabularies and event moments). Key terms repeated here for quick reference: **Plan/package** — a published supplier offering, not an imposed fixed package; **Subscription (agreement)** — a customer's versioned commitment; **Meal obligation** — one scheduled meal, the unit cooked, delivered, skipped and credited; **Service credit** — a non-cash liability, never a wallet; **Verified payment/collection** — confirmed by server-side gateway validation or Accounts-verified COD remittance, never a submitted claim alone; **Trusted boundary** — the only layer authorised to decide money, role and policy outcomes.

## Required policy gate

BR-001…BR-005 (meal pauses, billing, manual payment verification, delivery assignment, cancellation/refunds) and the extended BR-006…BR-026 (credits, delivery fees, discounts, commission, earning recognition, COD, payouts, disputes, tax, approval limits, multi-kitchen, cutoff, dual-role, kitchen discontinuity, legal status of credits, COD netting) are all deliberately unresolved, with alternatives and recommendations in [requirements/BUSINESS_RULES.md](requirements/BUSINESS_RULES.md) and [requirements/POLICY_DECISION_REGISTER.md](requirements/POLICY_DECISION_REGISTER.md). Their owner is the **business owner/authorised stakeholder — to be identified**. Nothing here turns a proposed cutoff, fee, commission, threshold or refund path into implemented behaviour without recorded approval.

## Verification and change control

No product test or production deployment is claimed anywhere in this package. Document integrity checks validate only the prepared package. Product acceptance requires implemented authorised workflows, approved policy fixtures, real boundary tests, and appropriate bilingual/accessibility validation across all four applications. Record evidence against the tested revision and environment. Update the canonical requirement before downstream contracts, then maintain traceability; never silently defer a requested Must feature to declare completion.
