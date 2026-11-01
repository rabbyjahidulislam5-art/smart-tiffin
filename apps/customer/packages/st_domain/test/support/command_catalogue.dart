import 'package:st_domain/st_domain.dart';

/// One repository method in the catalogue used by the catalogue-driven
/// property tests (Properties 3, 12, 13, 14).
class CatalogueMethod {
  const CatalogueMethod({
    required this.name,
    required this.isCommand,
    required this.call,
    this.roles,
  });

  final String name;
  final bool isCommand;

  /// Roles of this method when narrower than the repository's.
  final Set<StRole>? roles;

  /// Calls the method on a fresh or given repository as [actor].
  final Future<RepoResult<Object?>> Function(
      Object repo, Actor actor, RequestId requestId) call;
}

/// A repository with its allowed roles, a factory and an observation of its
/// state (a value that changes when, and only when, a command commits).
class CatalogueEntry {
  const CatalogueEntry({
    required this.repository,
    required this.allowedRoles,
    required this.create,
    required this.observe,
    required this.methods,
    this.gated = true,
    this.signedInOnly = true,
  });

  final String repository;
  final Set<StRole> allowedRoles;
  final Object Function(MockBehavior behavior) create;
  final Future<Object?> Function(Object repo) observe;
  final List<CatalogueMethod> methods;

  /// False for the pre-session `StaffAuthRepository`.
  final bool gated;

  /// True when guests of an allowed role are refused.
  final bool signedInOnly;
}

/// Every mock repository registered so far. Later batches append entries.
final List<CatalogueEntry> commandCatalogue = [
  CatalogueEntry(
    repository: 'StaffAuthRepository',
    allowedRoles: StRole.values.toSet(),
    gated: false,
    signedInOnly: false,
    create: (b) => MockStaffAuthRepository(behavior: b),
    observe: (repo) async => (repo as MockStaffAuthRepository).calls.length,
    methods: [
      CatalogueMethod(
        name: 'verifyCredentials',
        isCommand: false,
        call: (repo, actor, id) => (repo as MockStaffAuthRepository)
            .verifyCredentials(
                MockStaffAuthRepository.adminEmail, 'demo-password'),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'EarningsRepository',
    allowedRoles: {StRole.supplier, StRole.rider},
    create: (b) => MockEarningsRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
        name: 'supplierEarnings',
        isCommand: false,
        roles: {StRole.supplier},
        call: (repo, a, id) =>
            (repo as MockEarningsRepository).supplierEarnings(a),
      ),
      CatalogueMethod(
        name: 'supplierBalances',
        isCommand: false,
        roles: {StRole.supplier},
        call: (repo, a, id) =>
            (repo as MockEarningsRepository).supplierBalances(a),
      ),
      CatalogueMethod(
        name: 'riderEarnings',
        isCommand: false,
        roles: {StRole.rider},
        call: (repo, a, id) =>
            (repo as MockEarningsRepository).riderEarnings(a),
      ),
      CatalogueMethod(
        name: 'riderBalances',
        isCommand: false,
        roles: {StRole.rider},
        call: (repo, a, id) =>
            (repo as MockEarningsRepository).riderBalances(a),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'PayoutRepository',
    allowedRoles: {StRole.supplier, StRole.rider},
    create: (b) => MockPayoutRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'eligibleBalance',
          isCommand: false,
          call: (repo, a, id) =>
              (repo as MockPayoutRepository).eligibleBalance(a)),
      CatalogueMethod(
          name: 'history',
          isCommand: false,
          call: (repo, a, id) => (repo as MockPayoutRepository).history(a)),
      CatalogueMethod(
        name: 'requestPayout',
        isCommand: true,
        call: (repo, a, id) => (repo as MockPayoutRepository)
            .requestPayout(a, id, amountMinor: 10000),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'KitchenOperationsRepository',
    allowedRoles: {StRole.supplier},
    create: (b) => MockKitchenOperationsRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'capacity',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockKitchenOperationsRepository).capacity(a)),
      CatalogueMethod(
        name: 'saveCapacity',
        isCommand: true,
        call: (r, a, id) => (r as MockKitchenOperationsRepository).saveCapacity(
            a, id,
            slot: Slot.lunch, maxPortions: 61, expectedVersion: 3),
      ),
      CatalogueMethod(
        name: 'setSlotAvailability',
        isCommand: true,
        call: (r, a, id) => (r as MockKitchenOperationsRepository)
            .setSlotAvailability(a, id, slot: Slot.lunch, open: false),
      ),
      CatalogueMethod(
          name: 'priceVersions',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockKitchenOperationsRepository).priceVersions(a)),
      CatalogueMethod(
        name: 'schedulePriceChange',
        isCommand: true,
        call: (r, a, id) => (r as MockKitchenOperationsRepository)
            .schedulePriceChange(a, id,
                mealId: 'thali',
                amountMinor: 19000,
                effectiveFrom: '2026-11-10',
                reason: 'Season change'),
      ),
      CatalogueMethod(
          name: 'forecast',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockKitchenOperationsRepository).forecast(a)),
      CatalogueMethod(
          name: 'pendingHandoffs',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockKitchenOperationsRepository).pendingHandoffs(a)),
      CatalogueMethod(
        name: 'recordHandoff',
        isCommand: true,
        call: (r, a, id) => (r as MockKitchenOperationsRepository)
            .recordHandoff(a, id,
                handoffId: 'HO-81',
                pickupCode: '4821',
                itemsCounted: true,
                sealed: true),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'CodRepository',
    allowedRoles: {StRole.rider},
    create: (b) => MockCodRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'collections',
          isCommand: false,
          call: (r, a, id) => (r as MockCodRepository).collections(a)),
      CatalogueMethod(
          name: 'liability',
          isCommand: false,
          call: (r, a, id) => (r as MockCodRepository).liability(a)),
      CatalogueMethod(
        name: 'recordCodCollection',
        isCommand: true,
        call: (r, a, id) => (r as MockCodRepository).recordCodCollection(a, id,
            collectionId: 'COD-913', amountMinor: 24000),
      ),
      CatalogueMethod(
          name: 'remittances',
          isCommand: false,
          call: (r, a, id) => (r as MockCodRepository).remittances(a)),
      CatalogueMethod(
        name: 'submitCodRemittance',
        isCommand: true,
        call: (r, a, id) => (r as MockCodRepository).submitCodRemittance(a, id,
            amountMinor: 10000, reference: 'DEP-80001', method: 'Bank deposit'),
      ),
      CatalogueMethod(
          name: 'discrepancies',
          isCommand: false,
          call: (r, a, id) => (r as MockCodRepository).discrepancies(a)),
      CatalogueMethod(
        name: 'respondToDiscrepancy',
        isCommand: true,
        call: (r, a, id) => (r as MockCodRepository).respondToDiscrepancy(a, id,
            discrepancyId: 'DS-12', response: 'Paid the rest at the hub.'),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'DeliveryDisputeRepository',
    allowedRoles: {StRole.rider},
    create: (b) => MockDeliveryDisputeRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'reports',
          isCommand: false,
          call: (r, a, id) => (r as MockDeliveryDisputeRepository).reports(a)),
      CatalogueMethod(
        name: 'reportDeliveryFailure',
        isCommand: true,
        call: (r, a, id) => (r as MockDeliveryDisputeRepository)
            .reportDeliveryFailure(a, id,
                deliveryRef: 'DL-913',
                kind: DeliveryFailureKind.noShow,
                note: 'Waited 10 minutes at the gate.'),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'OpsOverviewRepository',
    allowedRoles: {StRole.admin},
    create: (b) => MockOpsOverviewRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'kpis',
          isCommand: false,
          call: (r, a, id) => (r as MockOpsOverviewRepository).kpis(a)),
      CatalogueMethod(
          name: 'incidents',
          isCommand: false,
          call: (r, a, id) => (r as MockOpsOverviewRepository).incidents(a)),
    ],
  ),
  CatalogueEntry(
    repository: 'PolicyRepository',
    allowedRoles: {StRole.admin},
    create: (b) => MockPolicyRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'versions',
          isCommand: false,
          call: (r, a, id) => (r as MockPolicyRepository).versions(a)),
      CatalogueMethod(
        name: 'publishPolicyVersion',
        isCommand: true,
        call: (r, a, id) => (r as MockPolicyRepository).publishPolicyVersion(
            a, id,
            key: 'policy.discount.rules',
            value: 'none',
            effectiveFrom: '2026-12-01'),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'ApplicationReviewRepository',
    allowedRoles: {StRole.admin},
    create: (b) => MockApplicationReviewRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'queue',
          isCommand: false,
          call: (r, a, id) => (r as MockApplicationReviewRepository).queue(a)),
      CatalogueMethod(
          name: 'application',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockApplicationReviewRepository).application(a, 'sultana')),
      CatalogueMethod(
        name: 'decideApplication',
        isCommand: true,
        call: (r, a, id) => (r as MockApplicationReviewRepository)
            .decideApplication(a, id,
                id: 'sultana',
                decision: ApplicationDecision.requestInfo,
                checklist: const {},
                reason: 'Please upload the hygiene certificate.'),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'DispatchRepository',
    allowedRoles: {StRole.admin},
    create: (b) => MockDispatchRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'delayedDeliveries',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockDispatchRepository).delayedDeliveries(a)),
      CatalogueMethod(
          name: 'backupRiders',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockDispatchRepository).backupRiders(a, 'DL-913')),
      CatalogueMethod(
        name: 'reassignDelivery',
        isCommand: true,
        call: (r, a, id) => (r as MockDispatchRepository).reassignDelivery(
            a, id,
            deliveryId: 'DL-913', riderId: 'rider-sabbir'),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'FinanceKpiRepository',
    allowedRoles: {StRole.admin, StRole.accounting},
    create: (b) => MockFinanceKpiRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'limited',
          isCommand: false,
          call: (r, a, id) => (r as MockFinanceKpiRepository).limited(a)),
      CatalogueMethod(
          name: 'full',
          isCommand: false,
          roles: {StRole.accounting},
          call: (r, a, id) => (r as MockFinanceKpiRepository).full(a)),
    ],
  ),
  CatalogueEntry(
    repository: 'ReportRepository',
    allowedRoles: {StRole.admin, StRole.accounting},
    create: (b) => MockReportRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
        name: 'definitions(operational)',
        isCommand: false,
        roles: {StRole.admin},
        call: (r, a, id) =>
            (r as MockReportRepository).definitions(a, ReportScope.operational),
      ),
      CatalogueMethod(
        name: 'definitions(financial)',
        isCommand: false,
        roles: {StRole.accounting},
        call: (r, a, id) =>
            (r as MockReportRepository).definitions(a, ReportScope.financial),
      ),
      CatalogueMethod(
        name: 'exportReport(operational)',
        isCommand: true,
        roles: {StRole.admin},
        call: (r, a, id) => (r as MockReportRepository).exportReport(a, id,
            definitionId: 'OPS-LATE', range: '2026-10-01..2026-10-31'),
      ),
      CatalogueMethod(
        name: 'exportReport(financial)',
        isCommand: true,
        roles: {StRole.accounting},
        call: (r, a, id) => (r as MockReportRepository).exportReport(a, id,
            definitionId: 'FIN-TB', range: '2026-10-01..2026-10-31'),
      ),
      CatalogueMethod(
        name: 'exportLog(operational)',
        isCommand: false,
        roles: {StRole.admin},
        call: (r, a, id) =>
            (r as MockReportRepository).exportLog(a, ReportScope.operational),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'PaymentReconciliationRepository',
    allowedRoles: {StRole.accounting},
    create: (b) => MockPaymentReconciliationRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'matches',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockPaymentReconciliationRepository).matches(a)),
      CatalogueMethod(
          name: 'exceptions',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockPaymentReconciliationRepository).exceptions(a)),
      CatalogueMethod(
          name: 'statements',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockPaymentReconciliationRepository).statements(a)),
      CatalogueMethod(
        name: 'reconcileGatewayStatement',
        isCommand: true,
        call: (r, a, id) => (r as MockPaymentReconciliationRepository)
            .reconcileGatewayStatement(a, id,
                statementId: 'ST-2026-10-B', evidenceRef: 'EV-1201'),
      ),
      CatalogueMethod(
        name: 'assignException',
        isCommand: true,
        call: (r, a, id) => (r as MockPaymentReconciliationRepository)
            .assignException(a, id,
                exceptionIds: const ['EXC-31'], assignee: 'Rahim'),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'CodVerificationRepository',
    allowedRoles: {StRole.accounting},
    create: (b) => MockCodVerificationRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'custody',
          isCommand: false,
          call: (r, a, id) => (r as MockCodVerificationRepository).custody(a)),
      CatalogueMethod(
          name: 'remittances',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockCodVerificationRepository).remittances(a)),
      CatalogueMethod(
          name: 'remittance',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockCodVerificationRepository).remittance(a, 'RM-66')),
      CatalogueMethod(
        name: 'verifyCodRemittance',
        isCommand: true,
        call: (r, a, id) => (r as MockCodVerificationRepository)
            .verifyCodRemittance(a, id,
                remittanceId: 'RM-66',
                depositReference: 'DEP-55188',
                accept: true),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'SettlementLedgerRepository',
    allowedRoles: {StRole.accounting},
    create: (b) => MockSettlementLedgerRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'supplierPayables',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockSettlementLedgerRepository).supplierPayables(a)),
      CatalogueMethod(
          name: 'riderPayables',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockSettlementLedgerRepository).riderPayables(a)),
      CatalogueMethod(
        name: 'placeHold',
        isCommand: true,
        call: (r, a, id) => (r as MockSettlementLedgerRepository).placeHold(
            a, id,
            partyId: 'maas-kitchen', reason: 'Hygiene review'),
      ),
      CatalogueMethod(
        name: 'releaseHold',
        isCommand: true,
        call: (r, a, id) => (r as MockSettlementLedgerRepository).releaseHold(
            a, id,
            partyId: 'dhaka-tiffin', reason: 'Review passed'),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'PayoutOperationsRepository',
    allowedRoles: {StRole.accounting},
    create: (b) => MockPayoutOperationsRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'requests',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockPayoutOperationsRepository).requests(a)),
      CatalogueMethod(
          name: 'reviewPayout',
          isCommand: true,
          call: (r, a, id) => (r as MockPayoutOperationsRepository)
              .reviewPayout(a, id, caseId: 'PO-311')),
      CatalogueMethod(
        name: 'rejectPayout',
        isCommand: true,
        call: (r, a, id) => (r as MockPayoutOperationsRepository).rejectPayout(
            a, id,
            caseId: 'PO-314', reason: 'Beneficiary not verified'),
      ),
      CatalogueMethod(
          name: 'batches',
          isCommand: false,
          call: (r, a, id) => (r as MockPayoutOperationsRepository).batches(a)),
      CatalogueMethod(
        name: 'createPayoutBatch',
        isCommand: true,
        call: (r, a, id) => (r as MockPayoutOperationsRepository)
            .createPayoutBatch(a, id, caseIds: const ['PO-312']),
      ),
      CatalogueMethod(
        name: 'releasePayoutBatch',
        isCommand: true,
        call: (r, a, id) => (r as MockPayoutOperationsRepository)
            .releasePayoutBatch(a, id, batchId: 'PB-21'),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'CreditAndRefundRepository',
    allowedRoles: {StRole.accounting},
    create: (b) => MockCreditAndRefundRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'liability',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockCreditAndRefundRepository).liability(a)),
      CatalogueMethod(
          name: 'voidCredit',
          isCommand: true,
          call: (r, a, id) => (r as MockCreditAndRefundRepository)
              .voidCredit(a, id, rowId: 'CL-95', reason: 'Issued twice')),
      CatalogueMethod(
          name: 'cases',
          isCommand: false,
          call: (r, a, id) => (r as MockCreditAndRefundRepository).cases(a)),
      CatalogueMethod(
          name: 'initiateRefund',
          isCommand: true,
          call: (r, a, id) => (r as MockCreditAndRefundRepository)
              .initiateRefund(a, id, caseId: 'RF-21')),
    ],
  ),
  CatalogueEntry(
    repository: 'LedgerRepository',
    allowedRoles: {StRole.accounting},
    create: (b) => MockLedgerRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'journals',
          isCommand: false,
          call: (r, a, id) => (r as MockLedgerRepository).journals(a)),
      CatalogueMethod(
        name: 'reverseJournal',
        isCommand: true,
        call: (r, a, id) => (r as MockLedgerRepository).reverseJournal(a, id,
            journalId: 'JE-9012', reason: 'Posted to the wrong period'),
      ),
      CatalogueMethod(
          name: 'periods',
          isCommand: false,
          call: (r, a, id) => (r as MockLedgerRepository).periods(a)),
      CatalogueMethod(
          name: 'closePeriod',
          isCommand: true,
          call: (r, a, id) => (r as MockLedgerRepository)
              .closePeriod(a, id, periodId: '2026-10')),
    ],
  ),
  CatalogueEntry(
    repository: 'StaffRoleRepository',
    allowedRoles: {StRole.accounting},
    create: (b) => MockStaffRoleRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'staff',
          isCommand: false,
          call: (r, a, id) => (r as MockStaffRoleRepository).staff(a)),
      CatalogueMethod(
        name: 'grantStaffRole',
        isCommand: true,
        call: (r, a, id) => (r as MockStaffRoleRepository).grantStaffRole(a, id,
            email: 'mim@smarttiffin.bd',
            subRole: FinanceSubRole.financialAuditor),
      ),
      CatalogueMethod(
        name: 'revokeStaffRole',
        isCommand: true,
        call: (r, a, id) => (r as MockStaffRoleRepository).revokeStaffRole(
            a, id,
            staffId: 'rahim.acop', reason: 'Left the team'),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'AdjustmentRepository',
    allowedRoles: {StRole.accounting},
    create: (b) => MockAdjustmentRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'adjustments',
          isCommand: false,
          call: (r, a, id) => (r as MockAdjustmentRepository).adjustments(a)),
      CatalogueMethod(
        name: 'requestAdjustment',
        isCommand: true,
        call: (r, a, id) => (r as MockAdjustmentRepository).requestAdjustment(
            a, id,
            description: 'Correct rounding on TK-901',
            amountMinor: -500,
            evidenceRef: 'EV-2001'),
      ),
      CatalogueMethod(
        name: 'approveAdjustment',
        isCommand: true,
        call: (r, a, id) => (r as MockAdjustmentRepository)
            .approveAdjustment(a, id, adjustmentId: 'ADJ-14', approve: true),
      ),
    ],
  ),
  CatalogueEntry(
    repository: 'KitchenRepository',
    allowedRoles: {StRole.customer},
    signedInOnly: false,
    create: (b) => MockKitchenRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'search',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockKitchenRepository).search(a, const KitchenQuery())),
      CatalogueMethod(
          name: 'kitchen',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockKitchenRepository).kitchen(a, 'maas-kitchen')),
      CatalogueMethod(
          name: 'menuDates',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockKitchenRepository).menuDates(a, 'maas-kitchen')),
      CatalogueMethod(
          name: 'menu',
          isCommand: false,
          call: (r, a, id) => (r as MockKitchenRepository)
              .menu(a, 'maas-kitchen', slot: Slot.lunch, date: '2026-11-03')),
      CatalogueMethod(
          name: 'reviews',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockKitchenRepository).reviews(a, 'maas-kitchen')),
    ],
  ),
  CatalogueEntry(
    repository: 'FavouriteRepository',
    allowedRoles: {StRole.customer},
    create: (b) => MockFavouriteRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'favourites',
          isCommand: false,
          call: (r, a, id) => (r as MockFavouriteRepository).favourites(a)),
      CatalogueMethod(
          name: 'setFavourite',
          isCommand: true,
          call: (r, a, id) => (r as MockFavouriteRepository)
              .setFavourite(a, id, kitchenId: 'maas-kitchen', favourite: true)),
    ],
  ),
  CatalogueEntry(
    repository: 'SubscriptionRepository',
    allowedRoles: {StRole.customer},
    create: (b) => MockSubscriptionRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'createDraft',
          isCommand: true,
          call: (r, a, id) => (r as MockSubscriptionRepository)
              .createDraft(a, id, kitchenId: 'rinas-kitchen')),
      CatalogueMethod(
          name: 'draft',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockSubscriptionRepository).draft(a, 'DR-404')),
      CatalogueMethod(
          name: 'saveSchedule',
          isCommand: true,
          call: (r, a, id) => (r as MockSubscriptionRepository).saveSchedule(
              a, id,
              draftId: 'DR-404',
              expectedVersion: 1,
              startDate: '2026-11-03',
              weeks: 1,
              billing: BillingFrequency.weekly,
              cells: const [])),
      CatalogueMethod(
          name: 'savePattern',
          isCommand: true,
          call: (r, a, id) => (r as MockSubscriptionRepository).savePattern(
              a, id,
              draftId: 'DR-404',
              expectedVersion: 1,
              rule: const RecurrenceRule(
                  weekdays: {1},
                  slot: Slot.lunch,
                  menuItemId: 'rk-thali',
                  qty: 1,
                  weeks: 1))),
      CatalogueMethod(
          name: 'discard',
          isCommand: true,
          call: (r, a, id) => (r as MockSubscriptionRepository)
              .discard(a, id, draftId: 'DR-404')),
      CatalogueMethod(
          name: 'changeHistory',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockSubscriptionRepository).changeHistory(a, 'SUB-301')),
      CatalogueMethod(
          name: 'renewalOffer',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockSubscriptionRepository).renewalOffer(a, 'SUB-301')),
      CatalogueMethod(
          name: 'respondToRenewal',
          isCommand: true,
          call: (r, a, id) => (r as MockSubscriptionRepository)
              .respondToRenewal(a, id, offerId: 'RO-301', accept: true)),
    ],
  ),
  CatalogueEntry(
    repository: 'QuoteRepository',
    allowedRoles: {StRole.customer},
    create: (b) => MockQuoteRepository(
        behavior: b,
        credits: MockCreditRepository(behavior: MockBehavior.instant()),
        subscriptions:
            MockSubscriptionRepository(behavior: MockBehavior.instant())),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'createQuote',
          isCommand: true,
          call: (r, a, id) =>
              (r as MockQuoteRepository).createQuote(a, id, draftId: 'DR-404')),
      CatalogueMethod(
          name: 'quote',
          isCommand: false,
          call: (r, a, id) => (r as MockQuoteRepository).quote(a, 'Q-CART-1')),
      CatalogueMethod(
          name: 'confirmQuote',
          isCommand: true,
          call: (r, a, id) => (r as MockQuoteRepository)
              .confirmQuote(a, id, quoteId: 'Q-CART-1')),
      CatalogueMethod(
          name: 'priceExplanation',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockQuoteRepository).priceExplanation(a, 'Q-CART-1')),
    ],
  ),
  CatalogueEntry(
    repository: 'ScheduleRepository',
    allowedRoles: {StRole.customer},
    create: (b) => MockScheduleRepository(
        behavior: b,
        credits: MockCreditRepository(behavior: MockBehavior.instant())),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'month',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockScheduleRepository).month(a, period: '2026-11')),
      CatalogueMethod(
          name: 'obligation',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockScheduleRepository).obligation(a, 'OB-20261110')),
      CatalogueMethod(
          name: 'replacementOptions',
          isCommand: false,
          call: (r, a, id) => (r as MockScheduleRepository)
              .replacementOptions(a, 'OB-20261110')),
      CatalogueMethod(
          name: 'previewChange',
          isCommand: false,
          call: (r, a, id) => (r as MockScheduleRepository).previewChange(a,
              obligationId: 'OB-20261110', kind: ScheduleChangeKind.skip)),
      CatalogueMethod(
          name: 'skipMeals',
          isCommand: true,
          call: (r, a, id) => (r as MockScheduleRepository)
              .skipMeals(a, id, obligationId: 'OB-20261110')),
      CatalogueMethod(
          name: 'confirmScheduleChange',
          isCommand: true,
          call: (r, a, id) => (r as MockScheduleRepository)
              .confirmScheduleChange(a, id,
                  obligationId: 'OB-20261110', newMenuItemId: 'rk-khichuri')),
    ],
  ),
  CatalogueEntry(
    repository: 'CreditRepository',
    allowedRoles: {StRole.customer},
    create: (b) => MockCreditRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'account',
          isCommand: false,
          call: (r, a, id) => (r as MockCreditRepository).account(a)),
      CatalogueMethod(
          name: 'transactions',
          isCommand: false,
          call: (r, a, id) => (r as MockCreditRepository).transactions(a)),
      CatalogueMethod(
          name: 'reservedFor',
          isCommand: false,
          call: (r, a, id) =>
              (r as MockCreditRepository).reservedFor(a, 'Q-CART-1')),
      CatalogueMethod(
          name: 'reserveCredit',
          isCommand: true,
          call: (r, a, id) => (r as MockCreditRepository)
              .reserveCredit(a, id, quoteId: 'Q-CART-1', amountMinor: 5000)),
      CatalogueMethod(
          name: 'consumeCredit',
          isCommand: true,
          call: (r, a, id) => (r as MockCreditRepository)
              .consumeCredit(a, id, quoteId: 'Q-CART-1')),
      CatalogueMethod(
          name: 'releaseCredit',
          isCommand: true,
          call: (r, a, id) => (r as MockCreditRepository)
              .releaseCredit(a, id, quoteId: 'Q-CART-1')),
    ],
  ),
  CatalogueEntry(
    repository: 'BillingRepository',
    allowedRoles: {StRole.customer},
    create: (b) => MockBillingRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'invoices',
          isCommand: false,
          call: (r, a, id) => (r as MockBillingRepository)
              .invoices(a, BillingFrequency.weekly)),
      CatalogueMethod(
          name: 'prepaidLiability',
          isCommand: false,
          call: (r, a, id) => (r as MockBillingRepository).prepaidLiability(a)),
      CatalogueMethod(
          name: 'payInstalment',
          isCommand: true,
          call: (r, a, id) => (r as MockBillingRepository)
              .payInstalment(a, id, invoiceId: 'INV-W-45')),
    ],
  ),
  CatalogueEntry(
    repository: 'CheckoutRepository',
    allowedRoles: {StRole.customer},
    create: (b) => MockCheckoutRepository(
        behavior: b,
        quotes: MockQuoteRepository(behavior: MockBehavior.instant())),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'summary',
          isCommand: false,
          call: (r, a, id) => (r as MockCheckoutRepository).summary(a)),
      CatalogueMethod(
          name: 'codEligibility',
          isCommand: false,
          call: (r, a, id) => (r as MockCheckoutRepository).codEligibility(a)),
      CatalogueMethod(
          name: 'placeOneTimeOrder',
          isCommand: true,
          call: (r, a, id) => (r as MockCheckoutRepository).placeOneTimeOrder(
              a, id,
              quoteId: 'Q-CART-1', payment: PaymentChoice.cod)),
    ],
  ),
  CatalogueEntry(
    repository: 'RefundRepository',
    allowedRoles: {StRole.customer},
    create: (b) => MockRefundRepository(behavior: b),
    observe: _revision,
    methods: [
      CatalogueMethod(
          name: 'refunds',
          isCommand: false,
          call: (r, a, id) => (r as MockRefundRepository).refunds(a)),
      CatalogueMethod(
          name: 'refund',
          isCommand: false,
          call: (r, a, id) => (r as MockRefundRepository).refund(a, 'RF-21')),
    ],
  ),
  // Later batches append entries above this line.
];

/// Committed state changes of a mock (changes only when a command commits).
Future<Object?> _revision(Object repo) async =>
    (repo as MockRepositoryBase).revision;
