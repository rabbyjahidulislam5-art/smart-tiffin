/// Where a Bangla string comes from.
enum StTextSource {
  /// Written by this project; listed for native-speaker review (D-04).
  authored,

  /// Taken verbatim from a Source_Of_Truth document or the legacy prototype.
  doc,
}

/// A visible text in English and Bangla. Placeholders `{0}`, `{1}` are
/// replaced by `AppState.tx(text, [args])`.
class StText {
  const StText(this.en, this.bn, {this.source = StTextSource.authored});

  final String en;
  final String bn;
  final StTextSource source;

  /// Replaces `{i}` with `args[i]` in [template].
  static String fill(String template, List<String> args) {
    var out = template;
    for (var i = 0; i < args.length; i++) {
      out = out.replaceAll('{$i}', args[i]);
    }
    return out;
  }

  @override
  bool operator ==(Object other) => other is StText && other.en == en && other.bn == bn;

  @override
  int get hashCode => Object.hash(en, bn);

  @override
  String toString() => 'StText($en)';
}
