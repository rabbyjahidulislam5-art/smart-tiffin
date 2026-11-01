import 'package:st_domain/st_domain.dart';

import '../repo_check.dart';

/// The demo accounting actor (`FinanceStaff.me`).
const accountingActor = Actor(StRole.accounting, id: 'demo-accounting');
const financeAdminActor = Actor(StRole.admin, id: 'demo-admin');

MockBehavior _instant() => MockBehavior.instant();

final paymentReconciliationChecks = <RepoCheck>[
  (
    name:
        'payment recon: matches, exceptions and statements read the mock data',
    run: () async {
      final repo = MockPaymentReconciliationRepository(behavior: _instant());
      final m = (await repo.matches(accountingActor)).valueOrNull;
      final e = (await repo.exceptions(accountingActor)).valueOrNull;
      final s = (await repo.statements(accountingActor)).valueOrNull;
      return m?.length == 5 && e?.length == 3 && s?.length == 2;
    },
  ),
  (
    name:
        'payment recon: a reconciled statement is read back with its evidence',
    run: () async {
      final repo = MockPaymentReconciliationRepository(behavior: _instant());
      final r = await repo.reconcileGatewayStatement(
          accountingActor, RequestId.next('t'),
          statementId: 'ST-2026-10-B', evidenceRef: 'EV-1201');
      final s = (await repo.statements(accountingActor))
          .valueOrNull
          ?.firstWhere((x) => x.id == 'ST-2026-10-B');
      return r.isOk &&
          s?.status == StatementStatus.reconciled &&
          s?.evidenceRef == 'EV-1201';
    },
  ),
  (
    name:
        'payment recon: a bulk assignment is read back; an empty selection is invalid',
    run: () async {
      final repo = MockPaymentReconciliationRepository(behavior: _instant());
      final empty = await repo.assignException(
          accountingActor, RequestId.next('t'),
          exceptionIds: const [], assignee: 'Rahim');
      final ok = await repo.assignException(
          accountingActor, RequestId.next('t'),
          exceptionIds: const ['EXC-31', 'EXC-32'], assignee: 'Sadia');
      final list =
          (await repo.exceptions(accountingActor)).valueOrNull ?? const [];
      return empty.errorOrNull?.field == 'selection' &&
          ok.isOk &&
          list.where((x) => x.assignedTo == 'Sadia').length == 2;
    },
  ),
  (
    name: 'payment recon: admin is refused',
    run: () async =>
        (await MockPaymentReconciliationRepository(behavior: _instant())
                .matches(financeAdminActor))
            .errorOrNull
            ?.kind ==
        RepoErrorKind.permissionDenied,
  ),
];

final codVerificationChecks = <RepoCheck>[
  (
    name:
        'cod verification: a matching reference verifies once; a second verification is refused',
    run: () async {
      final repo = MockCodVerificationRepository(behavior: _instant());
      final ok = await repo.verifyCodRemittance(
          accountingActor, RequestId.next('t'),
          remittanceId: 'RM-66', depositReference: 'DEP-55188', accept: true);
      final again = await repo.verifyCodRemittance(
          accountingActor, RequestId.next('t'),
          remittanceId: 'RM-66', depositReference: 'DEP-55188', accept: true);
      final c = (await repo.remittance(accountingActor, 'RM-66')).valueOrNull;
      return ok.isOk &&
          c?.status == VerificationStatus.verified &&
          again.errorOrNull?.kind == RepoErrorKind.businessRuleRejected;
    },
  ),
  (
    name: 'cod verification: a wrong reference is invalid and changes nothing',
    run: () async {
      final repo = MockCodVerificationRepository(behavior: _instant());
      final r = await repo.verifyCodRemittance(
          accountingActor, RequestId.next('t'),
          remittanceId: 'RM-64', depositReference: 'XX-1', accept: true);
      return r.errorOrNull?.field == 'reference' && repo.revision == 0;
    },
  ),
  (
    name: 'cod verification: custody rows read the mock data',
    run: () async =>
        (await MockCodVerificationRepository(behavior: _instant())
                .custody(accountingActor))
            .valueOrNull
            ?.length ==
        3,
  ),
];

final settlementLedgerChecks = <RepoCheck>[
  (
    name: 'settlement: a hold is placed, read back and released',
    run: () async {
      final repo = MockSettlementLedgerRepository(behavior: _instant());
      final place = await repo.placeHold(accountingActor, RequestId.next('t'),
          partyId: 'maas-kitchen', reason: 'Hygiene review');
      final held = (await repo.supplierPayables(accountingActor))
          .valueOrNull
          ?.firstWhere((x) => x.partyId == 'maas-kitchen');
      final release = await repo.releaseHold(
          accountingActor, RequestId.next('t'),
          partyId: 'maas-kitchen', reason: 'Review passed');
      final after = (await repo.supplierPayables(accountingActor))
          .valueOrNull
          ?.firstWhere((x) => x.partyId == 'maas-kitchen');
      return place.isOk &&
          (held?.onHold ?? false) &&
          release.isOk &&
          !(after?.onHold ?? true);
    },
  ),
  (
    name:
        'settlement: rider rows keep the COD liability separate from the eligible amount',
    run: () async {
      final rows = (await MockSettlementLedgerRepository(behavior: _instant())
                  .riderPayables(accountingActor))
              .valueOrNull ??
          const [];
      final rokon = rows.firstWhere((r) => r.partyId == 'rider-rokon');
      return rokon.codLiabilityMinor == 54000 &&
          rokon.eligibleMinor ==
              rokon.recognisedMinor -
                  rokon.deductionsMinor -
                  rokon.heldMinor -
                  rokon.disputedMinor;
    },
  ),
];

final payoutOperationsChecks = <RepoCheck>[
  (
    name:
        'payout ops: approve, batch and release by another approver, then record the result',
    run: () async {
      final repo = MockPayoutOperationsRepository(behavior: _instant());
      final review = await repo
          .reviewPayout(accountingActor, RequestId.next('t'), caseId: 'PO-311');
      final batch = await repo.createPayoutBatch(
          accountingActor, RequestId.next('t'),
          caseIds: const ['PO-311']);
      final selfRelease = await repo.releasePayoutBatch(
          accountingActor, RequestId.next('t'),
          batchId: batch.valueOrNull?.id ?? '');
      final otherRelease = await repo.releasePayoutBatch(
          accountingActor, RequestId.next('t'),
          batchId: 'PB-21');
      final result = await repo.recordPayoutResult(
          accountingActor, RequestId.next('t'),
          batchId: 'PB-21', settled: true, reference: 'BK-88001');
      final pb21 = (await repo.batches(accountingActor))
          .valueOrNull
          ?.firstWhere((b) => b.id == 'PB-21');
      return review.isOk &&
          batch.isOk &&
          selfRelease.errorOrNull?.field == 'approver' &&
          otherRelease.isOk &&
          result.isOk &&
          pb21?.status == BatchStatus.settled;
    },
  ),
  (
    name: 'payout ops: an ineligible or unverified request cannot be approved',
    run: () async {
      final repo = MockPayoutOperationsRepository(behavior: _instant());
      final r = await repo.reviewPayout(accountingActor, RequestId.next('t'),
          caseId: 'PO-314');
      return r.errorOrNull?.field == 'eligibility' && repo.revision == 0;
    },
  ),
  (
    name: 'payout ops: admin has no payout authority',
    run: () async =>
        (await MockPayoutOperationsRepository(behavior: _instant())
                .reviewPayout(financeAdminActor, RequestId.next('t'),
                    caseId: 'PO-311'))
            .errorOrNull
            ?.kind ==
        RepoErrorKind.permissionDenied,
  ),
];

final creditAndRefundChecks = <RepoCheck>[
  (
    name: 'credit and refund: a void is a separate movement read back',
    run: () async {
      final repo = MockCreditAndRefundRepository(behavior: _instant());
      final r = await repo.voidCredit(accountingActor, RequestId.next('t'),
          rowId: 'CL-95', reason: 'Issued twice');
      final rows =
          (await repo.liability(accountingActor)).valueOrNull ?? const [];
      return r.isOk &&
          rows.any((x) => x.movement == CreditMovement.voided) &&
          rows.any((x) => x.id == 'CL-95');
    },
  ),
  (
    name:
        'credit and refund: a refund is blocked when a credit was issued (INV-17)',
    run: () async {
      final repo = MockCreditAndRefundRepository(behavior: _instant());
      final r = await repo.initiateRefund(accountingActor, RequestId.next('t'),
          caseId: 'RF-22');
      return r.errorOrNull?.field == 'credit' && repo.revision == 0;
    },
  ),
  (
    name: 'credit and refund: initiate then record an executed refund',
    run: () async {
      final repo = MockCreditAndRefundRepository(behavior: _instant());
      final a = await repo.initiateRefund(accountingActor, RequestId.next('t'),
          caseId: 'RF-21');
      final b = await repo.recordRefundResult(
          accountingActor, RequestId.next('t'),
          caseId: 'RF-21', executed: true, providerRef: 'SSL-R-4500');
      final c = (await repo.cases(accountingActor))
          .valueOrNull
          ?.firstWhere((x) => x.id == 'RF-21');
      return a.isOk && b.isOk && c?.status == RefundOpsStatus.executed;
    },
  ),
];

final ledgerChecks = <RepoCheck>[
  (
    name: 'ledger: journals are balanced and paged',
    run: () async {
      final repo = MockLedgerRepository(behavior: _instant());
      final page = (await repo.journals(accountingActor)).valueOrNull;
      return page != null &&
          page.items.length == MockLedgerRepository.pageSize &&
          !page.atEnd &&
          page.items.every((j) => j.balanced);
    },
  ),
  (
    name:
        'ledger: a reversal posts a new entry and marks the original reversed',
    run: () async {
      final repo = MockLedgerRepository(behavior: _instant());
      final r = await repo.reverseJournal(accountingActor, RequestId.next('t'),
          journalId: 'JE-9012', reason: 'Posted to the wrong period');
      final first =
          (await repo.journals(accountingActor)).valueOrNull?.items.first;
      return r.isOk && first?.reversalOf == 'JE-9012';
    },
  ),
  (
    name:
        'ledger: close is refused until the checklist is complete; a ready period closes',
    run: () async {
      final repo = MockLedgerRepository(behavior: _instant());
      final notReady = await repo.closePeriod(
          accountingActor, RequestId.next('t'),
          periodId: '2026-11');
      final ready = await repo.closePeriod(accountingActor, RequestId.next('t'),
          periodId: '2026-10');
      final p = (await repo.periods(accountingActor))
          .valueOrNull
          ?.firstWhere((x) => x.id == '2026-10');
      return notReady.errorOrNull?.field == 'checklist' &&
          ready.isOk &&
          p?.status == PeriodStatus.closed;
    },
  ),
];

final staffRoleChecks = <RepoCheck>[
  (
    name: 'staff roles: a grant is read back; a non-staff email is invalid',
    run: () async {
      final repo = MockStaffRoleRepository(behavior: _instant());
      final bad = await repo.grantStaffRole(
          accountingActor, RequestId.next('t'),
          email: 'x@gmail.com', subRole: FinanceSubRole.financeViewer);
      final ok = await repo.grantStaffRole(accountingActor, RequestId.next('t'),
          email: 'mim@smarttiffin.bd',
          subRole: FinanceSubRole.financialAuditor);
      final list = (await repo.staff(accountingActor)).valueOrNull ?? const [];
      return bad.errorOrNull?.field == 'email' &&
          ok.isOk &&
          list.any((g) => g.email == 'mim@smarttiffin.bd');
    },
  ),
  (
    name: 'staff roles: you cannot revoke your own role',
    run: () async {
      final repo = MockStaffRoleRepository(behavior: _instant());
      final r = await repo.revokeStaffRole(accountingActor, RequestId.next('t'),
          staffId: 'demo-accounting', reason: 'Testing self');
      return r.errorOrNull?.field == 'staff' && repo.revision == 0;
    },
  ),
];

final adjustmentChecks = <RepoCheck>[
  (
    name: 'adjustments: a request is read back; the maker cannot approve it',
    run: () async {
      final repo = MockAdjustmentRepository(behavior: _instant());
      final r = await repo.requestAdjustment(
          accountingActor, RequestId.next('t'),
          description: 'Correct rounding on TK-901',
          amountMinor: -500,
          evidenceRef: 'EV-2001');
      final self = await repo.approveAdjustment(
          accountingActor, RequestId.next('t'),
          adjustmentId: r.valueOrNull?.id ?? '', approve: true);
      return r.isOk && self.errorOrNull?.field == 'checker';
    },
  ),
  (
    name: 'adjustments: a request by another maker is approved',
    run: () async {
      final repo = MockAdjustmentRepository(behavior: _instant());
      final r = await repo.approveAdjustment(
          accountingActor, RequestId.next('t'),
          adjustmentId: 'ADJ-14', approve: true);
      final a = (await repo.adjustments(accountingActor))
          .valueOrNull
          ?.firstWhere((x) => x.id == 'ADJ-14');
      return r.isOk &&
          a?.status == AdjustmentStatus.approved &&
          a?.checker == 'demo-accounting';
    },
  ),
];
