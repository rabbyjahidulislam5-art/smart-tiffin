class Applicant {
  const Applicant({
    required this.id,
    required this.kind,
    required this.name,
    required this.owner,
    required this.area,
    required this.cap,
    required this.tier,
    required this.ago,
    required this.docs,
    this.payout,
    this.ref,
  });
  final String id;
  final String kind; // Cook | Rider
  final String name;
  final String owner;
  final String area;
  final String cap;
  final String tier;
  final String ago;
  final Map<String, String> docs;
  final String? payout;
  final String? ref;
}
