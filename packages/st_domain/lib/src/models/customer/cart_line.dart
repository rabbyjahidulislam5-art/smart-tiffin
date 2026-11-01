/// One cart line of a one-time order (NC-14).
class CartLine {
  const CartLine({required this.menuItemId, required this.mealId, required this.qty, required this.priceMinor});

  final String menuItemId;
  final String mealId;
  final int qty;
  final int priceMinor;

  int get totalMinor => qty * priceMinor;
}
