import 'cod_status.dart';

/// Cash the rider collects for one order: a company liability, never income.
class CodCollection {
  const CodCollection({
    required this.id,
    required this.orderRef,
    required this.customerRef,
    required this.expectedMinor,
    required this.status,
    this.collectedMinor,
  });

  final String id;
  final String orderRef;
  final String customerRef;
  final int expectedMinor;
  final CodStatus status;
  final int? collectedMinor;

  CodCollection collect(int minor) => CodCollection(
        id: id,
        orderRef: orderRef,
        customerRef: customerRef,
        expectedMinor: expectedMinor,
        status: CodStatus.collected,
        collectedMinor: minor,
      );
}
