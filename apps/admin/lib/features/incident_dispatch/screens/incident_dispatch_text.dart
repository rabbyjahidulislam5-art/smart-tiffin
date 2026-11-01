import 'package:st_domain/st_domain.dart';

/// Texts of NA-04 (admin-web/OPERATIONS_MANAGEMENT.md, delivery operations; WF-J).
abstract final class IncidentDispatchText {
  static const eyebrow = StText('Operations', 'অপারেশনস');
  static const title = StText('Incident dispatcher', 'ঘটনা ডিসপ্যাচার');
  static const intro = StText(
    'Resolve delays and unavailable riders. Reassignment reverses the original rider\'s expected earning and only the completing rider is paid; the server enforces this (WF-J).',
    'দেরি ও অনুপস্থিত রাইডারের সমাধান করুন। পুনর্বণ্টনে আগের রাইডারের প্রত্যাশিত আয় বাতিল হয় এবং শুধু যিনি ডেলিভারি সম্পন্ন করেন তিনিই পান; সার্ভার এটি নিশ্চিত করে (WF-J)।',
  );
  static const delayed = StText('Delayed {0} min', '{0} মিনিট দেরি');
  static const riderNow = StText('Rider: {0}', 'রাইডার: {0}');
  static const reassignedTo = StText(
    'Reassigned to {0}',
    '{0}-কে পুনর্বণ্টন করা হয়েছে',
  );
  static const statusDelayed = StText('Delayed', 'দেরি');
  static const statusReassigned = StText('Reassigned', 'পুনর্বণ্টিত');
  static const empty = StText(
    'No delayed deliveries',
    'কোনো দেরির ডেলিভারি নেই',
  );
  static const backups = StText('Backup riders', 'বিকল্প রাইডার');
  static const pick = StText(
    'Select a delivery to see backup riders.',
    'বিকল্প রাইডার দেখতে একটি ডেলিভারি বেছে নিন।',
  );
  static const riderLine = StText('{0} · {1}', '{0} · {1}');
  static const reassign = StText('Reassign', 'পুনর্বণ্টন');
  static const commandName = StText(
    'Reassigning the delivery',
    'ডেলিভারি পুনর্বণ্টন',
  );
  static const success = StText(
    'Delivery reassigned.',
    'ডেলিভারি পুনর্বণ্টন করা হয়েছে।',
  );
  static const alreadyDone = StText(
    'This delivery is already reassigned.',
    'এই ডেলিভারি আগেই পুনর্বণ্টিত।',
  );

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'intro': intro,
    'delayed': delayed,
    'riderNow': riderNow,
    'reassignedTo': reassignedTo,
    'statusDelayed': statusDelayed,
    'statusReassigned': statusReassigned,
    'empty': empty,
    'backups': backups,
    'pick': pick,
    'riderLine': riderLine,
    'reassign': reassign,
    'commandName': commandName,
    'success': success,
    'alreadyDone': alreadyDone,
  };
}
