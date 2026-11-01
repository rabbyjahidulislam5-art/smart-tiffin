import 'package:flutter/widgets.dart';

import '../features/partner_handoff/widgets/partner_handoff_sheet.dart';

/// AU-09, AU-10 and AU-11 live in the Partner app: the Customer app shows the
/// hand-off sheet instead of a route (CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md 2.3).
Widget? customerHandoffFor(String id) => switch (id) {
      'AU-09' => const PartnerHandoffSheet(supplier: true),
      'AU-10' || 'AU-11' => const PartnerHandoffSheet(supplier: false),
      _ => null,
    };
