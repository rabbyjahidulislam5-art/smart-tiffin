import 'billing_frequency.dart';
import 'invoice_status.dart';

/// A weekly or monthly subscription invoice (NC-12, NC-13).
class Invoice {
  const Invoice({
    required this.id,
    required this.variant,
    required this.period,
    required this.totalMinor,
    required this.appliedCreditMinor,
    required this.paidMinor,
    required this.status,
  });

  final String id;
  final BillingFrequency variant;
  final String period;
  final int totalMinor;
  final int appliedCreditMinor;
  final int paidMinor;
  final InvoiceStatus status;

  int get dueMinor {
    final v = totalMinor - appliedCreditMinor - paidMinor;
    return v < 0 ? 0 : v;
  }

  Invoice paid() => Invoice(
        id: id,
        variant: variant,
        period: period,
        totalMinor: totalMinor,
        appliedCreditMinor: appliedCreditMinor,
        paidMinor: totalMinor - appliedCreditMinor,
        status: InvoiceStatus.paid,
      );
}
