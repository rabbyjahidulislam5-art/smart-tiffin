/// Sample finance staff. The signed-in accounting user is `demo-accounting`.
abstract final class FinanceStaff {
  static const me = 'demo-accounting';
  static const operator = 'rahim.acop';
  static const approver = 'sadia.payap';

  static const names = <String, String>{me: 'You', operator: 'Rahim', approver: 'Sadia'};

  static String nameOf(String id) => names[id] ?? id;
}
