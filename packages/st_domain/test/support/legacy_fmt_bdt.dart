// Exact copy of the pre-DF-1 `fmtBdt` from the legacy prototype
// (`lib/data/st_data.dart`), kept as the reference for Property 20.
String legacyFmtBdt(int n) {
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
