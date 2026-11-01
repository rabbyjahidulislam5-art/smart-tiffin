const _latin = '0123456789';
const _bangla = '০১২৩৪৫৬৭৮৯';

/// Replaces Latin digits 0-9 with Bangla digits ০-৯. Other characters are unchanged.
String bnDigits(String s) {
  final out = StringBuffer();
  for (final r in s.runes) {
    final ch = String.fromCharCode(r);
    final i = _latin.indexOf(ch);
    out.write(i < 0 ? ch : _bangla[i]);
  }
  return out.toString();
}

/// Replaces Bangla digits ০-৯ with Latin digits 0-9. Other characters are unchanged.
String latinDigits(String s) {
  final out = StringBuffer();
  for (final r in s.runes) {
    final ch = String.fromCharCode(r);
    final i = _bangla.indexOf(ch);
    out.write(i < 0 ? ch : _latin[i]);
  }
  return out.toString();
}
