import 'package:st_domain/st_domain.dart';

/// Texts of NS-06 (SUPPLIER_MODULES.md M6, price and version manager).
abstract final class MenuPricingText {
  static const eyebrow = StText('Menu', 'মেনু');
  static const title = StText('Prices and versions', 'দাম ও সংস্করণ');
  static const snapshotNote = StText(
    'Changes apply to new quotations only. Paid quotations and existing obligations keep their price snapshot (ADR-009).',
    'পরিবর্তন শুধু নতুন কোটেশনে প্রযোজ্য। পরিশোধিত কোটেশন ও চলমান দায় তাদের দামের স্ন্যাপশট রাখে (ADR-009)।',
  );
  static const history = StText('Price history', 'দামের ইতিহাস');
  static const effectiveFrom = StText('Effective from {0}', '{0} থেকে কার্যকর');
  static const byAuthor = StText('{0} · {1}', '{0} · {1}');
  static const bound = StText(
    '{0} active commitments and open quotes still use this price',
    '{0}টি চলমান প্রতিশ্রুতি ও খোলা কোটেশন এখনো এই দাম ব্যবহার করছে',
  );
  static const statusActive = StText('Active', 'সক্রিয়');
  static const statusScheduled = StText('Scheduled', 'নির্ধারিত');
  static const statusSuperseded = StText('Superseded', 'প্রতিস্থাপিত');
  static const statusCancelled = StText('Cancelled', 'বাতিল');
  static const cancel = StText('Cancel scheduled price', 'নির্ধারিত দাম বাতিল');
  static const cancelGap = StText(
    'Cancelling a scheduled price is not available yet.',
    'নির্ধারিত দাম বাতিল করা এখনো চালু হয়নি।',
  );
  static const schedule = StText(
    'Schedule a price change',
    'দাম পরিবর্তন নির্ধারণ',
  );
  static const meal = StText('Meal', 'খাবার');
  static const newPrice = StText('New price (৳)', 'নতুন দাম (৳)');
  static const date = StText(
    'Effective date (YYYY-MM-DD)',
    'কার্যকর তারিখ (YYYY-MM-DD)',
  );
  static const reason = StText('Reason', 'কারণ');
  static const submit = StText('Schedule change', 'পরিবর্তন নির্ধারণ করুন');
  static const commandName = StText(
    'Scheduling the price change',
    'দাম পরিবর্তন নির্ধারণ',
  );
  static const success = StText(
    'Price change scheduled.',
    'দাম পরিবর্তন নির্ধারিত হয়েছে।',
  );
  static const chooseMeal = StText('Choose a meal.', 'একটি খাবার বেছে নিন।');
  static const futureDate = StText(
    'Enter a future date as YYYY-MM-DD.',
    'YYYY-MM-DD আকারে ভবিষ্যতের একটি তারিখ লিখুন।',
  );
  static const reasonShort = StText(
    'Write a reason of at least 5 characters.',
    'অন্তত ৫ অক্ষরের একটি কারণ লিখুন।',
  );
  static const noticePolicy = StText(
    'The minimum notice for a price change (policy.price_change.minimum_notice_hours) is not set yet.',
    'দাম পরিবর্তনের ন্যূনতম নোটিশ (policy.price_change.minimum_notice_hours) এখনো ঠিক হয়নি।',
  );
  static const empty = StText('No prices yet', 'এখনো কোনো দাম নেই');

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'snapshotNote': snapshotNote,
    'history': history,
    'effectiveFrom': effectiveFrom,
    'byAuthor': byAuthor,
    'bound': bound,
    'statusActive': statusActive,
    'statusScheduled': statusScheduled,
    'statusSuperseded': statusSuperseded,
    'statusCancelled': statusCancelled,
    'cancel': cancel,
    'cancelGap': cancelGap,
    'schedule': schedule,
    'meal': meal,
    'newPrice': newPrice,
    'date': date,
    'reason': reason,
    'submit': submit,
    'commandName': commandName,
    'success': success,
    'chooseMeal': chooseMeal,
    'futureDate': futureDate,
    'reasonShort': reasonShort,
    'noticePolicy': noticePolicy,
    'empty': empty,
  };
}
