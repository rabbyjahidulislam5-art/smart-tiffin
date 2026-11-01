import 'package:st_domain/st_domain.dart';

/// Texts of NS-01..NS-03 (SUPPLIER_SCREENS.md; partner-app/SUPPLIER_EARNINGS.md).
abstract final class SupplierEarningsText {
  static const eyebrow = StText('Kitchen earnings', 'কিচেনের আয়');
  static const title = StText('Earnings detail', 'আয়ের বিবরণ');
  static const expected = StText('Expected', 'প্রত্যাশিত');
  static const expectedNote = StText(
    'Projected, not a balance',
    'অনুমান, ব্যালেন্স নয়',
  );
  static const earned = StText('Earned', 'অর্জিত');
  static const held = StText('Held', 'আটকে আছে');
  static const eligible = StText('Eligible', 'উত্তোলনযোগ্য');
  static const settled = StText('Settled', 'নিষ্পন্ন');
  static const separateNote = StText(
    'The five balances are shown separately and never added together. Expected amounts come from future obligations and cannot be requested.',
    'পাঁচটি ব্যালেন্স আলাদা দেখানো হয়, কখনো যোগ করা হয় না। প্রত্যাশিত পরিমাণ ভবিষ্যতের অর্ডার থেকে আসে, তা উত্তোলন করা যায় না।',
  );
  static const requestPayout = StText('Request payout', 'পেআউট অনুরোধ');
  static const payoutHistory = StText('Payout history', 'পেআউট ইতিহাস');
  static const statement = StText('Statement', 'বিবরণী');
  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'expected': expected,
    'expectedNote': expectedNote,
    'earned': earned,
    'held': held,
    'eligible': eligible,
    'settled': settled,
    'separateNote': separateNote,
    'requestPayout': requestPayout,
    'payoutHistory': payoutHistory,
    'statement': statement,
    'filterAll': filterAll,
    'empty': empty,
    'colEntry': colEntry,
    'colRecognised': colRecognised,
    'colGross': colGross,
    'colCommission': colCommission,
    'colNet': colNet,
    'notYet': notYet,
    'detailTitle': detailTitle,
    'source': source,
    'reference': reference,
    'recognitionEvent': recognitionEvent,
    'holdReason': holdReason,
    'commissionNote': commissionNote,
    'close': close,
    'requestTitle': requestTitle,
    'pending': pending,
    'requestNote': requestNote,
    'amountLabel': amountLabel,
    'destination': destination,
    'confirmDestination': confirmDestination,
    'confirmNeeded': confirmNeeded,
    'submit': submit,
    'commandName': commandName,
    'success': success,
    'notPaidNote': notPaidNote,
    'historyTitle': historyTitle,
    'historyEmpty': historyEmpty,
    'historyNote': historyNote,
    'colRequested': colRequested,
    'colDestination': colDestination,
    'colReference': colReference,
  };
  static const filterAll = StText('All', 'সব');
  static const empty = StText(
    'No earnings with this status',
    'এই অবস্থার কোনো আয় নেই',
  );
  static const colEntry = StText('Order or obligation', 'অর্ডার বা দায়');
  static const colRecognised = StText('Recognised on', 'স্বীকৃতির তারিখ');
  static const colGross = StText('Gross', 'মোট');
  static const colCommission = StText('Commission', 'কমিশন');
  static const colNet = StText('Net', 'নিট');
  static const notYet = StText('Not yet recognised', 'এখনো স্বীকৃত নয়');
  static const detailTitle = StText('Earning entry', 'আয়ের এন্ট্রি');
  static const source = StText('Source', 'উৎস');
  static const reference = StText('Reference', 'রেফারেন্স');
  static const recognitionEvent = StText('Recognition event', 'স্বীকৃতির ঘটনা');
  static const holdReason = StText('Hold reason', 'আটকের কারণ');
  static const commissionNote = StText(
    'Commission is a sample figure until the commission rule (BR-009) is approved.',
    'কমিশনের নিয়ম (BR-009) অনুমোদনের আগে কমিশন একটি নমুনা সংখ্যা।',
  );
  static const close = StText('Close', 'বন্ধ করুন');
  static const requestTitle = StText('Request a payout', 'পেআউটের অনুরোধ');
  static const pending = StText(
    'Requested, not settled',
    'অনুরোধ করা, নিষ্পন্ন নয়',
  );
  static const requestNote = StText(
    'You can request up to your eligible balance. Held amounts are not included.',
    'আপনি উত্তোলনযোগ্য ব্যালেন্স পর্যন্ত অনুরোধ করতে পারেন। আটকে থাকা পরিমাণ এতে নেই।',
  );
  static const amountLabel = StText('Amount (৳)', 'পরিমাণ (৳)');
  static const destination = StText(
    'Approved destination',
    'অনুমোদিত অ্যাকাউন্ট',
  );
  static const confirmDestination = StText(
    'Send to this approved account',
    'এই অনুমোদিত অ্যাকাউন্টে পাঠান',
  );
  static const confirmNeeded = StText(
    'Confirm the destination.',
    'অ্যাকাউন্টটি নিশ্চিত করুন।',
  );
  static const submit = StText('Request payout', 'পেআউট অনুরোধ করুন');
  static const commandName = StText('Payout request', 'পেআউট অনুরোধ');
  static const success = StText(
    'Payout requested. Track it in payout history.',
    'পেআউট অনুরোধ করা হয়েছে। পেআউট ইতিহাসে দেখুন।',
  );
  static const notPaidNote = StText(
    'A request is not a payment. It shows as settled only after the transfer is confirmed.',
    'অনুরোধ মানে পেমেন্ট নয়। ট্রান্সফার নিশ্চিত হলে তবেই নিষ্পন্ন দেখাবে।',
  );
  static const historyTitle = StText('Payout requests', 'পেআউট অনুরোধ');
  static const historyEmpty = StText(
    'No payout requests yet',
    'এখনো কোনো পেআউট অনুরোধ নেই',
  );
  static const historyNote = StText(
    'Settled means the transfer is confirmed. Requested and processing amounts are not paid yet.',
    'নিষ্পন্ন মানে ট্রান্সফার নিশ্চিত। অনুরোধ করা ও প্রক্রিয়াধীন পরিমাণ এখনো পরিশোধ হয়নি।',
  );
  static const colRequested = StText('Requested on', 'অনুরোধের তারিখ');
  static const colDestination = StText('Destination', 'গন্তব্য');
  static const colReference = StText(
    'Transfer reference',
    'ট্রান্সফার রেফারেন্স',
  );
}
