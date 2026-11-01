import 'package:st_domain/st_domain.dart';

/// Texts of NC-02 and NC-03 (CUSTOMER_NEW_SCREENS.md NC-02, NC-03).
abstract final class KitchenProfileText {
  static const aboutTitle = StText('About the kitchen', 'কিচেন সম্পর্কে');
  static const menuTitle = StText('Kitchen menu', 'কিচেনের মেনু');
  static const eyebrow = StText('KITCHEN', 'কিচেন');
  static const segAbout = StText('About', 'সম্পর্কে');
  static const segMenu = StText('Menu', 'মেনু');
  static const segReviews = StText('Reviews', 'রিভিউ');
  static const accepting = StText('Accepting orders', 'অর্ডার নিচ্ছে');
  static const notAccepting = StText(
    'Not accepting new orders',
    'নতুন অর্ডার নিচ্ছে না',
  );
  static const verified = StText('Verified kitchen', 'যাচাইকৃত কিচেন');
  static const ratingSummary = StText('{0} ({1} reviews)', '{0} ({1}টি রিভিউ)');
  static const description = StText('About this kitchen', 'এই কিচেন সম্পর্কে');
  static const servedAreas = StText('Served areas', 'সেবার এলাকা');
  static const servesYou = StText('Serves {0}', '{0}-এ সেবা দেয়');
  static const notServesYou = StText(
    'Does not serve {0}',
    '{0}-এ সেবা দেয় না',
  );
  static const changeAddress = StText('Change address', 'ঠিকানা বদলান');
  static const hours = StText('Operating days and hours', 'চালু দিন ও সময়');
  static const slots = StText('Meal slots', 'খাবারের সময়');
  static const policyTitle = StText(
    'Cutoff and cancellation',
    'কাট-অফ ও বাতিল',
  );
  static const policy = StText(
    'See the active policy. Cutoff and cancellation times are confirmed at checkout (BR-022, pending).',
    'চলমান নীতি দেখুন। কাট-অফ ও বাতিলের সময় চেকআউটে নিশ্চিত হয় (BR-022, বাকি)।',
  );
  static const recentReviews = StText('Recent reviews', 'সাম্প্রতিক রিভিউ');
  static const seeAll = StText('See all', 'সব দেখুন');
  static const noReviews = StText('No reviews yet', 'এখনো কোনো রিভিউ নেই');
  static const reviewsNote = StText(
    'Only permitted, moderated reviews are shown.',
    'শুধু অনুমোদিত ও যাচাই করা রিভিউ দেখানো হয়।',
  );
  static const stars = StText('{0} of 5 stars', '৫-এর মধ্যে {0} তারা');
  static const viewMenu = StText('View menu', 'মেনু দেখুন');
  static const subscribe = StText(
    'Subscribe from this kitchen',
    'এই কিচেন থেকে সাবস্ক্রাইব',
  );
  static const subscribeBlocked = StText(
    'This kitchen is not accepting subscriptions.',
    'এই কিচেন সাবস্ক্রিপশন নিচ্ছে না।',
  );
  static const subscribePrompt = StText(
    'Sign in to start a subscription from this kitchen.',
    'এই কিচেন থেকে সাবস্ক্রিপশন শুরু করতে সাইন ইন করুন।',
  );
  static const offlineAction = StText('Needs a connection.', 'সংযোগ প্রয়োজন।');
  static const report = StText('Report this kitchen', 'এই কিচেন রিপোর্ট করুন');
  static const reportPrompt = StText(
    'Sign in to report a kitchen.',
    'কিচেন রিপোর্ট করতে সাইন ইন করুন।',
  );
  static const date = StText('Service date', 'পরিবেশনের তারিখ');
  static const noSlot = StText(
    'The kitchen does not offer this slot',
    'কিচেনটি এই সময়ে খাবার দেয় না',
  );
  static const noDates = StText(
    'The kitchen has not published any dates',
    'কিচেনটি কোনো তারিখ প্রকাশ করেনি',
  );
  static const noMeals = StText(
    'No meals for this slot on this date',
    'এই তারিখে এই সময়ে কোনো খাবার নেই',
  );
  static const nextDate = StText('Next date', 'পরের তারিখ');
  static const available = StText('Available', 'পাওয়া যাচ্ছে');
  static const soldOut = StText('Sold out', 'শেষ');
  static const cutoffPassed = StText('Cutoff passed', 'কাট-অফ পেরিয়ে গেছে');
  static const cutoffReason = StText(
    'Dates past their cutoff cannot be ordered.',
    'কাট-অফ পেরোনো তারিখে অর্ডার করা যায় না।',
  );
  static const notOrderable = StText(
    'Kitchen not accepting orders',
    'কিচেন অর্ডার নিচ্ছে না',
  );
  static const select = StText('Select', 'বাছুন');
  static const quantity = StText('Quantity', 'পরিমাণ');
  static const less = StText('One less', 'একটি কম');
  static const more = StText('One more', 'একটি বেশি');
  static const portionNote = StText(
    'One standard portion per meal; portion choices are not offered yet.',
    'প্রতি খাবারে একটি সাধারণ পরিমাণ; পরিমাণ বাছাই এখনো নেই।',
  );
  static const addToOrder = StText('Add to order', 'অর্ডারে যোগ করুন');
  static const added = StText(
    'Added to your cart. The price is confirmed at checkout.',
    'কার্টে যোগ হয়েছে। দাম চেকআউটে নিশ্চিত হবে।',
  );
  static const addPrompt = StText(
    'Sign in to order meals.',
    'খাবার অর্ডার করতে সাইন ইন করুন।',
  );
  static const offlineOrder = StText(
    'Ordering needs a connection.',
    'অর্ডার করতে সংযোগ প্রয়োজন।',
  );
  static const replaceTitle = StText('Replace your cart?', 'কার্ট বদলাবেন?');
  static const replaceBody = StText(
    'Your cart has a meal from another kitchen. Adding this meal replaces it.',
    'আপনার কার্টে অন্য কিচেনের খাবার আছে। এটি যোগ করলে সেটি বদলে যাবে।',
  );
  static const replaceOk = StText('Replace cart', 'কার্ট বদলান');
  static const close = StText('Close', 'বন্ধ করুন');
  static const inCart = StText('{0} in your cart', 'কার্টে {0}টি');
  static const openCart = StText('Open cart', 'কার্ট খুলুন');
  static const confirmNote = StText(
    'Availability and price are confirmed at checkout.',
    'প্রাপ্যতা ও দাম চেকআউটে নিশ্চিত হয়।',
  );
  static const sellerClaim = StText(
    "Dietary tags are the kitchen's own statements, not medical advice.",
    'খাদ্য ট্যাগগুলো কিচেনের নিজের দাবি, চিকিৎসা পরামর্শ নয়।',
  );

  static const all = <String, StText>{
    'aboutTitle': aboutTitle,
    'menuTitle': menuTitle,
    'eyebrow': eyebrow,
    'segAbout': segAbout,
    'segMenu': segMenu,
    'segReviews': segReviews,
    'accepting': accepting,
    'notAccepting': notAccepting,
    'verified': verified,
    'ratingSummary': ratingSummary,
    'description': description,
    'servedAreas': servedAreas,
    'servesYou': servesYou,
    'notServesYou': notServesYou,
    'changeAddress': changeAddress,
    'hours': hours,
    'slots': slots,
    'policyTitle': policyTitle,
    'policy': policy,
    'recentReviews': recentReviews,
    'seeAll': seeAll,
    'noReviews': noReviews,
    'reviewsNote': reviewsNote,
    'stars': stars,
    'viewMenu': viewMenu,
    'subscribe': subscribe,
    'subscribeBlocked': subscribeBlocked,
    'subscribePrompt': subscribePrompt,
    'offlineAction': offlineAction,
    'report': report,
    'reportPrompt': reportPrompt,
    'date': date,
    'noSlot': noSlot,
    'noDates': noDates,
    'noMeals': noMeals,
    'nextDate': nextDate,
    'available': available,
    'soldOut': soldOut,
    'cutoffPassed': cutoffPassed,
    'cutoffReason': cutoffReason,
    'notOrderable': notOrderable,
    'select': select,
    'quantity': quantity,
    'less': less,
    'more': more,
    'portionNote': portionNote,
    'addToOrder': addToOrder,
    'added': added,
    'addPrompt': addPrompt,
    'offlineOrder': offlineOrder,
    'replaceTitle': replaceTitle,
    'replaceBody': replaceBody,
    'replaceOk': replaceOk,
    'close': close,
    'inCart': inCart,
    'openCart': openCart,
    'confirmNote': confirmNote,
    'sellerClaim': sellerClaim,
  };
}
