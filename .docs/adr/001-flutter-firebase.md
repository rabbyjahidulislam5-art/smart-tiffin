# ADR-001: Follow the Flutter and Firebase direction

**SUPERSEDED IN PART, 2026-10-30.** The single-mobile-app framing below is superseded by [ADR-004](004-four-app-monorepo.md) (four applications on one backend) and the Firestore-only data store is superseded by [ADR-005](005-hybrid-datastore.md) (hybrid Firestore + proposed PostgreSQL). Flutter as the client framework, and Firebase Authentication/Cloud Firestore/FCM as backend-service choices, remain in force for the operational (non-ledger) domain — this ADR's technology choice is *extended*, not reversed. Kept below unchanged as the historical record.

Status: accepted as source-aligned requirements direction; implementation versions and configuration pending.

Context: the proposal specifies one mobile application with four roles and prefers Flutter, Firebase Authentication, Firestore and FCM. The user confirmed Android first and Bangla/English.

Options: Flutter with preferred managed services; Flutter with custom Dart server/relational storage; local-only or pure Dart application.

Decision: use Flutter as the client direction and the three preferred Firebase services in the requirements architecture. Separate UI, state and data access. Compare a trusted service explicitly in ADR-002 rather than hiding privileged work in a client repository.

Consequences: aligns with the course proposal and reduces unnecessary server infrastructure, while requiring Firestore-specific authorization/query design, service-cost review and financial consistency work. Versions, region, identity provider and package selection remain open. No claim that Firebase alone implements the business rules is made.

Revisit if approved reporting, transaction, offline, cost or data-governance requirements cannot be met simply with this design. [Technology comparison](../architecture/TECH_STACK.md).
