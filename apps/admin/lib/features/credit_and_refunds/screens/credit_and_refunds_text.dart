import 'package:st_domain/st_domain.dart';

/// Texts of NF-09, NF-10 and NF-16 (accounts-web/REFUNDS_AND_ADJUSTMENTS.md).
abstract final class CreditAndRefundsText {
  static const eyebrow = StText('Accounts', 'অ্যাকাউন্টস');
  static const creditTitle = StText(
    'Customer credit liability',
    'গ্রাহক ক্রেডিট দায়',
  );
  static const creditIntro = StText(
    'Service credits are a liability to deliver food, not cash available to the customer. Issued, consumed and voided credits are tracked separately.',
    'সার্ভিস ক্রেডিট খাবার দেওয়ার দায়, গ্রাহকের হাতে থাকা নগদ নয়। দেওয়া, ব্যবহৃত ও বাতিল ক্রেডিট আলাদা হিসাব হয়।',
  );
  static const issued = StText('Issued', 'দেওয়া');
  static const consumed = StText('Consumed', 'ব্যবহৃত');
  static const voided = StText('Voided', 'বাতিল');
  static const remaining = StText('Remaining liability', 'অবশিষ্ট দায়');
  static const colCustomer = StText('Customer', 'গ্রাহক');
  static const voidCredit = StText('Void credit', 'ক্রেডিট বাতিল');
  static const voidName = StText('Voiding the credit', 'ক্রেডিট বাতিল');
  static const voidDone = StText('Credit voided.', 'ক্রেডিট বাতিল হয়েছে।');
  static const voidBody = StText(
    'Voiding records a separate movement; nothing is deleted (at least 5 characters).',
    'বাতিলে আলাদা একটি চলাচল রেকর্ড হয়; কিছু মোছা হয় না (অন্তত ৫ অক্ষর)।',
  );
  static const noCredits = StText(
    'No credit movements',
    'কোনো ক্রেডিট চলাচল নেই',
  );
  static const refundTitle = StText(
    'Refund and chargeback management',
    'রিফান্ড ও চার্জব্যাক ব্যবস্থাপনা',
  );
  static const refundIntro = StText(
    'Gateway refunds and chargebacks are separate workflows; service credits are issued in the credit ledger. A refund and a credit are never both granted for the same obligation (INV-17).',
    'গেটওয়ে রিফান্ড ও চার্জব্যাক আলাদা প্রক্রিয়া; সার্ভিস ক্রেডিট দেওয়া হয় ক্রেডিট খতিয়ানে। একই দায়ের জন্য রিফান্ড ও ক্রেডিট দুটোই কখনো দেওয়া হয় না (INV-17)।',
  );
  static const refund = StText('Refund', 'রিফান্ড');
  static const chargeback = StText('Chargeback', 'চার্জব্যাক');
  static const pending = StText('Pending', 'অপেক্ষমাণ');
  static const approved = StText('Approved', 'অনুমোদিত');
  static const executed = StText('Executed', 'সম্পন্ন');
  static const disputed = StText('Disputed', 'বিরোধপূর্ণ');
  static const creditBlocks = StText(
    'A credit was already issued for this obligation (INV-17).',
    'এই দায়ের জন্য আগেই ক্রেডিট দেওয়া হয়েছে (INV-17)।',
  );
  static const initiate = StText('Initiate refund', 'রিফান্ড শুরু');
  static const initiateName = StText('Initiating the refund', 'রিফান্ড শুরু');
  static const initiateDone = StText(
    'Refund approved for execution.',
    'সম্পাদনের জন্য রিফান্ড অনুমোদিত।',
  );
  static const providerRef = StText(
    'Provider reference',
    'প্রোভাইডার রেফারেন্স',
  );
  static const refundExecuted = StText(
    'The gateway executed the refund',
    'গেটওয়ে রিফান্ড সম্পন্ন করেছে',
  );
  static const recordResult = StText(
    'Record refund result',
    'রিফান্ডের ফল রেকর্ড',
  );
  static const resultName = StText(
    'Recording the refund result',
    'রিফান্ডের ফল রেকর্ড',
  );
  static const resultDone = StText(
    'Refund result recorded.',
    'রিফান্ডের ফল রেকর্ড হয়েছে।',
  );
  static const refShort = StText(
    'Enter the provider reference (at least 4 characters).',
    'প্রোভাইডার রেফারেন্স লিখুন (অন্তত ৪ অক্ষর)।',
  );
  static const evidenceReview = StText(
    'Review chargeback evidence',
    'চার্জব্যাকের প্রমাণ পর্যালোচনা',
  );
  static const evidenceGap = StText(
    'Chargeback evidence review and loss allocation (BR-015) are not available yet.',
    'চার্জব্যাকের প্রমাণ পর্যালোচনা ও ক্ষতি বণ্টন (BR-015) এখনো চালু হয়নি।',
  );
  static const openCredits = StText('Service credits', 'সার্ভিস ক্রেডিট');
  static const noCases = StText(
    'No refund or chargeback cases',
    'কোনো রিফান্ড বা চার্জব্যাক কেস নেই',
  );
  static const adjTitle = StText(
    'Financial adjustment approval',
    'আর্থিক সমন্বয় অনুমোদন',
  );
  static const adjIntro = StText(
    'Rare manual corrections. The preparer cannot approve their own request; approval posts a new correcting journal and never overwrites a balance (INV-02).',
    'বিরল ম্যানুয়াল সংশোধন। প্রস্তুতকারী নিজের অনুরোধ অনুমোদন করতে পারেন না; অনুমোদনে নতুন সংশোধনী জার্নাল পোস্ট হয়, কোনো ব্যালেন্স মুছে লেখা হয় না (INV-02)।',
  );
  static const adjDescription = StText('Description', 'বিবরণ');
  static const adjAmount = StText('Amount (৳)', 'পরিমাণ (৳)');
  static const adjReduces = StText(
    'This correction reduces a balance',
    'এই সংশোধনে ব্যালেন্স কমে',
  );
  static const adjEvidence = StText('Evidence reference', 'প্রমাণের রেফারেন্স');
  static const adjSubmit = StText('Request adjustment', 'সমন্বয়ের অনুরোধ');
  static const adjName = StText(
    'Requesting the adjustment',
    'সমন্বয়ের অনুরোধ',
  );
  static const adjDone = StText(
    'Adjustment requested for approval.',
    'অনুমোদনের জন্য সমন্বয়ের অনুরোধ করা হয়েছে।',
  );
  static const adjDescShort = StText(
    'Describe the correction (at least 10 characters).',
    'সংশোধনের বিবরণ দিন (অন্তত ১০ অক্ষর)।',
  );
  static const adjEvidenceShort = StText(
    'Enter the evidence reference (at least 4 characters).',
    'প্রমাণের রেফারেন্স লিখুন (অন্তত ৪ অক্ষর)।',
  );
  static const adjRequested = StText('Requested', 'অনুরোধ করা');
  static const adjApproved = StText('Approved', 'অনুমোদিত');
  static const adjRejected = StText('Rejected', 'প্রত্যাখ্যাত');
  static const adjMaker = StText('Prepared by {0}', '{0} প্রস্তুত করেছেন');
  static const adjChecker = StText('Decided by {0}', '{0} সিদ্ধান্ত দিয়েছেন');
  static const adjApprove = StText('Approve', 'অনুমোদন');
  static const adjReject = StText('Reject', 'প্রত্যাখ্যান');
  static const adjSelf = StText(
    'You prepared this adjustment; another manager must decide it.',
    'আপনি এই সমন্বয় প্রস্তুত করেছেন; অন্য একজন ম্যানেজারকে সিদ্ধান্ত দিতে হবে।',
  );
  static const adjDecideName = StText(
    'Deciding the adjustment',
    'সমন্বয়ের সিদ্ধান্ত',
  );
  static const adjApprovedDone = StText(
    'Adjustment approved; a correcting journal is posted.',
    'সমন্বয় অনুমোদিত; একটি সংশোধনী জার্নাল পোস্ট হয়েছে।',
  );
  static const adjRejectedDone = StText(
    'Adjustment rejected.',
    'সমন্বয় প্রত্যাখ্যাত।',
  );
  static const noAdjustments = StText('No adjustments', 'কোনো সমন্বয় নেই');

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'creditTitle': creditTitle,
    'creditIntro': creditIntro,
    'issued': issued,
    'consumed': consumed,
    'voided': voided,
    'remaining': remaining,
    'colCustomer': colCustomer,
    'voidCredit': voidCredit,
    'voidName': voidName,
    'voidDone': voidDone,
    'voidBody': voidBody,
    'noCredits': noCredits,
    'refundTitle': refundTitle,
    'refundIntro': refundIntro,
    'refund': refund,
    'chargeback': chargeback,
    'pending': pending,
    'approved': approved,
    'executed': executed,
    'disputed': disputed,
    'creditBlocks': creditBlocks,
    'initiate': initiate,
    'initiateName': initiateName,
    'initiateDone': initiateDone,
    'providerRef': providerRef,
    'refundExecuted': refundExecuted,
    'recordResult': recordResult,
    'resultName': resultName,
    'resultDone': resultDone,
    'refShort': refShort,
    'evidenceReview': evidenceReview,
    'evidenceGap': evidenceGap,
    'openCredits': openCredits,
    'noCases': noCases,
    'adjTitle': adjTitle,
    'adjIntro': adjIntro,
    'adjDescription': adjDescription,
    'adjAmount': adjAmount,
    'adjReduces': adjReduces,
    'adjEvidence': adjEvidence,
    'adjSubmit': adjSubmit,
    'adjName': adjName,
    'adjDone': adjDone,
    'adjDescShort': adjDescShort,
    'adjEvidenceShort': adjEvidenceShort,
    'adjRequested': adjRequested,
    'adjApproved': adjApproved,
    'adjRejected': adjRejected,
    'adjMaker': adjMaker,
    'adjChecker': adjChecker,
    'adjApprove': adjApprove,
    'adjReject': adjReject,
    'adjSelf': adjSelf,
    'adjDecideName': adjDecideName,
    'adjApprovedDone': adjApprovedDone,
    'adjRejectedDone': adjRejectedDone,
    'noAdjustments': noAdjustments,
  };
}
