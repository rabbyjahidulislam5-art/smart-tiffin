import 'package:st_domain/st_domain.dart';

/// Texts of NF-07 and NF-08 (accounts-web/PAYOUT_MANAGEMENT.md; ADR-010).
abstract final class PayoutOperationsText {
  static const eyebrow = StText('Accounts', 'অ্যাকাউন্টস');
  static const reviewTitle = StText(
    'Payout request review',
    'পেআউট অনুরোধ পর্যালোচনা',
  );
  static const reviewIntro = StText(
    'Check each request against the eligible balance (INV-14) and the beneficiary verification, then approve or reject with a reason.',
    'প্রতিটি অনুরোধ উত্তোলনযোগ্য ব্যালেন্স (INV-14) ও প্রাপকের যাচাইয়ের সাথে মিলিয়ে দেখুন, তারপর কারণসহ অনুমোদন বা প্রত্যাখ্যান করুন।',
  );
  static const colParty = StText('Party', 'পক্ষ');
  static const eligible = StText('Eligible', 'উত্তোলনযোগ্য');
  static const supplier = StText('Supplier', 'সরবরাহকারী');
  static const rider = StText('Rider', 'রাইডার');
  static const verifiedBeneficiary = StText(
    'Beneficiary verified',
    'প্রাপক যাচাইকৃত',
  );
  static const unverifiedBeneficiary = StText(
    'Beneficiary not verified',
    'প্রাপক যাচাই হয়নি',
  );
  static const withinBalance = StText(
    'Within the eligible balance',
    'উত্তোলনযোগ্য ব্যালেন্সের মধ্যে',
  );
  static const aboveBalance = StText(
    'Above the eligible balance',
    'উত্তোলনযোগ্য ব্যালেন্সের বেশি',
  );
  static const requested = StText('Requested', 'অনুরোধ করা');
  static const approved = StText('Approved', 'অনুমোদিত');
  static const batched = StText('In a batch', 'ব্যাচে');
  static const rejected = StText('Rejected', 'প্রত্যাখ্যাত');
  static const approve = StText('Approve', 'অনুমোদন');
  static const approveBlocked = StText(
    'Fails the eligibility or beneficiary check.',
    'যোগ্যতা বা প্রাপক যাচাইয়ে মেলেনি।',
  );
  static const reject = StText('Reject', 'প্রত্যাখ্যান');
  static const rejectTitle = StText(
    'Reject the payout request',
    'পেআউট অনুরোধ প্রত্যাখ্যান',
  );
  static const reviewName = StText('Reviewing the payout', 'পেআউট পর্যালোচনা');
  static const approvedDone = StText(
    'Payout approved for batching.',
    'ব্যাচের জন্য পেআউট অনুমোদিত।',
  );
  static const rejectedDone = StText('Payout rejected.', 'পেআউট প্রত্যাখ্যাত।');
  static const reasonBody = StText(
    'The requester sees this reason (at least 5 characters).',
    'অনুরোধকারী এই কারণ দেখবেন (অন্তত ৫ অক্ষর)।',
  );
  static const empty = StText('No payout requests', 'কোনো পেআউট অনুরোধ নেই');
  static const batchTitle = StText(
    'Payout batch execution',
    'পেআউট ব্যাচ সম্পাদন',
  );
  static const batchIntro = StText(
    'An operator builds a batch from approved requests; a different approver releases it. Only the recorded external transfer result marks a payout settled; a failed transfer returns the requests to review.',
    'অপারেটর অনুমোদিত অনুরোধ থেকে ব্যাচ তৈরি করেন; অন্য একজন অনুমোদনকারী তা ছাড়েন। শুধু রেকর্ড করা বাহ্যিক ট্রান্সফারের ফল পেআউট নিষ্পন্ন করে; ব্যর্থ ট্রান্সফারে অনুরোধ আবার পর্যালোচনায় যায়।',
  );
  static const approvedRequests = StText(
    'Approved requests',
    'অনুমোদিত অনুরোধ',
  );
  static const createBatch = StText('Create batch', 'ব্যাচ তৈরি');
  static const createConfirmTitle = StText(
    'Create a batch of {0} requests?',
    '{0}টি অনুরোধের ব্যাচ তৈরি করবেন?',
  );
  static const createConfirmBody = StText(
    'Total {0}. The batch must be released by another approver.',
    'মোট {0}। ব্যাচটি অন্য একজন অনুমোদনকারীকে ছাড়তে হবে।',
  );
  static const createName = StText('Creating the batch', 'ব্যাচ তৈরি');
  static const createDone = StText('Batch prepared.', 'ব্যাচ প্রস্তুত।');
  static const selectFirst = StText(
    'Select at least one approved request.',
    'অন্তত একটি অনুমোদিত অনুরোধ বেছে নিন।',
  );
  static const batches = StText('Batches', 'ব্যাচ');
  static const prepared = StText('Prepared', 'প্রস্তুত');
  static const processing = StText('Processing', 'প্রক্রিয়াধীন');
  static const settled = StText('Settled', 'নিষ্পন্ন');
  static const failed = StText('Failed', 'ব্যর্থ');
  static const preparedBy = StText('Prepared by {0}', '{0} প্রস্তুত করেছেন');
  static const approvedBy = StText('Released by {0}', '{0} ছেড়েছেন');
  static const requestsCount = StText('{0} requests', '{0}টি অনুরোধ');
  static const release = StText('Release batch', 'ব্যাচ ছাড়ুন');
  static const releaseSelf = StText(
    'You prepared this batch; another approver must release it.',
    'আপনি এই ব্যাচ প্রস্তুত করেছেন; অন্য একজন অনুমোদনকারীকে ছাড়তে হবে।',
  );
  static const releaseName = StText('Releasing the batch', 'ব্যাচ ছাড়া');
  static const releaseDone = StText(
    'Batch released for transfer.',
    'ট্রান্সফারের জন্য ব্যাচ ছাড়া হয়েছে।',
  );
  static const recordResult = StText(
    'Record transfer result',
    'ট্রান্সফারের ফল রেকর্ড',
  );
  static const transferRef = StText(
    'Transfer reference',
    'ট্রান্সফার রেফারেন্স',
  );
  static const transferSettled = StText(
    'The bank or MFS confirmed the transfer',
    'ব্যাংক বা এমএফএস ট্রান্সফার নিশ্চিত করেছে',
  );
  static const refShort = StText(
    'Enter the transfer reference (at least 4 characters).',
    'ট্রান্সফার রেফারেন্স লিখুন (অন্তত ৪ অক্ষর)।',
  );
  static const resultName = StText('Recording the result', 'ফল রেকর্ড');
  static const resultDone = StText(
    'Transfer result recorded.',
    'ট্রান্সফারের ফল রেকর্ড হয়েছে।',
  );
  static const dualApproval = StText(
    'The dual-approval threshold (policy.payout.dual_approval_threshold, BR-020) is pending.',
    'দ্বৈত অনুমোদনের সীমা (policy.payout.dual_approval_threshold, BR-020) এখনো বাকি।',
  );
  static const noBatches = StText('No batches', 'কোনো ব্যাচ নেই');

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'reviewTitle': reviewTitle,
    'reviewIntro': reviewIntro,
    'colParty': colParty,
    'eligible': eligible,
    'supplier': supplier,
    'rider': rider,
    'verifiedBeneficiary': verifiedBeneficiary,
    'unverifiedBeneficiary': unverifiedBeneficiary,
    'withinBalance': withinBalance,
    'aboveBalance': aboveBalance,
    'requested': requested,
    'approved': approved,
    'batched': batched,
    'rejected': rejected,
    'approve': approve,
    'approveBlocked': approveBlocked,
    'reject': reject,
    'rejectTitle': rejectTitle,
    'reviewName': reviewName,
    'approvedDone': approvedDone,
    'rejectedDone': rejectedDone,
    'reasonBody': reasonBody,
    'empty': empty,
    'batchTitle': batchTitle,
    'batchIntro': batchIntro,
    'approvedRequests': approvedRequests,
    'createBatch': createBatch,
    'createConfirmTitle': createConfirmTitle,
    'createConfirmBody': createConfirmBody,
    'createName': createName,
    'createDone': createDone,
    'selectFirst': selectFirst,
    'batches': batches,
    'prepared': prepared,
    'processing': processing,
    'settled': settled,
    'failed': failed,
    'preparedBy': preparedBy,
    'approvedBy': approvedBy,
    'requestsCount': requestsCount,
    'release': release,
    'releaseSelf': releaseSelf,
    'releaseName': releaseName,
    'releaseDone': releaseDone,
    'recordResult': recordResult,
    'transferRef': transferRef,
    'transferSettled': transferSettled,
    'refShort': refShort,
    'resultName': resultName,
    'resultDone': resultDone,
    'dualApproval': dualApproval,
    'noBatches': noBatches,
  };
}
