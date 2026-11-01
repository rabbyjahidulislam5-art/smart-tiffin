import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/partner/earning_balances.dart';
import '../../models/partner/earning_status.dart';
import '../../models/partner/rider_earning.dart';
import '../../models/partner/rider_earning_status.dart';
import '../../models/partner/supplier_earning.dart';
import '../../repositories/partner/earnings_repository.dart';
import '../../result/repo_result.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';
import 'mock_payout_repository.dart';

/// Sample earnings (HYPOTHETICAL amounts). Eligible and held figures come from
/// the payout mock when one is given, so NS-01 and NS-02 always agree.
class MockEarningsRepository extends MockRepositoryBase implements EarningsRepository {
  MockEarningsRepository({MockBehavior? behavior, this.payouts}) : super(behavior);

  final MockPayoutRepository? payouts;

  static const supplierRoles = {StRole.supplier};
  static const riderRoles = {StRole.rider};

  static const supplierFixtures = <SupplierEarning>[
    SupplierEarning(id: 'SE-1043', orderRef: 'OB-2041', source: 'Subscription obligation · lunch · Nov 3', recognisedOn: '', grossMinor: 18000, commissionMinor: 2700, status: EarningStatus.expected),
    SupplierEarning(id: 'SE-1042', orderRef: 'TK-912', source: 'Order TK-912 · 1× Diet Khichuri', recognisedOn: '2026-10-31', grossMinor: 18000, commissionMinor: 2700, status: EarningStatus.eligible),
    SupplierEarning(id: 'SE-1041', orderRef: 'TK-911', source: 'Order TK-911 · 2× Bengali Thali', recognisedOn: '2026-10-30', grossMinor: 36000, commissionMinor: 5400, status: EarningStatus.earned),
    SupplierEarning(id: 'SE-1039', orderRef: 'TK-905', source: 'Order TK-905 · 1× Roti & Chicken', recognisedOn: '2026-10-28', grossMinor: 20000, commissionMinor: 3000, status: EarningStatus.held, holdReason: 'Customer complaint under review'),
    SupplierEarning(id: 'SE-1030', orderRef: 'TK-890', source: 'Order TK-890 · 3× Bengali Thali', recognisedOn: '2026-10-24', grossMinor: 54000, commissionMinor: 8100, status: EarningStatus.settled),
  ];

  static const riderFixtures = <RiderEarning>[
    RiderEarning(id: 'RE-771', deliveryRef: 'DL-913', date: '2026-11-02', expectedMinor: 6000, confirmedMinor: 0, status: RiderEarningStatus.expected),
    RiderEarning(id: 'RE-770', deliveryRef: 'DL-911', date: '2026-11-01', expectedMinor: 6000, confirmedMinor: 6000, status: RiderEarningStatus.confirmed),
    RiderEarning(id: 'RE-768', deliveryRef: 'DL-905', date: '2026-10-31', expectedMinor: 7000, confirmedMinor: 7000, status: RiderEarningStatus.held),
    RiderEarning(id: 'RE-760', deliveryRef: 'DL-890', date: '2026-10-29', expectedMinor: 6500, confirmedMinor: 6500, status: RiderEarningStatus.paid),
    RiderEarning(id: 'RE-752', deliveryRef: 'DL-874', date: '2026-10-27', expectedMinor: 6000, confirmedMinor: 0, status: RiderEarningStatus.reversed, reversedMinor: 6000),
  ];

  @override
  Future<RepoResult<List<SupplierEarning>>> supplierEarnings(Actor actor, {EarningStatus? status}) => guardRead(
      actor, supplierRoles, 'supplierEarnings', () => Ok([for (final e in supplierFixtures) if (status == null || e.status == status) e]));

  @override
  Future<RepoResult<EarningBalances>> supplierBalances(Actor actor) => guardRead(actor, supplierRoles, 'supplierBalances', () {
        int sum(EarningStatus s) => supplierFixtures.where((e) => e.status == s).fold(0, (a, e) => a + e.netMinor);
        return Ok(EarningBalances(
          expectedMinor: 1620000 + sum(EarningStatus.expected),
          earnedMinor: 2412000 + sum(EarningStatus.earned),
          heldMinor: payouts?.heldOf(StRole.supplier) ?? 210000,
          eligibleMinor: payouts?.eligibleOf(StRole.supplier) ?? 1845000,
          settledMinor: 9850000 + sum(EarningStatus.settled),
        ));
      });

  @override
  Future<RepoResult<List<RiderEarning>>> riderEarnings(Actor actor, {RiderEarningStatus? status}) => guardRead(
      actor, riderRoles, 'riderEarnings', () => Ok([for (final e in riderFixtures) if (status == null || e.status == status) e]));

  @override
  Future<RepoResult<EarningBalances>> riderBalances(Actor actor) => guardRead(
        actor,
        riderRoles,
        'riderBalances',
        () => Ok(EarningBalances(
          expectedMinor: 6000,
          earnedMinor: 426000,
          heldMinor: payouts?.heldOf(StRole.rider) ?? 7000,
          eligibleMinor: payouts?.eligibleOf(StRole.rider) ?? 260000,
          settledMinor: 1840000,
        )),
      );
}
