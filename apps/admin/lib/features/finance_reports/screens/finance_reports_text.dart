import 'package:st_domain/st_domain.dart';

/// Texts of NF-14 (ACCOUNTS_UI_UX.md, financial report export).
abstract final class FinanceReportsText {
  static const eyebrow = StText('Accounts', 'অ্যাকাউন্টস');
  static const title = StText(
    'Financial report export',
    'আর্থিক রিপোর্ট এক্সপোর্ট',
  );
  static const intro = StText(
    'Secured exports of financial reports. Every export is logged with who ran it, when and for which range.',
    'আর্থিক রিপোর্টের সুরক্ষিত এক্সপোর্ট। প্রতিটি এক্সপোর্ট কে, কখন ও কোন সময়সীমার জন্য চালিয়েছেন তা লগে থাকে।',
  );
  static const from = StText('From (YYYY-MM-DD)', 'শুরু (YYYY-MM-DD)');
  static const to = StText('To (YYYY-MM-DD)', 'শেষ (YYYY-MM-DD)');
  static const exportLabel = StText('Export report', 'রিপোর্ট এক্সপোর্ট');
  static const commandName = StText(
    'Exporting the report',
    'রিপোর্ট এক্সপোর্ট',
  );
  static const success = StText(
    'Export ready and logged.',
    'এক্সপোর্ট প্রস্তুত ও লগ করা হয়েছে।',
  );
  static const chooseReport = StText(
    'Choose a report.',
    'একটি রিপোর্ট বেছে নিন।',
  );
  static const badRange = StText(
    'Enter a valid range that ends today or earlier.',
    'আজ বা তার আগে শেষ হওয়া সঠিক সময়সীমা দিন।',
  );
  static const log = StText('Export log', 'এক্সপোর্টের তালিকা');
  static const logLine = StText('{0} · {1}', '{0} · {1}');
  static const noExports = StText('No exports yet', 'এখনো কোনো এক্সপোর্ট নেই');
  static const empty = StText('No reports available', 'কোনো রিপোর্ট নেই');

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'intro': intro,
    'from': from,
    'to': to,
    'exportLabel': exportLabel,
    'commandName': commandName,
    'success': success,
    'chooseReport': chooseReport,
    'badRange': badRange,
    'log': log,
    'logLine': logLine,
    'noExports': noExports,
    'empty': empty,
  };
}
