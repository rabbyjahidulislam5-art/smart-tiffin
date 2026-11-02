# ADR-007: Payment gateway abstraction (SSLCOMMERZ) plus four distinct COD models

| Field | Value |
|---|---|
| Status | PROPOSED — NOT APPROVED |
| Date | 2026-10-30 |

## Context

USER-REQ: SSLCOMMERZ is the selected future gateway; prepare the complete integration architecture now (gateway abstraction, payment lifecycle, environment configuration, sandbox/live separation, frontend screens, backend initiation, secure IPN handling, server-side validation, status reconciliation, refund boundary, mock-gateway tests) without requesting or using real credentials or initiating real transactions. COD must be supported for eligible individual orders and specifically approved subscription arrangements, as four distinct models (per-order, per-scheduled-meal, approved weekly collection, approved monthly settlement), never conflated into one workflow. ADR-003's "no payment webhook, no gateway SDK" statement is directly superseded.

## Options considered (payment gateway)

1. Integrate SSLCOMMERZ directly with no abstraction layer.
2. Build a provider-agnostic gateway abstraction interface, with SSLCOMMERZ as the first (and, in this phase, only) implementation.

## Decision (payment gateway)

Option 2. A `PaymentGateway` interface (initiate, validate, query status, refund) is implemented once for SSLCOMMERZ; this avoids hard-wiring gateway-specific assumptions into MOD-PAY and keeps the option open to add a second gateway later without touching the domain model. No live credential, store ID, or transaction is used in this phase (NFR-025).

## Options considered (COD)

1. One generic "pay on delivery" flag for every order type.
2. Four distinct, separately modelled COD arrangements — individual order, per scheduled meal, approved weekly collection, approved monthly settlement/postpaid — each with its own eligibility, limit and remittance rule.

## Decision (COD)

Option 2, per explicit USER-REQ instruction. Treating them as one workflow would hide materially different collection, remittance and exposure characteristics (BR-012, BR-013, BR-016).

## Consequences

More interface surface than a direct integration, but the gateway can be verified, mocked and tested without ever touching a live endpoint; COD's four models each get their own schema and state machine instead of one conflated flag, at the cost of more initial design work.

## Risks

Incorrect assumptions about SSLCOMMERZ's actual IPN/validation contract if not verified against official documentation before implementation (RISK-025); COD exposure growing unbounded without an approved remittance deadline (RISK-035).

## Links

[payments/PAYMENT_ARCHITECTURE.md](../payments/PAYMENT_ARCHITECTURE.md), [payments/SSLCOMMERZ_INTEGRATION_PLAN.md](../payments/SSLCOMMERZ_INTEGRATION_PLAN.md), [payments/COD_PAYMENT_WORKFLOW.md](../payments/COD_PAYMENT_WORKFLOW.md), BR-003, BR-012, BR-013.
