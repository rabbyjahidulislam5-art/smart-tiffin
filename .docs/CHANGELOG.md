# Changelog

All notable changes to the Smart Tiffin documentation set. This file tracks documentation revisions, not application releases (none exist yet).

## [3.0] — 2026-10-30 — Four-application documentation rewrite

Rewrote the documentation set from a single combined Android/Firebase application into four applications (Customer App, Partner App, Admin Web, Accounts Web) on one shared backend, following the user's two primary requirement sources (an expanded master prompt and the legacy 94-screen prototype documentation, both preserved as digests in [analysis/](analysis/)).

Added: policy decision register BR-006…BR-026; glossary and terminology; eleven new ADRs (004…014); multi-app architecture, backend domain design, time/cutoff policy, React-to-Flutter migration; extended database/financial data model with ledger, credits, quotes, COD, payouts; full API command specification; payments domain (SSLCOMMERZ abstraction, COD, pricing, credits); Accounts Web domain (ledger, reconciliation, settlement, payouts, refunds); customer/partner/admin module specifications; 55 proposed screen contracts (NC/NS/NR/NA/NF) plus full reconciliation of the legacy 94 screens and the prior 129-family planning inventory; 25 cross-system scenarios and 10 workflows; extended testing, security, operations, deployment, setup and diagram documentation; full verification pass.

Revised in place: FR-001…025, UC-001…025, AC-001…025, US-001…025 (extended with FR/UC/AC/US-026…050); BUSINESS_RULES.md (BR-001…005 preserved unchanged, extended register linked); all original architecture, database, API and security documents; all planning documents; SOURCE_MATERIAL_REGISTER.md (reversed the earlier "not adopted" statement, per the user's explicit 2026-10-30 direction).

Superseded, kept as history with a banner: ADR-001 (single-app Firebase, part), ADR-003 (manual-payment half); the 129-family SCREEN_INVENTORY.md and SCREEN_AND_CONTROL_INVENTORY.md (reconciled one-to-one against the authoritative legacy 94 IDs, nothing lost).

## [2.0] — 2026-10-30 — Code reality correction (FINAL_REFINED_DOCS baseline)

Corrected the false statement, repeated across several documents, that no application existed; recorded the real `app/`, `backend/functions` and `firebase/` code on disk as an OBSERVED, unverified baseline.

## [0.1]–[0.2] — 2026-10-28 — Initial requirements package

Original single-application requirements, architecture, planning, design and test documentation for an Android-first Flutter/Firebase application, with BR-001…BR-005 established as Pending Decision.
