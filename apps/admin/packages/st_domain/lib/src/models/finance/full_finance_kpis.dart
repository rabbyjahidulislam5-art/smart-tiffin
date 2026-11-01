/// Every NF-01 metric (FINANCE_DASHBOARD.md) for one period, in minor units.
class FullFinanceKpis {
  const FullFinanceKpis({
    required this.period,
    required this.verifiedCollectionsMinor,
    required this.receivablesMinor,
    required this.supplierPayablesMinor,
    required this.riderPayablesMinor,
    required this.creditLiabilityMinor,
    required this.codAwaitingMinor,
    required this.availableFundsMinor,
    required this.pendingSettlementsMinor,
    required this.completedSettlementsMinor,
    required this.refundObligationsMinor,
    required this.revenueMinor,
    required this.exceptionCount,
    required this.generatedAt,
  });

  final String period;
  final int verifiedCollectionsMinor;
  final int receivablesMinor;
  final int supplierPayablesMinor;
  final int riderPayablesMinor;
  final int creditLiabilityMinor;
  final int codAwaitingMinor;
  final int availableFundsMinor;
  final int pendingSettlementsMinor;
  final int completedSettlementsMinor;
  final int refundObligationsMinor;
  final int revenueMinor;
  final int exceptionCount;
  final String generatedAt;
}
