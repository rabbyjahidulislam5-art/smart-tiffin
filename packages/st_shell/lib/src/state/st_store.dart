import 'package:st_domain/st_domain.dart';

import 'app_state.dart';

class StStore {
  const StStore({
    this.paused = false,
    this.online = true,
    this.onDuty = true,
    this.stock = const {'thali': true, 'khichuri': true, 'roti': false},
    this.accepted = const [],
    this.declined = const [],
    this.riderStep = 2,
    this.cart = 0,
    this.cartMeal = 'biryani',
    this.stage = 1,
    this.approved = const [],
    this.rejected = const [],
    this.readAll = false,
    this.readIds = const [],
    this.gps = true,
    this.submitted = const [],
    this.info = const {},
    this.reasons = const {},
    this.history = const {},
    this.myApp,
    this.reverify = const [],
  });

  final bool paused;
  final bool online;
  final bool onDuty;
  final Map<String, bool> stock;
  final List<String> accepted;
  final List<String> declined;
  final int riderStep;
  final int cart;
  final String cartMeal;
  final int stage;
  final List<String> approved;
  final List<String> rejected;
  final bool readAll;
  final List<String> readIds;
  final bool gps;
  final List<Applicant> submitted;
  final Map<String, String> info;
  final Map<String, String> reasons;
  final Map<String, List<String>> history;
  final String? myApp;
  final List<String> reverify;

  StStore copyWith({
    bool? paused,
    bool? online,
    bool? onDuty,
    Map<String, bool>? stock,
    List<String>? accepted,
    List<String>? declined,
    int? riderStep,
    int? cart,
    String? cartMeal,
    int? stage,
    List<String>? approved,
    List<String>? rejected,
    bool? readAll,
    List<String>? readIds,
    bool? gps,
    List<Applicant>? submitted,
    Map<String, String>? info,
    Map<String, String>? reasons,
    Map<String, List<String>>? history,
    String? myApp,
    bool clearMyApp = false,
    List<String>? reverify,
  }) {
    return StStore(
      paused: paused ?? this.paused,
      online: online ?? this.online,
      onDuty: onDuty ?? this.onDuty,
      stock: stock ?? this.stock,
      accepted: accepted ?? this.accepted,
      declined: declined ?? this.declined,
      riderStep: riderStep ?? this.riderStep,
      cart: cart ?? this.cart,
      cartMeal: cartMeal ?? this.cartMeal,
      stage: stage ?? this.stage,
      approved: approved ?? this.approved,
      rejected: rejected ?? this.rejected,
      readAll: readAll ?? this.readAll,
      readIds: readIds ?? this.readIds,
      gps: gps ?? this.gps,
      submitted: submitted ?? this.submitted,
      info: info ?? this.info,
      reasons: reasons ?? this.reasons,
      history: history ?? this.history,
      myApp: clearMyApp ? null : (myApp ?? this.myApp),
      reverify: reverify ?? this.reverify,
    );
  }
}

AppStatus appStatusOf(StStore s, String id) {
  if (s.approved.contains(id)) return AppStatus.approved;
  if (s.rejected.contains(id)) return AppStatus.rejected;
  if (s.info.containsKey(id)) return AppStatus.info;
  return AppStatus.pending;
}

List<Applicant> allApplicantsOf(StStore s) => [...s.submitted, ...applicants];

int unreadCountOf(StStore s, StRole role) {
  if (s.readAll) return 0;
  final prefix = role.name;
  // LC-12: counts the items SH-01 shows for the role (fixed 3 in the prototype).
  final total = stNotificationCountOf(role);
  return (total - s.readIds.where((x) => x.startsWith(prefix)).length).clamp(0, total);
}

/// Number of SH-01 notification items per role (keep in sync with SH-01).
int stNotificationCountOf(StRole role) => switch (role) {
      StRole.customer => 4,
      StRole.supplier => 4,
      StRole.rider => 4,
      StRole.admin => 2,
      StRole.accounting => 3,
    };
// end LC-12
