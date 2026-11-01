/// Picks the string for [lang] (`'en'` or `'bn'`).
///
/// Returns [en] when the language is Bangla but [bn] is empty or only
/// whitespace, so a blank value or a raw key is never shown.
String localized(String lang, String en, String bn) {
  if (lang == 'bn' && bn.trim().isNotEmpty) return bn;
  return en;
}
