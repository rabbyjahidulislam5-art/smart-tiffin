# Master index

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead |
| Purpose | Map every software-engineering question to the one file that answers it. |
| Status | Current, 212 Markdown files. |

## Start here

[README.md](README.md) · [PROJECT_STATUS.md](PROJECT_STATUS.md) · [CHANGE_SUMMARY.md](CHANGE_SUMMARY.md) · [SRS.md](SRS.md) · [TASKS.md](TASKS.md) · [DELIVERABLE_COVERAGE.md](DELIVERABLE_COVERAGE.md)

## Analysis (how this rewrite was done)

[Existing document audit](analysis/EXISTING_DOCUMENT_AUDIT.md) · [Gap analysis](analysis/GAP_ANALYSIS.md) · [File refinement plan](analysis/FILE_REFINEMENT_PLAN.md) · [Conflict register](analysis/CONFLICT_REGISTER.md) · [Provenance matrix](analysis/PROVENANCE_MATRIX.md) · [Requirements change log](analysis/REQUIREMENTS_CHANGE_LOG.md) · [Obsolete document review](analysis/OBSOLETE_DOCUMENT_REVIEW.md) · [Conventions and ID register](analysis/CONVENTIONS_AND_ID_REGISTER.md) · [Master prompt digest](analysis/SOURCE_MASTER_PROMPT_DIGEST.md) · [Legacy prototype digest](analysis/SOURCE_LEGACY_PROTOTYPE_DIGEST.md)

## "I need to know..."

| Question | File |
|---|---|
| What does the product do, for whom? | [requirements/PROJECT_VISION.md](requirements/PROJECT_VISION.md), [requirements/PROJECT_SCOPE.md](requirements/PROJECT_SCOPE.md) |
| What are the four applications? | [architecture/MULTI_APP_ARCHITECTURE.md](architecture/MULTI_APP_ARCHITECTURE.md) |
| What is approved vs pending? | [requirements/BUSINESS_RULES.md](requirements/BUSINESS_RULES.md), [requirements/POLICY_DECISION_REGISTER.md](requirements/POLICY_DECISION_REGISTER.md) |
| What does a term mean (credit, earning, revenue...)? | [requirements/GLOSSARY_AND_TERMINOLOGY.md](requirements/GLOSSARY_AND_TERMINOLOGY.md) |
| What functional behaviour is required? | [requirements/FUNCTIONAL_REQUIREMENTS.md](requirements/FUNCTIONAL_REQUIREMENTS.md) |
| What does a specific screen do? | [design/COMPLETE_SCREEN_INVENTORY.md](design/COMPLETE_SCREEN_INVENTORY.md) → [design/screens/](design/screens/) |
| How does the legacy 94-screen prototype map to the new design? | [design/INVENTORY_RECONCILIATION.md](design/INVENTORY_RECONCILIATION.md) |
| What's the backend architecture? | [architecture/SYSTEM_ARCHITECTURE.md](architecture/SYSTEM_ARCHITECTURE.md), [architecture/BACKEND_DOMAIN_DESIGN.md](architecture/BACKEND_DOMAIN_DESIGN.md) |
| What's the data model? | [database/DATABASE_DESIGN.md](database/DATABASE_DESIGN.md), [database/FINANCIAL_DATA_MODEL.md](database/FINANCIAL_DATA_MODEL.md) |
| What API commands exist? | [api/API_SPECIFICATION.md](api/API_SPECIFICATION.md) → six command detail files |
| Who can do what? | [api/AUTHORIZATION.md](api/AUTHORIZATION.md) |
| How does payment/credit/COD work? | [payments/](payments/) |
| How does Accounts Web work? | [accounts-web/](accounts-web/) |
| What are the 25 end-to-end scenarios? | [scenarios/SCENARIO_INDEX.md](scenarios/SCENARIO_INDEX.md) |
| What architecture decisions were made? | [adr/](adr/) (001…014) |
| What security controls exist? | [security/](security/) |
| What tests are planned? | [testing/](testing/) |
| How do we deploy/operate this? | [deployment/](deployment/), [operations/](operations/) |
| What's left to do? | [verification/OPEN_DECISIONS.md](verification/OPEN_DECISIONS.md), [TASKS.md](TASKS.md) |
| Was anything actually verified? | [verification/FINAL_VERIFICATION_REPORT.md](verification/FINAL_VERIFICATION_REPORT.md) |

## By application

Customer App: [customer-app/](customer-app/) · Partner App: [partner-app/](partner-app/) · Admin Web: [admin-web/](admin-web/) · Accounts Web: [accounts-web/](accounts-web/)

## Folder map

`analysis/` `requirements/` `planning/` `architecture/` `adr/` `database/` `api/` `payments/` `customer-app/` `partner-app/` `admin-web/` `accounts-web/` `design/` (+`design/screens/`) `scenarios/` `security/` `testing/` `operations/` `deployment/` `setup/` `references/` `diagrams/` `verification/`
