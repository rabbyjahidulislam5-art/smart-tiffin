import 'package:st_domain/st_domain.dart';

/// Texts of NF-11 and NF-12 (accounts-web/FINANCIAL_LEDGER.md).
abstract final class GeneralLedgerText {
  static const eyebrow = StText('Accounts', 'অ্যাকাউন্টস');
  static const ledgerTitle = StText('General ledger explorer', 'সাধারণ লেজার');
  static const ledgerIntro = StText(
    'Balanced journal entries with their source command and policy version. A posted entry is never edited; the only action is a reversing entry.',
    'উৎস কমান্ড ও নীতির সংস্করণসহ সুষম জার্নাল এন্ট্রি। পোস্ট করা এন্ট্রি কখনো সম্পাদনা হয় না; একমাত্র কাজ বিপরীত এন্ট্রি।',
  );
  static const allAccounts = StText('All accounts', 'সব হিসাব');
  static const colJournal = StText('Journal', 'জার্নাল');
  static const colDate = StText('Date', 'তারিখ');
  static const colSource = StText('Source', 'উৎস');
  static const colPolicy = StText('Policy version', 'নীতির সংস্করণ');
  static const debit = StText('Debit', 'ডেবিট');
  static const credit = StText('Credit', 'ক্রেডিট');
  static const posted = StText('Posted', 'পোস্ট করা');
  static const reversedStatus = StText('Reversed', 'বিপরীত করা');
  static const balanced = StText('Balanced', 'সুষম');
  static const unbalanced = StText('Not balanced', 'সুষম নয়');
  static const reversalOf = StText('Reversal of {0}', '{0}-এর বিপরীত');
  static const reversedBy = StText('Reversed by {0}', '{0} দ্বারা বিপরীত');
  static const reverse = StText('Reverse journal', 'জার্নাল বিপরীত');
  static const reverseTitle = StText(
    'Reverse this journal?',
    'এই জার্নাল বিপরীত করবেন?',
  );
  static const reverseBody = StText(
    'A new reversing entry is posted; the original stays (at least 10 characters).',
    'একটি নতুন বিপরীত এন্ট্রি পোস্ট হয়; মূলটি থেকে যায় (অন্তত ১০ অক্ষর)।',
  );
  static const reverseName = StText('Reversing the journal', 'জার্নাল বিপরীত');
  static const reverseDone = StText(
    'Reversing entry posted.',
    'বিপরীত এন্ট্রি পোস্ট হয়েছে।',
  );
  static const lines = StText('Lines', 'লাইন');
  static const noJournals = StText(
    'No journals for this account',
    'এই হিসাবের কোনো জার্নাল নেই',
  );
  static const close = StText('Close', 'বন্ধ করুন');
  static const periodTitle = StText('Period close workspace', 'পিরিয়ড ক্লোজ');
  static const periodIntro = StText(
    'Close a period only when the checklist is complete. A late event after close posts to the next open period with an adjusting reference, never backdated (INV-16).',
    'চেকলিস্ট সম্পূর্ণ হলে তবেই পিরিয়ড বন্ধ করুন। বন্ধের পরে আসা ঘটনা পরের খোলা পিরিয়ডে সমন্বয় রেফারেন্সসহ পোস্ট হয়, কখনো পেছনের তারিখে নয় (INV-16)।',
  );
  static const open = StText('Open', 'খোলা');
  static const closing = StText('Closing', 'বন্ধ হচ্ছে');
  static const closed = StText('Closed', 'বন্ধ');
  static const reopened = StText('Reopened', 'পুনরায় খোলা');
  static const checklist = StText('Close checklist', 'বন্ধের চেকলিস্ট');
  static const noChecklist = StText(
    'No checklist items for this period.',
    'এই পিরিয়ডের কোনো চেকলিস্ট নেই।',
  );
  static const closePeriod = StText('Close period', 'পিরিয়ড বন্ধ');
  static const closeBlocked = StText(
    'Complete every checklist item first.',
    'আগে চেকলিস্টের প্রতিটি কাজ শেষ করুন।',
  );
  static const closeName = StText('Closing the period', 'পিরিয়ড বন্ধ');
  static const closeDone = StText('Period closed.', 'পিরিয়ড বন্ধ হয়েছে।');
  static const reopen = StText('Reopen period', 'পিরিয়ড আবার খুলুন');
  static const reopenTitle = StText('Reopen the period', 'পিরিয়ড আবার খোলা');
  static const reopenBody = StText(
    'Reopening is governed: an independent approver is required (at least 10 characters).',
    'আবার খোলা নিয়ন্ত্রিত: একজন স্বতন্ত্র অনুমোদনকারী লাগবে (অন্তত ১০ অক্ষর)।',
  );
  static const reopenName = StText('Reopening the period', 'পিরিয়ড আবার খোলা');
  static const reopenDone = StText(
    'Period reopened.',
    'পিরিয়ড আবার খোলা হয়েছে।',
  );
  static const note = StText('Note: {0}', 'নোট: {0}');
  static const noPeriods = StText('No periods', 'কোনো পিরিয়ড নেই');

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'ledgerTitle': ledgerTitle,
    'ledgerIntro': ledgerIntro,
    'allAccounts': allAccounts,
    'colJournal': colJournal,
    'colDate': colDate,
    'colSource': colSource,
    'colPolicy': colPolicy,
    'debit': debit,
    'credit': credit,
    'posted': posted,
    'reversedStatus': reversedStatus,
    'balanced': balanced,
    'unbalanced': unbalanced,
    'reversalOf': reversalOf,
    'reversedBy': reversedBy,
    'reverse': reverse,
    'reverseTitle': reverseTitle,
    'reverseBody': reverseBody,
    'reverseName': reverseName,
    'reverseDone': reverseDone,
    'lines': lines,
    'noJournals': noJournals,
    'close': close,
    'periodTitle': periodTitle,
    'periodIntro': periodIntro,
    'open': open,
    'closing': closing,
    'closed': closed,
    'reopened': reopened,
    'checklist': checklist,
    'noChecklist': noChecklist,
    'closePeriod': closePeriod,
    'closeBlocked': closeBlocked,
    'closeName': closeName,
    'closeDone': closeDone,
    'reopen': reopen,
    'reopenTitle': reopenTitle,
    'reopenBody': reopenBody,
    'reopenName': reopenName,
    'reopenDone': reopenDone,
    'note': note,
    'noPeriods': noPeriods,
  };
}
