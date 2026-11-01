import 'package:st_domain/st_domain.dart';

/// Texts of NA-02 (admin-web/OPERATIONS_MANAGEMENT.md, policy configuration).
abstract final class PolicyConfigText {
  static const eyebrow = StText('Operations', 'অপারেশনস');
  static const title = StText(
    'Business policy configuration',
    'ব্যবসায়িক নীতি কনফিগারেশন',
  );
  static const intro = StText(
    'Propose cutoff, zone, delivery and discount rules. Every version is effective-dated; a new version supersedes the old one and nothing is overwritten.',
    'কাট-অফ, এলাকা, ডেলিভারি ও ছাড়ের নিয়ম প্রস্তাব করুন। প্রতিটি সংস্করণের কার্যকর তারিখ থাকে; নতুন সংস্করণ পুরোনোটি প্রতিস্থাপন করে, কিছুই মুছে যায় না।',
  );
  static const notConfigured = StText('Not configured', 'কনফিগার করা হয়নি');
  static const draft = StText('Draft', 'খসড়া');
  static const published = StText('Published', 'প্রকাশিত');
  static const superseded = StText('Superseded', 'প্রতিস্থাপিত');
  static const effective = StText('Effective from {0}', '{0} থেকে কার্যকর');
  static const author = StText('By {0}', '{0} দ্বারা');
  static const publishTitle = StText(
    'Publish a new version',
    'নতুন সংস্করণ প্রকাশ',
  );
  static const key = StText('Policy', 'নীতি');
  static const value = StText('Value', 'মান');
  static const date = StText(
    'Effective date (YYYY-MM-DD)',
    'কার্যকর তারিখ (YYYY-MM-DD)',
  );
  static const preview = StText(
    'Preview and publish',
    'দেখে নিয়ে প্রকাশ করুন',
  );
  static const previewTitle = StText(
    'Publish this version?',
    'এই সংস্করণ প্রকাশ করবেন?',
  );
  static const previewBody = StText(
    '{0} becomes "{1}" from {2}. The current version is superseded.',
    '{2} থেকে {0} হবে "{1}"। বর্তমান সংস্করণ প্রতিস্থাপিত হবে।',
  );
  static const publish = StText('Publish', 'প্রকাশ করুন');
  static const commandName = StText(
    'Publishing the policy version',
    'নীতির সংস্করণ প্রকাশ',
  );
  static const success = StText(
    'Policy version published.',
    'নীতির সংস্করণ প্রকাশিত হয়েছে।',
  );
  static const chooseKey = StText('Choose a policy.', 'একটি নীতি বেছে নিন।');
  static const valueShort = StText(
    'Enter a value of at least 2 characters.',
    'অন্তত ২ অক্ষরের একটি মান লিখুন।',
  );
  static const futureDate = StText(
    'Enter a future date as YYYY-MM-DD.',
    'YYYY-MM-DD আকারে ভবিষ্যতের একটি তারিখ লিখুন।',
  );
  static const empty = StText(
    'No policies to configure',
    'কনফিগার করার মতো কোনো নীতি নেই',
  );

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'intro': intro,
    'notConfigured': notConfigured,
    'draft': draft,
    'published': published,
    'superseded': superseded,
    'effective': effective,
    'author': author,
    'publishTitle': publishTitle,
    'key': key,
    'value': value,
    'date': date,
    'preview': preview,
    'previewTitle': previewTitle,
    'previewBody': previewBody,
    'publish': publish,
    'commandName': commandName,
    'success': success,
    'chooseKey': chooseKey,
    'valueShort': valueShort,
    'futureDate': futureDate,
    'empty': empty,
  };
}
