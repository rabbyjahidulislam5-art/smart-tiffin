import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/finance/cod_custody_row.dart';
import '../../models/finance/cod_remittance_case.dart';
import '../../models/finance/verification_status.dart';
import '../../repositories/finance/cod_verification_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';
import 'finance_staff.dart';

class MockCodVerificationRepository extends MockRepositoryBase implements CodVerificationRepository {
  MockCodVerificationRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.accounting};

  static const custodyFixtures = <CodCustodyRow>[
    CodCustodyRow(riderId: 'rider-rokon', riderName: 'Rokon', date: '2026-11-01', heldMinor: 114000, remittedMinor: 54000, overdue: false),
    CodCustodyRow(riderId: 'rider-sabbir', riderName: 'Sabbir Hasan', date: '2026-10-30', heldMinor: 72000, remittedMinor: 0, overdue: true),
    CodCustodyRow(riderId: 'rider-mitu', riderName: 'Mitu Akter', date: '2026-11-01', heldMinor: 36000, remittedMinor: 36000, overdue: false),
  ];

  final List<CodRemittanceCase> _cases = [
    const CodRemittanceCase(id: 'RM-64', riderName: 'Rokon', reference: 'BK-90214', method: 'bKash transfer', declaredMinor: 54000, expectedMinor: 60000, status: VerificationStatus.pending),
    const CodRemittanceCase(id: 'RM-66', riderName: 'Mitu Akter', reference: 'DEP-55188', method: 'Bank deposit', declaredMinor: 36000, expectedMinor: 36000, status: VerificationStatus.pending),
    const CodRemittanceCase(id: 'RM-61', riderName: 'Rokon', reference: 'DEP-55120', method: 'Bank deposit', declaredMinor: 60000, expectedMinor: 60000, status: VerificationStatus.verified, verifiedBy: 'Rahim'),
  ];

  @override
  Future<RepoResult<List<CodCustodyRow>>> custody(Actor actor) => guardRead(actor, roles, 'custody', () => const Ok(custodyFixtures));

  @override
  Future<RepoResult<List<CodRemittanceCase>>> remittances(Actor actor) => guardRead(actor, roles, 'remittances', () => Ok(List.unmodifiable(_cases)));

  @override
  Future<RepoResult<CodRemittanceCase>> remittance(Actor actor, String id) => guardRead(actor, roles, 'remittance', () {
        for (final c in _cases) {
          if (c.id == id) return Ok(c);
        }
        return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
      });

  @override
  Future<RepoResult<CodRemittanceCase>> verifyCodRemittance(Actor actor, RequestId requestId,
          {required String remittanceId, required String depositReference, required bool accept}) =>
      guardCommand(actor, roles, 'verifyCodRemittance', requestId, () {
        final i = _cases.indexWhere((c) => c.id == remittanceId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final c = _cases[i];
        if (c.status != VerificationStatus.pending) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (accept && depositReference.trim().toLowerCase() != c.reference.toLowerCase()) return MockRepositoryBase.invalid('reference');
        final next = CodRemittanceCase(
          id: c.id,
          riderName: c.riderName,
          reference: c.reference,
          method: c.method,
          declaredMinor: c.declaredMinor,
          expectedMinor: c.expectedMinor,
          status: accept ? VerificationStatus.verified : VerificationStatus.rejected,
          verifiedBy: FinanceStaff.nameOf(actor.id ?? ''),
        );
        _cases[i] = next;
        return Ok(next);
      });
}
