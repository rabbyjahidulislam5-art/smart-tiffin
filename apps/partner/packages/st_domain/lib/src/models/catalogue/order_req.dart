class OrderReq {
  const OrderReq({
    required this.id,
    required this.name,
    required this.area,
    required this.item,
    required this.qty,
    required this.pay,
    required this.amount,
    this.note,
  });
  final String id;
  final String name;
  final String area;
  final String item;
  final String qty;
  final String pay;
  final int amount;
  final String? note;
}
