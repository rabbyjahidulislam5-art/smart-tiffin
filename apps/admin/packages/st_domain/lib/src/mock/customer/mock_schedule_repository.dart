import '../../access/actor.dart';
import '../../access/st_role.dart';
import '../../models/customer/meal_obligation.dart';
import '../../models/customer/menu_item.dart';
import '../../models/customer/obligation_status.dart';
import '../../models/customer/schedule_change_kind.dart';
import '../../models/customer/schedule_change_preview.dart';
import '../../repositories/customer/schedule_repository.dart';
import '../../result/repo_error.dart';
import '../../result/repo_result.dart';
import '../../result/request_id.dart';
import '../../result/slot.dart';
import '../mock_behavior.dart';
import '../mock_clock.dart';
import '../mock_repository_base.dart';
import 'customer_fixtures.dart';
import 'mock_credit_repository.dart';

/// Meal obligations of SUB-301 (lunch, Monday to Saturday, Rina's Kitchen).
/// A skip issues one service credit per obligation (INV-08).
class MockScheduleRepository extends MockRepositoryBase implements ScheduleRepository {
  MockScheduleRepository({MockBehavior? behavior, this.credits}) : super(behavior) {
    for (final period in const ['2026-10', '2026-11']) {
      final days = period == '2026-10' ? 31 : 30;
      for (var d = 1; d <= days; d++) {
        final date = '$period-${d.toString().padLeft(2, '0')}';
        final weekday = DateTime.utc(int.parse(period.substring(0, 4)), int.parse(period.substring(5)), d).weekday;
        if (weekday == DateTime.sunday) continue;
        final item = d.isEven ? 'rk-thali' : 'rk-khichuri';
        final m = menuItemById(item)!;
        final cmp = date.compareTo(mockToday);
        var status = cmp < 0 ? ObligationStatus.delivered : (cmp == 0 ? ObligationStatus.dispatched : ObligationStatus.scheduled);
        if (date == '2026-10-22' || date == '2026-10-23') status = ObligationStatus.credited;
        if (date == '2026-11-05') status = ObligationStatus.skipped;
        if (date == '2026-11-07') status = ObligationStatus.replaced;
        _obligations.add(MealObligation(
          id: 'OB-${date.replaceAll('-', '')}',
          date: date,
          slot: Slot.lunch,
          menuItemId: item,
          mealId: m.mealId,
          priceMinor: m.priceMinor,
          status: status,
          cutoffPassed: cmp <= 0,
        ));
      }
    }
  }

  final MockCreditRepository? credits;

  static const roles = {StRole.customer};

  final List<MealObligation> _obligations = [];

  int _index(String id) => _obligations.indexWhere((o) => o.id == id);

  @override
  Future<RepoResult<List<MealObligation>>> month(Actor actor, {required String period}) => guardRead(actor, roles, 'month', () {
        if (!RegExp(r'^\d{4}-\d{2}$').hasMatch(period)) return MockRepositoryBase.invalid('period');
        return Ok([for (final o in _obligations) if (o.date.startsWith(period)) o]);
      });

  @override
  Future<RepoResult<MealObligation>> obligation(Actor actor, String id) => guardRead(actor, roles, 'obligation', () {
        final i = _index(id);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        return Ok(_obligations[i]);
      });

  @override
  Future<RepoResult<List<MenuItem>>> replacementOptions(Actor actor, String obligationId) => guardRead(actor, roles, 'replacementOptions', () {
        final i = _index(obligationId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final o = _obligations[i];
        final current = menuItemById(o.menuItemId);
        return Ok([
          for (final m in menuItems)
            if (current != null && m.kitchenId == current.kitchenId && m.slot == o.slot && m.id != o.menuItemId) m,
        ]);
      });

  @override
  Future<RepoResult<ScheduleChangePreview>> previewChange(Actor actor, {required String obligationId, required ScheduleChangeKind kind, String? newMenuItemId}) =>
      guardRead(actor, roles, 'previewChange', () {
        final i = _index(obligationId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final o = _obligations[i];
        if (!o.changeable) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        if (kind == ScheduleChangeKind.skip) {
          return Ok(ScheduleChangePreview(obligationId: o.id, kind: kind, creditMinor: o.priceMinor, chargeMinor: 0));
        }
        final next = newMenuItemId == null ? null : menuItemById(newMenuItemId);
        if (next == null || !next.available) return MockRepositoryBase.invalid('menuItem');
        final diff = next.priceMinor - o.priceMinor;
        return Ok(ScheduleChangePreview(obligationId: o.id, kind: kind, creditMinor: diff < 0 ? -diff : 0, chargeMinor: diff > 0 ? diff : 0, newMenuItemId: next.id));
      });

  @override
  Future<RepoResult<MealObligation>> skipMeals(Actor actor, RequestId requestId, {required String obligationId}) =>
      guardCommand(actor, roles, 'skipMeals', requestId, () {
        final i = _index(obligationId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final o = _obligations[i];
        if (!o.changeable) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        final next = o.copyWith(status: ObligationStatus.skipped);
        _obligations[i] = next;
        credits?.issue(o.priceMinor, 'Skip · ${o.id}');
        return Ok(next);
      });

  @override
  Future<RepoResult<MealObligation>> confirmScheduleChange(Actor actor, RequestId requestId,
          {required String obligationId, required String newMenuItemId, bool paymentConfirmed = false}) =>
      guardCommand(actor, roles, 'confirmScheduleChange', requestId, () {
        final i = _index(obligationId);
        if (i < 0) return MockRepositoryBase.fail(RepoErrorKind.notAvailable);
        final o = _obligations[i];
        if (!o.changeable) return MockRepositoryBase.fail(RepoErrorKind.businessRuleRejected);
        final next = menuItemById(newMenuItemId);
        final current = menuItemById(o.menuItemId);
        if (next == null || !next.available || current == null || next.kitchenId != current.kitchenId || next.slot != o.slot) {
          return MockRepositoryBase.invalid('menuItem');
        }
        final diff = next.priceMinor - o.priceMinor;
        if (diff > 0 && !paymentConfirmed) return const Err(RepoError(RepoErrorKind.businessRuleRejected, field: 'payment'));
        final updated = o.copyWith(status: ObligationStatus.replaced, menuItemId: next.id, mealId: next.mealId, priceMinor: next.priceMinor);
        _obligations[i] = updated;
        if (diff < 0) credits?.issue(-diff, 'Replacement · ${o.id}');
        return Ok(updated);
      });
}
