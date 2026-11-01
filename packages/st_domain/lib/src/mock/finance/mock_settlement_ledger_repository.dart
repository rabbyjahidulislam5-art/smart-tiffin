import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/finance/payable_row.dart';
import '../../repositories/finance/settlement_ledger_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';

/// Payable ledgers. Placing a hold moves the eligible amount into held;
/// releasing it moves it back. A recognised figure is never edited.
class MockSettlementLedgerRepository extends MockRepositoryBase implements SettlementLedgerRepository {
  MockSettlementLedgerRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.accounting};

  final List<PayableRow> _suppliers = [
    const PayableRow(partyId: 'rinas-kitchen', partyName: "Rina's Kitchen", recognisedMinor: 2412000, deductionsMinor: 361800, heldMinor: 0, disputedMinor: 20000),
    const PayableRow(partyId: 'maas-kitchen', partyName: "Maa's Kitchen", recognisedMinor: 1830000, deductionsMinor: 274500, heldMinor: 0, disputedMinor: 0),
    const PayableRow(partyId: 'dhaka-tiffin', partyName: 'Dhaka Tiffin Co.', recognisedMinor: 960000, deductionsMinor: 144000, heldMinor: 816000, disputedMinor: 0, holdReason: 'Hygiene certificate expired (SC-17)'),
  ];

  final List<PayableRow> _riders = [
    const PayableRow(partyId: 'rider-rokon', partyName: 'Rokon', recognisedMinor: 426000, deductionsMinor: 0, heldMinor: 0, disputedMinor: 7000, codLiabilityMinor: 54000),
    const PayableRow(partyId: 'rider-sabbir', partyName: 'Sabbir Hasan', recognisedMinor: 318000, deductionsMinor: 0, heldMinor: 0, disputedMinor: 0, codLiabilityMinor: 72000),
    const PayableRow(partyId: 'rider-mitu', partyName: 'Mitu Akter', recognisedMinor: 204000, deductionsMinor: 0, heldMinor: 0, disputedMinor: 0, codLiabilityMinor: 0),
  ];

  @override
  Future<RepoResult<List<PayableRow>>> supplierPayables(Actor actor) => guardRead(actor, roles, 'supplierPayables', () => Ok(List.unmodifiable(_suppliers)));

  @override
  Future<RepoResult<List<PayableRow>>> riderPayables(Actor actor) => guardRead(actor, roles, 'riderPayables', () => Ok(List.unmodifiable(_riders)));

  (List<PayableRow>, int)? _find(String partyId) {
    for (final list in [_suppliers, _riders]) {
      final i = list.indexWhere((r) => r.partyId == partyId);
      if (i >= 0) return (list, i);
    }
    return null;
  }

  @override
  Future<RepoResult<PayableRow>> placeHold(Actor actor, RequestId requestId, {required String partyId, required String reason}) =>
      guardCommand(actor, roles, 'placeHold', requestId, () {
        final found = _find(partyId);
        if (found == null) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final (list, i) = found;
        final row = list[i];
        if (row.onHold) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (reason.trim().length < 5) return MockRepositoryBase.invalid('reason');
        final next = row.withHold(heldMinor: row.heldMinor + row.eligibleMinor, holdReason: reason.trim());
        list[i] = next;
        return Ok(next);
      });

  @override
  Future<RepoResult<PayableRow>> releaseHold(Actor actor, RequestId requestId, {required String partyId, required String reason}) =>
      guardCommand(actor, roles, 'releaseHold', requestId, () {
        final found = _find(partyId);
        if (found == null) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final (list, i) = found;
        final row = list[i];
        if (!row.onHold) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (reason.trim().length < 5) return MockRepositoryBase.invalid('reason');
        final next = row.withHold(heldMinor: 0);
        list[i] = next;
        return Ok(next);
      });
}
