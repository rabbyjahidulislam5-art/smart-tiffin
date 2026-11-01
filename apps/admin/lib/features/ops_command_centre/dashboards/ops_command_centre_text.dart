import 'package:st_domain/st_domain.dart';

/// Texts of NA-01 (admin-web/ADMIN_DASHBOARD.md).
abstract final class OpsCommandCentreText {
  static const eyebrow = StText('Operations', 'অপারেশনস');
  static const title = StText(
    'Operations command centre',
    'অপারেশনস কমান্ড সেন্টার',
  );
  static const generated = StText('Updated {0}', 'হালনাগাদ {0}');
  static const ongoing = StText('Ongoing orders', 'চলমান অর্ডার');
  static const late = StText('Late orders', 'দেরির অর্ডার');
  static const nearCapacity = StText(
    'Kitchens near capacity',
    'ধারণক্ষমতার কাছে কিচেন',
  );
  static const dispatchRisk = StText('Dispatch risk', 'ডিসপ্যাচ ঝুঁকি');
  static const openIncidents = StText('Open incidents', 'খোলা ঘটনা');
  static const pendingApplications = StText(
    'Pending applications',
    'অপেক্ষমাণ আবেদন',
  );
  static const incidents = StText('Incident queue', 'ঘটনার তালিকা');
  static const filterAll = StText('All', 'সব');
  static const statusOpen = StText('Open', 'খোলা');
  static const statusAssigned = StText('Assigned', 'দায়িত্ব দেওয়া');
  static const statusResolved = StText('Resolved', 'সমাধান');
  static const high = StText('High', 'উচ্চ');
  static const medium = StText('Medium', 'মাঝারি');
  static const low = StText('Low', 'নিম্ন');
  static const age = StText('{0} min', '{0} মিনিট');
  static const noIncidents = StText(
    'No incidents with this status',
    'এই অবস্থার কোনো ঘটনা নেই',
  );
  static const workQueues = StText('Work queues', 'কাজের তালিকা');
  static const policy = StText('Policy configuration', 'নীতি কনফিগারেশন');
  static const verification = StText('Verification queue', 'যাচাইয়ের তালিকা');
  static const dispatcher = StText('Incident dispatcher', 'ঘটনা ডিসপ্যাচার');
  static const oversight = StText(
    'Accounts oversight (limited)',
    'অ্যাকাউন্টস তদারকি (সীমিত)',
  );
  static const reports = StText('Operations reports', 'অপারেশনস রিপোর্ট');
  static const financeNote = StText(
    'Finance detail lives in the accounting workspace. This console shows operations only.',
    'আর্থিক বিস্তারিত অ্যাকাউন্টিং ওয়ার্কস্পেসে থাকে। এই কনসোল শুধু অপারেশনস দেখায়।',
  );

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'generated': generated,
    'ongoing': ongoing,
    'late': late,
    'nearCapacity': nearCapacity,
    'dispatchRisk': dispatchRisk,
    'openIncidents': openIncidents,
    'pendingApplications': pendingApplications,
    'incidents': incidents,
    'filterAll': filterAll,
    'statusOpen': statusOpen,
    'statusAssigned': statusAssigned,
    'statusResolved': statusResolved,
    'high': high,
    'medium': medium,
    'low': low,
    'age': age,
    'noIncidents': noIncidents,
    'workQueues': workQueues,
    'policy': policy,
    'verification': verification,
    'dispatcher': dispatcher,
    'oversight': oversight,
    'reports': reports,
    'financeNote': financeNote,
  };
}
