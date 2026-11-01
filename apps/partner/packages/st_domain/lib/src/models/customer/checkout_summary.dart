import '../../result/slot.dart';
import 'cart_line.dart';
import 'quote.dart';

/// Server summary of a one-time checkout (NC-14).
class CheckoutSummary {
  const CheckoutSummary({required this.lines, required this.addressLabel, required this.zoneServed, required this.slot, required this.quote});

  final List<CartLine> lines;
  final String addressLabel;
  final bool zoneServed;
  final Slot slot;
  final Quote quote;
}
