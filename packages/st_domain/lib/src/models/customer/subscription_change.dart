import '../../text/st_text.dart';
import 'subscription_change_kind.dart';

/// One confirmed change of a subscription (NC-15), read-only.
class SubscriptionChange {
  const SubscriptionChange({
    required this.id,
    required this.at,
    required this.kind,
    required this.actor,
    required this.summary,
    this.before,
    this.after,
    this.adjustmentRef,
  });

  final String id;
  final String at;
  final SubscriptionChangeKind kind;
  final String actor;
  final StText summary;
  final String? before;
  final String? after;
  final String? adjustmentRef;
}
