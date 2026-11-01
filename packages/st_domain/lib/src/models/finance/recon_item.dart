import 'recon_state.dart';

/// A gateway payment matched against the ledger (NF-02).
class ReconItem {
  const ReconItem({required this.id, required this.paymentRef, required this.gatewayMinor, required this.ledgerMinor, required this.state});

  final String id;
  final String paymentRef;
  final int gatewayMinor;
  final int ledgerMinor;
  final ReconState state;

  int get differenceMinor => gatewayMinor - ledgerMinor;
}
