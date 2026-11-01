import '../../access/actor.dart';
import '../../models/customer/meal_obligation.dart';
import '../../models/customer/menu_item.dart';
import '../../models/customer/schedule_change_kind.dart';
import '../../models/customer/schedule_change_preview.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';

/// Purchased meals and their changes (NC-06, NC-09, NC-10).
abstract interface class ScheduleRepository {
  /// [period] is `YYYY-MM`.
  Future<RepoResult<List<MealObligation>>> month(Actor actor, {required String period});

  Future<RepoResult<MealObligation>> obligation(Actor actor, String id);

  Future<RepoResult<List<MenuItem>>> replacementOptions(Actor actor, String obligationId);

  Future<RepoResult<ScheduleChangePreview>> previewChange(Actor actor, {required String obligationId, required ScheduleChangeKind kind, String? newMenuItemId});

  Future<RepoResult<MealObligation>> skipMeals(Actor actor, RequestId requestId, {required String obligationId});

  Future<RepoResult<MealObligation>> confirmScheduleChange(
    Actor actor,
    RequestId requestId, {
    required String obligationId,
    required String newMenuItemId,
    bool paymentConfirmed = false,
  });
}
