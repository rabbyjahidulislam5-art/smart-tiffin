import 'package:st_domain/st_domain.dart';

/// Texts of NF-03 and NF-04 (accounts-web/COD_RECONCILIATION.md; INV-12).
abstract final class CodVerificationText {
  static const eyebrow = StText('Accounts', 'অ্যাকাউন্টস');
  static const custodyTitle = StText(
    'COD collection dashboard',
    'সিওডি সংগ্রহ ড্যাশবোর্ড',
  );
  static const custodyIntro = StText(
    'Cash custody per rider and date, overdue first. The overdue deadline (BR-013) is pending, so overdue comes from the sample data.',
    'রাইডার ও তারিখ অনুযায়ী নগদ জিম্মা, আগে মেয়াদোত্তীর্ণ। মেয়াদের নিয়ম (BR-013) এখনো বাকি, তাই মেয়াদোত্তীর্ণ তথ্য নমুনা থেকে আসে।',
  );
  static const colRider = StText('Rider', 'রাইডার');
  static const colDate = StText('Date', 'তারিখ');
  static const colHeld = StText('Held', 'জিম্মায়');
  static const colRemitted = StText('Remitted', 'জমা');
  static const outstanding = StText('Outstanding', 'বকেয়া');
  static const overdue = StText('Overdue', 'মেয়াদোত্তীর্ণ');
  static const onTime = StText('On time', 'সময়মতো');
  static const settled = StText('Settled', 'নিষ্পন্ন');
  static const verifyDeposits = StText('Verify deposits', 'জমা যাচাই করুন');
  static const empty = StText(
    'No COD custody to show',
    'দেখানোর মতো কোনো সিওডি জিম্মা নেই',
  );
  static const verifyTitle = StText(
    'COD deposit verification',
    'সিওডি জমা যাচাই',
  );
  static const verifyIntro = StText(
    'Confirm a remittance against its deposit reference and amount. An image alone never confirms cash, and a receipt cannot be verified twice.',
    'জমার রেফারেন্স ও পরিমাণ মিলিয়ে রেমিট্যান্স নিশ্চিত করুন। শুধু ছবি দিয়ে নগদ নিশ্চিত হয় না, আর একটি রসিদ দুবার যাচাই করা যায় না।',
  );
  static const pending = StText('Pending', 'অপেক্ষমাণ');
  static const verified = StText('Verified', 'যাচাইকৃত');
  static const rejected = StText('Rejected', 'প্রত্যাখ্যাত');
  static const declared = StText('Declared', 'ঘোষিত');
  static const expected = StText('Expected', 'প্রত্যাশিত');
  static const difference = StText('Difference', 'পার্থক্য');
  static const method = StText('Method', 'পদ্ধতি');
  static const reference = StText('Deposit reference', 'জমার রেফারেন্স');
  static const typeReference = StText(
    'Type the deposit reference from the bank or MFS record',
    'ব্যাংক বা এমএফএস রেকর্ড থেকে জমার রেফারেন্স লিখুন',
  );
  static const referenceMismatch = StText(
    'Enter the deposit reference exactly as recorded.',
    'রেকর্ডে যেমন আছে ঠিক তেমন জমার রেফারেন্স লিখুন।',
  );
  static const verify = StText('Verify deposit', 'জমা যাচাই');
  static const reject = StText('Reject deposit', 'জমা প্রত্যাখ্যান');
  static const verifyName = StText('Verifying the deposit', 'জমা যাচাই');
  static const verifyDone = StText('Deposit verified.', 'জমা যাচাই হয়েছে।');
  static const rejectDone = StText(
    'Deposit rejected.',
    'জমা প্রত্যাখ্যাত হয়েছে।',
  );
  static const by = StText('Verified by {0}', '{0} যাচাই করেছেন');
  static const noCases = StText(
    'No deposits to verify',
    'যাচাইয়ের মতো কোনো জমা নেই',
  );

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'custodyTitle': custodyTitle,
    'custodyIntro': custodyIntro,
    'colRider': colRider,
    'colDate': colDate,
    'colHeld': colHeld,
    'colRemitted': colRemitted,
    'outstanding': outstanding,
    'overdue': overdue,
    'onTime': onTime,
    'settled': settled,
    'verifyDeposits': verifyDeposits,
    'empty': empty,
    'verifyTitle': verifyTitle,
    'verifyIntro': verifyIntro,
    'pending': pending,
    'verified': verified,
    'rejected': rejected,
    'declared': declared,
    'expected': expected,
    'difference': difference,
    'method': method,
    'reference': reference,
    'typeReference': typeReference,
    'referenceMismatch': referenceMismatch,
    'verify': verify,
    'reject': reject,
    'verifyName': verifyName,
    'verifyDone': verifyDone,
    'rejectDone': rejectDone,
    'by': by,
    'noCases': noCases,
  };
}
