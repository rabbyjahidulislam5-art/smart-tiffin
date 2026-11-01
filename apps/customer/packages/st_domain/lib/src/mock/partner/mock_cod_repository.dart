import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/partner/cod_collection.dart';
import '../../models/partner/cod_discrepancy.dart';
import '../../models/partner/cod_remittance.dart';
import '../../models/partner/cod_status.dart';
import '../../models/partner/discrepancy_status.dart';
import '../../models/partner/remittance_status.dart';
import '../../repositories/partner/cod_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../validation/amount.dart';
import '../mock_behavior.dart';
import '../mock_clock.dart';
import '../mock_repository_base.dart';

/// COD custody of rider Rokon (sample).
class MockCodRepository extends MockRepositoryBase implements CodRepository {
  MockCodRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.rider};

  final List<CodCollection> _collections = [
    const CodCollection(id: 'COD-913', orderRef: 'TK-913', customerRef: 'Arif · Dhanmondi 27', expectedMinor: 24000, status: CodStatus.toCollect),
    const CodCollection(id: 'COD-908', orderRef: 'TK-908', customerRef: 'Rumana · Banani', expectedMinor: 36000, status: CodStatus.collected, collectedMinor: 36000),
    const CodCollection(id: 'COD-902', orderRef: 'TK-902', customerRef: 'Habib · Gulshan 1', expectedMinor: 18000, status: CodStatus.collected, collectedMinor: 18000),
  ];

  final List<CodRemittance> _remittances = [
    const CodRemittance(id: 'RM-61', amountMinor: 60000, reference: 'DEP-55120', method: 'Bank deposit', submittedOn: '2026-10-30', status: RemittanceStatus.verified),
    const CodRemittance(id: 'RM-64', amountMinor: 54000, reference: 'BK-90214', method: 'bKash transfer', submittedOn: '2026-11-01', status: RemittanceStatus.submitted),
  ];

  final List<CodDiscrepancy> _discrepancies = [
    const CodDiscrepancy(id: 'DS-12', remittanceId: 'RM-64', expectedMinor: 60000, declaredMinor: 54000, status: DiscrepancyStatus.open),
  ];

  /// Collected cash not yet covered by a remittance.
  int _liability = 54000;
  int _seq = 70;

  @override
  Future<RepoResult<List<CodCollection>>> collections(Actor actor) => guardRead(actor, roles, 'collections', () => Ok(List.unmodifiable(_collections)));

  @override
  Future<RepoResult<int>> liability(Actor actor) => guardRead(actor, roles, 'liability', () => Ok(_liability));

  @override
  Future<RepoResult<CodCollection>> recordCodCollection(Actor actor, RequestId requestId, {required String collectionId, required int amountMinor}) =>
      guardCommand(actor, roles, 'recordCodCollection', requestId, () {
        final i = _collections.indexWhere((c) => c.id == collectionId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (amountMinor < minAmountMinor || amountMinor > maxAmountMinor) return MockRepositoryBase.invalid('amount');
        if (_collections[i].status != CodStatus.toCollect) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        final done = _collections[i].collect(amountMinor);
        _collections[i] = done;
        _liability += amountMinor;
        return Ok(done);
      });

  @override
  Future<RepoResult<List<CodRemittance>>> remittances(Actor actor) => guardRead(actor, roles, 'remittances', () => Ok(List.unmodifiable(_remittances)));

  @override
  Future<RepoResult<CodRemittance>> submitCodRemittance(Actor actor, RequestId requestId,
          {required int amountMinor, required String reference, required String method}) =>
      guardCommand(actor, roles, 'submitCodRemittance', requestId, () {
        if (amountMinor < minAmountMinor || amountMinor > maxAmountMinor) return MockRepositoryBase.invalid('amount');
        if (amountMinor > _liability) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'amount'));
        final ref = reference.trim();
        if (ref.length < 4) return MockRepositoryBase.invalid('reference');
        if (_remittances.any((r) => r.reference.toLowerCase() == ref.toLowerCase())) {
          return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'reference'));
        }
        final partial = amountMinor < _liability;
        final r = CodRemittance(
          id: 'RM-${++_seq}',
          amountMinor: amountMinor,
          reference: ref,
          method: method,
          submittedOn: mockToday,
          status: partial ? RemittanceStatus.partial : RemittanceStatus.submitted,
        );
        _remittances.insert(0, r);
        _liability -= amountMinor;
        return Ok(r);
      });

  @override
  Future<RepoResult<List<CodDiscrepancy>>> discrepancies(Actor actor) => guardRead(actor, roles, 'discrepancies', () => Ok(List.unmodifiable(_discrepancies)));

  @override
  Future<RepoResult<CodDiscrepancy>> respondToDiscrepancy(Actor actor, RequestId requestId, {required String discrepancyId, required String response}) =>
      guardCommand(actor, roles, 'respondToDiscrepancy', requestId, () {
        final i = _discrepancies.indexWhere((d) => d.id == discrepancyId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        if (_discrepancies[i].status != DiscrepancyStatus.open) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (response.trim().length < 10) return MockRepositoryBase.invalid('response');
        final d = _discrepancies[i];
        final next = CodDiscrepancy(
          id: d.id,
          remittanceId: d.remittanceId,
          expectedMinor: d.expectedMinor,
          declaredMinor: d.declaredMinor,
          status: DiscrepancyStatus.responded,
          riderResponse: response.trim(),
        );
        _discrepancies[i] = next;
        return Ok(next);
      });
}
