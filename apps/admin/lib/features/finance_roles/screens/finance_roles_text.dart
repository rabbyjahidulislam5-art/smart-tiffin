import 'package:st_domain/st_domain.dart';

/// Texts of NF-15 (accounts-web/ACCOUNTS_ARCHITECTURE.md section 2).
abstract final class FinanceRolesText {
  static const eyebrow = StText('Accounts', 'অ্যাকাউন্টস');
  static const title = StText('Finance role permissions', 'আর্থিক রোল অনুমতি');
  static const intro = StText(
    'Grant finance sub-roles to invited staff. A preparer never approves their own work (ADR-010); every grant and revocation is audited.',
    'আমন্ত্রিত স্টাফকে আর্থিক সাব-রোল দিন। প্রস্তুতকারী কখনো নিজের কাজ অনুমোদন করেন না (ADR-010); প্রতিটি অনুমতি ও প্রত্যাহার অডিট হয়।',
  );
  static const financeViewer = StText('Finance viewer', 'ফিন্যান্স ভিউয়ার');
  static const accountsOperator = StText(
    'Accounts operator',
    'অ্যাকাউন্টস অপারেটর',
  );
  static const accountsManager = StText(
    'Accounts manager',
    'অ্যাকাউন্টস ম্যানেজার',
  );
  static const payoutApprover = StText('Payout approver', 'পেআউট অনুমোদনকারী');
  static const financialAuditor = StText(
    'Financial auditor',
    'আর্থিক নিরীক্ষক',
  );
  static const active = StText('Active', 'সক্রিয়');
  static const revoked = StText('Revoked', 'প্রত্যাহৃত');
  static const you = StText('You', 'আপনি');
  static const grantTitle = StText('Grant a role', 'রোল দিন');
  static const email = StText(
    'Staff email (@smarttiffin.bd)',
    'স্টাফ ইমেইল (@smarttiffin.bd)',
  );
  static const emailBad = StText(
    'Enter a @smarttiffin.bd staff email.',
    'একটি @smarttiffin.bd স্টাফ ইমেইল দিন।',
  );
  static const subRole = StText('Sub-role', 'সাব-রোল');
  static const chooseRole = StText(
    'Choose a sub-role.',
    'একটি সাব-রোল বেছে নিন।',
  );
  static const grant = StText('Grant role', 'রোল দিন');
  static const grantName = StText('Granting the role', 'রোল প্রদান');
  static const grantDone = StText('Role granted.', 'রোল দেওয়া হয়েছে।');
  static const revoke = StText('Revoke', 'প্রত্যাহার');
  static const revokeTitle = StText('Revoke the role', 'রোল প্রত্যাহার');
  static const revokeBody = StText(
    'The reason is recorded in the audit log (at least 5 characters).',
    'কারণটি অডিট লগে রেকর্ড হয় (অন্তত ৫ অক্ষর)।',
  );
  static const revokeName = StText('Revoking the role', 'রোল প্রত্যাহার');
  static const revokeDone = StText('Role revoked.', 'রোল প্রত্যাহার হয়েছে।');
  static const revokeSelf = StText(
    'You cannot revoke your own role.',
    'আপনি নিজের রোল প্রত্যাহার করতে পারবেন না।',
  );
  static const noStaff = StText('No staff', 'কোনো স্টাফ নেই');

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'intro': intro,
    'financeViewer': financeViewer,
    'accountsOperator': accountsOperator,
    'accountsManager': accountsManager,
    'payoutApprover': payoutApprover,
    'financialAuditor': financialAuditor,
    'active': active,
    'revoked': revoked,
    'you': you,
    'grantTitle': grantTitle,
    'email': email,
    'emailBad': emailBad,
    'subRole': subRole,
    'chooseRole': chooseRole,
    'grant': grant,
    'grantName': grantName,
    'grantDone': grantDone,
    'revoke': revoke,
    'revokeTitle': revokeTitle,
    'revokeBody': revokeBody,
    'revokeName': revokeName,
    'revokeDone': revokeDone,
    'revokeSelf': revokeSelf,
    'noStaff': noStaff,
  };
}
