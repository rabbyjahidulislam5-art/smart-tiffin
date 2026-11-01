import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/admin/application_case.dart';
import '../../models/admin/application_decision.dart';
import '../../models/admin/application_kind.dart';
import '../../models/admin/application_status.dart';
import '../../repositories/admin/application_review_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../catalogue/catalogue_fixtures.dart';
import '../mock_behavior.dart';
import '../mock_repository_base.dart';

/// Application review built from the legacy applicant fixtures.
class MockApplicationReviewRepository extends MockRepositoryBase implements ApplicationReviewRepository {
  MockApplicationReviewRepository({MockBehavior? behavior}) : super(behavior);

  static const roles = {StRole.admin};

  late final List<ApplicationCase> _cases = [
    for (final a in applicants)
      ApplicationCase(
        id: a.id,
        kind: a.kind == 'Rider' ? ApplicationKind.rider : ApplicationKind.cook,
        name: a.name,
        owner: a.owner,
        area: a.area,
        submittedAgo: a.ago,
        status: ApplicationStatus.pending,
        checklist: {
          'identity': a.docs['nid'] == 'Verified',
          'premises': a.docs['kitchen'] == 'Checked' || a.docs['kitchen'] == 'License OK' || a.docs['kitchen'] == 'Not required',
          'compliance': a.docs['hygiene'] == 'Pass',
        },
      ),
  ];

  @override
  Future<RepoResult<List<ApplicationCase>>> queue(Actor actor, {ApplicationStatus? status}) =>
      guardRead(actor, roles, 'queue', () => Ok([for (final c in _cases) if (status == null || c.status == status) c]));

  @override
  Future<RepoResult<ApplicationCase>> application(Actor actor, String id) => guardRead(actor, roles, 'application', () {
        for (final c in _cases) {
          if (c.id == id) return Ok(c);
        }
        return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
      });

  @override
  Future<RepoResult<ApplicationCase>> decideApplication(Actor actor, RequestId requestId,
          {required String id, required ApplicationDecision decision, required Map<String, bool> checklist, String reason = ''}) =>
      guardCommand(actor, roles, 'decideApplication', requestId, () {
        final i = _cases.indexWhere((c) => c.id == id);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final current = _cases[i];
        if (current.status == ApplicationStatus.approved || current.status == ApplicationStatus.rejected) {
          return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        }
        final merged = {...current.checklist, ...checklist};
        final ApplicationStatus next;
        switch (decision) {
          case ApplicationDecision.approve:
            if (!merged.values.every((v) => v)) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'checklist'));
            next = ApplicationStatus.approved;
          case ApplicationDecision.requestInfo:
            if (reason.trim().length < 10) return MockRepositoryBase.invalid('reason');
            next = ApplicationStatus.infoRequested;
          case ApplicationDecision.reject:
            if (reason.trim().length < 10) return MockRepositoryBase.invalid('reason');
            next = ApplicationStatus.rejected;
        }
        final updated = current.copyWith(status: next, checklist: merged, reason: reason.trim().isEmpty ? null : reason.trim());
        _cases[i] = updated;
        return Ok(updated);
      });
}
