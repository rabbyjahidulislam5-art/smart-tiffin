import 'package:st_domain/st_domain.dart';

/// Texts of NR-01 and NR-02 (RIDER_SCREENS.md; partner-app/RIDER_EARNINGS.md).
abstract final class RiderEarningsText {
  static const eyebrow = StText('Rider earnings', 'রাইডারের আয়');
  static const title = StText('Earning ledger', 'আয়ের খতিয়ান');
  static const expected = StText('Expected', 'প্রত্যাশিত');
  static const expectedNote = StText(
    'Assigned, nothing to withdraw yet',
    'নির্ধারিত, এখনো তোলা যাবে না',
  );
  static const confirmed = StText('Confirmed', 'নিশ্চিত');
  static const held = StText('Held', 'আটকে আছে');
  static const eligible = StText('Eligible', 'উত্তোলনযোগ্য');
  static const settled = StText('Settled', 'নিষ্পন্ন');
  static const paid = StText('Paid', 'পরিশোধিত');
  static const reversed = StText('Reversed', 'বাতিলকৃত');
  static const codTitle = StText(
    'COD cash you hold',
    'আপনার কাছে থাকা সিওডি নগদ',
  );
  static const codNote = StText(
    'This is company money you hold, not your income. It is never added to or taken from your earnings.',
    'এটি আপনার কাছে থাকা কোম্পানির টাকা, আপনার আয় নয়। এটি কখনো আপনার আয়ে যোগ বা বাদ হয় না।',
  );
  static const deliveries = StText('Per delivery', 'প্রতি ডেলিভারি');
  static const filterAll = StText('All', 'সব');
  static const empty = StText(
    'No earnings with this status',
    'এই অবস্থার কোনো আয় নেই',
  );
  static const colDelivery = StText('Delivery', 'ডেলিভারি');
  static const colDate = StText('Date', 'তারিখ');
  static const colExpected = StText('Expected', 'প্রত্যাশিত');
  static const colReversed = StText('Reversed', 'বাতিল');
  static const colConfirmed = StText('Confirmed', 'নিশ্চিত');
  static const reportError = StText(
    'Report an earning error',
    'আয়ের ভুল জানান',
  );
  static const requestPayout = StText('Request payout', 'পেআউট অনুরোধ');
  static const remitCod = StText('Remit COD cash', 'সিওডি জমা দিন');
  static const payoutTitle = StText('Request a payout', 'পেআউটের অনুরোধ');
  static const payoutNote = StText(
    'Withdraw only your eligible balance. The COD cash you hold is shown separately and is never netted against a payout without an approved rule (BR-026).',
    'শুধু উত্তোলনযোগ্য ব্যালেন্স তুলুন। আপনার কাছে থাকা সিওডি নগদ আলাদা দেখানো হয় এবং অনুমোদিত নিয়ম (BR-026) ছাড়া কখনো পেআউট থেকে কাটা হয় না।',
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
    'Payout requested.',
    'পেআউট অনুরোধ করা হয়েছে।',
  );
  static const pending = StText(
    'Requested, not settled',
    'অনুরোধ করা, নিষ্পন্ন নয়',
  );
  static const recent = StText('Recent requests', 'সাম্প্রতিক অনুরোধ');
  static const noRequests = StText(
    'No payout requests yet',
    'এখনো কোনো পেআউট অনুরোধ নেই',
  );
  static const colRequest = StText('Request', 'অনুরোধ');

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'expected': expected,
    'expectedNote': expectedNote,
    'confirmed': confirmed,
    'held': held,
    'eligible': eligible,
    'settled': settled,
    'paid': paid,
    'reversed': reversed,
    'codTitle': codTitle,
    'codNote': codNote,
    'deliveries': deliveries,
    'filterAll': filterAll,
    'empty': empty,
    'colDelivery': colDelivery,
    'colDate': colDate,
    'colExpected': colExpected,
    'colReversed': colReversed,
    'colConfirmed': colConfirmed,
    'reportError': reportError,
    'requestPayout': requestPayout,
    'remitCod': remitCod,
    'payoutTitle': payoutTitle,
    'payoutNote': payoutNote,
    'amountLabel': amountLabel,
    'destination': destination,
    'confirmDestination': confirmDestination,
    'confirmNeeded': confirmNeeded,
    'submit': submit,
    'commandName': commandName,
    'success': success,
    'pending': pending,
    'recent': recent,
    'noRequests': noRequests,
    'colRequest': colRequest,
  };
}
