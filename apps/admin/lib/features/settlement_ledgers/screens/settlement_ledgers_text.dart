import 'package:st_domain/st_domain.dart';

/// Texts of NF-05 and NF-06 (accounts-web/SUPPLIER_SETTLEMENT.md, RIDER_SETTLEMENT.md).
abstract final class SettlementLedgersText {
  static const eyebrow = StText('Accounts', 'অ্যাকাউন্টস');
  static const supplierTitle = StText(
    'Supplier payable ledger',
    'সরবরাহকারী পাওনা খতিয়ান',
  );
  static const supplierIntro = StText(
    'Recognised earnings, platform deductions, holds and disputes per supplier. A recognised figure is changed only by a reversing adjustment.',
    'প্রতি সরবরাহকারীর স্বীকৃত আয়, প্ল্যাটফর্ম কর্তন, আটক ও বিরোধ। স্বীকৃত সংখ্যা শুধু বিপরীত সমন্বয়ে বদলায়।',
  );
  static const riderTitle = StText(
    'Rider payable ledger',
    'রাইডার পাওনা খতিয়ান',
  );
  static const riderIntro = StText(
    'Delivery compensation per rider. The COD cash a rider holds is shown beside it and never netted unless BR-026 is approved and an offset is recorded.',
    'প্রতি রাইডারের ডেলিভারি পারিশ্রমিক। রাইডারের কাছে থাকা সিওডি নগদ পাশে দেখানো হয়, BR-026 অনুমোদিত ও অফসেট রেকর্ড না হলে কখনো কাটা হয় না।',
  );
  static const colParty = StText('Party', 'পক্ষ');
  static const recognised = StText('Recognised', 'স্বীকৃত');
  static const deductions = StText('Deductions', 'কর্তন');
  static const held = StText('Held', 'আটক');
  static const disputed = StText('Disputed', 'বিরোধপূর্ণ');
  static const eligible = StText('Eligible', 'উত্তোলনযোগ্য');
  static const codLiability = StText('COD held', 'সিওডি জিম্মায়');
  static const onHold = StText('On hold', 'আটকে আছে');
  static const clear = StText('Clear', 'মুক্ত');
  static const explain = StText(
    'Why this amount is available',
    'এই পরিমাণ কেন উত্তোলনযোগ্য',
  );
  static const formula = StText(
    'Recognised − deductions − held − disputed = eligible',
    'স্বীকৃত − কর্তন − আটক − বিরোধপূর্ণ = উত্তোলনযোগ্য',
  );
  static const holdReason = StText('Hold reason: {0}', 'আটকের কারণ: {0}');
  static const placeHold = StText('Place a hold', 'আটক করুন');
  static const releaseHold = StText('Release the hold', 'আটক তুলুন');
  static const holdName = StText('Changing the hold', 'আটক পরিবর্তন');
  static const holdPlaced = StText('Hold placed.', 'আটক করা হয়েছে।');
  static const holdReleased = StText('Hold released.', 'আটক তোলা হয়েছে।');
  static const holdBody = StText(
    'The reason is recorded in the audit log (at least 5 characters).',
    'কারণটি অডিট লগে রেকর্ড হয় (অন্তত ৫ অক্ষর)।',
  );
  static const empty = StText('No payables', 'কোনো পাওনা নেই');
  static const close = StText('Close', 'বন্ধ করুন');

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'supplierTitle': supplierTitle,
    'supplierIntro': supplierIntro,
    'riderTitle': riderTitle,
    'riderIntro': riderIntro,
    'colParty': colParty,
    'recognised': recognised,
    'deductions': deductions,
    'held': held,
    'disputed': disputed,
    'eligible': eligible,
    'codLiability': codLiability,
    'onHold': onHold,
    'clear': clear,
    'explain': explain,
    'formula': formula,
    'holdReason': holdReason,
    'placeHold': placeHold,
    'releaseHold': releaseHold,
    'holdName': holdName,
    'holdPlaced': holdPlaced,
    'holdReleased': holdReleased,
    'holdBody': holdBody,
    'empty': empty,
    'close': close,
  };
}
