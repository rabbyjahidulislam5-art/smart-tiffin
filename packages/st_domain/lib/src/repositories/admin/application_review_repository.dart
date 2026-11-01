import '../../access/actor.dart';
import '../../models/admin/application_case.dart';
import '../../models/admin/application_decision.dart';
import '../../models/admin/application_status.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Supplier and rider application review (NA-03), admin only.
abstract interface class ApplicationReviewRepository {
  Future<RepoResult<List<ApplicationCase>>> queue(Actor actor, {ApplicationStatus? status});

  Future<RepoResult<ApplicationCase>> application(Actor actor, String id);

  Future<RepoResult<ApplicationCase>> decideApplication(
    Actor actor,
    RequestId requestId, {
    required String id,
    required ApplicationDecision decision,
    required Map<String, bool> checklist,
    String reason = '',
  });
}
