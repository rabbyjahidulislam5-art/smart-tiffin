# ADR-003: Preserve status tracking and manual reference payments

**SUPERSEDED IN PART, 2026-10-30.** The payment half of this decision — "no payment webhook, no gateway SDK required" — is superseded by [ADR-007](007-payment-gateway-abstraction-and-cod.md): SSLCOMMERZ is now the designated future gateway, prepared behind an abstraction with IPN/webhook handling, though still not connected or live in this phase. The manual bKash/Nagad reference path is retained as one optional evidentiary fallback (BR-003 unchanged). The delivery-status half of this decision — the four confirmed states Pending → Picked Up → On The Way → Delivered — is **retained unchanged** and remains authoritative; it is not superseded. Kept below unchanged as the historical record.

Status: accepted scope boundary from the supplied proposal; detailed business policies pending.

Context: the current release specifies delivery status updates and bKash/Nagad reference submission. Live GPS and online payment gateway integration are explicitly later features.

Options: status tracking/manual references in the current release; expand into live mapping and gateway integration now.

Decision: preserve Pending → Picked Up → On The Way → Delivered and record manual references without treating submission as successful payment. Store only necessary textual destination data for assignment. No GPS permission, provider PIN/OTP, payment webhook or gateway SDK is required by current scope.

Consequences: delivery visibility and payment reconciliation still require complete workflows, role checks and audit. BR-003 must define the verifier/evidence; BR-002 defines bill/earnings/revenue calculations; BR-004 defines assignment; BR-005 defines cancellation/refunds. Failed delivery is an exception requiring policy, not an invented fifth successful status.

Revisit through a later-release change request for GPS or gateway functionality, with permission, privacy, cost, authenticity and retry requirements. Do not silently move any current-release feature to that backlog.
