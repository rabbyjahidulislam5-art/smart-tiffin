import 'order_status.dart';
import 'payment_choice.dart';

class OrderReceipt {
  const OrderReceipt({required this.orderId, required this.status, required this.totalMinor, required this.payment});

  final String orderId;
  final OrderStatus status;
  final int totalMinor;
  final PaymentChoice payment;
}
