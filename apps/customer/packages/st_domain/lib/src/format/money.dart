import '../text/digits.dart';

/// Formats whole taka with lakh grouping (12,34,567).
///
/// DF-1 (LC-6): a negative number formats as `-` plus the formatting of its
/// absolute value. For `n >= 0` the code below the guard is the legacy body,
/// so the output is byte-identical to the prototype.
String fmtBdt(int n) {
  if (n < 0) return '-${fmtBdt(-n)}';
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final fromEnd = s.length - i;
    buf.write(s[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(',');
  }
  // Simple Indian grouping approximation
  final raw = n.toString();
  if (raw.length <= 3) return raw;
  final last3 = raw.substring(raw.length - 3);
  var rest = raw.substring(0, raw.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '${parts.join(',')},$last3';
}

/// `৳` plus [fmtBdt]; digits are Bangla when [bn] is true.
String moneyLabel(int taka, {bool bn = false}) {
  final label = '৳${fmtBdt(taka)}';
  return bn ? bnDigits(label) : label;
}

/// Formats integer minor units (paisa): `fmtBdt(minor ~/ 100)` plus `.dd`
/// only when the paisa part is not zero, so whole-taka values print exactly
/// as the legacy screens do.
String fmtBdtMinor(int minor) {
  final negative = minor < 0;
  final abs = minor.abs();
  final whole = fmtBdt(abs ~/ 100);
  final paisa = abs % 100;
  final text =
      paisa == 0 ? whole : '$whole.${paisa.toString().padLeft(2, '0')}';
  return negative ? '-$text' : text;
}

/// `৳` plus [fmtBdtMinor]; digits are Bangla when [bn] is true.
String moneyLabelMinor(int minor, {bool bn = false}) {
  final label = '৳${fmtBdtMinor(minor)}';
  return bn ? bnDigits(label) : label;
}
