import '../../text/st_text.dart';
import 'quote.dart';
import 'renewal_status.dart';

/// A renewal offer: explicit accept or decline, never an automatic renewal.
class RenewalOffer {
  const RenewalOffer({
    required this.id,
    required this.subscriptionId,
    required this.term,
    required this.changes,
    required this.quote,
    required this.expiresAt,
    required this.status,
  });

  final String id;
  final String subscriptionId;
  final StText term;
  final List<StText> changes;
  final Quote quote;
  final String expiresAt;
  final RenewalStatus status;

  RenewalOffer withStatus(RenewalStatus s) =>
      RenewalOffer(id: id, subscriptionId: subscriptionId, term: term, changes: changes, quote: quote, expiresAt: expiresAt, status: s);
}
