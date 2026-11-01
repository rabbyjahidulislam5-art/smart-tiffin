/// One debit or credit line of a balanced journal entry.
class JournalLine {
  const JournalLine({required this.account, this.debitMinor = 0, this.creditMinor = 0});

  final String account;
  final int debitMinor;
  final int creditMinor;
}
