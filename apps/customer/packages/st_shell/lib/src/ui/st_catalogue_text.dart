import 'package:st_domain/st_domain.dart';

import '../state/app_state.dart';

/// Localized names of meal slots and catalogue meals, shared by the Partner
/// and Customer screens. Meal names come from the legacy `meals` fixtures.
abstract final class StCatalogueText {
  static const breakfast = StText('Breakfast', 'সকালের নাশতা');
  static const lunch = StText('Lunch', 'দুপুরের খাবার');
  static const snack = StText('Snack', 'বিকেলের নাশতা');
  static const dinner = StText('Dinner', 'রাতের খাবার');

  static StText slotText(Slot slot) => switch (slot) {
        Slot.breakfast => breakfast,
        Slot.lunch => lunch,
        Slot.snack => snack,
        Slot.dinner => dinner,
      };

  static String slot(AppState s, Slot slot) => s.tx(slotText(slot));

  /// The meal's localized name, or its id when the catalogue has no entry.
  static String meal(AppState s, String mealId) {
    for (final m in meals) {
      if (m.id == mealId) return s.t(m.en, m.bn);
    }
    return mealId;
  }
}
