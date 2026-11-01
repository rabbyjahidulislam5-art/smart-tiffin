/// A permitted, moderated review (DEC-013).
class KitchenReview {
  const KitchenReview({required this.author, required this.rating, required this.textEn, required this.textBn, required this.ago});

  final String author;
  final int rating;
  final String textEn;
  final String textBn;
  final String ago;
}
