import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/admin/policy_status.dart';
import '../../models/admin/policy_version.dart';
import '../../repositories/admin/policy_repository.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../mock_behavior.dart';
import '../mock_clock.dart';
import '../mock_repository_base.dart';

/// Policy keys Admin may configure (OPERATIONS_MANAGEMENT.md, NA-02). Every
/// value starts not configured: BR-001..026 are still pending.
class MockPolicyRepository extends MockRepositoryBase implements PolicyRepository {
  MockPolicyRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.admin};

  static const keys = <String, String>{
    'policy.cutoff.change': 'BR-022',
    'policy.delivery_fee.rules': 'BR-007',
    'policy.discount.rules': 'BR-008',
    'policy.zone.service_areas': 'BR-021',
  };

  final List<PolicyVersion> _versions = [
    for (final e in keys.entries)
      PolicyVersion(id: 'PV-${e.value}', key: e.key, rule: e.value, value: '', effectiveFrom: '', status: PolicyStatus.draft, author: 'System'),
  ];
  int _seq = 0;

  @override
  Future<RepoResult<List<PolicyVersion>>> versions(Actor actor) => guardRead(actor, roles, 'versions', () => Ok(List.unmodifiable(_versions)));

  @override
  Future<RepoResult<PolicyVersion>> publishPolicyVersion(Actor actor, RequestId requestId,
          {required String key, required String value, required String effectiveFrom}) =>
      guardCommand(actor, roles, 'publishPolicyVersion', requestId, () {
        if (!keys.containsKey(key)) return MockRepositoryBase.invalid('key');
        if (value.trim().length < 2) return MockRepositoryBase.invalid('value');
        if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(effectiveFrom) || effectiveFrom.compareTo(mockToday) <= 0) {
          return MockRepositoryBase.invalid('effectiveFrom');
        }
        for (var i = 0; i < _versions.length; i++) {
          final v = _versions[i];
          if (v.key == key && v.status == PolicyStatus.published) {
            _versions[i] = PolicyVersion(id: v.id, key: v.key, rule: v.rule, value: v.value, effectiveFrom: v.effectiveFrom, status: PolicyStatus.superseded, author: v.author);
          }
        }
        final next = PolicyVersion(id: 'PV-N${++_seq}', key: key, rule: keys[key]!, value: value.trim(), effectiveFrom: effectiveFrom, status: PolicyStatus.published, author: 'Nadia');
        _versions.insert(0, next);
        return Ok(next);
      });
}
