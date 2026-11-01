/// Payout states (accounts-web/PAYOUT_MANAGEMENT.md). Settled only after the
/// external transfer is confirmed.
enum PayoutStatus { requested, underReview, approved, processing, settled, failed, rejected }
