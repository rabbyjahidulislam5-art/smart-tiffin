/// Read-only operations KPIs for NA-01 (counts only, no balances).
class OpsKpi {
  const OpsKpi({
    required this.ongoingOrders,
    required this.lateOrders,
    required this.kitchensNearCapacity,
    required this.dispatchRisk,
    required this.openIncidents,
    required this.pendingApplications,
    required this.generatedAt,
  });

  final int ongoingOrders;
  final int lateOrders;
  final int kitchensNearCapacity;

  /// Deliveries at risk of missing their window.
  final int dispatchRisk;
  final int openIncidents;
  final int pendingApplications;
  final String generatedAt;
}
