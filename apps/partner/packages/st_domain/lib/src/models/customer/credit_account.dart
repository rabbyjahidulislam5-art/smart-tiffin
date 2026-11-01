/// Customer credit balances (NC-11); never withdrawable cash, never negative.
class CreditAccount {
  const CreditAccount({required this.availableMinor, required this.reservedMinor, required this.consumedMinor, required this.expiredMinor});

  final int availableMinor;
  final int reservedMinor;
  final int consumedMinor;
  final int expiredMinor;
}
