import 'package:st_domain/st_domain.dart';

/// Texts of NS-07 (SUPPLIER_MODULES.md M9, pickup handoff; DEC-014).
abstract final class HandoffText {
  static const eyebrow = StText('Pickup', 'পিকআপ');
  static const title = StText(
    'Kitchen pickup handoff',
    'কিচেন পিকআপ হস্তান্তর',
  );
  static const intro = StText(
    'Hand orders only to the assigned rider. Count the items, seal the containers and enter the code the rider shows.',
    'শুধু নির্ধারিত রাইডারকে অর্ডার দিন। আইটেম গুনুন, কন্টেইনার সিল করুন এবং রাইডারের দেখানো কোড লিখুন।',
  );
  static const ready = StText('Ready for pickup', 'পিকআপের জন্য প্রস্তুত');
  static const handedOff = StText('Handed off', 'হস্তান্তরিত');
  static const exception = StText('Exception', 'ব্যতিক্রম');
  static const items = StText('{0} items', '{0}টি আইটেম');
  static const rider = StText('Rider {0} · {1}', 'রাইডার {0} · {1}');
  static const code = StText('Pickup code', 'পিকআপ কোড');
  static const counted = StText('Items counted', 'আইটেম গোনা হয়েছে');
  static const sealed = StText('Containers sealed', 'কন্টেইনার সিল করা হয়েছে');
  static const confirm = StText('Confirm handoff', 'হস্তান্তর নিশ্চিত করুন');
  static const commandName = StText(
    'Recording the handoff',
    'হস্তান্তর রেকর্ড',
  );
  static const success = StText(
    'Handoff recorded. The rider now confirms pickup.',
    'হস্তান্তর রেকর্ড হয়েছে। এখন রাইডার পিকআপ নিশ্চিত করবেন।',
  );
  static const chooseOrder = StText(
    'Choose an order.',
    'একটি অর্ডার বেছে নিন।',
  );
  static const enterCode = StText(
    'Enter the 4-digit pickup code.',
    '৪ অঙ্কের পিকআপ কোড লিখুন।',
  );
  static const checksNeeded = StText(
    'Count the items and seal the containers first.',
    'আগে আইটেম গুনুন ও কন্টেইনার সিল করুন।',
  );
  static const noEffect = StText(
    'A handoff does not complete the delivery, does not recognise earnings and does not close COD.',
    'হস্তান্তরে ডেলিভারি সম্পন্ন হয় না, আয় স্বীকৃত হয় না এবং সিওডি বন্ধ হয় না।',
  );
  static const report = StText('Report a problem', 'সমস্যা জানান');
  static const reportGap = StText(
    'Recording a handoff exception is not available yet.',
    'হস্তান্তরের ব্যতিক্রম রেকর্ড করা এখনো চালু হয়নি।',
  );
  static const empty = StText(
    'No orders are waiting for pickup',
    'পিকআপের অপেক্ষায় কোনো অর্ডার নেই',
  );

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'intro': intro,
    'ready': ready,
    'handedOff': handedOff,
    'exception': exception,
    'items': items,
    'rider': rider,
    'code': code,
    'counted': counted,
    'sealed': sealed,
    'confirm': confirm,
    'commandName': commandName,
    'success': success,
    'chooseOrder': chooseOrder,
    'enterCode': enterCode,
    'checksNeeded': checksNeeded,
    'noEffect': noEffect,
    'report': report,
    'reportGap': reportGap,
    'empty': empty,
  };
}
