/// What a monthly upfront payment still owes the customer (NC-13, SC-01).
class PrepaidLiability {
  const PrepaidLiability({
    required this.invoiceId,
    required this.prepaidMinor,
    required this.fulfilledMinor,
    required this.creditedMinor,
    required this.obligationsTotal,
    required this.obligationsDone,
  });

  final String invoiceId;
  final int prepaidMinor;
  final int fulfilledMinor;
  final int creditedMinor;
  final int obligationsTotal;
  final int obligationsDone;

  /// Never shown as consumed until every obligation is fulfilled or credited.
  int get remainingMinor => prepaidMinor - fulfilledMinor - creditedMinor;
}
