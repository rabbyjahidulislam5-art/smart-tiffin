import 'package:st_domain/st_domain.dart';

/// Texts of NR-06 (RIDER_MODULES.md section 4; SC-21).
abstract final class DeliveryDisputeText {
  static const eyebrow = StText('Delivery', 'ডেলিভারি');
  static const title = StText(
    'Report a delivery problem',
    'ডেলিভারির সমস্যা জানান',
  );
  static const policy = StText(
    'Before reporting, wait the documented time and try the masked call. The waiting-time policy is not approved yet. A report never marks the order delivered.',
    'জানানোর আগে নির্ধারিত সময় অপেক্ষা করুন এবং মাস্কড কল করে দেখুন। অপেক্ষার সময়ের নীতি এখনো অনুমোদিত হয়নি। রিপোর্টে অর্ডার কখনো ডেলিভারড হয় না।',
  );
  static const delivery = StText('Delivery reference', 'ডেলিভারি রেফারেন্স');
  static const deliveryNeeded = StText(
    'Enter the delivery reference, for example DL-913.',
    'ডেলিভারি রেফারেন্স লিখুন, যেমন DL-913।',
  );
  static const kind = StText('What happened', 'কী হয়েছে');
  static const noShow = StText('Customer did not show', 'গ্রাহক আসেননি');
  static const accident = StText('Accident', 'দুর্ঘটনা');
  static const failed = StText('Delivery failed', 'ডেলিভারি ব্যর্থ');
  static const kindNeeded = StText(
    'Choose what happened.',
    'কী হয়েছে তা বেছে নিন।',
  );
  static const note = StText('Details', 'বিস্তারিত');
  static const noteShort = StText(
    'Write at least 10 characters.',
    'অন্তত ১০ অক্ষর লিখুন।',
  );
  static const submit = StText('Send report', 'রিপোর্ট পাঠান');
  static const commandName = StText('Sending the report', 'রিপোর্ট পাঠানো');
  static const success = StText(
    'Report sent. Dispatch reviews it.',
    'রিপোর্ট পাঠানো হয়েছে। ডিসপ্যাচ এটি পর্যালোচনা করবে।',
  );
  static const history = StText('Your reports', 'আপনার রিপোর্ট');
  static const underReview = StText('Under review', 'পর্যালোচনায়');
  static const reviewed = StText('Reviewed', 'পর্যালোচিত');
  static const noReports = StText('No reports yet', 'এখনো কোনো রিপোর্ট নেই');
  static const sos = StText('In danger? Use SOS', 'বিপদে? SOS ব্যবহার করুন');

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'policy': policy,
    'delivery': delivery,
    'deliveryNeeded': deliveryNeeded,
    'kind': kind,
    'noShow': noShow,
    'accident': accident,
    'failed': failed,
    'kindNeeded': kindNeeded,
    'note': note,
    'noteShort': noteShort,
    'submit': submit,
    'commandName': commandName,
    'success': success,
    'history': history,
    'underReview': underReview,
    'reviewed': reviewed,
    'noReports': noReports,
    'sos': sos,
  };
}
