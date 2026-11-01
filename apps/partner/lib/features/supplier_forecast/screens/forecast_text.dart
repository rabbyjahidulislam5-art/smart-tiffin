import 'package:st_domain/st_domain.dart';

/// Texts of NS-04 (SUPPLIER_MODULES.md M8, forecast).
abstract final class ForecastText {
  static const eyebrow = StText('Kitchen planning', 'কিচেন পরিকল্পনা');
  static const title = StText(
    'Subscription forecast',
    'সাবস্ক্রিপশন পূর্বাভাস',
  );
  static const advisory = StText(
    'Figures come from subscription obligations only. They are advisory for purchasing and staffing; they are not orders and carry no payment promise.',
    'সংখ্যাগুলো শুধু সাবস্ক্রিপশনের দায় থেকে আসে। কেনাকাটা ও কর্মী পরিকল্পনার জন্য এটি পরামর্শ মাত্র; এগুলো অর্ডার নয়, কোনো পেমেন্টের প্রতিশ্রুতিও নয়।',
  );
  static const allSlots = StText('All slots', 'সব সময়');
  static const empty = StText(
    'No future portions yet',
    'এখনো ভবিষ্যতের কোনো পোর্শন নেই',
  );
  static const dayTotal = StText('{0} · {1} portions', '{0} · {1} পোর্শন');
  static const portionsOf = StText('{0} of {1}', '{1}-এর মধ্যে {0}');
  static const overCapacity = StText('Over capacity', 'ধারণক্ষমতার বেশি');
  static const overCount = StText(
    '{0} slots exceed the daily limit. Raise the limit in capacity or plan extra cooking.',
    '{0}টি সময় দৈনিক সীমা ছাড়িয়েছে। ধারণক্ষমতায় সীমা বাড়ান বা বাড়তি রান্নার পরিকল্পনা করুন।',
  );
  static const openCapacity = StText('Open capacity', 'ধারণক্ষমতা খুলুন');

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'advisory': advisory,
    'allSlots': allSlots,
    'empty': empty,
    'dayTotal': dayTotal,
    'portionsOf': portionsOf,
    'overCapacity': overCapacity,
    'overCount': overCount,
    'openCapacity': openCapacity,
  };
}
