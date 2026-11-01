import 'package:st_domain/st_domain.dart';

/// Texts of NC-01 (CUSTOMER_NEW_SCREENS.md NC-01).
abstract final class KitchenDiscoveryText {
  static const title = StText('Kitchens', 'কিচেন');
  static const eyebrow = StText('DISCOVER', 'খুঁজুন');
  static const search = StText('Search kitchens', 'কিচেন খুঁজুন');
  static const searchHint = StText(
    'English or Bangla name',
    'ইংরেজি বা বাংলা নাম',
  );
  static const clear = StText('Clear search', 'খোঁজ মুছুন');
  static const queryTooLong = StText(
    'Use at most 60 characters.',
    'সর্বোচ্চ ৬০ অক্ষর ব্যবহার করুন।',
  );
  static const area = StText('Area', 'এলাকা');
  static const anyArea = StText('Any area', 'যেকোনো এলাকা');
  static const changeAddress = StText('Change address', 'ঠিকানা বদলান');
  static const filters = StText('Filters', 'ফিল্টার');
  static const cuisine = StText('Cuisine', 'রান্নার ধরন');
  static const dietary = StText('Dietary', 'খাদ্যাভ্যাস');
  static const slots = StText('Meal slots', 'খাবারের সময়');
  static const more = StText('More filters', 'আরও ফিল্টার');
  static const verified = StText('Verified kitchen', 'যাচাইকৃত কিচেন');
  static const verifiedOnly = StText('Verified kitchens', 'যাচাইকৃত কিচেনগুলো');
  static const favourites = StText('My favourites', 'আমার পছন্দ');
  static const openOn = StText('Open on a date', 'নির্দিষ্ট দিনে খোলা');
  static const openOnGap = StText(
    'Date availability is not part of the search read yet.',
    'তারিখভিত্তিক প্রাপ্যতা এখনো খোঁজে নেই।',
  );
  static const halal = StText('Halal', 'হালাল');
  static const diet = StText('Diet', 'ডায়েট');
  static const cuisineBengali = StText('Bengali', 'বাঙালি');
  static const cuisineBiryani = StText('Biryani', 'বিরিয়ানি');
  static const cuisineBeef = StText('Beef', 'গরুর মাংস');
  static const cuisineDiet = StText('Diet meals', 'ডায়েট খাবার');
  static const zoneBanani = StText('Banani', 'বনানী');
  static const zoneGulshan = StText('Gulshan', 'গুলশান');
  static const zoneMohakhali = StText('Mohakhali', 'মহাখালী');
  static const zoneDhanmondi = StText('Dhanmondi', 'ধানমন্ডি');
  static const zoneUttara = StText('Uttara', 'উত্তরা');
  static const sort = StText('Sort', 'সাজান');
  static const sortRelevance = StText('Relevance', 'প্রাসঙ্গিকতা');
  static const sortRating = StText('Highest rated', 'সর্বোচ্চ রেটিং');
  static const sortName = StText('Name A to Z', 'নাম অনুযায়ী');
  static const apply = StText('Apply', 'প্রয়োগ করুন');
  static const reset = StText('Reset', 'রিসেট');
  static const cancel = StText('Cancel', 'বাতিল');
  static const count = StText('{0} kitchens', '{0}টি কিচেন');
  static const countMore = StText('{0}+ kitchens', '{0}+টি কিচেন');
  static const rating = StText('{0} ({1} reviews)', '{0} ({1}টি রিভিউ)');
  static const serves = StText('Serves {0}', '{0}-এ সেবা দেয়');
  static const notServes = StText(
    'Does not serve this area',
    'এই এলাকায় সেবা দেয় না',
  );
  static const notAccepting = StText(
    'Not accepting orders',
    'অর্ডার নিচ্ছে না',
  );
  static const noMatch = StText('No kitchens match', 'কোনো কিচেন মেলেনি');
  static const clearFilters = StText('Clear filters', 'ফিল্টার মুছুন');
  static const noArea = StText(
    'No kitchens serve this area',
    'এই এলাকায় কোনো কিচেন সেবা দেয় না',
  );
  static const offlineControls = StText(
    'Search and filters need a connection.',
    'খোঁজ ও ফিল্টারের জন্য সংযোগ প্রয়োজন।',
  );
  static const partners = StText(
    'Work with Smart Tiffin',
    'স্মার্ট টিফিনের সাথে কাজ করুন',
  );
  static const cook = StText(
    'Cook with Smart Tiffin',
    'স্মার্ট টিফিনে রান্না করুন',
  );
  static const cookSub = StText(
    'Kitchen applications continue in the Partner app',
    'কিচেনের আবেদন পার্টনার অ্যাপে চলবে',
  );
  static const ride = StText(
    'Ride with Smart Tiffin',
    'স্মার্ট টিফিনে রাইড করুন',
  );
  static const rideSub = StText(
    'Rider applications continue in the Partner app',
    'রাইডারের আবেদন পার্টনার অ্যাপে চলবে',
  );

  static const all = <String, StText>{
    'title': title,
    'eyebrow': eyebrow,
    'search': search,
    'searchHint': searchHint,
    'clear': clear,
    'queryTooLong': queryTooLong,
    'area': area,
    'anyArea': anyArea,
    'changeAddress': changeAddress,
    'filters': filters,
    'cuisine': cuisine,
    'dietary': dietary,
    'slots': slots,
    'more': more,
    'verified': verified,
    'verifiedOnly': verifiedOnly,
    'favourites': favourites,
    'openOn': openOn,
    'openOnGap': openOnGap,
    'halal': halal,
    'diet': diet,
    'cuisineBengali': cuisineBengali,
    'cuisineBiryani': cuisineBiryani,
    'cuisineBeef': cuisineBeef,
    'cuisineDiet': cuisineDiet,
    'zoneBanani': zoneBanani,
    'zoneGulshan': zoneGulshan,
    'zoneMohakhali': zoneMohakhali,
    'zoneDhanmondi': zoneDhanmondi,
    'zoneUttara': zoneUttara,
    'sort': sort,
    'sortRelevance': sortRelevance,
    'sortRating': sortRating,
    'sortName': sortName,
    'apply': apply,
    'reset': reset,
    'cancel': cancel,
    'count': count,
    'countMore': countMore,
    'rating': rating,
    'serves': serves,
    'notServes': notServes,
    'notAccepting': notAccepting,
    'noMatch': noMatch,
    'clearFilters': clearFilters,
    'noArea': noArea,
    'offlineControls': offlineControls,
    'partners': partners,
    'cook': cook,
    'cookSub': cookSub,
    'ride': ride,
    'rideSub': rideSub,
  };
}
