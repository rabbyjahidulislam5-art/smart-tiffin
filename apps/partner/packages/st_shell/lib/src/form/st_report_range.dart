import 'package:st_domain/st_domain.dart';

/// Report export range rules shared by NA-06 and NF-14: two YYYY-MM-DD dates,
/// start not after end, end not after [today].
abstract final class StReportRange {
  static bool valid(String from, String to, String today) {
    final f = latinDigits(from).trim();
    final t = latinDigits(to).trim();
    final shape = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!shape.hasMatch(f) || !shape.hasMatch(t)) return false;
    if (DateTime.tryParse(f) == null || DateTime.tryParse(t) == null)
      return false;
    return f.compareTo(t) <= 0 && t.compareTo(today) <= 0;
  }

  static String of(String from, String to) =>
      '${latinDigits(from).trim()}..${latinDigits(to).trim()}';
}
