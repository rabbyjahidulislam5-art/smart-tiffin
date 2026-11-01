import 'package:st_domain/st_domain.dart';

/// Texts of NS-05 (SUPPLIER_MODULES.md M7, capacity scheduler).
abstract final class CapacityText {
  static const eyebrow = StText('Kitchen planning', 'কিচেন পরিকল্পনা');
  static const title = StText('Capacity scheduler', 'ধারণক্ষমতা নির্ধারণ');
  static const intro = StText(
    'Set the most portions you can cook per slot each day. Capacity at or below what is committed stops new purchases.',
    'প্রতিদিন প্রতিটি সময়ে সর্বোচ্চ কত পোর্শন রাঁধতে পারবেন তা ঠিক করুন। প্রতিশ্রুত পরিমাণের সমান বা কম হলে নতুন কেনা বন্ধ থাকে।',
  );
  static const committed = StText('{0} committed', '{0} প্রতিশ্রুত');
  static const currentMax = StText(
    'Current limit: {0} portions',
    'বর্তমান সীমা: {0} পোর্শন',
  );
  static const newMax = StText('New daily limit', 'নতুন দৈনিক সীমা');
  static const save = StText('Save limit', 'সীমা সংরক্ষণ');
  static const open = StText('Open for new orders', 'নতুন অর্ডারের জন্য খোলা');
  static const full = StText('Full', 'পূর্ণ');
  static const closed = StText('Closed', 'বন্ধ');
  static const enterLimit = StText(
    'Enter a whole number from 1 to 500.',
    '১ থেকে ৫০০ এর মধ্যে একটি পূর্ণ সংখ্যা লিখুন।',
  );
  static const belowCommitted = StText(
    'The limit cannot be lower than the {0} portions already committed. Use the continuity process instead (BR-024).',
    'সীমা ইতিমধ্যে প্রতিশ্রুত {0} পোর্শনের কম হতে পারে না। এর বদলে ধারাবাহিকতা প্রক্রিয়া ব্যবহার করুন (BR-024)।',
  );
  static const saveName = StText('Saving the limit', 'সীমা সংরক্ষণ');
  static const saved = StText('Limit saved.', 'সীমা সংরক্ষিত হয়েছে।');
  static const availabilityName = StText(
    'Changing availability',
    'প্রাপ্যতা পরিবর্তন',
  );
  static const availabilitySaved = StText(
    'Availability updated.',
    'প্রাপ্যতা হালনাগাদ হয়েছে।',
  );
  static const cutoffNote = StText(
    'Edits near a cutoff use the server time. The cutoff rule (BR-022) is pending, so no lock time is shown yet.',
    'কাট-অফের কাছাকাছি পরিবর্তনে সার্ভারের সময় ধরা হয়। কাট-অফ নিয়ম (BR-022) এখনো বাকি, তাই লক সময় দেখানো হচ্ছে না।',
  );
  static const closuresGap = StText(
    'Closures for single dates (holiday, maintenance) are not available yet.',
    'নির্দিষ্ট দিনের বন্ধ (ছুটি, রক্ষণাবেক্ষণ) এখনো চালু হয়নি।',
  );
  static const addClosure = StText('Add a closure', 'বন্ধের দিন যোগ করুন');
  static const informed = StText(
    'When a change affects subscribers, the platform informs them; you do not need to message customers.',
    'কোনো পরিবর্তন গ্রাহকদের প্রভাবিত করলে প্ল্যাটফর্ম তাদের জানায়; আপনাকে বার্তা পাঠাতে হবে না।',
  );

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'intro': intro,
    'committed': committed,
    'currentMax': currentMax,
    'newMax': newMax,
    'save': save,
    'open': open,
    'full': full,
    'closed': closed,
    'enterLimit': enterLimit,
    'belowCommitted': belowCommitted,
    'saveName': saveName,
    'saved': saved,
    'availabilityName': availabilityName,
    'availabilitySaved': availabilitySaved,
    'cutoffNote': cutoffNote,
    'closuresGap': closuresGap,
    'addClosure': addClosure,
    'informed': informed,
  };
}
