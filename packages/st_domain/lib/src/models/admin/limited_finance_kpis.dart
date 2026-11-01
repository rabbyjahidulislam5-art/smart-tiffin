import '../finance/period_status.dart';

/// The non-sensitive finance KPIs Admin may see on NA-05. Integers, ratios
/// and enums only, so no balance can appear (conflict register C-06).
class LimitedFinanceKpis {
  const LimitedFinanceKpis({
    required this.orderVolumeChangePercent,
    required this.collectionRatePercent,
    required this.openExceptionCount,
    required this.pendingPayoutRequestCount,
    required this.periodStatus,
  });

  final int orderVolumeChangePercent;
  final int collectionRatePercent;
  final int openExceptionCount;
  final int pendingPayoutRequestCount;
  final PeriodStatus periodStatus;
}
