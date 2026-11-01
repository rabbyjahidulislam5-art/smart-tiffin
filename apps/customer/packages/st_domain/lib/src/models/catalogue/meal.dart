class Meal {
  const Meal({
    required this.id,
    required this.en,
    required this.bn,
    required this.kitchen,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.img,
    required this.cat,
    required this.desc,
    required this.descBn,
    required this.spice,
    this.badge,
    this.soldOut = false,
  });

  final String id;
  final String en;
  final String bn;
  final String kitchen;
  final int price;
  final double rating;
  final int reviews;
  final String img;
  final String cat;
  final String? badge;
  final String desc;
  final String descBn;
  final bool soldOut;
  final int spice;
}
