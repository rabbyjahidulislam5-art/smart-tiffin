import 'package:st_domain/st_domain.dart';

/// Texts of NR-03..NR-05 (partner-app/COD_COLLECTION.md; SC-09, INV-12).
abstract final class CodText {
  static const eyebrow = StText('COD cash', 'সিওডি নগদ');
  static const collectTitle = StText(
    'Record cash collected',
    'সংগৃহীত নগদ রেকর্ড',
  );
  static const collectNote = StText(
    'Enter the exact cash the customer paid. It becomes company money you hold, never your income.',
    'গ্রাহক যত নগদ দিয়েছেন ঠিক তত লিখুন। এটি আপনার কাছে থাকা কোম্পানির টাকা, কখনো আপনার আয় নয়।',
  );
  static const expectedAmount = StText('Expected {0}', 'প্রত্যাশিত {0}');
  static const amountLabel = StText('Cash received (৳)', 'প্রাপ্ত নগদ (৳)');
  static const acknowledged = StText(
    'The customer confirmed this amount',
    'গ্রাহক এই পরিমাণ নিশ্চিত করেছেন',
  );
  static const ackNeeded = StText(
    'Ask the customer to confirm the amount.',
    'গ্রাহককে পরিমাণটি নিশ্চিত করতে বলুন।',
  );
  static const chooseOrder = StText(
    'Choose an order.',
    'একটি অর্ডার বেছে নিন।',
  );
  static const record = StText('Record collection', 'সংগ্রহ রেকর্ড করুন');
  static const recordName = StText('Recording the collection', 'সংগ্রহ রেকর্ড');
  static const recorded = StText(
    'Collection recorded. Remit it before the deadline.',
    'সংগ্রহ রেকর্ড হয়েছে। সময়সীমার আগে জমা দিন।',
  );
  static const nothingToCollect = StText(
    'No cash orders to collect',
    'সংগ্রহের জন্য কোনো নগদ অর্ডার নেই',
  );
  static const toRemit = StText('Go to remittance', 'জমা দেওয়ায় যান');
  static const remitTitle = StText('COD remittance', 'সিওডি জমা');
  static const liability = StText('Cash to remit', 'জমা দেওয়ার নগদ');
  static const liabilityNote = StText(
    'Stays due until Accounts verifies your deposit. A partial deposit reduces the amount but does not close it.',
    'অ্যাকাউন্টস আপনার জমা যাচাই না করা পর্যন্ত বকেয়া থাকে। আংশিক জমায় পরিমাণ কমে, তবে বন্ধ হয় না।',
  );
  static const collected = StText('Collected cash', 'সংগৃহীত নগদ');
  static const deposits = StText('Your deposits', 'আপনার জমা');
  static const method = StText('Method', 'পদ্ধতি');
  static const bank = StText('Bank deposit', 'ব্যাংক জমা');
  static const bkash = StText('bKash transfer', 'বিকাশ ট্রান্সফার');
  static const reference = StText('Deposit reference', 'জমার রেফারেন্স');
  static const referenceShort = StText(
    'Enter the deposit reference (at least 4 characters).',
    'জমার রেফারেন্স লিখুন (অন্তত ৪ অক্ষর)।',
  );
  static const submit = StText('Submit remittance', 'জমার তথ্য দাখিল করুন');
  static const submitName = StText('Submitting the remittance', 'জমা দাখিল');
  static const submitted = StText(
    'Remittance submitted for verification.',
    'যাচাইয়ের জন্য জমা দাখিল হয়েছে।',
  );
  static const statusSubmitted = StText('Submitted', 'দাখিল');
  static const statusPartial = StText('Partial', 'আংশিক');
  static const statusVerified = StText('Verified', 'যাচাইকৃত');
  static const statusRejected = StText('Rejected', 'প্রত্যাখ্যাত');
  static const noDeposits = StText('No deposits yet', 'এখনো কোনো জমা নেই');
  static const discrepancies = StText('Mismatch cases', 'অমিলের কেস');
  static const discrepancyTitle = StText('COD mismatch', 'সিওডি অমিল');
  static const discrepancyNote = StText(
    'Accounts found a difference between your deposit and the cash due. Respond with what happened; your earnings are never adjusted to hide a shortfall.',
    'অ্যাকাউন্টস আপনার জমা ও বকেয়া নগদের মধ্যে পার্থক্য পেয়েছে। কী হয়েছিল তা জানান; ঘাটতি লুকাতে আপনার আয় কখনো সমন্বয় করা হয় না।',
  );
  static const caseLine = StText(
    'Deposit {0}: expected {1}, declared {2}',
    'জমা {0}: প্রত্যাশিত {1}, ঘোষিত {2}',
  );
  static const difference = StText('Difference', 'পার্থক্য');
  static const statusOpen = StText('Open', 'খোলা');
  static const statusResponded = StText('Responded', 'উত্তর দেওয়া');
  static const statusResolved = StText('Resolved', 'নিষ্পন্ন');
  static const response = StText('Your response', 'আপনার উত্তর');
  static const responseShort = StText(
    'Write at least 10 characters.',
    'অন্তত ১০ অক্ষর লিখুন।',
  );
  static const respond = StText('Send response', 'উত্তর পাঠান');
  static const respondName = StText('Sending the response', 'উত্তর পাঠানো');
  static const responded = StText(
    'Response sent to Accounts.',
    'উত্তর অ্যাকাউন্টসে পাঠানো হয়েছে।',
  );
  static const yourResponse = StText('You wrote: {0}', 'আপনি লিখেছেন: {0}');
  static const attach = StText('Attach evidence', 'প্রমাণ সংযুক্ত করুন');
  static const attachGap = StText(
    'Attaching evidence files is not available yet.',
    'প্রমাণের ফাইল সংযুক্ত করা এখনো চালু হয়নি।',
  );
  static const noDiscrepancies = StText(
    'No mismatch cases',
    'কোনো অমিলের কেস নেই',
  );

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'collectTitle': collectTitle,
    'collectNote': collectNote,
    'expectedAmount': expectedAmount,
    'amountLabel': amountLabel,
    'acknowledged': acknowledged,
    'ackNeeded': ackNeeded,
    'chooseOrder': chooseOrder,
    'record': record,
    'recordName': recordName,
    'recorded': recorded,
    'nothingToCollect': nothingToCollect,
    'toRemit': toRemit,
    'remitTitle': remitTitle,
    'liability': liability,
    'liabilityNote': liabilityNote,
    'collected': collected,
    'deposits': deposits,
    'method': method,
    'bank': bank,
    'bkash': bkash,
    'reference': reference,
    'referenceShort': referenceShort,
    'submit': submit,
    'submitName': submitName,
    'submitted': submitted,
    'statusSubmitted': statusSubmitted,
    'statusPartial': statusPartial,
    'statusVerified': statusVerified,
    'statusRejected': statusRejected,
    'noDeposits': noDeposits,
    'discrepancies': discrepancies,
    'discrepancyTitle': discrepancyTitle,
    'discrepancyNote': discrepancyNote,
    'caseLine': caseLine,
    'difference': difference,
    'statusOpen': statusOpen,
    'statusResponded': statusResponded,
    'statusResolved': statusResolved,
    'response': response,
    'responseShort': responseShort,
    'respond': respond,
    'respondName': respondName,
    'responded': responded,
    'yourResponse': yourResponse,
    'attach': attach,
    'attachGap': attachGap,
    'noDiscrepancies': noDiscrepancies,
  };
}
