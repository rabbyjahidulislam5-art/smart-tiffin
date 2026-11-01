import 'package:st_domain/st_domain.dart';

/// Texts of NF-02, NF-13 and NF-17 (accounts-web/PAYMENT_RECONCILIATION.md).
abstract final class PaymentReconciliationText {
  static const eyebrow = StText('Accounts', 'অ্যাকাউন্টস');
  static const title = StText(
    'Online payment reconciliation',
    'অনলাইন পেমেন্ট মিলকরণ',
  );
  static const intro = StText(
    'Gateway records are matched to ledger postings. A mismatch raises an exception; resolution never corrects a balance automatically.',
    'গেটওয়ের রেকর্ড লেজারের পোস্টিংয়ের সাথে মেলানো হয়। অমিল হলে ব্যতিক্রম তৈরি হয়; সমাধানে কখনো ব্যালেন্স নিজে থেকে সংশোধন হয় না।',
  );
  static const matched = StText('Matched', 'মিলেছে');
  static const exception = StText('Exception', 'ব্যতিক্রম');
  static const resolving = StText('Resolving', 'সমাধান চলছে');
  static const colPayment = StText('Payment', 'পেমেন্ট');
  static const colGateway = StText('Gateway', 'গেটওয়ে');
  static const colLedger = StText('Ledger', 'লেজার');
  static const colDifference = StText('Difference', 'পার্থক্য');
  static const openExceptions = StText('Open exceptions', 'খোলা ব্যতিক্রম');
  static const openStatements = StText(
    'Gateway statements',
    'গেটওয়ে স্টেটমেন্ট',
  );
  static const empty = StText('Nothing to reconcile', 'মেলানোর কিছু নেই');
  static const exTitle = StText(
    'Reconciliation exceptions',
    'মিলকরণের ব্যতিক্রম',
  );
  static const unmatched = StText('Unmatched', 'মেলেনি');
  static const duplicate = StText('Duplicate', 'দ্বৈত');
  static const invalid = StText('Invalid', 'অবৈধ');
  static const open = StText('Open', 'খোলা');
  static const assigned = StText('Assigned to {0}', '{0}-কে দেওয়া');
  static const resolved = StText('Resolved', 'সমাধান');
  static const assignTo = StText('Assign selected to', 'বেছে নেওয়াগুলো দিন');
  static const assign = StText('Assign', 'দায়িত্ব দিন');
  static const assignConfirmTitle = StText(
    'Assign {0} exceptions?',
    '{0}টি ব্যতিক্রম দায়িত্বে দেবেন?',
  );
  static const assignConfirmBody = StText(
    '{0} exceptions will be assigned to {1}. Nothing else changes.',
    '{0}টি ব্যতিক্রম {1}-কে দেওয়া হবে। আর কিছু বদলাবে না।',
  );
  static const assignName = StText(
    'Assigning the exceptions',
    'ব্যতিক্রম দায়িত্বে দেওয়া',
  );
  static const assignDone = StText(
    'Exceptions assigned.',
    'ব্যতিক্রম দায়িত্বে দেওয়া হয়েছে।',
  );
  static const selectFirst = StText(
    'Select at least one open exception.',
    'অন্তত একটি খোলা ব্যতিক্রম বেছে নিন।',
  );
  static const noExceptions = StText('No exceptions', 'কোনো ব্যতিক্রম নেই');
  static const stTitle = StText(
    'Gateway settlement statement',
    'গেটওয়ে নিষ্পত্তি স্টেটমেন্ট',
  );
  static const stIntro = StText(
    'Provider statements are compared line by line with platform records. Fees, refund deductions and withholding are separate lines. Deviations are resolved with evidence, never assumed away.',
    'প্রোভাইডারের স্টেটমেন্ট প্ল্যাটফর্মের রেকর্ডের সাথে লাইন ধরে মেলানো হয়। ফি, রিফান্ড কর্তন ও উৎসে কর আলাদা লাইন। অমিল প্রমাণসহ সমাধান হয়, ধরে নেওয়া হয় না।',
  );
  static const lineKindPayment = StText('Payment', 'পেমেন্ট');
  static const lineKindFee = StText('Processor fee', 'প্রসেসর ফি');
  static const lineKindRefund = StText('Refund deduction', 'রিফান্ড কর্তন');
  static const lineKindWithholding = StText('Withholding', 'উৎসে কর');
  static const colStatement = StText('Statement', 'স্টেটমেন্ট');
  static const colRecord = StText('Our record', 'আমাদের রেকর্ড');
  static const deviation = StText('Deviation', 'অমিল');
  static const imported = StText('Imported', 'আমদানিকৃত');
  static const reconciled = StText('Reconciled', 'মিলানো হয়েছে');
  static const evidence = StText('Evidence reference', 'প্রমাণের রেফারেন্স');
  static const reconcile = StText('Reconcile with evidence', 'প্রমাণসহ মেলান');
  static const reconcileName = StText(
    'Reconciling the statement',
    'স্টেটমেন্ট মিলকরণ',
  );
  static const reconcileDone = StText(
    'Statement reconciled.',
    'স্টেটমেন্ট মিলানো হয়েছে।',
  );
  static const reconcileBody = StText(
    'Enter the reference of the statement or transaction query that explains the deviation (at least 4 characters).',
    'অমিল ব্যাখ্যা করে এমন স্টেটমেন্ট বা লেনদেন অনুসন্ধানের রেফারেন্স দিন (অন্তত ৪ অক্ষর)।',
  );
  static const importStatement = StText(
    'Import a statement',
    'স্টেটমেন্ট আমদানি',
  );
  static const importGap = StText(
    'The import mechanism is not decided yet.',
    'আমদানির পদ্ধতি এখনো ঠিক হয়নি।',
  );
  static const evidenceOn = StText('Evidence {0}', 'প্রমাণ {0}');
  static const noStatements = StText('No statements', 'কোনো স্টেটমেন্ট নেই');

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'intro': intro,
    'matched': matched,
    'exception': exception,
    'resolving': resolving,
    'colPayment': colPayment,
    'colGateway': colGateway,
    'colLedger': colLedger,
    'colDifference': colDifference,
    'openExceptions': openExceptions,
    'openStatements': openStatements,
    'empty': empty,
    'exTitle': exTitle,
    'unmatched': unmatched,
    'duplicate': duplicate,
    'invalid': invalid,
    'open': open,
    'assigned': assigned,
    'resolved': resolved,
    'assignTo': assignTo,
    'assign': assign,
    'assignConfirmTitle': assignConfirmTitle,
    'assignConfirmBody': assignConfirmBody,
    'assignName': assignName,
    'assignDone': assignDone,
    'selectFirst': selectFirst,
    'noExceptions': noExceptions,
    'stTitle': stTitle,
    'stIntro': stIntro,
    'lineKindPayment': lineKindPayment,
    'lineKindFee': lineKindFee,
    'lineKindRefund': lineKindRefund,
    'lineKindWithholding': lineKindWithholding,
    'colStatement': colStatement,
    'colRecord': colRecord,
    'deviation': deviation,
    'imported': imported,
    'reconciled': reconciled,
    'evidence': evidence,
    'reconcile': reconcile,
    'reconcileName': reconcileName,
    'reconcileDone': reconcileDone,
    'reconcileBody': reconcileBody,
    'importStatement': importStatement,
    'importGap': importGap,
    'evidenceOn': evidenceOn,
    'noStatements': noStatements,
  };
}
