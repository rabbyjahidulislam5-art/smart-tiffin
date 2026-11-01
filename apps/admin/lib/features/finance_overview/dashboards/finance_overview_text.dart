import 'package:st_domain/st_domain.dart';

/// Texts of NF-01 (accounts-web/FINANCE_DASHBOARD.md, ACCOUNTS_UI_UX.md).
abstract final class FinanceOverviewText {
  static const eyebrow = StText('Accounts', 'অ্যাকাউন্টস');
  static const title = StText('Finance overview', 'আর্থিক সারসংক্ষেপ');
  static const period = StText(
    'Period {0} · updated {1}',
    'পিরিয়ড {0} · হালনাগাদ {1}',
  );
  static const cash = StText('Cash movement', 'নগদ চলাচল');
  static const recognised = StText(
    'Recognised (accrual)',
    'স্বীকৃত (অ্যাক্রুয়াল)',
  );
  static const verifiedCollections = StText(
    'Verified collections',
    'যাচাইকৃত আদায়',
  );
  static const receivables = StText('Receivables', 'প্রাপ্য');
  static const supplierPayables = StText(
    'Supplier payables',
    'সরবরাহকারী পাওনা',
  );
  static const riderPayables = StText('Rider payables', 'রাইডার পাওনা');
  static const creditLiability = StText(
    'Customer credit liability',
    'গ্রাহক ক্রেডিট দায়',
  );
  static const codAwaiting = StText(
    'COD awaiting verification',
    'যাচাইয়ের অপেক্ষায় সিওডি',
  );
  static const availableFunds = StText('Available funds', 'উপলব্ধ তহবিল');
  static const availableNote = StText(
    'Excludes money in pending payout batches',
    'অপেক্ষমাণ পেআউট ব্যাচের টাকা বাদে',
  );
  static const pendingSettlements = StText(
    'Pending settlements',
    'অপেক্ষমাণ নিষ্পত্তি',
  );
  static const completedSettlements = StText(
    'Completed settlements',
    'সম্পন্ন নিষ্পত্তি',
  );
  static const refundObligations = StText(
    'Refund obligations',
    'রিফান্ডের দায়',
  );
  static const revenue = StText('Platform revenue', 'প্ল্যাটফর্ম আয়');
  static const exceptions = StText('Open exceptions', 'খোলা ব্যতিক্রম');
  static const drill = StText(
    'Every figure opens its supporting records before you approve an operation.',
    'কোনো কাজ অনুমোদনের আগে প্রতিটি সংখ্যা তার সহায়ক রেকর্ড খোলে।',
  );
  static const sample = StText(
    'Figures are hypothetical sample data.',
    'সংখ্যাগুলো কাল্পনিক নমুনা তথ্য।',
  );

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'period': period,
    'cash': cash,
    'recognised': recognised,
    'verifiedCollections': verifiedCollections,
    'receivables': receivables,
    'supplierPayables': supplierPayables,
    'riderPayables': riderPayables,
    'creditLiability': creditLiability,
    'codAwaiting': codAwaiting,
    'availableFunds': availableFunds,
    'availableNote': availableNote,
    'pendingSettlements': pendingSettlements,
    'completedSettlements': completedSettlements,
    'refundObligations': refundObligations,
    'revenue': revenue,
    'exceptions': exceptions,
    'drill': drill,
    'sample': sample,
  };
}
