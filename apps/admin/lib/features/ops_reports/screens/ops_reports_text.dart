import 'package:st_domain/st_domain.dart';

/// Texts of NA-06 (admin-web/OPERATIONS_MANAGEMENT.md, reports).
abstract final class OpsReportsText {
  static const eyebrow = StText('Operations', 'অপারেশনস');
  static const title = StText('Operations report explorer', 'অপারেশনস রিপোর্ট');
  static const intro = StText(
    'Operational reports only. Financial reports are produced in the accounting workspace.',
    'শুধু অপারেশনসের রিপোর্ট। আর্থিক রিপোর্ট অ্যাকাউন্টিং ওয়ার্কস্পেসে তৈরি হয়।',
  );
  static const from = StText('From (YYYY-MM-DD)', 'শুরু (YYYY-MM-DD)');
  static const to = StText('To (YYYY-MM-DD)', 'শেষ (YYYY-MM-DD)');
  static const exportLabel = StText('Export report', 'রিপোর্ট এক্সপোর্ট');
  static const commandName = StText(
    'Exporting the report',
    'রিপোর্ট এক্সপোর্ট',
  );
  static const success = StText(
    'Export recorded with its provenance.',
    'উৎসসহ এক্সপোর্ট রেকর্ড হয়েছে।',
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
