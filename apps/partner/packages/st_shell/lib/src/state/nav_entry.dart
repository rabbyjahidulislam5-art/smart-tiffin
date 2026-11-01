class NavEntry {
  const NavEntry(this.id, [this.params = const {}]);
  final String id;
  final Map<String, String> params;
}
