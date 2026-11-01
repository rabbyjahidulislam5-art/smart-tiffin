import 'package:st_domain/st_domain.dart';

/// Texts of NC-18 and the favourite heart of NC-01 and NC-02
/// (CUSTOMER_NEW_SCREENS.md NC-18, NC-01.5).
abstract final class KitchenFavouritesText {
  static const title = StText('Favourite kitchens', 'পছন্দের কিচেন');
  static const eyebrow = StText('PREFERENCES', 'পছন্দ');
  static const intro = StText(
    "Saving a favourite never changes a kitchen's public rating.",
    'পছন্দ রাখলে কিচেনের পাবলিক রেটিং কখনো বদলায় না।',
  );
  static const empty = StText(
    'No favourites yet. Browse kitchens to add some.',
    'এখনো কোনো পছন্দ নেই। কিচেন দেখে যোগ করুন।',
  );
  static const browse = StText('Browse kitchens', 'কিচেন দেখুন');
  static const addLabel = StText(
    'Add {0} to favourites',
    '{0} পছন্দে যোগ করুন',
  );
  static const removeLabel = StText(
    'Remove {0} from favourites',
    '{0} পছন্দ থেকে সরান',
  );
  static const commandName = StText('Saving the favourite', 'পছন্দ সংরক্ষণ');
  static const prompt = StText(
    'Sign in to save favourite kitchens.',
    'পছন্দের কিচেন রাখতে সাইন ইন করুন।',
  );
  static const offline = StText(
    'Favourites need a connection.',
    'পছন্দ বদলাতে সংযোগ প্রয়োজন।',
  );
  static const rating = StText('{0} ({1} reviews)', '{0} ({1}টি রিভিউ)');

  static const all = <String, StText>{
    'title': title,
    'eyebrow': eyebrow,
    'intro': intro,
    'empty': empty,
    'browse': browse,
    'addLabel': addLabel,
    'removeLabel': removeLabel,
    'commandName': commandName,
    'prompt': prompt,
    'offline': offline,
    'rating': rating,
  };
}
