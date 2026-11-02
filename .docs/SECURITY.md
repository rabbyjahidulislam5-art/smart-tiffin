# Security policy (documentation set)

| Field | Value |
|---|---|
| Revision | 1.0 · 2026-10-30 |
| Owner | Documentation lead; security review owner — to be identified |
| Status | No reporting channel is currently defined for this project. This is an open item, not a placeholder to be filled with an invented contact. |

## Scope

This file covers security concerns about the **documentation set** in `FINAL_REFINED_DOCS/` (for example, a document that would leak a secret pattern, or that describes an insecure default as if it were safe). For security concerns about the real code in `app/`, `backend/` or `firebase/`, see [firebase/SECURITY_REVIEW.md](../firebase/SECURITY_REVIEW.md) and [security/SECURITY_REVIEW_PLANNING.md](security/SECURITY_REVIEW_PLANNING.md); a reporting route for that code is also not currently defined.

## What this documentation set already guards against

No document in this set contains a real credential, API key, SSLCOMMERZ merchant identifier, signing key, production customer data, or wallet PIN/OTP. See [security/SECRETS_MANAGEMENT.md](security/SECRETS_MANAGEMENT.md) for the rule and [analysis/CONVENTIONS_AND_ID_REGISTER.md](analysis/CONVENTIONS_AND_ID_REGISTER.md) §10 for the authoring rule that enforces it.

## Reporting a documentation security issue

No dedicated reporting channel (security contact, issue template, disclosure email) exists for this project yet. This is recorded as an open decision; see [verification/OPEN_DECISIONS.md](verification/OPEN_DECISIONS.md). Until one is established, raise a concern directly with the documentation lead or business owner identified in [requirements/STAKEHOLDER_ANALYSIS.md](requirements/STAKEHOLDER_ANALYSIS.md).

## Threat model and financial security

See [security/THREAT_MODEL.md](security/THREAT_MODEL.md) and [security/FINANCIAL_SECURITY.md](security/FINANCIAL_SECURITY.md) for the documented threat scenarios (price tampering, forged gateway callbacks, duplicate credits, payout fraud, journal tampering, duplicate COD deposits, replay attacks) and their PROPOSED controls. None of these controls has been implemented or tested; this document does not claim otherwise.
